defmodule Wiki.Content.GitEnvTest do
  use Wiki.ContentCase, async: false

  # Issue #2: git exports GIT_DIR inside hooks (pre-push runs the gate); git calls on a temporary repo must ignore it.
  setup %{dir: dir} do
    fake = Path.join(dir, "not-the-repo/.git")
    File.mkdir_p!(fake)
    System.put_env("GIT_DIR", fake)
    on_exit(fn -> System.delete_env("GIT_DIR") end)
    {:ok, fake: fake}
  end

  test "test helpers build the temporary repo, not the one GIT_DIR names", %{dir: dir, fake: fake} do
    repo = Path.join(dir, "r")
    init_repo(repo)
    File.write!(Path.join(repo, "a"), "1")
    commit_all(repo, "c", "2026-01-01T10:00:00Z")
    assert File.dir?(Path.join(repo, ".git"))
    refute File.exists?(Path.join(fake, "config"))
  end

  test "Git.head reads the repo it is asked about", %{dir: dir} do
    repo = Path.join(dir, "r")
    System.delete_env("GIT_DIR")
    init_repo(repo)
    File.write!(Path.join(repo, "a"), "1")
    commit_all(repo, "c", "2026-01-01T10:00:00Z")
    System.put_env("GIT_DIR", Path.join(dir, "not-the-repo/.git"))
    assert Wiki.Content.Git.head(repo) =~ ~r/^[0-9a-f]{40}$/
  end
end
