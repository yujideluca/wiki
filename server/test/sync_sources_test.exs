defmodule Wiki.Content.SyncSourcesTest do
  use Wiki.ContentCase, async: false
  alias Wiki.Content.Sources

  @old 1_767_312_000
  @new 1_767_571_200

  setup %{dir: dir} do
    home = Path.join(dir, "home")
    root = Path.join(home, ".claude/skills")
    bucket = Path.join(root, "synced/account")
    skill = Path.join(bucket, "example")
    File.mkdir_p!(skill)
    File.write!(Path.join(skill, "SKILL.md"), "Instructions")
    manifest(bucket, @old)
    File.write!(Path.join(bucket, ".last-complete-round"), "round one")
    for path <- [home, Path.join(home, ".claude"), root, Path.join(root, "synced"), bucket, skill,
                 Path.join(skill, "SKILL.md"), Path.join(bucket, "manifest.json"), Path.join(bucket, ".last-complete-round")],
        do: File.touch!(path, @old)
    System.put_env("WIKI_HOME_ROOT", home)
    on_exit(fn -> System.delete_env("WIKI_HOME_ROOT") end)
    {:ok, root: root, bucket: bucket, skill: skill}
  end

  defp manifest(bucket, time, names \\ ["example"]) do
    File.write!(Path.join(bucket, "manifest.json"), JSON.encode!(%{lastUpdated: time * 1000, skills: Enum.map(names, &%{name: &1})}))
  end

  # REQ ST-7
  test "repeated sync writes and atomic marker replacement do not stale a reviewed page", %{content: c, bucket: bucket} do
    write_page(c, "a", base_header("a", sources: ["home:.claude/skills"], reviewed: "2026-01-03T00:00Z"))
    assert Stale.pages(Store.load(c)) == []
    for round <- 1..2 do
      manifest(bucket, @old)
      temp = Path.join(bucket, ".round-writing")
      File.write!(temp, "round #{round}")
      File.rename!(temp, Path.join(bucket, ".last-complete-round"))
      assert Stale.pages(Store.load(c)) == []
      assert Sources.last_change("home:.claude/skills") == @old
    end
  end

  # REQ ST-7
  test "real skill changes and identically named files inside skills stay watched", %{skill: skill} do
    for name <- ["SKILL.md", "manifest.json", ".last-complete-round"] do
      path = Path.join(skill, name)
      File.write!(path, "Changed instructions")
      File.touch!(path, @new)
      File.touch!(skill, @old)
      assert Sources.last_change("home:.claude/skills") == @new
      File.touch!(path, @old)
    end
  end

  # REQ ST-7
  test "sync membership changes count even after the last skill is removed", %{bucket: bucket, skill: skill} do
    File.rm_rf!(skill)
    manifest(bucket, @new, [])
    assert Sources.last_change("home:.claude/skills") == @new
    File.mkdir_p!(skill)
    File.touch!(skill, @old)
    manifest(bucket, @new)
    assert Sources.last_change("home:.claude/skills") == @new
  end

  # REQ ST-7
  test "deleting a file inside a skill still changes its directory time", %{skill: skill} do
    File.rm!(Path.join(skill, "SKILL.md"))
    File.touch!(skill, @new)
    assert Sources.last_change("home:.claude/skills") == @new
  end

  # REQ ST-7
  test "manual removal without a manifest update warns and keeps the deletion visible", %{bucket: bucket, skill: skill} do
    File.write!(Path.join(bucket, "manifest.json"), JSON.encode!(%{lastUpdated: @old * 1000, skills: [%{name: "example"}]}))
    assert Sources.last_change("home:.claude/skills") == @old
    File.rm_rf!(skill)
    File.touch!(Path.join(bucket, "manifest.json"), @old)
    File.touch!(bucket, @new)
    warning = ExUnit.CaptureIO.capture_io(:stderr, fn ->
      assert Sources.last_change("home:.claude/skills") == @new
    end)
    assert warning =~ "installed skill list"
  end

  # REQ ST-7
  test "bad or missing manifests warn and conservatively preserve directory changes", %{bucket: bucket} do
    path = Path.join(bucket, "manifest.json")
    for raw <- ["{", "{}", ~s({"lastUpdated":0,"skills":[]}), ~s({"lastUpdated":"bad","skills":[]}),
                JSON.encode!(%{lastUpdated: (System.os_time(:second) + 3600) * 1000, skills: []}), nil] do
      if raw, do: File.write!(path, raw), else: File.rm!(path)
      if raw, do: File.touch!(path, @old)
      File.touch!(bucket, @new)
      warning = ExUnit.CaptureIO.capture_io(:stderr, fn ->
        assert Sources.last_change("home:.claude/skills") == @new
      end)
      assert warning =~ "cannot read a valid Claude sync change time"
      assert warning =~ "manifest.json"
    end
  end
end
