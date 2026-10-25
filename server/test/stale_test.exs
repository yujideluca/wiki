defmodule Wiki.Content.StaleTest do
  use Wiki.ContentCase, async: false

  # Source commits and review times in these tests are UTC, so the result does not depend on the laptop's time zone.
  @changed "2026-01-05T10:00:00Z"

  setup %{dir: dir, content: c} do
    repo = Path.join(dir, "dev/r1")
    init_repo(repo)
    File.mkdir_p!(Path.join(repo, "lib"))
    File.write!(Path.join(repo, "lib/x.ex"), "1")
    commit_all(repo, "first", "2026-01-01T10:00:00Z")
    System.put_env("WIKI_DEV_ROOT", Path.join(dir, "dev"))
    System.put_env("WIKI_HOME_ROOT", Path.join(dir, "home"))
    valid_wiki(c)

    on_exit(fn ->
      System.delete_env("WIKI_DEV_ROOT")
      System.delete_env("WIKI_HOME_ROOT")
      System.delete_env("WIKI_ROOT")
    end)

    {:ok, repo: repo}
  end

  defp change_source(repo, date \\ @changed) do
    File.write!(Path.join(repo, "lib/x.ex"), "changed #{date}")
    commit_all(repo, "change", date)
  end

  defp review(c, reviewed, extra \\ []) do
    write_page(c, "a", base_header("a", Keyword.merge([feeds: ["b"], sources: ["r1:lib/x.ex"], reviewed: reviewed], extra)))
  end

  defp stale_ids(c), do: Stale.pages(Store.load(c)) |> Enum.map(& &1.id)

  # REQ ST-1
  test "a page is listed when a source changed after its review, and a new review clears it", %{content: c, repo: repo} do
    review(c, "2026-01-02T00:00Z")
    assert stale_ids(c) == []

    change_source(repo)
    assert stale_ids(c) == ["a"]

    review(c, "2026-01-06T00:00Z")
    assert stale_ids(c) == []
  end

  # REQ ST-1
  test "commits that only touch the page file never clear it (the bulk rewrite of 2026-10-24)", %{content: c, dir: dir, repo: repo} do
    review(c, "2026-01-02T00:00Z")
    change_source(repo)

    # Every page is rewritten and committed in the wiki repository after the source changed.
    wiki_repo = Path.join(dir, "wiki")
    init_repo(wiki_repo)
    commit_all(wiki_repo, "rewrite every page", "2026-02-01T10:00:00Z")
    write_page(c, "a", base_header("a", feeds: ["b"], sources: ["r1:lib/x.ex"], reviewed: "2026-01-02T00:00Z"), %{"what" => "Reworded."})
    commit_all(wiki_repo, "rewrite again", "2026-02-02T10:00:00Z")

    assert stale_ids(c) == ["a"]
  end

  # REQ ST-1
  test "the review time has minute precision, and a date alone means the start of that day", %{content: c, repo: repo} do
    change_source(repo)

    review(c, "2026-01-05T12:00Z")
    assert stale_ids(c) == [], "changed at 10:00, reviewed at 12:00 the same day"

    review(c, "2026-01-05T09:00Z")
    assert stale_ids(c) == ["a"], "changed at 10:00, reviewed at 09:00 the same day"

    review(c, "2026-01-05")
    assert stale_ids(c) == ["a"], "a date alone is 00:00, so a change that day is listed"
  end

  # REQ ST-1
  test "a review at minute M covers all of that minute: a change at M:30 is not listed, one at M+1 is", %{content: c, repo: repo} do
    change_source(repo, "2026-01-05T10:00:30Z")

    review(c, "2026-01-05T10:00Z")
    assert stale_ids(c) == [], "changed 30 seconds into the minute the page was reviewed"

    change_source(repo, "2026-01-05T10:01:00Z")
    assert stale_ids(c) == ["a"], "changed in the next minute"
  end

  # REQ ST-1
  test "of several changed sources the newest is named; pages without sources are never listed; a page with sources and no review is listed",
       %{content: c, repo: repo} do
    File.write!(Path.join(repo, "lib/y.ex"), "1")
    commit_all(repo, "add y", "2026-01-03T10:00:00Z")
    change_source(repo, "2026-01-09T10:00:00Z")
    review(c, "2026-01-02T00:00Z", sources: ["r1:lib/y.ex", "r1:lib/x.ex"])

    [entry] = Stale.pages(Store.load(c))
    assert entry.reason =~ "r1:lib/x.ex changed 2026-01-09 10:00 UTC"
    assert entry.reason =~ "after the review of 2026-01-02 00:00 UTC"

    write_page(c, "a", Keyword.delete(base_header("a", feeds: ["b"], sources: ["r1:lib/x.ex"]), :reviewed))
    assert [%{id: "a", reason: reason}] = Stale.pages(Store.load(c))
    assert reason =~ "no reviewed time"

    write_page(c, "a", base_header("a", feeds: ["b"], reviewed: "2000-01-01"))
    assert stale_ids(c) == []
  end

  # REQ ST-2
  test "a source outside git counts as changed at the newest modification time of its file or folder", %{content: c, dir: dir} do
    skill = Path.join(dir, "home/.claude/skills/s")
    File.mkdir_p!(Path.join(skill, "sub"))
    old = DateTime.to_unix(~U[2026-01-02 00:00:00Z])
    File.write!(Path.join(skill, "SKILL.md"), "1")
    File.write!(Path.join(skill, "sub/notes.md"), "1")
    File.touch!(Path.join(skill, "SKILL.md"), old)
    File.touch!(Path.join(skill, "sub/notes.md"), old)
    File.touch!(Path.join(skill, "sub"), old)
    File.touch!(skill, old)

    write_page(c, "a", base_header("a", feeds: ["b"], sources: ["home:.claude/skills/s"], reviewed: "2026-01-03T00:00Z"))
    assert stale_ids(c) == []

    File.touch!(Path.join(skill, "sub/notes.md"), DateTime.to_unix(~U[2026-01-04 10:00:00Z]))
    assert [%{id: "a", reason: reason}] = Stale.pages(Store.load(c))
    assert reason =~ "home:.claude/skills/s changed 2026-01-04 10:00 UTC"

    write_page(c, "a", base_header("a", feeds: ["b"], sources: ["home:.claude/skills/s/SKILL.md"], reviewed: "2026-01-03T00:00Z"))
    assert stale_ids(c) == [], "a single file source ignores the folder around it"

    write_page(c, "a", base_header("a", feeds: ["b"], sources: ["home:.claude/skills/gone"], reviewed: "2026-01-03T00:00Z"))
    assert stale_ids(c) == [], "a source that does not exist is the check's business (CO-7), not staleness"
  end

  # REQ ST-3
  test "wiki stale prints the page, the source and both times, and exits 1; with nothing stale it exits 0", %{content: c, dir: dir, repo: repo} do
    System.put_env("WIKI_ROOT", Path.join(dir, "wiki"))
    review(c, "2026-01-02T00:00Z")

    out = ExUnit.CaptureIO.capture_io(fn -> assert Wiki.CLI.run(["stale"], []) == 0 end)
    assert out =~ "no stale pages"

    change_source(repo)
    out = ExUnit.CaptureIO.capture_io(fn -> assert Wiki.CLI.run(["stale"], []) == 1 end)
    assert out =~ "a: r1:lib/x.ex changed 2026-01-05 10:00 UTC, after the review of 2026-01-02 00:00 UTC"
    refute out =~ "no stale pages"
  end
end
