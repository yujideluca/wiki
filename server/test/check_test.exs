defmodule Wiki.Content.CheckTest do
  use Wiki.ContentCase, async: false

  defp errors(content, opts \\ []), do: Check.run(Store.load(content), opts)

  test "a valid wiki has no errors", %{content: c} do
    valid_wiki(c)
    assert errors(c) == []
  end

  # REQ CO-1
  test "missing header fields and empty or missing sections are reported", %{content: c} do
    valid_wiki(c)
    write_page(c, "x", [id: "x", title: "X", project: "proj", reviewed: "2026-10-22"], %{"how" => "", "what" => "[[a]]"})
    errs = errors(c)
    assert Enum.any?(errs, &(&1 =~ "x.md: header field kind missing"))
    assert Enum.any?(errs, &(&1 =~ "x.md: header field status missing"))
    assert Enum.any?(errs, &(&1 =~ "x.md: section ## How it does it is missing or empty"))
  end

  # REQ CO-1
  test "unknown kind, bad status, wrong id and unknown heading are reported", %{content: c} do
    valid_wiki(c)
    File.write!(Path.join(c, "y.md"), page_text(base_header("z", kind: "spaceship", status: "maybe")) <> "\n## Gossip\nno\n")
    errs = errors(c)
    assert Enum.any?(errs, &(&1 =~ "y.md: header id z does not match"))
    assert Enum.any?(errs, &(&1 =~ "y.md: unknown kind spaceship"))
    assert Enum.any?(errs, &(&1 =~ "y.md: status must be one of"))
    assert Enum.any?(errs, &(&1 =~ "y.md: unknown section heading: ## Gossip"))
  end

  # REQ CO-2
  test "links and pipeline ids must exist", %{content: c} do
    valid_wiki(c)
    write_page(c, "a", base_header("a", feeds: ["b", "ghost"]), %{"what" => "See [[nowhere|there]]."})
    errs = errors(c)
    assert Enum.any?(errs, &(&1 =~ "a.md: link [[nowhere]] points to no page"))
    assert Enum.any?(errs, &(&1 =~ "a.md: feeds ghost points to no page"))
  end

  # REQ CO-2
  test "links written inside code quotes are examples, not links", %{content: c} do
    valid_wiki(c)
    write_page(c, "a", base_header("a", feeds: ["b"]), %{"what" => "Write `[[id]]` to link; see [[b]]."})
    assert errors(c) == []
  end

  # REQ CO-2
  test "feeds and fed_by must agree", %{content: c} do
    valid_wiki(c)
    write_page(c, "b", base_header("b"), %{"what" => "[[a]]"})
    assert Enum.any?(errors(c), &(&1 =~ "b.md: fed_by is missing a"))
  end

  # REQ CO-3
  test "orphans are reported, except actors", %{content: c} do
    valid_wiki(c)
    write_page(c, "lonely", base_header("lonely", project: "none"))
    write_page(c, "giovanni", base_header("giovanni", kind: "actor", project: "none"))
    errs = errors(c)
    assert Enum.any?(errs, &(&1 =~ "lonely.md: orphan page"))
    refute Enum.any?(errs, &(&1 =~ "giovanni.md: orphan"))
  end

  # REQ CO-4
  test "privacy scan blocks secrets, phone numbers and other people's e-mails", %{content: c} do
    valid_wiki(c)

    for {id, text} <- [
          {"k1", "token: ghp_abcdefghijklmnopqrstuvwxyz123456"},
          {"k2", "Call +55 11 91234-5678 tomorrow."},
          {"k3", "Write to maria.silva@hospital.org"},
          {"k4", "password = hunter2hunter2"},
          {"k5", "-----BEGIN OPENSSH PRIVATE KEY-----"}
        ] do
      write_page(c, id, base_header(id), %{"what" => "[[a]] " <> text})
    end

    errs = errors(c) |> Enum.filter(&(&1 =~ "privacy"))
    for id <- ~w(k1 k2 k3 k4 k5), do: assert(Enum.any?(errs, &String.starts_with?(&1, "#{id}.md")), "#{id} not caught")
    refute Enum.any?(errors(c), &(&1 =~ "yujideluca"))
  end

  # REQ CO-4
  test "Giovanni's own e-mail is allowed", %{content: c} do
    valid_wiki(c)
    write_page(c, "a", base_header("a", feeds: ["b"]), %{"what" => "Login: yujideluca@gmail.com only."})
    assert errors(c) == []
  end

  # REQ CO-5
  test "a listed function mentioned by two other pages must be promoted", %{content: c} do
    valid_wiki(c)
    write_page(c, "a", base_header("a", feeds: ["b"]), %{"functions" => "- `fold`: folds the log\n- `tiny`: helper"})
    write_page(c, "b", base_header("b", fed_by: ["a"]), %{"how" => "Calls `fold`."})
    assert errors(c) == []

    write_page(c, "proj", base_header("proj", kind: "project", project: "none"), %{"what" => "[[a]] [[b]] use `fold`."})
    assert Enum.any?(errors(c), &(&1 =~ "a.md: `fold` is mentioned by b, proj: give it its own page"))

    write_page(c, "fold", base_header("fold"), %{"what" => "Part of [[a]]."})
    refute Enum.any?(errors(c), &(&1 =~ "give it its own page"))
  end

  # REQ CO-6
  test "a page without sources needs a reviewed date", %{content: c} do
    valid_wiki(c)
    write_page(c, "a", Keyword.delete(base_header("a", feeds: ["b"]), :reviewed))
    assert Enum.any?(errors(c), &(&1 =~ "a.md: a page without sources needs reviewed"))
  end

  # REQ CO-7
  test "sources must be repo:path, and local mode checks they exist", %{content: c, dir: dir} do
    valid_wiki(c)
    File.mkdir_p!(Path.join(dir, "dev/repo1"))
    File.write!(Path.join(dir, "dev/repo1/real.txt"), "x")
    System.put_env("WIKI_DEV_ROOT", Path.join(dir, "dev"))

    write_page(c, "a", base_header("a", feeds: ["b"], sources: ["repo1:real.txt", "repo1:gone.txt", "/abs/path"]))
    ci = errors(c)
    assert Enum.any?(ci, &(&1 =~ "a.md: source /abs/path is not repo:path"))
    refute Enum.any?(ci, &(&1 =~ "does not exist"))

    local = errors(c, local: true)
    assert Enum.any?(local, &(&1 =~ "a.md: source repo1:gone.txt does not exist"))
    refute Enum.any?(local, &(&1 =~ "repo1:real.txt does not exist"))
  after
    System.delete_env("WIKI_DEV_ROOT")
  end

  # REQ LG-1
  test "translations must exist and match the current English text", %{content: c} do
    valid_wiki(c)
    File.rm!(Path.join(c, "a.de.md"))
    assert Enum.any?(errors(c), &(&1 =~ "a.md: de translation missing"))

    valid_wiki(c)
    write_page(c, "b", base_header("b", fed_by: ["a"]), %{"does" => "Does new things."}, translate: false)
    errs = errors(c)
    assert Enum.any?(errs, &(&1 =~ "b.de.md: outdated"))
    assert Enum.any?(errs, &(&1 =~ "b.pt-BR.md: outdated"))
  end
end
