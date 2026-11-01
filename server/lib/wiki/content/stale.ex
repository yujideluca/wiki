defmodule Wiki.Content.Stale do
  @moduledoc """
  Keeps the wiki from falling behind the code.

  * `pages/1`: pages with a source that changed after the page's `reviewed` time (ADR-0006). The page file's own
    commits are never used: a rewrite or a translation fix is not a review. A source outside git counts by modification time.
  * `claimed/2`: the pages whose `reviewed` line a commit changed and that were still behind a source when that commit
    was made. `wiki publish` refuses to push such a commit (ADR-0009).
  * `record_publish/2`: the publish stamp the hook compares against. It moves forward only when no page is still
    behind a change made since the previous stamp, so one session's publish cannot hide another session's unreviewed code.
  * `hook_message/2`: the Claude Code Stop hook. It returns a message (and the hook blocks the stop, exit 2)
    only when, since the last `wiki publish`, a repo under ~/dev got commits that touch some page's sources
    or add files no page covers. It blocks at most once per session for the same set of changes, and never
    when Claude Code says a stop hook is already active, so it cannot loop.
  """
  alias Wiki.Content.{Page, Sources, Git}

  def state_dir, do: System.get_env("WIKI_STATE_DIR") || Path.expand("~/.local/state/wiki")
  defp last_publish_file, do: Path.join(state_dir(), "last_publish")
  defp blocked_file, do: Path.join(state_dir(), "hook_blocked")

  # The stamp is written to a temporary file and renamed, so a reader never sees half a number.
  def mark_published(time \\ System.os_time(:second)) do
    File.mkdir_p!(state_dir())
    tmp = last_publish_file() <> ".tmp#{System.pid()}.#{System.unique_integer([:positive])}"
    File.write!(tmp, Integer.to_string(time))
    File.rename!(tmp, last_publish_file())
  end

  @doc """
  Moves the publish stamp forward after a publish, unless a page is still behind a change made since the previous
  stamp, or a new file no page covers appeared since then (another session's unreviewed work): then the stamp stays,
  and the Stop hook keeps naming them. A missing or broken stamp is never overwritten while a page is behind a source
  (that would erase the obligation); only a verified clean state sets a baseline. Returns `:kept` or `:ok`.
  """
  def record_publish(store, time \\ System.os_time(:second)) do
    pending =
      case last_published() do
        since when is_integer(since) -> changes(store, since)
        _ -> pages(store)
      end

    if pending == [] do
      mark_published(time)
      :ok
    else
      :kept
    end
  end

  @doc """
  The publish stamp: `nil` when none was ever written, a positive unix time, or `{:invalid, reason}` when the file is
  empty, torn, not a whole number, zero, negative or in the far future. It never raises.
  """
  def last_published do
    case File.read(last_publish_file()) do
      {:ok, raw} -> parse_stamp(raw)
      {:error, :enoent} -> nil
      {:error, reason} -> {:invalid, "cannot be read (#{reason})"}
    end
  end

  defp parse_stamp(raw) do
    with true <- String.valid?(raw),
         {n, ""} <- raw |> String.trim() |> Integer.parse(),
         true <- n > 0 and n <= System.os_time(:second) do
      n
    else
      _ -> {:invalid, "does not hold a plausible time"}
    end
  end

  def pages(store, opts \\ []) do
    ctx = context(store, opts)

    for {id, page} <- Enum.sort(store.pages),
        sources = Page.list(page, "sources"),
        sources != [],
        entry = stale_entry(ctx, id, page, sources),
        do: entry
  end

  @doc """
  Pages whose `reviewed` line was changed by the commit `rev` (or by the commits of a range `a..b`) and were still behind
  a source when it was made. Source changes after the commit are ignored: they are later work, not a false review.
  """
  def claimed(store, rev) do
    tip = rev |> String.split("..") |> List.last() |> then(&if(&1 == "", do: "HEAD", else: &1))

    with dir when is_binary(dir) <- wiki_repo(store),
         as_of when is_binary(as_of) <- Git.cmd(dir, ["log", "-1", "--format=%ct", tip]),
         diff when is_binary(diff) <- Git.cmd(dir, diff_args(rev)) do
      ids = reviewed_ids(diff)
      store |> pages(as_of: String.to_integer(as_of), tip: tip) |> Enum.filter(&(&1.id in ids))
    else
      _ -> []
    end
  end

  defp diff_args(rev) do
    if String.contains?(rev, ".."),
      do: ["log", "-p", "--format=", "-U0", rev, "--", "content"],
      else: ["show", "--format=", "-U0", rev, "--", "content"]
  end

  # Ids of the English pages with a `+reviewed:` line in a unified diff.
  defp reviewed_ids(diff) do
    {_, ids} =
      diff
      |> String.split("\n")
      |> Enum.reduce({nil, MapSet.new()}, fn
        "+++ b/content/" <> file, {_, ids} -> {file, ids}
        "+reviewed:" <> _, {file, ids} when is_binary(file) ->
          if Regex.match?(~r/^[^.]+\.md$/, file), do: {file, MapSet.put(ids, String.replace_suffix(file, ".md", ""))}, else: {file, ids}
        _, acc -> acc
      end)

    ids
  end

  defp wiki_repo(store) do
    case Git.cmd(store.dir, ["rev-parse", "--show-toplevel"]) do
      nil -> nil
      top -> top
    end
  end

  defp context(store, opts) do
    %{store: store, repo: wiki_repo(store) && realpath(wiki_repo(store)), as_of: opts[:as_of], tip: opts[:tip]}
  end

  defp realpath(path), do: Sources.real(path)
  defp real(path), do: Sources.real(path)

  defp stale_entry(ctx, id, page, sources) do
    case Page.reviewed_at(page) do
      nil ->
        %{id: id, reason: "has no reviewed time (missing or not understood), so it was never compared with its sources"}

      reviewed ->
        covered = Page.reviewed_until(page)
        own = real(Path.join(ctx.store.dir, page.file))
        review_commit = review_commit(ctx, page)

        changed =
          for source <- sources,
              not own?(source, own),
              {time, sha, same_repo?, exact?} <- [source_change(ctx, source)],
              time != nil,
              time > covered,
              exact? or ctx.as_of == nil or time <= ctx.as_of,
              not covered_by_commit?(ctx, {time, sha, same_repo?}, covered, review_commit),
              do: {time, source}

        case Enum.sort(changed, :desc) do
          [{time, source} | _] ->
            %{id: id, reason: "#{source} changed #{stamp(time)}, after the review of #{stamp(reviewed)}"}

          [] ->
            nil
        end
    end
  end

  # A page that lists its own file: its text can never be "newer than its review" in a way the review could have seen.
  defp own?(source, own) do
    case Sources.resolve(source) do
      {_, dir, path} -> real(Path.join(dir, path)) == own
      nil -> false
    end
  end

  # `{unix time, commit, in the wiki repository?, from git history?}` of the last change of a source. Inside the wiki
  # repository the text of a page counts only when something other than its `since` and `reviewed` lines changed.
  # When judging a claim (`ctx.as_of`), git history is read as of the commit being judged (the revision itself in the
  # wiki repository, the commit date elsewhere); a source outside git has no history, so its newest change is used
  # and ignored when later than the commit.
  defp source_change(ctx, source) do
    case Sources.git_location(source) do
      {repo, path} ->
        same? = real(repo) == ctx.repo
        at = cond do
          ctx.as_of == nil -> nil
          same? -> {:rev, ctx.tip}
          true -> {:until, ctx.as_of}
        end

        found =
          if same? and Regex.match?(~r{^content/[^/]+\.md$}, path),
            do: Sources.last_substantive_commit(repo, path, at),
            else: Sources.last_commit(repo, path, at)

        case found do
          {time, sha} -> {time, sha, same?, true}
          nil -> {Sources.last_change(source), nil, false, false}
        end

      nil ->
        {Sources.last_change(source), nil, false, false}
    end
  end

  # Exact rule, no grace period: a source in the wiki repository is covered by the review only when the commit that
  # last changed its text is the very commit that last set the page's `reviewed` line. They are one atomic change, so
  # the reviewer had that text in front of them; the typed minute necessarily precedes the commit. A source commit
  # of any other session, before or after, is covered only by the minute on the clock.
  defp covered_by_commit?(_ctx, {_t, nil, _}, _covered, _rc), do: false
  defp covered_by_commit?(_ctx, {_t, _sha, false}, _covered, _rc), do: false
  defp covered_by_commit?(_ctx, {_t, _sha, true}, _covered, nil), do: false
  defp covered_by_commit?(_ctx, {_t, sha, true}, _covered, review_commit), do: sha == review_commit

  defp review_commit(%{repo: nil}, _page), do: nil

  defp review_commit(ctx, page) do
    case Git.cmd(ctx.repo, ["log", "-1", "--format=%H", "-G^reviewed:"] ++ List.wrap(ctx.tip) ++ ["--", Path.relative_to(real(Path.join(ctx.store.dir, page.file)), ctx.repo)]) do
      "" -> nil
      sha -> sha
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
    behind = store |> pages() |> MapSet.new(& &1.id)

    prefixes =
      for {id, p} <- store.pages, s <- Page.list(p, "sources"), [repo, path] <- [String.split(s, ":", parts: 2)],
          do: {repo, String.trim_trailing(path, "/"), id}

    for repo <- covered_repos(store),
        dir = Path.join(Sources.dev_root(), repo),
        Git.toplevel?(dir),
        files = Git.changed_since(dir, since) |> Enum.reject(&ignored?(ignores, repo, &1)),
        files != [] do
      own = for {^repo, path, id} <- prefixes, do: {path, id}
      hit = fn f -> Enum.filter(own, fn {path, _} -> path == "." or f == path or String.starts_with?(f, path <> "/") end) end
      stale =
        files
        |> Enum.flat_map(fn f -> Enum.map(hit.(f), &elem(&1, 1)) end)
        |> Enum.uniq()
        |> Enum.filter(&MapSet.member?(behind, &1))
        |> Enum.sort()
      added = Git.cmd(dir, ["log", "--since=@#{since}", "--diff-filter=A", "--name-only", "--format="]) || ""
      uncovered =
        added
        |> String.split("\n", trim: true)
        |> Enum.uniq()
        |> Enum.reject(&ignored?(ignores, repo, &1))
        |> Enum.reject(&(own_repo?(store, repo) and String.starts_with?(&1, "content/")))
        |> Enum.filter(&(hit.(&1) == []))
      {repo, stale, uncovered}
    end
    |> Enum.reject(fn {_, s, u} -> s == [] and u == [] end)
  end

  # New page files in the wiki repository are the documentation itself, never "uncovered".
  defp own_repo?(store, repo) do
    case wiki_repo(store) do
      nil -> false
      top -> Sources.real(Path.join(Sources.dev_root(), repo)) == Sources.real(top)
    end
  end

  def hook_message(store, payload) do
    session = payload["session_id"] || "unknown"

    cond do
      payload["stop_hook_active"] == true -> nil
      true ->
        case last_published() do
          nil ->
            # Never published (or the state was deleted): without a baseline the pages that are behind are the obligation.
            case pages(store) do
              [] -> nil
              behind -> once_per_session(session, [{:stamp, "is missing", behind}], &format_invalid/1)
            end

          {:invalid, reason} ->
            once_per_session(session, [{:stamp, reason, pages(store)}], &format_invalid/1)

          since ->
            case changes(store, since) do
              [] -> nil
              changes -> once_per_session(session, changes, &format/1)
            end
        end
    end
  end

  defp format_invalid([{:stamp, reason, behind}]) do
    list = Enum.map_join(behind, "\n", &"- #{&1.id}: #{&1.reason}")

    """
    Wiki publish stamp #{reason} (#{last_publish_file()}), so the hook cannot tell which code changes are new.
    #{if behind == [], do: "No page is behind its sources right now.", else: "These pages are behind their sources:\n" <> list}
    Compare each page with its sources, set `reviewed:`, then run `wiki publish -m "..."`; a publish writes a fresh stamp
    once no page is behind.
    """
  end

  defp once_per_session(session, changes, render) do
    signature = :erlang.phash2(changes) |> Integer.to_string()
    key = session <> " " <> signature
    seen = case File.read(blocked_file()) do
      {:ok, s} -> s |> String.split("\n", trim: true) |> Enum.filter(&String.valid?/1)
      _ -> []
    end

    if key in seen do
      nil
    else
      # If the state cannot be written the message is still shown (it may then repeat): never skip an obligation.
      with :ok <- File.mkdir_p(state_dir()) do
        tmp = blocked_file() <> ".tmp#{System.pid()}.#{System.unique_integer([:positive])}"

        with :ok <- File.write(tmp, Enum.join(Enum.take([key | seen], 200), "\n")),
             do: File.rename(tmp, blocked_file())
      end

      render.(changes)
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
    Update or create those pages in ~/dev/wiki/content (English, then de and pt-BR).
    For every page of kind skill, locate and read the complete SKILL.md (description and all instructions),
    then include its full original text and fingerprint on the page and in both translations; a summary is
    insufficient. Follow AGENTS.md and wiki-page-writer, and run wiki check --local to compare with the sources.
    A page you compared with its
    sources and found right still needs `reviewed: <UTC time>` (date -u +%Y-%m-%dT%H:%MZ): that edit is the review.
    Then run `wiki publish -m "..."` (add --co-author "Name <email>" with the attribution line your own session was
    given, if it has one; otherwise leave it out), then `mem use`. Use `wiki publish -m "review: no page change"` only when what
    changed is described by no page (for example a data file).
    """
  end
end
