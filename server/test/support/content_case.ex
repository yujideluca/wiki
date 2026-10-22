defmodule Wiki.ContentCase do
  @moduledoc "Builds throw-away content folders (and git repos) for tests."
  use ExUnit.CaseTemplate
  alias Wiki.Content.{Page, Store}

  using do
    quote do
      import Wiki.ContentCase
      alias Wiki.Content.{Page, Store, Check, Build, Stale, Privacy}
    end
  end

  setup do
    dir = Path.join(System.tmp_dir!(), "wiki-test-#{System.unique_integer([:positive])}")
    content = Path.join(dir, "wiki/content")
    File.mkdir_p!(content)
    File.write!(Path.join(content, "_kinds.json"), ~s([{"name":"project","colour":"#c97a7a"},
      {"name":"program","colour":"#c9a14a"},{"name":"module","colour":"#7aa2c9"},{"name":"actor","colour":"#8fc97a"}]))
    on_exit(fn -> File.rm_rf!(dir) end)
    {:ok, dir: dir, content: content}
  end

  @doc "Header map + sections map -> file text."
  def page_text(header, sections \\ %{}) do
    sections =
      Map.merge(
        %{"what" => "A thing.", "does" => "Does things.", "how" => "Somehow.", "where" => "Middle.", "receives" => "Others."},
        sections
      )

    head = Enum.map_join(header, "\n", fn
      {k, v} when is_list(v) -> "#{k}: [#{Enum.join(v, ", ")}]"
      {k, v} -> "#{k}: #{v}"
    end)

    body =
      Page.section_keys()
      |> Enum.filter(&Map.has_key?(sections, &1))
      |> Enum.map_join("\n\n", &"## #{Page.heading(&1)}\n#{sections[&1]}")

    "---\n#{head}\n---\n\n#{body}\n"
  end

  def base_header(id, extra \\ []) do
    [id: id, title: String.capitalize(id), kind: "program", project: "proj", status: "active", reviewed: "2026-10-22"]
    |> Keyword.merge(extra)
  end

  @doc "Writes an English page and, unless `translate: false`, matching de and pt-BR versions."
  def write_page(content, id, header, sections \\ %{}, opts \\ []) do
    text = page_text(header, sections)
    File.write!(Path.join(content, "#{id}.md"), text)

    if Keyword.get(opts, :translate, true) do
      hash = Page.source_hash(Page.parse(text, "#{id}.md"))

      for lang <- Store.translation_langs() do
        File.write!(
          Path.join(content, "#{id}.#{lang}.md"),
          page_text([id: id, lang: lang, source_hash: hash, title: "#{id} (#{lang})"], sections)
        )
      end
    end

    :ok
  end

  @doc "A minimal valid wiki: project `proj`, program `a` feeding program `b`."
  def valid_wiki(content) do
    write_page(content, "proj", base_header("proj", kind: "project", project: "none"), %{"what" => "Has [[a]] and [[b]]."})
    write_page(content, "a", base_header("a", feeds: ["b"]))
    write_page(content, "b", base_header("b", fed_by: ["a"]))
  end
end
