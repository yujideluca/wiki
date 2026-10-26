defmodule Wiki.CLI do
  @moduledoc """
  The `wiki` command (an escript, installed as `~/.local/bin/wiki`).

      wiki check [--local]   validate content/ (exit 1 on any problem)
      wiki build             content -> site/data, Elm -> site/assets
      wiki stale             pages with a source changed after their reviewed time (exit 1 when any)
      wiki publish -m MSG [--co-author "Name <email>"]
                             check --local, build, commit content/, push; the Co-Authored-By line
                             comes only from --co-author or $WIKI_CO_AUTHOR (the committing session
                             supplies it), never a fixed name
      wiki hook-stop         Claude Code Stop hook (reads the hook JSON on stdin)
  """
  alias Wiki.Content.{Store, Check, Build, Stale}

  def main(args) do
    {opts, rest, _} = OptionParser.parse(args, strict: [local: :boolean, message: :string, co_author: :string], aliases: [m: :message])
    code = run(rest, opts)
    System.halt(code)
  end

  def root, do: System.get_env("WIKI_ROOT") || Path.expand("~/dev/wiki")
  def content_dir, do: Path.join(root(), "content")
  def site_dir, do: Path.join(root(), "site")

  def run(["check"], opts) do
    store = Store.load(content_dir())

    case Check.run(store, local: Keyword.get(opts, :local, false)) do
      [] ->
        IO.puts("wiki check ok (#{if opts[:local], do: "local", else: "ci"} mode): #{map_size(store.pages)} pages, " <>
                  "#{map_size(store.translations)} translations")
        0

      errors ->
        Enum.each(errors, &IO.puts/1)
        IO.puts("wiki check failed: #{length(errors)} problem(s)")
        1
    end
  end

  def run(["build"], _opts) do
    store = Store.load(content_dir())
    :ok = Build.run(store, site_dir())

    with 0 <- elm_build(),
         0 <- copy_frontend_static() do
      IO.puts("wiki build ok -> #{site_dir()}")
      0
    end
  end

  def run(["stale"], _opts) do
    case Stale.pages(Store.load(content_dir())) do
      [] ->
        IO.puts("no stale pages")
        0

      list ->
        Enum.each(list, &IO.puts("#{&1.id}: #{&1.reason}"))
        1
    end
  end

  def run(["publish"], opts) do
    msg = opts[:message] || "wiki: update pages"
    co_author = opts[:co_author] || System.get_env("WIKI_CO_AUTHOR")

    with :ok <- check_co_author(co_author),
         0 <- run(["check"], local: true),
         0 <- run(["build"], []),
         0 <- commit_and_push(msg, co_author) do
      Stale.mark_published()
      IO.puts("wiki published")
      0
    end
  end

  def run(["hook-stop"], _opts) do
    input = IO.read(:stdio, :eof)
    payload = case JSON.decode(if(is_binary(input), do: input, else: "{}")) do
      {:ok, map} when is_map(map) -> map
      _ -> %{}
    end

    case Stale.hook_message(Store.load(content_dir()), payload) do
      nil -> 0
      msg -> IO.puts(:stderr, msg) && 2
    end
  end

  def run(_, _) do
    IO.puts(@moduledoc)
    1
  end

  defp elm_build do
    frontend = Path.join(root(), "frontend")
    out = Path.join(site_dir(), "assets/app.js")
    sh("elm", ["make", "src/Main.elm", "--optimize", "--output=#{out}"], frontend)
  end

  defp copy_frontend_static do
    from = Path.join(root(), "frontend/static")
    File.mkdir_p!(Path.join(site_dir(), "assets"))
    File.cp!(Path.join(from, "index.html"), Path.join(site_dir(), "index.html"))

    for f <- File.ls!(from), f != "index.html",
        do: File.cp!(Path.join(from, f), Path.join(site_dir(), "assets/#{f}"))

    0
  end

  defp commit_and_push(msg, co_author) do
    r = root()

    with 0 <- commit_only_content(r, msg, co_author) do
      if System.cmd("git", ["remote"], cd: r, env: Wiki.Content.Git.env()) |> elem(0) |> String.trim() == "",
        do: 0,
        else: sh("git", ["push", "-q"], r)
    end
  end

  @doc """
  `Name <email>` of the session that publishes, or nil/"" for none. Anything else is refused, so a
  value can never add lines or other trailers to the commit message.
  """
  def check_co_author(co) when co in [nil, ""], do: :ok

  def check_co_author(co) do
    if Regex.match?(~r/\A[^\r\n<>]+ <[^\s<>@]+@[^\s<>@]+>\z/, co) do
      :ok
    else
      IO.puts("refused: --co-author must look like \"Name <email>\" on one line")
      1
    end
  end

  @doc "Stages and commits content/ only, so unrelated work in the repo is never swept into a publish."
  def commit_only_content(r, msg, co_author \\ nil) do
    with 0 <- sh("git", ["add", "content"], r) do
      case System.cmd("git", ["diff", "--cached", "--quiet", "--", "content"], cd: r, env: Wiki.Content.Git.env()) do
        {_, 0} ->
          IO.puts("no content changes to commit")
          0

        _ ->
          trailer = if co_author in [nil, ""], do: "", else: "\n\nCo-Authored-By: " <> co_author

          sh("git", ["commit", "-q", "-m", msg <> trailer, "--", "content"], r)
      end
    end
  end

  defp sh(cmd, args, dir) do
    {out, code} = System.cmd(cmd, args, cd: dir, env: Wiki.Content.Git.env(), stderr_to_stdout: true)
    if code != 0, do: IO.puts(out)
    code
  end
end
