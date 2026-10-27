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
reviewed: 2026-10-27T01:13Z
---

## What it is
This site is a wiki: an encyclopedia of every project, program, skill and process in Giovanni's systems, with a map that shows how they connect. Each topic has its own page, written so that a reader who knows nothing about the system or its technical language can follow it. New to a word? Open the [[glossary]], which explains the terms used on the pages. The repository `yujideluca/wiki` is public (since 2026-10-25), the folder is `~/dev/wiki`, and the project was started on 2026-10-22 from [[project-template]].

## Flow
trigger t1: Claude finishes a task that changed a system | [[end-of-task]]
step s1: Writes Markdown pages, each with a small header | [[wiki-content]]
step s2: wiki check applies the content rules | [[wiki-check]]
decide d1: Do the rules pass?
step s3: wiki build turns the pages into data | [[wiki-build]]
step s4: Only content/ is committed and uploaded | [[github]]
step s5: The server serves the site: Giovanni's Google account gets in, everyone else sees a decoy | [[wiki-router]], [[decoy-page]]
trigger t2: Giovanni opens the wiki | [[giovanni]]
step s6: Searches, hovers over the map, clicks a dot | [[wiki-frontend]]
product p1: Publishing refused, with the problems listed
product p2: A page that answers the architecture question

t1 -> s1
s1 -> s2
s2 -> d1
d1 -no-> p1
d1 -yes-> s3
s3 -> s4
s4 -> s5
t2 -> s5
s5 -> s6
s6 -> p2

## What it does
It lets Giovanni answer an architecture question after one search and at most two clicks: search with suggestions while typing, hover over a dot on the map to see what it is in four boxes, click the dot for the full page ([[wiki-frontend]]). On a phone the map fills the screen with a search bar on top and tapping a dot opens a balloon with its description; on a desktop the map is seen through a lens and its dots stretch elastically when dragged ([[wiki-map-view]]). It is kept up to date automatically at the end of every task ([[end-of-task]]). For the whole system on one page, start with [[system-overview]].

## How it does it
The content is Markdown text files, each with a small header ([[wiki-content]]); they are checked by [[wiki-check]] and turned into JSON (JavaScript Object Notation) data by [[wiki-build]]. The part you see is written in Elm ([[wiki-frontend]]); the server is written in Elixir ([[wiki-server]]) and lets in only one Google account, showing everyone else a decoy ([[wiki-router]], [[decoy-page]]). It is reachable on the internet through [[tailscale-funnel]]. The languages are English, German and Brazilian Portuguese.

## Where it sits in the pipeline
Beside [[workflow-memory]]: the memory holds rules and preferences, while the wiki describes what exists and how it works, and links to memory entries instead of copying them.

## Who receives its output
[[giovanni]], in the browser on the laptop or the phone.
