defmodule Wiki.Content.FlowTest do
  use Wiki.ContentCase, async: false

  alias Wiki.Content.Flow

  defp errors(content), do: Check.run(Store.load(content))

  @good """
  trigger t: Giovanni asks | [[a]]
  step s: Reads the brief | [[b]], [[a]]
  decide d: Did it change a system?
  product p: Page updated
  product q: Nothing to do

  t -> s
  s -> d
  d -yes-> p
  d -no-> q
  """

  # REQ FL-1
  test "a valid flow parses into boxes and arrows" do
    {nodes, edges, errs} = Flow.parse(@good)
    assert errs == []
    assert Enum.map(nodes, &{&1.id, &1.kind}) == [{"t", "trigger"}, {"s", "step"}, {"d", "decide"}, {"p", "product"}, {"q", "product"}]
    assert Enum.find(nodes, &(&1.id == "s")).links == ["b", "a"]
    assert Enum.find(edges, &(&1.from == "d" and &1.to == "q")).label == "no"
    assert Flow.problems(@good) == []
  end

  # REQ FL-1
  test "broken flows are explained" do
    check = fn text -> Flow.problems(text) end
    assert Enum.any?(check.("step s: x\nproduct p: y\ns -> p"), &(&1 =~ "needs a trigger"))
    assert Enum.any?(check.("trigger t: x\nstep s: y\nt -> s"), &(&1 =~ "needs a product"))
    assert Enum.any?(check.("trigger t: x\nproduct p: y\nt -> ghost"), &(&1 =~ "ghost: no such box"))
    assert Enum.any?(check.("trigger t: x\nproduct p: y\nproduct z: z\nt -> p"), &(&1 =~ "z cannot be reached"))
    assert Enum.any?(check.("trigger t: x\nstep s: y\nproduct p: z\nt -> s"), &(&1 =~ "box s has no arrow out"))
    assert Enum.any?(check.("trigger t: x\ndecide d: ?\nproduct p: y\nproduct q: z\nt -> d\nd -> p\nd -> q"), &(&1 =~ "decision needs"))
    assert Enum.any?(check.("trigger t: x\nstep a: y\nstep b: y\nproduct p: z\nt -> a\na -> b\nb -> a\nb -> p"), &(&1 =~ "loop"))
    assert Enum.any?(check.("trigger t: x\nproduct p: y\nt -> p\nsomething odd"), &(&1 =~ "not understood"))
    assert Enum.any?(check.("trigger t: x\ntrigger t: y\nproduct p: z\nt -> p"), &(&1 =~ "defined twice"))
    long = String.duplicate("x", 140)
    assert Enum.any?(check.("trigger t: #{long}\nproduct p: y\nt -> p"), &(&1 =~ "label longer"))
  end

  # REQ FL-1
  test "actors, projects, processes and skills need a Flow section; other kinds do not", %{content: c} do
    valid_wiki(c)
    write_page(c, "proc", base_header("proc", kind: "project", project: "none"), %{"what" => "[[a]]"})
    assert Enum.any?(errors(c), &(&1 =~ "proc.md: section ## Flow is missing"))
    write_page(c, "proc", base_header("proc", kind: "project", project: "none"), %{"what" => "[[a]]", "flow" => flow()})
    assert errors(c) == []
  end

  # REQ FL-1
  test "a flow link must point to an existing page", %{content: c} do
    valid_wiki(c)
    bad = "trigger t: x | [[ghost]]\nproduct p: y\nt -> p"
    write_page(c, "proj", base_header("proj", kind: "project", project: "none"), %{"what" => "[[a]] [[b]]", "flow" => bad})
    assert Enum.any?(errors(c), &(&1 =~ "link [[ghost]] points to no page"))
  end

  # REQ FL-2
  test "a translated flow keeps boxes, links and arrows and may change the words", %{content: c} do
    valid_wiki(c)
    hdr = base_header("proj", kind: "project", project: "none")
    sections = %{"what" => "[[a]] [[b]]", "flow" => flow()}
    write_page(c, "proj", hdr, sections)
    assert errors(c) == []

    changed = String.replace(flow(), "Someone asks", "Jemand fragt")
    File.write!(Path.join(c, "proj.de.md"), String.replace(File.read!(Path.join(c, "proj.de.md")), flow(), changed))
    assert errors(c) == []

    broken = String.replace(changed, "[[b]]", "[[a]]")
    File.write!(Path.join(c, "proj.de.md"), String.replace(File.read!(Path.join(c, "proj.de.md")), changed, broken))
    assert Enum.any?(errors(c), &(&1 =~ "proj.de.md: flow differs from the English one"))
  end

  # REQ FL-2
  test "a translation without the flow is reported", %{content: c} do
    valid_wiki(c)
    File.write!(Path.join(c, "proj.pt-BR.md"), String.replace(File.read!(Path.join(c, "proj.pt-BR.md")), ~r/## Flow\n.*?\n\n/s, ""))
    assert Enum.any?(errors(c), &(&1 =~ "proj.pt-BR.md: section ## Flow is missing"))
  end
end
