defmodule Wiki.Content.Sources do
  @moduledoc """
  A page's `sources` name the files whose change makes the page stale, as `repo:path`.
  `repo` is a folder under the dev root (`~/dev`), or `home` for paths under the home folder
  (for example `home:.claude/skills/brainstorming`). Absolute laptop paths are not allowed,
  so pages stay valid on any machine.
  """

  alias Wiki.Content.{Git, Memo}

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
        {own, names} = sync_contents(path, own, names)
        Enum.reduce(names -- [".git"], own, fn name, newest -> max(newest, newest_mtime(Path.join(path, name)) || 0) end)

      {:ok, %File.Stat{mtime: time}} ->
        time

      {:error, _} ->
        nil
    end
  end

  # Claude rewrites these two files and the bucket directory on every sync, even when nothing changed.
  # Its manifest preserves lastUpdated on that path, and advances it on actual sync additions/removals.
  defp sync_contents(path, own, names) do
    if Path.dirname(path) == Path.join(home_root(), ".claude/skills/synced") do
      manifest = Path.join(path, "manifest.json")

      with {:ok, raw} <- File.read(manifest),
           {:ok, %{"lastUpdated" => ms, "skills" => skills}} <- JSON.decode(raw),
           true <- is_integer(ms) and ms > 0 and ms <= System.os_time(:millisecond),
           true <- is_list(skills) and Enum.all?(skills, &installed_skill?(&1, path)) do
        {div(ms, 1000), names -- ["manifest.json", ".last-complete-round"]}
      else
        _ ->
          IO.warn("cannot read a valid Claude sync change time or installed skill list from #{manifest}; using filesystem modification times")
          {own, names}
      end
    else
      {own, names}
    end
  end

  # A manually removed skill must not disappear behind the unchanged manifest clock.
  defp installed_skill?(%{"name" => name}, bucket) when is_binary(name) and name not in ["", ".", ".."] do
    Path.basename(name) == name and File.dir?(Path.join(bucket, name))
  end
  defp installed_skill?(_, _), do: false

  @doc """
  The path with symbolic links resolved (the path as given when it cannot be resolved, for example a link loop).
  Same answer as `realpath -m` on the expanded path: missing parts are kept as written, and a `..` inside a link's
  target goes to the parent of where the link points. Done in-process: the Stop hook asks this hundreds of times per run (UP-8).
  """
  def real(path) do
    path = Path.expand(path)

    Memo.fetch({:realpath, path}, fn ->
      case resolve_links(tl(Path.split(path)), "/", 0) do
        {:ok, resolved} -> resolved
        :loop -> path
      end
    end)
  end

  # Like GNU realpath, give up after many link hops (a loop); a long but finite chain is far shorter in practice.
  @max_links 256

  defp resolve_links(_parts, _at, hops) when hops > @max_links, do: :loop
  defp resolve_links([], at, _hops), do: {:ok, at}
  defp resolve_links(["." | rest], at, hops), do: resolve_links(rest, at, hops)
  defp resolve_links([".." | rest], at, hops), do: resolve_links(rest, Path.dirname(at), hops)

  defp resolve_links([name | rest], at, hops) do
    next = Path.join(at, name)

    case File.read_link(next) do
      {:ok, "/" <> _ = target} -> resolve_links(tl(Path.split(target)) ++ rest, "/", hops + 1)
      {:ok, target} -> resolve_links(Path.split(target) ++ rest, at, hops + 1)
      # Not a link, missing, or unreadable: `realpath -m` keeps the part as written and goes on.
      {:error, _} -> resolve_links(rest, next, hops)
    end
  end

  @doc "The git repository that holds a source and the path inside it, or nil."
  def git_location(source), do: Memo.fetch({:git_location, source}, fn -> locate(source) end)

  defp locate(source) do
    with {_, dir, path} <- resolve(source),
         full = real(Path.join(dir, path)),
         base = if(File.dir?(full), do: full, else: Path.dirname(full)),
         top when is_binary(top) <- toplevel(base) do
      {top, Path.relative_to(full, top)}
    else
      _ -> nil
    end
  end

  # The top folder of the git working tree that holds `base`: the nearest folder upward with a `.git` entry (a folder,
  # or a file in a linked worktree), as `git rev-parse --show-toplevel` answers, found without starting a program
  # (UP-12). `base` is already a real path. nil when `base` does not exist or lies in no working tree.
  defp toplevel(base) do
    if File.dir?(base), do: Memo.fetch({:toplevel, base}, fn -> walk_up(base) end)
  end

  defp walk_up(dir) do
    cond do
      File.exists?(Path.join(dir, ".git")) -> dir
      Path.basename(dir) == ".git" -> nil
      dir == "/" -> nil
      true -> walk_up(Path.dirname(dir))
    end
  end

  @doc """
  Starts, in parallel, the `git log` questions `Stale.pages/2` is about to ask for these sources (when no commit
  bound `at` is given), so that they are answered at once and cached (UP-12). `page_files` are `{source list,
  page file}` pairs.
  """
  def prefetch_changes(sources, wiki_repo) do
    calls =
      for source <- sources,
          {repo, path} <- [git_location(source)] |> Enum.reject(&is_nil/1) do
        if repo == wiki_repo and Regex.match?(~r{^content/[^/]+\.md$}, path),
          do: {repo, ["log", "-60", "--format=%ct %H"] ++ ["--", path]},
          else: {repo, ["log", "-1", "--format=%ct %H"] ++ ["--", path]}
      end

    Git.prefetch(calls)
  end
end
