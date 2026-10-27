defmodule Wiki.Content.Page do
  @moduledoc """
  One wiki page parsed from `content/<id>.md` (English, the source of truth) or
  `content/<id>.<lang>.md` (a translation).

  File layout: a header between two `---` lines (`key: value`, lists as `[a, b]`),
  then sections that start with `## <canonical English heading>`.
  """

  @sections [
    {"what", "What it is"},
    {"flow", "Flow"},
    {"architecture", "Architecture"},
    {"does", "What it does"},
    {"how", "How it does it"},
    {"where", "Where it sits in the pipeline"},
    {"receives", "Who receives its output"},
    {"practices", "Engineering practices"},
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

    {chunks, _} =
      body
      |> fenced_lines()
      |> Enum.reduce({[], nil}, fn {line, mode}, {chunks, current} ->
        if mode == :prose and String.starts_with?(line, "## ") do
          {[{String.trim(String.slice(line, 3..-1//1)), []} | chunks], true}
        else
          case {chunks, current} do
            {[{heading, lines} | rest], true} -> {[{heading, [line | lines]} | rest], true}
            _ -> {chunks, current}
          end
        end
      end)

    chunks
    |> Enum.reverse()
    |> Enum.reduce({[], []}, fn {heading, lines}, {acc, errs} ->
      case by_heading[heading] do
        nil -> {acc, errs ++ ["unknown section heading: ## #{heading}"]}
        key -> {acc ++ [{key, lines |> Enum.reverse() |> Enum.join("\n") |> String.trim()}], errs}
      end
    end)
  end

  def section(page, key), do: page.sections |> List.keyfind(key, 0, {key, ""}) |> elem(1)

  def list(page, key), do: Map.get(page.header, key, []) |> List.wrap()

  @doc "Every `[[id]]` or `[[id|label]]` link in the page body (not inside `code` quotes)."
  def links(page) do
    page.sections
    |> Enum.flat_map(fn {_, text} ->
      Regex.scan(~r/\[\[([^\]|]+)(?:\|[^\]]*)?\]\]/, strip_code(text))
    end)
    |> Enum.map(fn [_, id] -> String.trim(id) end)
    |> Enum.uniq()
  end

  @doc "Text with inline code spans and fenced code blocks removed, so examples are not read as links."
  def strip_code(text) do
    text
    |> fenced_lines()
    |> Enum.filter(fn {_, mode} -> mode == :prose end)
    |> Enum.map_join("\n", &elem(&1, 0))
    |> String.replace(~r/`[^`]*`/, "")
  end

  @doc "Closed Markdown code blocks as {info string, original contents}, including nested shorter fences."
  def fenced_blocks(text) do
    {blocks, _} =
      Enum.reduce(fenced_lines(text), {[], nil}, fn
        {_, {:open, info}}, {blocks, _} ->
          {blocks, {info, []}}

        {_, :close}, {blocks, {info, lines}} ->
          {[{info, (Enum.reverse(lines) |> Enum.join("\n")) <> "\n"} | blocks], nil}

        {line, :code}, {blocks, {info, lines}} ->
          {blocks, {info, [line | lines]}}

        _, acc ->
          acc
      end)

    Enum.reverse(blocks)
  end

  # CO-10: headings and example links inside the complete skill are source text, not wiki structure.
  defp fenced_lines(text) do
    {lines, _} =
      text
      |> String.split("\n")
      |> Enum.map_reduce(nil, fn line, fence ->
        if fence do
          trimmed = String.trim(line)

          if String.length(trimmed) >= String.length(fence) and
               String.trim(trimmed, String.first(fence)) == "" do
            {{line, :close}, nil}
          else
            {{line, :code}, fence}
          end
        else
          case Regex.run(~r/^ {0,3}(`{3,}|~{3,})(.*)$/, line) do
            [_, marker, info] -> {{line, {:open, String.trim(info)}}, marker}
            nil -> {{line, :prose}, nil}
          end
        end
      end)

    lines
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

  @doc """
  The last second the review covers: the whole minute for `2026-10-24T18:30Z`, so a change made earlier in that minute
  is not "after" the review; for a date alone it is the start of the day (any change that day is listed).
  """
  def reviewed_until(%__MODULE__{header: header} = page) do
    case reviewed_at(page) do
      nil -> nil
      time -> if Regex.match?(~r/T\d{2}:\d{2}Z$/, header["reviewed"]), do: time + 59, else: time
    end
  end

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

    :crypto.hash(:sha256, Enum.join(text, "\n\n"))
    |> Base.encode16(case: :lower)
    |> binary_part(0, 12)
  end
end
