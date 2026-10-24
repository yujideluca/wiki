defmodule Wiki.Content.Page do
  @moduledoc """
  One wiki page parsed from `content/<id>.md` (English, the source of truth) or
  `content/<id>.<lang>.md` (a translation).

  File layout: a header between two `---` lines (`key: value`, lists as `[a, b]`),
  then sections that start with `## <canonical English heading>`.
  """

  @sections [
    {"what", "What it is"},
    {"does", "What it does"},
    {"how", "How it does it"},
    {"where", "Where it sits in the pipeline"},
    {"receives", "Who receives its output"},
    {"steps", "Steps"},
    {"functions", "Functions"},
    {"notes", "Notes"}
  ]
  @required ~w(what does how where receives)
  @list_fields ~w(aliases fed_by feeds tags sources memory)

  defstruct [:id, :lang, :file, header: %{}, sections: [], errors: []]

  def section_keys, do: Enum.map(@sections, &elem(&1, 0))
  def required_sections, do: @required
  def heading(key), do: @sections |> List.keyfind(key, 0) |> elem(1)

  @doc "Parses a file's text. `file` is the base name, e.g. `mem.md` or `mem.de.md`."
  def parse(text, file) do
    {id, lang} = id_and_lang(file)
    page = %__MODULE__{id: id, lang: lang, file: file}

    case String.split(text, ~r/^---[ \t]*$/m, parts: 3) do
      ["", head, body] ->
        {header, herrs} = parse_header(head)
        {sections, serrs} = parse_sections(body)
        %{page | header: header, sections: sections, errors: herrs ++ serrs}

      _ ->
        %{page | errors: ["missing header block between --- lines"]}
    end
  end

  def id_and_lang(file) do
    base = Path.basename(file, ".md")

    case String.split(base, ".", parts: 2) do
      [id, lang] -> {id, lang}
      [id] -> {id, "en"}
    end
  end

  defp parse_header(head) do
    head
    |> String.split("\n", trim: true)
    |> Enum.reject(&(String.trim(&1) == "" or String.starts_with?(String.trim(&1), "#")))
    |> Enum.reduce({%{}, []}, fn line, {acc, errs} ->
      case Regex.run(~r/^([a-z_]+):\s*(.*)$/, String.trim_trailing(line)) do
        [_, key, value] -> {Map.put(acc, key, value(key, String.trim(value))), errs}
        nil -> {acc, errs ++ ["header line not understood: #{line}"]}
      end
    end)
  end

  defp value(key, v) when key in @list_fields do
    v
    |> String.trim_leading("[")
    |> String.trim_trailing("]")
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp value(_key, v), do: v

  defp parse_sections(body) do
    by_heading = Map.new(@sections, fn {k, h} -> {h, k} end)

    body
    |> String.split(~r/^## /m)
    |> Enum.drop(1)
    |> Enum.reduce({[], []}, fn chunk, {acc, errs} ->
      [heading | rest] = String.split(chunk, "\n", parts: 2)
      heading = String.trim(heading)
      text = rest |> List.first("") |> String.trim()

      case by_heading[heading] do
        nil -> {acc, errs ++ ["unknown section heading: ## #{heading}"]}
        key -> {acc ++ [{key, text}], errs}
      end
    end)
  end

  def section(page, key), do: page.sections |> List.keyfind(key, 0, {key, ""}) |> elem(1)

  def list(page, key), do: Map.get(page.header, key, []) |> List.wrap()

  @doc "Every `[[id]]` or `[[id|label]]` link in the page body (not inside `code` quotes)."
  def links(page) do
    page.sections
    |> Enum.flat_map(fn {_, text} -> Regex.scan(~r/\[\[([^\]|]+)(?:\|[^\]]*)?\]\]/, strip_code(text)) end)
    |> Enum.map(fn [_, id] -> String.trim(id) end)
    |> Enum.uniq()
  end

  @doc "Text with inline code spans and fenced code blocks removed, so examples are not read as links."
  def strip_code(text) do
    text
    |> String.replace(~r/```.*?```/s, "")
    |> String.replace(~r/`[^`]*`/, "")
  end

  @doc "Names listed in the `Functions` section: lines starting with - `name`."
  def listed_functions(page) do
    Regex.scan(~r/^\s*[-*]\s+`([^`]+)`/m, section(page, "functions"))
    |> Enum.map(fn [_, name] -> name end)
  end

  @doc """
  Unix time of a page's `reviewed` value, or nil when it is missing or not understood. The value is a UTC date
  (`2026-10-24`, meaning the start of that day) or a UTC date and minute (`2026-10-24T18:30Z`); see ADR-0006.
  """
  def reviewed_at(%__MODULE__{header: header}), do: parse_reviewed(header["reviewed"])

  def parse_reviewed(value) when is_binary(value) do
    case Regex.run(~r/^(\d{4}-\d{2}-\d{2})(?:T(\d{2}:\d{2})Z)?$/, value) do
      [_, date] -> to_unix(date, "00:00")
      [_, date, time] -> to_unix(date, time)
      nil -> nil
    end
  end

  def parse_reviewed(_), do: nil

  defp to_unix(date, time) do
    case DateTime.from_iso8601("#{date}T#{time}:00Z") do
      {:ok, datetime, 0} -> DateTime.to_unix(datetime)
      _ -> nil
    end
  end

  @doc "First paragraph of a section, for the map's hover boxes."
  def first_paragraph(page, key) do
    page |> section(key) |> String.split(~r/\n\s*\n/, parts: 2) |> List.first("") |> String.trim()
  end

  @doc "Hash of the English text a translation was made from (title + all sections)."
  def source_hash(%__MODULE__{lang: "en"} = page) do
    text = [page.header["title"] || "" | Enum.map(page.sections, fn {k, t} -> k <> "\n" <> t end)]
    :crypto.hash(:sha256, Enum.join(text, "\n\n")) |> Base.encode16(case: :lower) |> binary_part(0, 12)
  end
end
