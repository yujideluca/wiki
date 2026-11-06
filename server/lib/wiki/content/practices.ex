defmodule Wiki.Content.Practices do
  @moduledoc """
  The `## Engineering practices` section of a project page: how the project follows the golden path of
  `project-template`, one `### ` part for each practice, always in this order. Requirement PJ-2.
  """

  @parts ["Principles", "Decisions", "Requirements", "Quality gate", "Continuous integration", "Maintenance"]

  def parts, do: @parts

  def headings(text), do: for(line <- String.split(text, "\n"), m = Regex.run(~r/^###[ \t]+(.+?)[ \t]*$/, line), do: List.last(m))

  @doc "Problems in a practices section; empty means it has the six parts in order."
  def problems(text) do
    found = headings(text)

    if found == @parts,
      do: [],
      else: ["practices need these parts in order: #{Enum.map_join(@parts, ", ", &"### #{&1}")} (found #{length(found)})"]
  end
end
