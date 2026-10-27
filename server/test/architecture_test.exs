defmodule Wiki.Content.ArchitectureTest do
  use Wiki.ContentCase, async: false

  alias Wiki.Content.{Architecture, Practices}

  defp errors(content), do: Check.run(Store.load(content))

  # REQ PJ-1
  test "a valid architecture has two parts and passes" do
    assert Architecture.problems(architecture()) == []
    assert [{"Context", _}, {"Containers", _}] = Architecture.levels(architecture())
  end

  # REQ PJ-1
  test "broken diagrams are explained" do
    one = fn ctx, con -> Architecture.problems("### Context\n#{ctx}\n### Containers\n#{con}") end
    ok_con = "person u: P — x\ncontainer c: C — y\nu -uses-> c"
    ok_ctx = "person u: P — x\nsystem s: S — y\nu -uses-> s"

    assert Enum.any?(Architecture.problems("### Context\n#{ok_ctx}"), &(&1 =~ "needs two parts"))
    assert Enum.any?(one.("person u: P\nu -uses-> u2", ok_con), &(&1 =~ "exactly one system"))
    assert Enum.any?(one.("system s: S\nsystem t: T\ns -uses-> t", ok_con), &(&1 =~ "exactly one system"))
    assert Enum.any?(one.("system s: S\nsystem t: T", ok_con), &(&1 =~ "exactly one system"))
    assert Enum.any?(one.(ok_ctx, "person u: P\ncontainer c: C\nu -> c"), &(&1 =~ "needs a label"))
    assert Enum.any?(one.(ok_ctx, "person u: P\ncontainer c: C\nstore d: D\nu -uses-> c"), &(&1 =~ "box d has no arrow"))
    assert Enum.any?(one.(ok_ctx, "container a: A\ncontainer b: B\na -x-> b\nb -y-> a"), &(&1 =~ "a loop through a, b"))
    assert Enum.any?(one.(ok_ctx, "person u: P\nsystem s: S\nu -uses-> s"), &(&1 =~ "no system box"))
    assert Enum.any?(one.("container c: C\nperson u: P\nsystem s: S\nu -uses-> s\nu -uses-> c", ok_con), &(&1 =~ "belong in the containers"))
  end

  # REQ PJ-1
  test "a project in a repository needs both sections; a project that is a laptop folder does not", %{content: c} do
    valid_wiki(c)
    write_page(c, "proj", base_header("proj", kind: "project", project: "none"), %{"what" => "[[a]] [[b]]", "flow" => flow()})
    assert Enum.any?(errors(c), &(&1 =~ "proj.md: section ## Architecture is missing"))

    write_page(c, "proj", base_header("proj", kind: "project", project: "none"), %{"what" => "[[a]] [[b]]", "flow" => flow(), "architecture" => architecture()})
    assert Enum.any?(errors(c), &(&1 =~ "proj.md: section ## Engineering practices is missing"))

    write_page(c, "proj", base_header("proj", kind: "project", project: "none", location: "home:.claude"), %{"what" => "[[a]] [[b]]", "flow" => flow()})
    assert errors(c) == []
  end

  # REQ PJ-4
  test "a program needs the Architecture section but not the practices", %{content: c} do
    valid_wiki(c)
    assert errors(c) == []
    write_page(c, "a", base_header("a", feeds: ["b"]), %{}, architecture: false)
    assert Enum.any?(errors(c), &(&1 =~ "a.md: section ## Architecture is missing: a program page"))
  end

  # REQ PJ-1
  test "a translated architecture keeps boxes, links and arrows and may change the words", %{content: c} do
    valid_wiki(c)
    de = Path.join(c, "proj.de.md")
    File.write!(de, String.replace(File.read!(de), "does the thing", "tut das Ding"))
    assert errors(c) == []

    File.write!(de, String.replace(File.read!(de), "c -writes-> d", "u -writes-> d"))
    assert Enum.any?(errors(c), &(&1 =~ "proj.de.md: architecture differs from the English one"))
  end

  # REQ PJ-2
  test "practices need the six parts in order; a translation needs six headings" do
    assert Practices.problems(practices()) == []
    assert [_] = Practices.problems("### Principles\nx")
    swapped = String.replace(practices(), "### Decisions", "### Zebra")
    assert [_] = Practices.problems(swapped)
    assert Practices.problems(swapped, true) == []
  end

  # REQ PJ-2
  test "a translation that drops a practice part is refused", %{content: c} do
    valid_wiki(c)
    de = Path.join(c, "proj.de.md")
    File.write!(de, String.replace(File.read!(de), "### Maintenance\nSix.", ""))
    assert Enum.any?(errors(c), &(&1 =~ "proj.de.md: practices need these parts"))
  end
end
