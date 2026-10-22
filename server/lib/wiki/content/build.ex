defmodule Wiki.Content.Build do
  @moduledoc """
  `wiki build`: turns the content folder into the data the Elm front end reads.

      <out>/data/graph.json             nodes, edges, kinds, projects (all languages)
      <out>/data/pages/<id>.<lang>.json one article per language

  Pipeline edges come from `feeds`; every `[[link]]` that is not already a pipeline edge becomes a
  `mentions` edge. `since` is the header value, else the first commit of the page's sources, else the
  first commit of the page file itself.
  """
  alias Wiki.Content.{Page, Store, Sources, Git, Check}

  def run(%Store{} = store, out, opts \\ []) do
    today = Keyword.get(opts, :today, Date.utc_today())
    wiki_repo = Path.dirname(store.dir)
    meta = Map.new(store.pages, fn {id, p} -> {id, meta(p, wiki_repo, today)} end)

    File.mkdir_p!(Path.join(out, "data/pages"))
    write(Path.join(out, "data/graph.json"), graph(store, meta))

    for {id, _} <- store.pages, lang <- Store.langs() do
      write(Path.join(out, "data/pages/#{id}.#{lang}.json"), article(store, id, lang, meta[id]))
    end

    :ok
  end

  defp write(path, data), do: File.write!(path, JSON.encode!(data))

  defp meta(p, wiki_repo, today) do
    rel = Path.join("content", p.file)

    since =
      p.header["since"] ||
        p |> Page.list("sources") |> Enum.map(&source_since/1) |> Enum.reject(&is_nil/1) |> Enum.min(fn -> nil end) ||
        Git.first_date(wiki_repo, rel) || Date.to_iso8601(today)

    may_be_stale =
      case p.header["reviewed"] && Page.list(p, "sources") == [] && Date.from_iso8601(p.header["reviewed"]) do
        {:ok, d} -> Date.diff(today, d) > Check.review_days()
        _ -> false
      end

    %{since: since, history: Git.history(wiki_repo, rel), may_be_stale: may_be_stale}
  end

  defp source_since(source) do
    case Sources.git_location(source) do
      {repo, path} -> Git.first_date(repo, path)
      nil -> nil
    end
  end

  def graph(store, meta) do
    nodes =
      for {id, p} <- Enum.sort(store.pages) do
        texts =
          Map.new(Store.langs(), fn lang ->
            l = Store.localized(store, id, lang)

            {lang,
             %{
               "title" => l.header["title"] || p.header["title"],
               "aliases" => Page.list(l, "aliases") ++ Page.list(p, "aliases"),
               "what" => Page.first_paragraph(l, "what"),
               "does" => Page.first_paragraph(l, "does")
             }}
          end)

        %{
          "id" => id,
          "kind" => p.header["kind"],
          "project" => p.header["project"],
          "status" => p.header["status"],
          "since" => meta[id].since,
          "until" => p.header["until"],
          "fedBy" => Page.list(p, "fed_by"),
          "feeds" => Page.list(p, "feeds"),
          "functions" => Page.listed_functions(p),
          "process" => Page.section(p, "steps") != "",
          "text" => texts
        }
      end

    pipeline = for {id, p} <- store.pages, to <- Page.list(p, "feeds"), do: {id, to}
    pipe_set = MapSet.new(pipeline, fn {a, b} -> Enum.sort([a, b]) end)

    mentions =
      for {id, p} <- store.pages, to <- Page.links(p), to != id, Map.has_key?(store.pages, to),
          !MapSet.member?(pipe_set, Enum.sort([id, to])),
          uniq: true,
          do: Enum.sort([id, to])

    edges =
      Enum.map(Enum.sort(pipeline), fn {a, b} -> %{"from" => a, "to" => b, "type" => "feeds"} end) ++
        Enum.map(Enum.uniq(mentions), fn [a, b] -> %{"from" => a, "to" => b, "type" => "mentions"} end)

    %{
      "nodes" => nodes,
      "edges" => edges,
      "kinds" => store.kinds |> Map.values() |> Enum.sort_by(& &1["name"])
    }
  end

  def article(store, id, lang, meta) do
    p = store.pages[id]
    l = Store.localized(store, id, lang)

    %{
      "id" => id,
      "lang" => if(l.lang == lang, do: lang, else: "en"),
      "title" => l.header["title"] || p.header["title"],
      "aliases" => Page.list(l, "aliases"),
      "kind" => p.header["kind"],
      "project" => p.header["project"],
      "status" => p.header["status"],
      "location" => p.header["location"],
      "since" => meta.since,
      "until" => p.header["until"],
      "reviewed" => p.header["reviewed"],
      "mayBeStale" => meta.may_be_stale,
      "fedBy" => Page.list(p, "fed_by"),
      "feeds" => Page.list(p, "feeds"),
      "memory" => Page.list(p, "memory"),
      "sources" => Page.list(p, "sources"),
      "sections" =>
        for key <- Page.section_keys(), (text = Page.section(l, key)) != "" do
          %{"key" => key, "markdown" => text}
        end,
      "history" => meta.history
    }
  end
end
