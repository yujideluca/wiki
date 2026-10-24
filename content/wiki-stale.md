---
id: wiki-stale
title: wiki stale (pages behind their sources)
aliases: [wiki stale, Stale.pages]
kind: function
project: wiki
status: active
location: wiki:server/lib/wiki/content/stale.ex
fed_by: []
feeds: [wiki-cli]
sources: [wiki:server/lib/wiki/content/stale.ex]
---

## What it is
`wiki stale` is the command that lists the wiki pages which may be out of date because the files they describe changed after the page did. It is one of the commands of [[wiki-cli]] and shares its code file with the Stop hook ([[wiki-hook-stop]]), but it asks a different question.

## What it does
For every page it looks at each file named in the page's `sources` header (written `repo:path`). If any of those files has a commit (a change saved in git) newer than the page's own last commit, the page is listed as "<source> changed after the page". With nothing to list it prints "no stale pages".

## How it does it
It asks git for the time of the last commit of the page and of each source, and compares the two times. It looks only at time, not at what the page says. So any later commit of the page, such as a mass rewrite or a publish, makes the page count as fresh even if its text does not mention the change. It also cannot see a new file that no page covers, because it only follows files that pages already name. The Stop hook uses a different test (changes since the last `wiki publish`, plus new uncovered files); the two can therefore disagree, as explained in [[wiki-hook-stop]]. No page carries its own review date: none of the 139 pages with sources has a `reviewed:` field, so the command cannot tell "reviewed and correct" from "touched".

## Where it sits in the pipeline
A manual check, run by Claude at the start of [[skill-wiki-page-writer]] and whenever Giovanni wants to know how far the wiki is behind the code.

## Who receives its output
Whoever ran it (Claude or Giovanni), through [[wiki-cli]].
