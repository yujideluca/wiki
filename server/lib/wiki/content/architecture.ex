defmodule Wiki.Content.Architecture do
  @moduledoc """
  The `## Architecture` section of a project page: two C4-model diagrams (c4model.com), written in the same line
  format as the flow (`Wiki.Content.Flow`), one under `### Context` and one under `### Containers`.

      ### Context
      person u: Giovanni — reads the pages
      system s: Wiki — the pages and the map
      external g: Google sign-in — proves who is asking

      u -reads-> s
      s -asks-> g

  Level 1 (context) shows the system as one box among the people and outside systems around it; level 2
  (containers) opens the system into the parts that run or store things. Box words: `person`, `system`,
  `container`, `store` (a data store), `external`. Every arrow names what the relation is for. The front end
  (`Flow.elm`) reads the same text. Requirement PJ-1.
  """

  alias Wiki.Content.Flow

  @kinds ~w(person system container store external)
  @max_nodes 14
  @max_label 140
  @max_links 2

  def kinds, do: @kinds

  @doc "Splits the section into its `### ` parts: `[{heading, text}]`."
  def levels(text) do
    text
    |> String.split(~r/^###[ \t]+/m)
    |> Enum.drop(1)
    |> Enum.map(fn part ->
      [heading | body] = String.split(part, "\n", parts: 2)
      {String.trim(heading), Enum.join(body, "")}
    end)
  end

  @doc "Problems in an architecture section (the English source or a translation); empty means it is valid."
  def problems(text) do
    case levels(text) do
      [{_, context}, {_, containers}] ->
        for(p <- level(context, :context), do: "architecture, context: " <> p) ++
          for(p <- level(containers, :containers), do: "architecture, containers: " <> p)

      parts ->
        ["architecture needs two parts, ### Context and ### Containers (found #{length(parts)})"]
    end
  end

  defp level(text, which) do
    {nodes, edges, errs} = Flow.parse(text, @kinds)
    ids = Enum.map(nodes, & &1.id)
    id_set = MapSet.new(ids)
    count = fn kind -> Enum.count(nodes, &(&1.kind == kind)) end
    touched = MapSet.new(Enum.flat_map(edges, &[&1.from, &1.to]))

    errs ++
      Enum.flat_map(
        [
          nodes == [] && ["no boxes"],
          length(nodes) > @max_nodes && ["#{length(nodes)} boxes (at most #{@max_nodes}): leave out the minor ones"],
          which == :context && count.("system") != 1 && ["the context diagram has exactly one system box (the project)"],
          which == :context && count.("person") + count.("external") == 0 && ["the context diagram shows at least one person or outside system"],
          which == :context && count.("container") + count.("store") > 0 && ["container and store boxes belong in the containers diagram"],
          which == :containers && count.("system") > 0 && ["the containers diagram opens the system: no system box"],
          which == :containers && count.("container") + count.("store") == 0 && ["the containers diagram needs at least one container or store"]
        ],
        &(&1 || [])
      ) ++
      for(id <- ids -- Enum.uniq(ids), do: "box #{id} is defined twice") ++
      for(n <- nodes, String.length(n.label) > @max_label, do: "box #{n.id}: label longer than #{@max_label} characters") ++
      for(n <- nodes, length(n.links) > @max_links, do: "box #{n.id}: at most #{@max_links} page links") ++
      for(e <- edges, e.from not in id_set, do: "arrow from #{e.from}: no such box") ++
      for(e <- edges, e.to not in id_set, do: "arrow to #{e.to}: no such box") ++
      for(e <- edges, e.label == "", do: "arrow #{e.from} -> #{e.to} needs a label saying what the relation is for (-reads->)") ++
      for(n <- nodes, !MapSet.member?(touched, n.id), do: "box #{n.id} has no arrow") ++
      case Flow.loop_through(edges, id_set) do
        [] -> []
        left -> ["a loop through #{Enum.join(Enum.sort(left), ", ")}: draw each relation once, from the side that starts it"]
      end
  end

  @doc "What a translation must keep: the boxes (ids, kinds, links) and the arrows' ends of both diagrams."
  def skeleton(text) do
    for {_, body} <- levels(text) do
      {nodes, edges, _} = Flow.parse(body, @kinds)
      {Enum.map(nodes, &{&1.id, &1.kind, &1.links}), Enum.map(edges, &{&1.from, &1.to})}
    end
  end
end
