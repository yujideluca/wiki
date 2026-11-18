defmodule Wiki.HoldTest do
  @moduledoc "Holds for the Stop hook (UP-10, UP-11) and the hook's speed-ups (UP-12)."
  use Wiki.ContentCase, async: false
  alias Wiki.Content.{Hold, Memo, Sources, Git}

  setup %{dir: dir, content: c} do
    for r <- ["r1", "r2"] do
      repo = Path.join(dir, "dev/#{r}")
      init_repo(repo)
      File.mkdir_p!(Path.join(repo, "lib"))
      File.write!(Path.join(repo, "lib/x.ex"), "1")
      commit_all(repo, "first", "2026-01-01T10:00:00")
    end

    System.put_env("WIKI_DEV_ROOT", Path.join(dir, "dev"))
    System.put_env("WIKI_STATE_DIR", Path.join(dir, "state"))
    valid_wiki(c)
    write_page(c, "a", base_header("a", feeds: ["b"], sources: ["r1:lib"]))
    write_page(c, "b", base_header("b", fed_by: ["a"], sources: ["r2:lib"]))
    on_exit(fn -> System.delete_env("WIKI_DEV_ROOT") && System.delete_env("WIKI_STATE_DIR") end)

    Stale.mark_published(System.os_time(:second) - 3600)
    {:ok, dev: Path.join(dir, "dev"), store: Store.load(c)}
  end

  defp change(dev, repo) do
    File.write!(Path.join([dev, repo, "lib/x.ex"]), "changed #{System.unique_integer([:positive])}")
    commit_all(Path.join(dev, repo), "change", DateTime.utc_now() |> DateTime.add(-5) |> DateTime.to_iso8601())
  end

  defp ask(store, session), do: Stale.hook_result(store, %{"session_id" => session})

  # REQ UP-10
  test "without a hold the commits demand the pages, as before", %{dev: dev, store: store} do
    change(dev, "r1")
    assert {:block, msg} = ask(store, "s1")
    assert msg =~ "r1: update pages a"
    refute msg =~ "Wiki hold"
  end

  # REQ UP-10
  test "a hold silences its project with one notice line; other projects still demand", %{dev: dev, store: store} do
    change(dev, "r1")
    assert {:ok, _} = Hold.set("r1", "milestone M3 open")
    assert {:notice, line} = ask(store, "s1")
    assert line =~ "r1" and line =~ "milestone M3 open" and line =~ "1 page(s) held" and line =~ "until"
    refute String.contains?(line, "\n")

    change(dev, "r2")
    assert {:block, msg} = ask(store, "s2")
    assert msg =~ "r2: update pages b"
    refute msg =~ "update pages a"
    assert msg =~ "Wiki hold: r1"
  end

  # REQ UP-10
  test "a hold never moves the stamp and never consumes the once-per-session block", %{dev: dev, store: store} do
    change(dev, "r1")
    stamp = Stale.last_published()
    {:ok, _} = Hold.set("r1", "x")
    assert {:notice, _} = ask(store, "s1")
    assert Stale.record_publish(store) == :kept, "a publish stamp must not hide the held pages"
    assert Stale.last_published() == stamp
    :ok = Hold.release("r1")
    assert {:block, msg} = ask(store, "s1")
    assert msg =~ "update pages a"
  end

  # REQ UP-10
  test "after the expiry the demand returns by itself (also when the session crashed without releasing)", %{dev: dev, store: store} do
    change(dev, "r1")
    now = System.os_time(:second)
    {:ok, _} = Hold.set("r1", "crashed session", started: now - 7200, hours: 1)
    assert [{:expired, _}] = Hold.all()
    assert {:block, msg} = ask(store, "s1")
    assert msg =~ "update pages a"
    refute msg =~ "Wiki hold"
  end

  # REQ UP-11
  test "release removes the hold, releasing twice is harmless", %{dev: dev, store: store} do
    change(dev, "r1")
    {:ok, _} = Hold.set("r1", "x")
    assert Hold.release("r1") == :ok
    assert Hold.release("r1") == :none
    assert {:block, _} = ask(store, "s1")
  end

  # REQ UP-11
  test "a corrupt, empty, torn or foreign marker holds nothing", %{dev: dev, store: store} do
    change(dev, "r1")
    File.mkdir_p!(Hold.dir())
    file = Path.join(Hold.dir(), "r1.json")
    good = JSON.encode!(%{"project" => "r1", "reason" => "x", "started" => 1, "expires" => 99_999_999_999})

    bad = [
      "", "{", "[]", "null", "garbage", <<255, 254, 0>>, binary_part(good, 0, 20),
      JSON.encode!(%{"project" => "r1", "started" => 1, "expires" => "later"}),
      JSON.encode!(%{"project" => "other", "started" => 1, "expires" => 99_999_999_999}),
      JSON.encode!(%{"project" => "r1", "started" => 10, "expires" => 5})
    ]

    for {content, i} <- Enum.with_index(bad) do
      File.write!(file, content)
      assert [{:broken, "r1"}] = Hold.all(), inspect(content)
      assert {:block, msg} = ask(store, "bad-#{i}"), "a broken marker must not hide #{inspect(content)}"
      assert msg =~ "update pages a"
    end

    File.rm!(file)
    File.mkdir_p!(file)
    assert [{:broken, "r1"}] = Hold.all()
    assert {:block, _} = ask(store, "dir-marker")
  end

  # REQ UP-11
  test "two sessions at once, one holding: nothing is overwritten and hook_blocked stays whole", %{dev: dev, store: store} do
    change(dev, "r1")
    change(dev, "r2")

    tasks =
      for i <- 1..8 do
        Task.async(fn ->
          if rem(i, 2) == 0, do: {:hold, Hold.set("r1", "session #{i}")}, else: {:ask, ask(store, "s-#{i}")}
        end)
      end

    results = Enum.map(tasks, &Task.await/1)
    assert Enum.all?(for({:hold, r} <- results, do: r), &match?({:ok, _}, &1))
    assert [{:active, h}] = Hold.all()
    assert h["project"] == "r1"
    assert JSON.decode!(File.read!(Path.join(Hold.dir(), "r1.json")))["project"] == "r1"

    # every asking session got a whole answer about r2 (the demanded project)
    for {:ask, r} <- results, do: assert(match?({:block, m} when is_binary(m), r) or r == :ok)
    blocked = File.read!(Path.join(Stale.state_dir(), "hook_blocked"))
    assert String.valid?(blocked)
    assert Enum.all?(String.split(blocked, "\n", trim: true), &Regex.match?(~r/^\S+ \d+$/, &1))
    assert Path.wildcard(Path.join(Hold.dir(), "*.tmp*")) == [], "no temporary file is left"
  end

  # REQ UP-11
  test "names and hours are validated", %{} do
    for bad <- ["", "../x", "a/b", ".hidden", "a b", nil], do: assert({:error, _} = Hold.set(bad, "x"))
    for bad <- [0, -1, "3"], do: assert({:error, _} = Hold.set("r1", "x", hours: bad))
    assert {:error, _} = Hold.release("../x")
  end

  # REQ UP-11
  test "the command line: hold, list, release, unknown project, bad hours", %{dev: dev, store: store} do
    change(dev, "r1")
    out = fn args -> ExUnit.CaptureIO.capture_io(fn -> send(self(), {:code, Wiki.CLI.exec(args)}) end) end
    err = fn args -> ExUnit.CaptureIO.capture_io(:stderr, fn -> send(self(), {:code, Wiki.CLI.exec(args)}) end) end

    System.put_env("WIKI_ROOT", Path.dirname(store.dir))
    on_exit(fn -> System.delete_env("WIKI_ROOT") end)

    assert out.(["hold", "r1", "-m", "M3 open"]) =~ "holding r1 until"
    assert_received {:code, 0}
    assert out.(["hold"]) =~ "active   r1"
    assert err.(["hold", "nowhere", "-m", "x"]) =~ "no page names nowhere"
    assert_received {:code, 1}
    err.(["hold", "r1", "--hours", "100"])
    assert_received {:code, 2}
    err.(["hold", "r1", "--hours", "0"])
    assert_received {:code, 2}
    assert out.(["release", "r1"]) =~ "released r1"
    assert_received {:code, 0}
    assert out.(["hold"]) =~ "no holds"
  end

  # REQ UP-12
  test "the in-process top folder is the one git names, including a linked worktree", %{dir: dir} do
    main = Path.join(dir, "dev/r1")
    git(main, ["worktree", "add", "-q", Path.join(dir, "dev/wt"), "-b", "side"])
    File.mkdir_p!(Path.join(dir, "dev/wt/deep/er"))

    for {rel, base} <- [{"r1", "dev/r1/lib/x.ex"}, {"wt", "dev/wt/deep/er"}, {"wt", "dev/wt/lib/x.ex"}] do
      Memo.run(fn ->
        {top, _} = Sources.git_location("#{rel}:#{Path.relative_to(base, "dev/#{rel}")}")
        {expected, 0} = System.cmd("git", ["-C", Path.join(dir, "dev/#{rel}"), "rev-parse", "--show-toplevel"], env: Git.env())
        assert top == String.trim(expected)
      end)
    end

    File.mkdir_p!(Path.join(dir, "dev/plain"))
    assert Sources.git_location("plain:nothing") == nil
  end

  # REQ UP-12
  test "the hook gives the same answer with the parallel prefetch as without it", %{dev: dev, store: store} do
    change(dev, "r1")
    change(dev, "r2")
    cold = Stale.pages(store)
    warm = Memo.run(fn -> Stale.pages(store) end)
    assert cold == warm
    assert Stale.changes(store, 0) == Memo.run(fn -> Stale.changes(store, 0) end)
  end
end
