defmodule Wiki.Content.Git do
  @moduledoc "Small read-only git helpers. Every function returns nil or [] when git has no answer."

  @doc "Env that unsets the repository variables git exports inside hooks, so a call acts on the repo it is given."
  def env, do: [{"GIT_DIR", nil}, {"GIT_WORK_TREE", nil}, {"GIT_INDEX_FILE", nil}]

  def cmd(dir, args) do
    case System.cmd("git", ["-C", dir | args], env: env(), stderr_to_stdout: true) do
      {out, 0} -> String.trim(out)
      _ -> nil
    end
  end

  @doc "Date (YYYY-MM-DD) of the first commit that added the path."
  def first_date(repo, path) do
    case cmd(repo, ["log", "--format=%as", "--reverse", "--", path]) do
      nil -> nil
      "" -> nil
      out -> out |> String.split("\n") |> hd()
    end
  end

  @doc "Unix time of the last commit touching the path."
  def last_time(repo, path) do
    case cmd(repo, ["log", "-1", "--format=%ct", "--", path]) do
      nil -> nil
      "" -> nil
      out -> String.to_integer(out)
    end
  end

  @doc "Commits touching a path, newest first, as maps with date and subject."
  def history(repo, path, limit \\ 30) do
    case cmd(repo, ["log", "-#{limit}", "--follow", "--format=%as%x09%s", "--", path]) do
      nil -> []
      "" -> []
      out ->
        out
        |> String.split("\n")
        |> Enum.map(fn line ->
          [date, subject] = String.split(line, "\t", parts: 2)
          %{"date" => date, "subject" => subject}
        end)
    end
  end

  @doc "Files changed in a repo by commits after a unix time."
  def changed_since(repo, time) do
    case cmd(repo, ["log", "--since=@#{time}", "--name-only", "--format="]) do
      nil -> []
      out -> out |> String.split("\n", trim: true) |> Enum.uniq()
    end
  end

  def head(repo), do: cmd(repo, ["rev-parse", "HEAD"])
end
