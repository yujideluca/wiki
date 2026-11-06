defmodule Wiki.Content.Store do
  @moduledoc """
  Loads every page and the kinds registry from a content folder.

  `content/<id>.md` is the page (the wiki is English only: one file per page, requirement LG-1);
  `content/_kinds.json` lists the kinds of concept (name, colour, description);
  `content/_acronyms.tsv` lists the acronyms whose first use on a page must come with the full name.
  """
  alias Wiki.Content.Page

  defstruct dir: nil, pages: %{}, kinds: %{}, acronyms: [], errors: []

  def load(dir) do
    files = dir |> File.ls!() |> Enum.filter(&String.ends_with?(&1, ".md")) |> Enum.sort()
    {pages, other} = Enum.split_with(files, &(Path.basename(&1, ".md") |> String.contains?(".") |> Kernel.not()))
    parsed = Enum.map(pages, fn f -> Page.parse(File.read!(Path.join(dir, f)), f) end)
    {kinds, kerrs} = load_kinds(Path.join(dir, "_kinds.json"))

    %__MODULE__{
      dir: dir,
      pages: Map.new(parsed, &{&1.id, &1}),
      kinds: kinds,
      acronyms: load_acronyms(Path.join(dir, "_acronyms.tsv")),
      errors: kerrs ++ Enum.map(other, &english_only/1)
    }
  end

  defp load_kinds(path) do
    with {:ok, text} <- File.read(path),
         {:ok, list} when is_list(list) <- JSON.decode(text) do
      {Map.new(list, &{&1["name"], &1}), []}
    else
      _ -> {%{}, ["content/_kinds.json missing or not a JSON list"]}
    end
  end

  # `_acronyms.tsv`: one `ACRONYM<TAB>full name` per line, `#` starts a comment. Missing file = no acronym rule.
  defp load_acronyms(path) do
    case File.read(path) do
      {:ok, text} ->
        for line <- String.split(text, "\n", trim: true), not String.starts_with?(line, "#"),
            [acronym, name] <- [String.split(line, "\t", parts: 2)],
            do: {String.trim(acronym), String.trim(name)}

      _ ->
        []
    end
  end

  # LG-1: a file such as `mem.de.md` would be a translation; there are none, so it is a mistake to report.
  defp english_only(file),
    do: "#{file}: the wiki is English only (one file per page, content/<id>.md): delete this file and put the text in the English page"
end
