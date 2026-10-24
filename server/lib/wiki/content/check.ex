defmodule Wiki.Content.Check do
  @moduledoc """
  `wiki check`: every rule a page must follow before it can be published.
  Returns a list of `"file: problem"` strings; empty means the content is valid.

  `local: true` adds the checks that need the laptop (sources exist, memory refs exist);
  CI runs without them because it cannot see the other private repositories.
  """
  alias Wiki.Content.{Page, Store, Sources, Privacy}

  @statuses ~w(active beta retired planned)
  @no_edges_ok ~w(actor external)
  @date ~r/^\d{4}-\d{2}-\d{2}$/
  @review_days 30

  def review_days, do: @review_days

  def run(%Store{} = store, opts \\ []) do
    local = Keyword.get(opts, :local, false)
    ids = Map.keys(store.pages) |> MapSet.new()

    store.errors ++
      Enum.flat_map(Map.values(store.pages), &page(&1, store, ids, local)) ++
      symmetry(store) ++
      orphans(store) ++
      promotion(store) ++
      translations(store) ++
      Enum.flat_map(Map.values(store.translations), &Privacy.scan/1)
    |> Enum.sort()
  end

  defp page(p, store, ids, local) do
    h = p.header

    errs =
      p.errors ++
        missing_fields(p) ++
        [
          h["id"] && h["id"] != p.id && "header id #{h["id"]} does not match the file name",
          h["kind"] && !Map.has_key?(store.kinds, h["kind"]) && "unknown kind #{h["kind"]} (add it to _kinds.json)",
          h["status"] && h["status"] not in @statuses && "status must be one of #{Enum.join(@statuses, ", ")}",
          h["project"] && h["project"] != "none" && !MapSet.member?(ids, h["project"]) &&
            "project #{h["project"]} has no page",
          h["project"] && h["project"] != "none" && store.pages[h["project"]] &&
            store.pages[h["project"]].header["kind"] != "project" && "project #{h["project"]} is not of kind project",
          bad_date(h, "since"),
          bad_date(h, "until"),
          h["status"] == "retired" && !h["until"] && "a retired page needs until: <date>",
          reviewed_problem(h)
        ] ++
        Enum.map(Page.required_sections(), fn k ->
          Page.section(p, k) == "" && "section ## #{Page.heading(k)} is missing or empty"
        end) ++
        [skill_definition(p)] ++
        acronyms(p, store.acronyms) ++
        Enum.map(Page.links(p), &(!MapSet.member?(ids, &1) && "link [[#{&1}]] points to no page")) ++
        Enum.map(Page.list(p, "fed_by"), &(!MapSet.member?(ids, &1) && "fed_by #{&1} points to no page")) ++
        Enum.map(Page.list(p, "feeds"), &(!MapSet.member?(ids, &1) && "feeds #{&1} points to no page")) ++
        Enum.map(Page.list(p, "sources"), &(Sources.resolve(&1) == nil && "source #{&1} is not repo:path")) ++
        if(local, do: local_checks(p), else: []) ++
        Privacy.scan(p)

    errs |> Enum.filter(&is_binary/1) |> Enum.map(&prefix(p, &1))
  end

  # A skill page holds the skill's own definition (its rules or steps), so a reader never needs the SKILL.md file.
  defp skill_definition(p) do
    p.header["kind"] == "skill" && Page.section(p, "steps") == "" &&
      "a skill page needs a ## Steps section with the skill's own rules or steps"
  end

  @acronym_gap 100

  # The first use of a listed acronym must be next to its full name: the name appears before it or within
  # @acronym_gap characters after it. Code quotes and link addresses are skipped; matching is on whole words, case-sensitive.
  defp acronyms(p, list) do
    prose =
      p.sections |> Enum.map_join("\n", &elem(&1, 1)) |> Page.strip_code() |> String.replace(~r/\]\([^)]*\)/, "]")

    for {acronym, name} <- list,
        [{at, _}] <- [Regex.run(~r/(?<![A-Za-z0-9])#{Regex.escape(acronym)}(?![A-Za-z0-9])/, prose, return: :index) || [nil]],
        at != nil,
        not full_name_near?(prose, name, at) do
      "#{acronym} is used without its full name (#{name}) at its first use"
    end
  end

  defp full_name_near?(prose, name, at) do
    case :binary.match(String.downcase(prose), String.downcase(name)) do
      {pos, _} -> pos <= at + @acronym_gap
      :nomatch -> false
    end
  end

  defp missing_fields(p) do
    for f <- ~w(id title kind project status), !p.header[f] or p.header[f] == "", do: "header field #{f} missing"
  end

  # CO-6 (ADR-0006): every page records when it was last compared with its sources, in UTC and not in the future.
  defp reviewed_problem(h) do
    if h["reviewed"] in [nil, ""] do
      "a page needs reviewed: <UTC date or date and minute> (when it was last compared with its sources)"
    else
      now = System.os_time(:second)

      case Page.parse_reviewed(h["reviewed"]) do
        nil -> "reviewed must be YYYY-MM-DD or YYYY-MM-DDTHH:MMZ (UTC)"
        time when time > now -> "reviewed is in the future"
        _ -> nil
      end
    end
  end

  defp bad_date(h, key), do: h[key] && !Regex.match?(@date, h[key]) && "#{key} must be YYYY-MM-DD"

  defp local_checks(p) do
    Enum.map(Page.list(p, "sources"), &(Sources.resolve(&1) && !Sources.exists?(&1) && "source #{&1} does not exist")) ++
      Enum.map(Page.list(p, "memory"), &(!memory_ref_exists?(&1) && "memory ref #{&1} not found in workflow-memory"))
  end

  defp memory_ref_exists?(ref) do
    ref = String.trim_leading(ref, "#")
    events = Path.join(Sources.dev_root(), "workflow-memory/events")
    Path.wildcard(Path.join(events, "**/*-#{ref}.md")) != []
  end

  defp symmetry(store) do
    for {id, p} <- store.pages, other <- Page.list(p, "feeds"), q = store.pages[other], q != nil,
        id not in Page.list(q, "fed_by") do
      "#{other}.md: fed_by is missing #{id} (#{id} says it feeds #{other})"
    end ++
      for {id, p} <- store.pages, other <- Page.list(p, "fed_by"), q = store.pages[other], q != nil,
          id not in Page.list(q, "feeds") do
        "#{other}.md: feeds is missing #{id} (#{id} says it is fed by #{other})"
      end
  end

  defp orphans(store) do
    linked =
      store.pages
      |> Map.values()
      |> Enum.flat_map(&(Page.links(&1) ++ Page.list(&1, "feeds") ++ Page.list(&1, "fed_by") ++ [&1.header["project"]]))
      |> MapSet.new()

    for {id, p} <- store.pages, p.header["kind"] not in @no_edges_ok, !MapSet.member?(linked, id),
        Page.links(p) == [] and Page.list(p, "feeds") == [] and Page.list(p, "fed_by") == [] do
      "#{id}.md: orphan page (nothing links to it and it links to nothing)"
    end
  end

  @doc """
  Promotion rule (D12): a name listed in some page's `## Functions` without its own page must get one
  as soon as it is mentioned, in backticks, by two or more other pages.
  """
  def promotion(store) do
    ids = Map.keys(store.pages) |> MapSet.new()

    for {id, p} <- store.pages, name <- Page.listed_functions(p), !MapSet.member?(ids, slug(name)) do
      mentions =
        for {oid, q} <- store.pages, oid != id,
            Enum.any?(q.sections, fn {k, t} -> k != "functions" and String.contains?(t, "`#{name}`") end),
            do: oid

      if length(mentions) >= 2,
        do: "#{id}.md: `#{name}` is mentioned by #{Enum.join(Enum.sort(mentions), ", ")}: give it its own page"
    end
    |> Enum.reject(&is_nil/1)
  end

  def slug(name),
    do: name |> String.downcase() |> String.replace(~r/[^a-z0-9]+/, "-") |> String.trim("-")

  defp translations(store) do
    for {id, p} <- store.pages, lang <- Store.translation_langs() do
      hash = Page.source_hash(p)

      case store.translations[{id, lang}] do
        nil ->
          "#{id}.md: #{lang} translation missing (#{id}.#{lang}.md)"

        t ->
          cond do
            t.errors != [] -> "#{t.file}: #{Enum.join(t.errors, "; ")}"
            t.header["source_hash"] != hash -> "#{t.file}: outdated, English changed (source_hash should be #{hash})"
            !t.header["title"] -> "#{t.file}: title missing"
            (miss = Enum.filter(Page.required_sections(), &(Page.section(t, &1) == ""))) != [] ->
              "#{t.file}: sections missing: #{Enum.join(miss, ", ")}"
            true -> nil
          end
      end
    end
    |> Enum.reject(&is_nil/1)
    |> Kernel.++(
      for {{id, _}, t} <- store.translations, !store.pages[id], do: "#{t.file}: translation of a page that does not exist"
    )
  end

  defp prefix(p, msg), do: "#{p.file}: #{msg}"
end
