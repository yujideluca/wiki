---
id: wiki-content
title: Wiki content (Markdown pages)
aliases: [content/, pages]
kind: data
project: wiki
status: active
location: wiki:content
fed_by: [claude-code]
feeds: [wiki-build, wiki-check]
sources: [wiki:content/_kinds.json, wiki:content/_ignore.txt]
---

## What it is
The source of truth of this wiki: one Markdown file per concept in `content/` (English), with `<id>.de.md` and `<id>.pt-BR.md` translations, and `_kinds.json`, the open list of kinds and their colours.

## What it does
Each page has a header (`id, title, aliases, kind, project, status, location, fed_by, feeds, sources, memory, since, until, reviewed`) and fixed sections: What it is, What it does, How it does it, Where it sits in the pipeline, Who receives its output, plus optional Steps (process pages), Functions and Notes.

## How it does it
Links are Obsidian-style `[[id]]`; `fed_by`/`feeds` are the pipeline edges and must agree in both directions. `sources` are `repo:path` so a code change can mark the page stale. Translations store a hash of the English text they were made from. Pages say what exists; rules live in memory and are linked by #code.

## Where it sits in the pipeline
Written by [[claude-code]] at the end of every task ([[end-of-task]]); checked by [[wiki-check]]; turned into data by [[wiki-build]].

## Who receives its output
[[wiki-check]] and [[wiki-build]].
