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
These are the pages themselves: the source of truth of this wiki. There is one [Markdown](https://en.wikipedia.org/wiki/Markdown) file (a text file with simple marks for headings, lists and links) per concept in the folder `content/`, in English, with a German version `<id>.de.md` and a Brazilian Portuguese version `<id>.pt-BR.md`. Two more files hold settings: `_kinds.json`, the open list of kinds of page and their colours, and `_acronyms.tsv`, the list of acronyms whose first use on a page must come with the full name.

## What it does
Each page has a header (`id, title, aliases, kind, project, status, location, fed_by, feeds, sources, memory, since, until, reviewed`) and fixed sections: What it is, What it does, How it does it, Where it sits in the pipeline, Who receives its output, plus optional Steps (for processes and skills), Functions and Notes.

The writing rules are these: every page must be understandable by someone who knows nothing about the system; a technical term is defined where it first appears and, when it is complex, links to a definition (an outside source or the [[glossary]]); an acronym is spelled out at its first use on each page; and a skill page carries the skill's own definition in its Steps section, so the page is enough to understand the skill.

## How it does it
Links between pages are written `[[id]]`. The headers `fed_by` and `feeds` are the pipeline edges (what feeds what) and must agree in both directions. `sources` are written `repo:path`, so that a change in the code can mark the page as stale. A translation stores a hash (a short fingerprint) of the English text it was made from, so an outdated translation is detected. Pages say what exists; rules and preferences live in memory and are linked by their `#code`.

## Where it sits in the pipeline
Written by [[claude-code]] at the end of every task ([[end-of-task]]); checked by [[wiki-check]]; turned into data by [[wiki-build]].

## Who receives its output
[[wiki-check]] and [[wiki-build]].
