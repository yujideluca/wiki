defmodule Wiki.Content.SkillSource do
  @moduledoc "Complete, fingerprinted SKILL.md copies on skill pages (CO-10)."
  alias Wiki.Content.{Page, Sources, Store}

  def check(page, store, local) do
    if page.header["kind"] == "skill" do
      sources = Page.list(page, "sources") |> Enum.filter(&(Path.basename(&1) == "SKILL.md"))
      copies = copies(page)

      translations =
        for lang <- Store.translation_langs(), p = store.translations[{page.id, lang}], do: p

      if(sources == [], do: ["#{page.file}: a skill page needs a SKILL.md source"], else: []) ++
        Enum.flat_map(sources, fn source ->
          validate(page.file, source, copies, local) ++
            Enum.flat_map(translations, fn translation ->
              translated = copies(translation)

              validate(translation.file, source, translated, false) ++
                if Map.get(copies, source) != Map.get(translated, source),
                  do: [
                    "#{translation.file}: complete SKILL.md copy must match the English original for #{source}"
                  ],
                  else: []
            end)
        end)
    else
      []
    end
  end

  defp copies(page) do
    page.sections
    |> Enum.flat_map(fn {_, text} -> Page.fenced_blocks(text) end)
    |> Enum.flat_map(fn {info, text} ->
      case String.split(info) do
        ["skill-source", source, hash] -> [{source, {hash, text}}]
        _ -> []
      end
    end)
    |> Map.new()
  end

  defp validate(file, source, copies, local) do
    case copies[source] do
      nil ->
        ["#{file}: missing complete SKILL.md copy for #{source}"]

      {hash, text} ->
        expected = :crypto.hash(:sha256, text) |> Base.encode16(case: :lower)

        if(hash != expected,
          do: ["#{file}: complete SKILL.md fingerprint mismatch for #{source}"],
          else: []
        ) ++
          if(Regex.match?(~r/\A---\n.*?^description:.*?^---\n.+/ms, text),
            do: [],
            else: [
              "#{file}: complete SKILL.md must include its description and instructions for #{source}"
            ]
          ) ++
          if(local, do: compare_source(file, source, text), else: [])
    end
  end

  defp compare_source(file, source, text) do
    with {_, dir, path} <- Sources.resolve(source),
         {:ok, original} <- File.read(Path.join(dir, path)) do
      original = String.replace(original, "\r\n", "\n")
      original = if String.ends_with?(original, "\n"), do: original, else: original <> "\n"

      if original == text,
        do: [],
        else: [
          "#{file}: complete SKILL.md copy differs from #{source}; read and copy the whole file"
        ]
    else
      _ -> ["#{file}: cannot read complete SKILL.md source #{source}"]
    end
  end
end
