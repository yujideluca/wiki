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
reviewed: 2026-10-22T16:33Z
---

## What it is
`wiki` is the command that Claude uses to keep the wiki current: an Elixir escript (a program packed into a single runnable file) installed as `~/.local/bin/wiki`.

## What it does
`wiki publish` is the end-of-task step. It runs [[wiki-check]] in local mode, then [[wiki-build]], then commits only the `content/` folder (so unrelated work in the repository is never swept in) and pushes it to the private repository on [[github]], and finally records the time of the publish for the [[wiki-hook-stop]]. It refuses on any failure.

## How it does it
It is built with `mix escript.build` from the server project; the variable `WIKI_ROOT` points at the repository (default `~/dev/wiki`). It never force-pushes.

## Where it sits in the pipeline
Called at [[end-of-task]], before `mem use`.

## Who receives its output
[[github]] (the commit) and the live site (through the [[wiki-site]]).

## Functions
- `wiki check [--local]`: validate the content
- `wiki build`: content → site/data, Elm → site/assets
- `wiki stale` ([[wiki-stale]]): pages whose sources changed after the page
- `wiki publish -m "msg"`: check --local, build, commit only content/, push
- `wiki hook-stop`: the Claude Code Stop hook
