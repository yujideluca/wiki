defmodule Wiki.Content.Sources do
  @moduledoc """
  A page's `sources` name the files whose change makes the page stale, as `repo:path`.
  `repo` is a folder under the dev root (`~/dev`), or `home` for paths under the home folder
  (for example `home:.claude/skills/brainstorming`). Absolute laptop paths are not allowed,
  so pages stay valid on any machine.
  """

  def dev_root, do: System.get_env("WIKI_DEV_ROOT") || Path.expand("~/dev")
  def home_root, do: System.get_env("WIKI_HOME_ROOT") || Path.expand("~")

  @doc "Splits `repo:path` into `{root_dir, repo_dir, relative_path}`; nil when malformed."
  def resolve(source) do
    case String.split(source, ":", parts: 2) do
      ["home", path] when path != "" -> {home_root(), home_root(), path}
      [repo, path] when repo != "" and path != "" ->
        if String.contains?(repo, "/"), do: nil, else: {dev_root(), Path.join(dev_root(), repo), path}
      [repo] when repo != "" and repo != "home" ->
        if String.contains?(repo, "/"), do: nil, else: {dev_root(), Path.join(dev_root(), repo), "."}
      _ -> nil
    end
  end

  def exists?(source) do
    case resolve(source) do
      {_, dir, path} -> File.exists?(Path.join(dir, path))
      nil -> false
    end
  end

  @doc "The git repository that holds a source and the path inside it, or nil."
  def git_location(source) do
    with {_, dir, path} <- resolve(source),
         full = Path.expand(Path.join(dir, path)),
         base = if(File.dir?(full), do: full, else: Path.dirname(full)),
         {top, 0} <- System.cmd("git", ["-C", base, "rev-parse", "--show-toplevel"], stderr_to_stdout: true) do
      top = String.trim(top)
      {top, Path.relative_to(full, top)}
    else
      _ -> nil
    end
  end
end
