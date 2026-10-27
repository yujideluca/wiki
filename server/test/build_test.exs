defmodule Wiki.Content.BuildTest do
  use Wiki.ContentCase, async: false

  # REQ BU-1
  test "graph.json has nodes, feeds and mentions edges; one article per page per language", %{content: c, dir: dir} do
    valid_wiki(c)
    out = Path.join(dir, "site")
    :ok = Build.run(Store.load(c), out, today: ~D[2026-10-22])

    graph = out |> Path.join("data/graph.json") |> File.read!() |> JSON.decode!()
    assert graph["nodes"] |> Enum.map(& &1["id"]) |> Enum.sort() == ~w(a b proj)
    assert %{"from" => "a", "to" => "b", "type" => "feeds"} in graph["edges"]
    assert %{"from" => "a", "to" => "proj", "type" => "mentions"} in graph["edges"]
    refute Enum.any?(graph["edges"], &(&1["type"] == "mentions" and Enum.sort([&1["from"], &1["to"]]) == ["a", "b"]))
    a = Enum.find(graph["nodes"], &(&1["id"] == "a"))
    assert a["text"]["de"]["title"] == "a (de)"
    assert a["text"]["en"]["what"] == "A thing."

    for id <- ~w(a b proj), lang <- ~w(en de pt-BR) do
      art = out |> Path.join("data/pages/#{id}.#{lang}.json") |> File.read!() |> JSON.decode!()
      assert art["lang"] == lang
      expected = if id == "proj", do: ~w(what flow architecture does how where receives practices), else: ~w(what architecture does how where receives)
      assert Enum.map(art["sections"], & &1["key"]) == expected
    end
  end

  # REQ BU-3
  test "a reference page (the glossary) links anywhere without drawing edges on the map", %{content: c, dir: dir} do
    valid_wiki(c)
    write_page(c, "glossary", base_header("glossary", kind: "reference", project: "none"), %{"what" => "Terms: [[a]], [[b]]."})
    write_page(c, "proj", base_header("proj", kind: "project", project: "none"), Map.merge(%{"what" => "Has [[a]], [[b]] and [[glossary]]."}, project_sections()))
    out = Path.join(dir, "site")
    :ok = Build.run(Store.load(c), out, today: ~D[2026-10-22])
    edges = out |> Path.join("data/graph.json") |> File.read!() |> JSON.decode!() |> Map.fetch!("edges")
    pair = &Enum.sort([&1["from"], &1["to"]])
    refute Enum.any?(edges, &(pair.(&1) in [["a", "glossary"], ["b", "glossary"]]))
    assert Enum.any?(edges, &(pair.(&1) == ["glossary", "proj"]))
  end

  # REQ BU-2
  test "since comes from the header, else from the first commit of the sources", %{content: c, dir: dir} do
    repo = Path.join(dir, "dev/r1")
    init_repo(repo)
    File.write!(Path.join(repo, "f.txt"), "1")
    commit_all(repo, "first", "2025-03-04T10:00:00")
    System.put_env("WIKI_DEV_ROOT", Path.join(dir, "dev"))

    valid_wiki(c)
    write_page(c, "a", base_header("a", feeds: ["b"], sources: ["r1:f.txt"]))
    write_page(c, "b", base_header("b", fed_by: ["a"], since: "2020-01-01"))
    out = Path.join(dir, "site")
    :ok = Build.run(Store.load(c), out, today: ~D[2026-10-22])
    nodes = Path.join(out, "data/graph.json") |> File.read!() |> JSON.decode!() |> Map.fetch!("nodes")
    assert Enum.find(nodes, &(&1["id"] == "a"))["since"] == "2025-03-04"
    assert Enum.find(nodes, &(&1["id"] == "b"))["since"] == "2020-01-01"
  after
    System.delete_env("WIKI_DEV_ROOT")
  end

  # REQ CO-6
  test "a page without sources is marked may-be-stale 30 days after its review", %{content: c, dir: dir} do
    valid_wiki(c)
    write_page(c, "a", base_header("a", feeds: ["b"], reviewed: "2026-09-01"))
    out = Path.join(dir, "site")
    :ok = Build.run(Store.load(c), out, today: ~D[2026-10-22])
    read = &(Path.join(out, "data/pages/#{&1}.en.json") |> File.read!() |> JSON.decode!())
    assert read.("a")["mayBeStale"] == true
    assert read.("b")["mayBeStale"] == false
  end

  # REQ CO-6
  test "the may-be-stale mark reads a review time given with minutes too", %{content: c, dir: dir} do
    valid_wiki(c)
    write_page(c, "a", base_header("a", feeds: ["b"], reviewed: "2026-09-01T23:59Z"))
    write_page(c, "b", base_header("b", fed_by: ["a"], reviewed: "2026-10-01T00:00Z"))
    out = Path.join(dir, "site")
    :ok = Build.run(Store.load(c), out, today: ~D[2026-10-22])
    read = &(Path.join(out, "data/pages/#{&1}.en.json") |> File.read!() |> JSON.decode!())
    assert read.("a")["mayBeStale"] == true
    assert read.("b")["mayBeStale"] == false
  end

  describe "Stop hook" do
    setup %{dir: dir, content: c} do
      repo = Path.join(dir, "dev/r1")
      init_repo(repo)
      File.mkdir_p!(Path.join(repo, "lib"))
      File.write!(Path.join(repo, "lib/x.ex"), "1")
      commit_all(repo, "first", "2026-01-01T10:00:00")
      System.put_env("WIKI_DEV_ROOT", Path.join(dir, "dev"))
      System.put_env("WIKI_STATE_DIR", Path.join(dir, "state"))
      valid_wiki(c)
      write_page(c, "a", base_header("a", feeds: ["b"], sources: ["r1:lib"]))

      on_exit(fn ->
        System.delete_env("WIKI_DEV_ROOT")
        System.delete_env("WIKI_STATE_DIR")
      end)

      {:ok, repo: repo}
    end

    # REQ UP-1
    # REQ UP-3
    test "blocks once when covered code changed after the last publish", %{content: c, repo: repo} do
      Stale.mark_published(System.os_time(:second) - 60)
      store = Store.load(c)
      assert Stale.hook_message(store, %{"session_id" => "s"}) == nil

      File.write!(Path.join(repo, "lib/x.ex"), "2")
      File.write!(Path.join(repo, "NEW.md"), "new")
      commit_all(repo, "change", DateTime.utc_now() |> DateTime.to_iso8601())

      msg = Stale.hook_message(store, %{"session_id" => "s"})
      assert msg =~ "r1: update pages a"
      assert msg =~ "new files no page covers: NEW.md"
      assert msg =~ "reviewed: <UTC time>", "UP-3: a page checked and found right is recorded by its reviewed time"
      # REQ CO-10
      assert msg =~ "complete SKILL.md"
      assert msg =~ ~r/only when\s+what\s+changed is described by no page/
      assert Stale.hook_message(store, %{"session_id" => "s"}) == nil, "must not block twice in a session"
      assert Stale.hook_message(store, %{"session_id" => "other", "stop_hook_active" => true}) == nil
      assert Stale.hook_message(store, %{"session_id" => "other"}) =~ "update pages a"

      Stale.mark_published()
      assert Stale.hook_message(store, %{"session_id" => "third"}) == nil
    end

    # REQ UP-1
    test "ignores data folders listed in _ignore.txt", %{content: c, repo: repo} do
      File.write!(Path.join(c, "_ignore.txt"), "# data\nr1:data\n")
      Stale.mark_published(System.os_time(:second) - 60)
      File.mkdir_p!(Path.join(repo, "data"))
      File.write!(Path.join(repo, "data/event-1.md"), "x")
      commit_all(repo, "data only", DateTime.utc_now() |> DateTime.to_iso8601())
      assert Stale.hook_message(Store.load(c), %{"session_id" => "s"}) == nil
    end

    # REQ UP-1
    test "never blocks before the first publish or for repos the wiki does not cover", %{content: c, dir: dir} do
      store = Store.load(c)
      assert Stale.hook_message(store, %{"session_id" => "s"}) == nil

      Stale.mark_published(System.os_time(:second) - 60)
      other = Path.join(dir, "dev/unrelated")
      init_repo(other)
      File.write!(Path.join(other, "y"), "1")
      commit_all(other, "c", DateTime.utc_now() |> DateTime.to_iso8601())
      assert Stale.hook_message(store, %{"session_id" => "s"}) == nil
    end
  end

  # REQ UP-2
  test "publish refuses when the local check fails and commits only content/", %{dir: dir, content: c} do
    root = Path.join(dir, "wiki")
    init_repo(root)
    valid_wiki(c)
    File.write!(Path.join(root, "other.txt"), "unrelated work in progress")
    write_page(c, "a", base_header("a", feeds: ["b", "ghost"]))
    System.put_env("WIKI_ROOT", root)
    System.put_env("WIKI_STATE_DIR", Path.join(dir, "state"))

    ExUnit.CaptureIO.capture_io(fn -> assert Wiki.CLI.run(["publish"], message: "t") == 1 end)
    assert Wiki.Content.Git.cmd(root, ["log", "--oneline"]) in [nil, ""]

    # Valid content: check passes; build needs Elm, so test the commit step directly.
    valid_wiki(c)
    ExUnit.CaptureIO.capture_io(fn -> assert Wiki.CLI.run(["check"], local: true) == 0 end)
    ExUnit.CaptureIO.capture_io(fn -> Wiki.CLI.commit_only_content(root, "t") end)
    files = Wiki.Content.Git.cmd(root, ["show", "--name-only", "--format=", "HEAD"]) |> String.split("\n")
    assert Enum.all?(files, &String.starts_with?(&1, "content/"))
    refute "other.txt" in files
  after
    System.delete_env("WIKI_ROOT")
    System.delete_env("WIKI_STATE_DIR")
  end

  # REQ UP-4
  test "the Co-Authored-By line comes only from the publishing session, never a fixed name", %{dir: dir, content: c} do
    root = Path.join(dir, "wiki")
    init_repo(root)
    valid_wiki(c)
    System.put_env("WIKI_ROOT", root)
    System.put_env("WIKI_STATE_DIR", Path.join(dir, "state"))

    ExUnit.CaptureIO.capture_io(fn -> Wiki.CLI.commit_only_content(root, "first") end)
    refute Wiki.Content.Git.cmd(root, ["log", "-1", "--format=%B"]) =~ "Co-Authored-By"

    File.write!(Path.join(c, "extra.txt"), "x")
    ExUnit.CaptureIO.capture_io(fn -> Wiki.CLI.commit_only_content(root, "second", "Some Model <m@example.com>") end)
    body = Wiki.Content.Git.cmd(root, ["log", "-1", "--format=%B"])
    assert body =~ "Co-Authored-By: Some Model <m@example.com>"
    refute body =~ "Opus"

    assert Wiki.CLI.check_co_author(nil) == :ok
    assert Wiki.CLI.check_co_author("") == :ok
    assert Wiki.CLI.check_co_author("A B <a@b.c>") == :ok

    ExUnit.CaptureIO.capture_io(fn ->
      assert Wiki.CLI.check_co_author("no email") == 1
      assert Wiki.CLI.check_co_author("A <a@b.c>\nSigned-off-by: x <y@z.w>") == 1
    end)
  after
    System.delete_env("WIKI_ROOT")
    System.delete_env("WIKI_STATE_DIR")
  end

  # REQ UP-5
  test "--help and unknown options print the usage and never run the command", %{dir: dir, content: c} do
    root = Path.join(dir, "wiki")
    init_repo(root)
    valid_wiki(c)
    System.put_env("WIKI_ROOT", root)
    System.put_env("WIKI_STATE_DIR", Path.join(dir, "state"))

    out = ExUnit.CaptureIO.capture_io(fn -> assert Wiki.CLI.exec(["publish", "--help"]) == 0 end)
    assert out =~ "wiki publish -m MSG"
    ExUnit.CaptureIO.capture_io(fn -> assert Wiki.CLI.exec(["-h"]) == 0 end)
    ExUnit.CaptureIO.capture_io(fn -> assert Wiki.CLI.exec(["help"]) == 0 end)

    ExUnit.CaptureIO.capture_io(:stderr, fn ->
      assert Wiki.CLI.exec(["publish", "-m", "t", "--co-autor", "A <a@b.c>"]) == 2
      assert Wiki.CLI.exec(["publish", "--bogus"]) == 2
    end)

    # none of those committed anything
    assert Wiki.Content.Git.cmd(root, ["log", "--oneline"]) in [nil, ""]
  after
    System.delete_env("WIKI_ROOT")
    System.delete_env("WIKI_STATE_DIR")
  end
end
