---
id: wiki-cli
title: wiki (command)
aliases: [wiki publish, wiki check, wiki stale, escript]
kind: program
project: wiki
status: active
location: wiki:server/lib/wiki/cli.ex
fed_by: [wiki-build, wiki-check]
feeds: [github]
sources: [wiki:server/lib/wiki/cli.ex]
---

## What it is
The command Claude uses to keep the wiki current: an Elixir escript installed as `~/.local/bin/wiki`.

## What it does
`wiki publish` is the end-of-task step: it runs [[wiki-check]] in local mode, [[wiki-build]], then commits only `content/` (unrelated work in the repo is never swept in) and pushes to the private repo on [[github]], and records the publish time for [[wiki-hook-stop]]. It refuses on any failure.

## How it does it
Built with `mix escript.build` from the server project; `WIKI_ROOT` points at the repo (default `~/dev/wiki`). Never force-pushes.

## Where it sits in the pipeline
Called at [[end-of-task]], before `mem use`.

## Who receives its output
[[github]] (the commit) and the live site (through [[wiki-site]]).

## Functions
- `wiki check [--local]`: validate the content
- `wiki build`: content → site/data, Elm → site/assets
- `wiki stale`: pages whose sources changed after the page
- `wiki publish -m "msg"`: check --local, build, commit only content/, push
- `wiki hook-stop`: the Claude Code Stop hook
