---
id: wiki
title: Wiki (this site)
aliases: [wiki, concept wiki]
kind: project
project: none
status: active
location: wiki:
fed_by: [claude-code, project-template]
feeds: []
sources: [wiki:docs/2026-10-22-wiki-design.md, wiki:DESIGN.md]
memory: [#f1e117]
---

## What it is
This site: a wiki of every project, program, skill and process in Giovanni's systems, with a Dark-style map of how they connect. Repo `yujideluca/wiki` (private), folder `~/dev/wiki`. Started 2026-10-22 from [[project-template]].

## What it does
Lets Giovanni answer an architecture question after one search and at most two clicks: search with autocomplete, hover a dot to see what it is in four boxes, click for the full article ([[wiki-frontend]]). Kept current automatically at the end of every task ([[end-of-task]]).

## How it does it
Content is Markdown files with a header ([[wiki-content]]), checked by [[wiki-check]] and turned into JSON by [[wiki-build]]. The front end is written in Elm ([[wiki-frontend]]); the back end in Elixir ([[wiki-server]]) with Google sign-in for one account and a decoy for everyone else ([[wiki-router]], [[decoy-page]]). It is reachable on the web through [[tailscale-funnel]]. Languages: English, German, Brazilian Portuguese.

## Where it sits in the pipeline
Beside [[workflow-memory]]: memory holds rules and preferences, the wiki describes what exists and how it works, and links to memory entries instead of copying them.

## Who receives its output
[[giovanni]], in the browser on the laptop or the phone.
