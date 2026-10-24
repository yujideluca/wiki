defmodule Wiki.Content.Store do
  @moduledoc """
  Loads every page and the kinds registry from a content folder.

  `content/<id>.md` is English; `content/<id>.de.md` and `content/<id>.pt-BR.md` are translations;
  `content/_kinds.json` lists the kinds of concept (name, colour, description);
  `content/_acronyms.tsv` lists the acronyms whose first use on a page must come with the full name.
  """
  alias Wiki.Content.Page

  @langs ["en", "de", "pt-BR"]
  def langs, do: @langs
  def translation_langs, do: tl(@langs)

  defstruct dir: nil, pages: %{}, translations: %{}, kinds: %{}, acronyms: [], errors: []

  def load(dir) do
    files = dir |> File.ls!() |> Enum.filter(&String.ends_with?(&1, ".md")) |> Enum.sort()
    parsed = Enum.map(files, fn f -> Page.parse(File.read!(Path.join(dir, f)), f) end)
    {en, tr} = Enum.split_with(parsed, &(&1.lang == "en"))
    {kinds, kerrs} = load_kinds(Path.join(dir, "_kinds.json"))

    %__MODULE__{
      dir: dir,
      pages: Map.new(en, &{&1.id, &1}),
      translations: Map.new(tr, &{{&1.id, &1.lang}, &1}),
      kinds: kinds,
      acronyms: load_acronyms(Path.join(dir, "_acronyms.tsv")),
      errors: kerrs
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

  @doc "The page in a language, falling back to English when there is no translation."
  def localized(store, id, "en"), do: store.pages[id]
  def localized(store, id, lang), do: store.translations[{id, lang}] || store.pages[id]
end
