defmodule Wiki.Content.Stale do
  @moduledoc """
  Keeps the wiki from falling behind the code.

  * `pages/1`: pages with a source that changed after the page's `reviewed` time (ADR-0006). The page file's own
    commits are never used: a rewrite or a translation fix is not a review. A source outside git counts by modification time.
  * `hook_message/2`: the Claude Code Stop hook. It returns a message (and the hook blocks the stop, exit 2)
    only when, since the last `wiki publish`, a repo under ~/dev got commits that touch some page's sources
    or add files no page covers. It blocks at most once per session for the same set of changes, and never
    when Claude Code says a stop hook is already active, so it cannot loop.
  """
  alias Wiki.Content.{Page, Sources, Git}

  def state_dir, do: System.get_env("WIKI_STATE_DIR") || Path.expand("~/.local/state/wiki")
  defp last_publish_file, do: Path.join(state_dir(), "last_publish")
  defp blocked_file, do: Path.join(state_dir(), "hook_blocked")

  def mark_published(time \\ System.os_time(:second)) do
    File.mkdir_p!(state_dir())
    File.write!(last_publish_file(), Integer.to_string(time))
  end

  def last_published do
    case File.read(last_publish_file()) do
      {:ok, s} -> s |> String.trim() |> String.to_integer()
      _ -> nil
    end
  end

  def pages(store) do
    for {id, page} <- Enum.sort(store.pages),
        sources = Page.list(page, "sources"),
        sources != [],
        entry = stale_entry(id, page, sources),
        do: entry
  end

  defp stale_entry(id, page, sources) do
    case Page.reviewed_at(page) do
      nil ->
        %{id: id, reason: "has no reviewed time (missing or not understood), so it was never compared with its sources"}

      reviewed ->
        changed = for source <- sources, time = Sources.last_change(source), time > reviewed, do: {time, source}

        case Enum.sort(changed, :desc) do
          [{time, source} | _] ->
            %{id: id, reason: "#{source} changed #{stamp(time)}, after the review of #{stamp(reviewed)}"}

          [] ->
            nil
        end
    end
  end

  defp stamp(unix), do: unix |> DateTime.from_unix!() |> Calendar.strftime("%Y-%m-%d %H:%M UTC")

  @doc "Repo folders under ~/dev that some page names as a source."
  def covered_repos(store) do
    store.pages
    |> Map.values()
    |> Enum.flat_map(&Page.list(&1, "sources"))
    |> Enum.flat_map(fn s -> case String.split(s, ":", parts: 2) do
      [repo, _] when repo != "home" -> [repo]
      _ -> []
    end end)
    |> Enum.uniq()
  end

  @doc "repo:path prefixes listed in content/_ignore.txt: data the hook does not watch file by file."
  def ignored(store) do
    case File.read(Path.join(store.dir, "_ignore.txt")) do
      {:ok, text} ->
        text
        |> String.split("\n", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == "" or String.starts_with?(&1, "#")))
        |> Enum.map(fn line ->
          [repo, path] = String.split(line <> ":", ":", parts: 3) |> Enum.take(2)
          {repo, String.trim_trailing(path, "/")}
        end)

      _ ->
        []
    end
  end

  defp ignored?(ignores, repo, file) do
    Enum.any?(ignores, fn {r, p} -> r == repo and (p == "" or file == p or String.starts_with?(file, p <> "/")) end)
  end

  @doc "Changes since the last publish: `[{repo, [stale page ids], [uncovered new files]}]`."
  def changes(store, since) do
    ignores = ignored(store)

    prefixes =
      for {id, p} <- store.pages, s <- Page.list(p, "sources"), [repo, path] <- [String.split(s, ":", parts: 2)],
          do: {repo, String.trim_trailing(path, "/"), id}

    for repo <- covered_repos(store),
        dir = Path.join(Sources.dev_root(), repo),
        File.dir?(Path.join(dir, ".git")),
        files = Git.changed_since(dir, since + 1) |> Enum.reject(&ignored?(ignores, repo, &1)),
        files != [] do
      own = for {^repo, path, id} <- prefixes, do: {path, id}
      hit = fn f -> Enum.filter(own, fn {path, _} -> path == "." or f == path or String.starts_with?(f, path <> "/") end) end
      stale = files |> Enum.flat_map(fn f -> Enum.map(hit.(f), &elem(&1, 1)) end) |> Enum.uniq() |> Enum.sort()
      added = Git.cmd(dir, ["log", "--since=@#{since + 1}", "--diff-filter=A", "--name-only", "--format="]) || ""
      uncovered =
        added
        |> String.split("\n", trim: true)
        |> Enum.uniq()
        |> Enum.reject(&ignored?(ignores, repo, &1))
        |> Enum.filter(&(hit.(&1) == []))
      {repo, stale, uncovered}
    end
    |> Enum.reject(fn {_, s, u} -> s == [] and u == [] end)
  end

  def hook_message(store, payload) do
    session = payload["session_id"] || "unknown"

    cond do
      payload["stop_hook_active"] == true -> nil
      last_published() == nil -> nil
      true ->
        case changes(store, last_published()) do
          [] -> nil
          changes -> once_per_session(session, changes)
        end
    end
  end

  defp once_per_session(session, changes) do
    signature = :erlang.phash2(changes) |> Integer.to_string()
    key = session <> " " <> signature
    seen = case File.read(blocked_file()) do
      {:ok, s} -> String.split(s, "\n", trim: true)
      _ -> []
    end

    if key in seen do
      nil
    else
      File.mkdir_p!(state_dir())
      File.write!(blocked_file(), Enum.join(Enum.take([key | seen], 200), "\n"))
      format(changes)
    end
  end

  defp format(changes) do
    lines =
      Enum.flat_map(changes, fn {repo, stale, uncovered} ->
        (stale != [] && ["- #{repo}: update pages #{Enum.join(stale, ", ")}"] || []) ++
          (uncovered != [] && ["- #{repo}: new files no page covers: #{uncovered |> Enum.take(8) |> Enum.join(", ")}"] || [])
      end)

    """
    Wiki update needed: code changed since the last `wiki publish`.
    #{Enum.join(lines, "\n")}
    Update or create those pages in ~/dev/wiki/content (English, then de and pt-BR). A page you compared with its
    sources and found right still needs `reviewed: <UTC time>` (date -u +%Y-%m-%dT%H:%MZ): that edit is the review.
    Then run `wiki publish -m "..."`, then `mem use`. Use `wiki publish -m "review: no page change"` only when what
    changed is described by no page (for example a data file).
    """
  end
end
