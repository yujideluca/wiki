defmodule Wiki.Content.Sources do
  @moduledoc """
  A page's `sources` name the files whose change makes the page stale, as `repo:path`.
  `repo` is a folder under the dev root (`~/dev`), or `home` for paths under the home folder
  (for example `home:.claude/skills/brainstorming`). Absolute laptop paths are not allowed,
  so pages stay valid on any machine.
  """

  alias Wiki.Content.Git

  def dev_root, do: System.get_env("WIKI_DEV_ROOT") || Path.expand("~/dev")
  def home_root, do: System.get_env("WIKI_HOME_ROOT") || Path.expand("~")

  # An isolated publication must validate the wiki sources it will actually publish.
  # Other repositories still resolve through the declared development root.
  defp repo_root("wiki"), do: System.get_env("WIKI_ROOT") || Path.join(dev_root(), "wiki")
  defp repo_root(repo), do: Path.join(dev_root(), repo)

  @doc "Splits `repo:path` into `{root_dir, repo_dir, relative_path}`; nil when malformed."
  def resolve(source) do
    case String.split(source, ":", parts: 2) do
      ["home", path] when path != "" -> {home_root(), home_root(), path}
      [repo, path] when repo != "" and path != "" ->
        if String.contains?(repo, "/"), do: nil, else: {dev_root(), repo_root(repo), path}
      [repo] when repo != "" and repo != "home" ->
        if String.contains?(repo, "/"), do: nil, else: {dev_root(), repo_root(repo), "."}
      _ -> nil
    end
  end

  def exists?(source) do
    case resolve(source) do
      {_, dir, path} -> File.exists?(Path.join(dir, path))
      nil -> false
    end
  end

  @doc """
  Unix time of the last change to a source (ADR-0006): the last commit that touches it when it is in a git
  repository, otherwise the newest modification time of the file, or of the folder and everything inside it.
  nil when it cannot be told (the source does not exist, or is not `repo:path`).
  """
  def last_change(source) do
    case git_location(source) do
      {repo, path} -> Git.last_time(repo, path) || modified_at(source)
      nil -> modified_at(source)
    end
  end

  defp at_args(nil), do: []
  defp at_args({:rev, rev}) when is_binary(rev), do: [rev]
  defp at_args({:until, time}), do: ["--until=@#{time}"]
  defp at_args(_), do: []

  @doc """
  `{unix time, commit}` of the last commit touching a path in a repository, or nil. `at` limits the history:
  `{:rev, revision}` (commits reachable from it) or `{:until, unix time}` (commit date).
  """
  def last_commit(repo, path, at \\ nil) do
    case Git.cmd(repo, ["log", "-1", "--format=%ct %H"] ++ at_args(at) ++ ["--", path]) do
      nil -> nil
      "" -> nil
      out -> out |> String.split(" ") |> then(fn [t, h] -> {String.to_integer(t), h} end)
    end
  end

  @volatile ~r/^(reviewed|since):/

  @doc """
  Like `last_commit/3` for a wiki page file, but a commit counts only when it changed something other than the
  `reviewed` and `since` header lines (dates of when the page was checked or the thing began, not what it says).
  """
  def last_substantive_commit(repo, path, at \\ nil, limit \\ 60) do
    case Git.cmd(repo, ["log", "-#{limit}", "--format=%ct %H"] ++ at_args(at) ++ ["--", path]) do
      nil -> nil
      "" -> nil
      out ->
        out
        |> String.split("\n", trim: true)
        |> Enum.find_value(fn line ->
          [t, h] = String.split(line, " ")
          if text_at(repo, h, path) != text_at(repo, h <> "~1", path), do: {String.to_integer(t), h}
        end)
    end
  end

  defp text_at(repo, rev, path) do
    case Git.cmd(repo, ["show", "#{rev}:#{path}"]) do
      nil -> nil
      text -> text |> String.split("\n") |> Enum.reject(&Regex.match?(@volatile, &1)) |> Enum.join("\n")
    end
  end

  defp modified_at(source) do
    case resolve(source) do
      {_, dir, path} -> newest_mtime(Path.expand(Path.join(dir, path)))
      nil -> nil
    end
  end

  defp newest_mtime(path) do
    case File.lstat(path, time: :posix) do
      {:ok, %File.Stat{type: :directory, mtime: own}} ->
        names = case File.ls(path), do: ({:ok, names} -> names; _ -> [])
        Enum.reduce(names -- [".git"], own, fn name, newest -> max(newest, newest_mtime(Path.join(path, name)) || 0) end)

      {:ok, %File.Stat{mtime: time}} ->
        time

      {:error, _} ->
        nil
    end
  end

  @doc "The path with symbolic links resolved (the path as given when it cannot be resolved)."
  def real(path) do
    path = Path.expand(path)

    case System.cmd("realpath", ["-m", path], stderr_to_stdout: true) do
      {out, 0} -> String.trim(out)
      _ -> path
    end
  end

  @doc "The git repository that holds a source and the path inside it, or nil."
  def git_location(source) do
    with {_, dir, path} <- resolve(source),
         full = real(Path.join(dir, path)),
         base = if(File.dir?(full), do: full, else: Path.dirname(full)),
         {top, 0} <- System.cmd("git", ["-C", base, "rev-parse", "--show-toplevel"], env: Wiki.Content.Git.env(), stderr_to_stdout: true) do
      top = String.trim(top)
      {top, Path.relative_to(full, top)}
    else
      _ -> nil
    end
  end
end
