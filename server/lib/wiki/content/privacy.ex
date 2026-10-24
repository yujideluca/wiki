defmodule Wiki.Content.Privacy do
  @moduledoc """
  Privacy scan (same boundary as workflow-memory): no keys, tokens or passwords, and no contact data about
  other people. The only e-mail addresses allowed are Giovanni's and Anthropic's no-reply address.
  It is a safety net, not a guarantee: Claude still must not write such data.
  """
  alias Wiki.Content.Page

  @allowed_emails ~w(yujideluca@gmail.com noreply@anthropic.com)
  # The list of patterns is shared with workflow-memory (mem/privacy-patterns.tsv); server/priv/privacy-patterns.tsv is its
  # copy and the gate compares them on the laptop. Columns: kind, flags (i or -), what it is, regex.
  @patterns_file Path.expand("../../../priv/privacy-patterns.tsv", __DIR__)
  @external_resource @patterns_file
  @patterns @patterns_file
            |> File.read!()
            |> String.split("\n", trim: true)
            |> Enum.reject(&String.starts_with?(&1, "#"))
            |> Enum.map(fn line ->
              [_kind, flags, what, regex] = String.split(line, "\t")
              {Regex.compile!(regex, if(flags == "i", do: "i", else: "")), what}
            end)

  def scan(%Page{} = p) do
    text = Enum.map_join(p.sections, "\n", &elem(&1, 1)) <> "\n" <> Enum.map_join(p.header, "\n", &inspect/1)

    found =
      for {re, what} <- @patterns, Regex.match?(re, text), do: "looks like it contains #{what}"

    emails =
      Regex.scan(~r/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/, text)
      |> Enum.map(&hd/1)
      |> Enum.uniq()
      |> Enum.reject(&(String.downcase(&1) in @allowed_emails))
      |> Enum.map(&"contains the e-mail address #{&1} (only Giovanni's is allowed)")

    Enum.map(found ++ emails, &"#{p.file}: privacy: #{&1}")
  end
end
