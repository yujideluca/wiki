defmodule Wiki.Content.Flow do
  @moduledoc """
  The `## Flow` section: a flowchart written as one line per box and one line per arrow.

      trigger t: Giovanni asks for a task | [[giovanni]]
      step    a: Reads the brief | [[session-brief]]
      decide  d: Did it change a system?
      product p: Page updated | [[wiki-content]]

      t -> a
      a -> d
      d -yes-> p
      d -no-> a2

  Box kinds: `trigger` (what starts the chain), `step`, `decide` (a question with two or more labelled
  arrows out) and `product` (an end of the chain). The front end (`Flow.elm`) reads the same text, so the two
  parsers must agree; both are tested on the same example.
  """

  @kinds ~w(trigger step decide product)
  @max_nodes 18
  @max_label 120
  @max_links 2

  @node ~r/^(trigger|step|decide|product)\s+([a-z][a-z0-9_]*)\s*:\s*(.+)$/
  @edge ~r/^([a-z][a-z0-9_]*)\s+-(?:([^>]*?)-)?>\s+([a-z][a-z0-9_]*)$/
  @link ~r/\[\[([^\]|]+)(?:\|[^\]]*)?\]\]/

  def kinds, do: @kinds

  @doc "Parses the section text into `{nodes, edges, errors}` (nodes and edges in file order)."
  def parse(text) do
    text
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.reduce({[], [], []}, fn line, {nodes, edges, errs} ->
      cond do
        m = Regex.run(@node, line) ->
          [_, kind, id, rest] = m
          {label, links} = split_links(rest)
          {[%{id: id, kind: kind, label: label, links: links} | nodes], edges, errs}

        m = Regex.run(@edge, line) ->
          [_, from, label, to] = m
          {nodes, [%{from: from, to: to, label: String.trim(label)} | edges], errs}

        true ->
          {nodes, edges, errs ++ ["flow line not understood: #{line}"]}
      end
    end)
    |> then(fn {n, e, errs} -> {Enum.reverse(n), Enum.reverse(e), errs} end)
  end

  defp split_links(rest) do
    case String.split(rest, "|", parts: 2) do
      [label, tail] -> {String.trim(label), Enum.map(Regex.scan(@link, tail), fn [_, id] -> String.trim(id) end)}
      [label] -> {String.trim(label), []}
    end
  end

  @doc "Problems in one flow (the English source or a translation); empty means it is valid."
  def problems(text) do
    {nodes, edges, errs} = parse(text)
    ids = Enum.map(nodes, & &1.id)
    id_set = MapSet.new(ids)
    out = Enum.group_by(edges, & &1.from)

    errs ++
      Enum.flat_map(
        [
          nodes == [] && ["flow has no boxes"],
          length(nodes) > @max_nodes && ["flow has #{length(nodes)} boxes (at most #{@max_nodes}): split the chain"],
          Enum.all?(nodes, &(&1.kind != "trigger")) && ["flow needs a trigger box (what starts the chain)"],
          Enum.all?(nodes, &(&1.kind != "product")) && ["flow needs a product box (what the chain ends with)"]
        ],
        &(&1 || [])
      ) ++
      for(id <- ids -- Enum.uniq(ids), do: "flow box #{id} is defined twice") ++
      for(n <- nodes, String.length(n.label) > @max_label, do: "flow box #{n.id}: label longer than #{@max_label} characters") ++
      for(n <- nodes, length(n.links) > @max_links, do: "flow box #{n.id}: at most #{@max_links} page links") ++
      for(e <- edges, e.from not in id_set, do: "flow arrow from #{e.from}: no such box") ++
      for(e <- edges, e.to not in id_set, do: "flow arrow to #{e.to}: no such box") ++
      for(n <- nodes, n.kind == "product", Map.has_key?(out, n.id), do: "flow box #{n.id}: a product ends the chain, it has no arrow out") ++
      for(n <- nodes, n.kind != "product", !Map.has_key?(out, n.id), do: "flow box #{n.id} has no arrow out") ++
      for(n <- nodes, n.kind == "trigger", Enum.any?(edges, &(&1.to == n.id)), do: "flow box #{n.id}: a trigger starts the chain, nothing points to it") ++
      for(n <- nodes, n.kind == "decide", not (length(out[n.id] || []) >= 2 and Enum.all?(out[n.id] || [], &(&1.label != ""))),
          do: "flow box #{n.id}: a decision needs two or more arrows, each with a label (-yes->)") ++
      unreachable(nodes, edges, id_set) ++
      cycle(edges, id_set)
  end

  defp unreachable(nodes, edges, id_set) do
    starts = for n <- nodes, n.kind == "trigger", do: n.id
    seen = walk(starts, edges, MapSet.new(starts))
    for n <- nodes, n.id in id_set, !MapSet.member?(seen, n.id), do: "flow box #{n.id} cannot be reached from a trigger"
  end

  defp walk([], _edges, seen), do: seen

  defp walk([id | rest], edges, seen) do
    next = for e <- edges, e.from == id, !MapSet.member?(seen, e.to), do: e.to
    walk(rest ++ Enum.uniq(next), edges, Enum.reduce(next, seen, &MapSet.put(&2, &1)))
  end

  # Kahn's algorithm: whatever cannot be removed lies on or behind a loop.
  defp cycle(edges, id_set) do
    edges = Enum.filter(edges, &(&1.from in id_set and &1.to in id_set))
    left = peel(MapSet.to_list(id_set), edges)
    if left == [], do: [], else: ["flow has a loop through #{Enum.join(Enum.sort(left), ", ")}: write a repeat in the text, not as an arrow"]
  end

  defp peel(ids, edges) do
    free = for id <- ids, Enum.all?(edges, &(&1.to != id)), do: id

    if free == [] do
      ids
    else
      peel(ids -- free, Enum.reject(edges, &(&1.from in free)))
    end
  end

  @doc "What a translation must keep from the English flow: box ids, kinds and links, and the arrows' ends."
  def skeleton(text) do
    {nodes, edges, _} = parse(text)
    {Enum.map(nodes, &{&1.id, &1.kind, &1.links}), Enum.map(edges, &{&1.from, &1.to})}
  end
end
