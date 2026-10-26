---
id: wiki-cli
title: wiki (command)
aliases: [wiki publish, wiki check, wiki stale, escript]
kind: program
project: wiki
status: active
location: wiki:server/lib/wiki/cli.ex
fed_by: [wiki-build, wiki-check, wiki-stale]
feeds: [github]
sources: [wiki:server/lib/wiki/cli.ex]
reviewed: 2026-10-26T18:38Z
---

## What it is
`wiki` is the command that Claude uses to keep the wiki current: an Elixir escript (a program packed into a single runnable file) installed as `~/.local/bin/wiki`.

## What it does
`wiki publish` is the end-of-task step. It runs [[wiki-check]] in local mode, then [[wiki-build]], then commits only the `content/` folder (so unrelated work in the repository is never swept in) and pushes it to the public repository on [[github]], and finally records the time of the publish for the [[wiki-hook-stop]]. It refuses on any failure. Every `git` command it runs first unsets `GIT_DIR`, `GIT_WORK_TREE` and `GIT_INDEX_FILE` (variables that git itself sets inside hooks such as pre-push), so the command always acts on the repository it was given and never on the one that started the hook.

## How it does it
It is built with `mix escript.build` from the server project; the variable `WIKI_ROOT` points at the repository (default `~/dev/wiki`). It never force-pushes. The commit's `Co-Authored-By` line (the git trailer that names a co-author of the commit) comes only from the session that publishes: `--co-author "Name <email>"` or the variable `WIKI_CO_AUTHOR`. With neither there is no such line, and a value that is not a single `Name <email>` line is refused. Until 2026-10-26 the command added a fixed "Claude Opus 5.5" line to every publish, which was wrong for commits made by Codex, Sonnet or Giovanni; the command cannot detect the model itself, so each session passes the attribution line it was given.

## Where it sits in the pipeline
Called at [[end-of-task]], before `mem use`.

## Who receives its output
[[github]] (the commit) and the live site (through the [[wiki-site]]).

## Functions
- `wiki check [--local]`: validate the content
- `wiki build`: content → site/data, Elm → site/assets
- `wiki stale` ([[wiki-stale]]): pages with a source changed after their reviewed time; exits 1 when it lists any
- `wiki publish -m "msg" [--co-author "Name <email>"]`: check --local, build, commit only content/ (with the co-author line only if given), push
- `wiki hook-stop`: the Claude Code Stop hook
- `wiki help`, `wiki --help`, `wiki -h`: print the usage and do nothing else. An option the command does not know (for example the typo `--co-autor`) also prints the usage and runs nothing, with exit code 2; before 2026-10-26 such an option was ignored, so `wiki publish --help` ran a real publish.
