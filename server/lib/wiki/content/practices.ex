defmodule Wiki.Content.Practices do
  @moduledoc """
  The `## Engineering practices` section of a project page: how the project follows the golden path of
  `project-template`, one `### ` part for each practice, always in this order. A translation translates the
  headings and keeps their number. Requirement PJ-2.
  """

  @parts ["Principles", "Decisions", "Requirements", "Quality gate", "Continuous integration", "Maintenance"]

  def parts, do: @parts

  def headings(text), do: for(line <- String.split(text, "\n"), m = Regex.run(~r/^###[ \t]+(.+?)[ \t]*$/, line), do: List.last(m))

  @doc "Problems in the English source (`translation: false`) or in a translation (`true`: only the count is checked)."
  def problems(text, translation \\ false) do
    found = headings(text)

    cond do
      translation and length(found) == length(@parts) -> []
      not translation and found == @parts -> []
      true -> ["practices need these parts in order: #{Enum.map_join(@parts, ", ", &"### #{&1}")} (found #{length(found)})"]
    end
  end
end
