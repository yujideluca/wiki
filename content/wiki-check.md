---
id: wiki-check
title: wiki check (content rules)
aliases: [Check, check.ex]
kind: function
project: wiki
status: active
location: wiki:server/lib/wiki/content/check.ex
fed_by: [wiki-content]
feeds: [wiki-cli]
sources: [wiki:server/lib/wiki/content/check.ex, wiki:server/lib/wiki/content/privacy.ex, wiki:server/lib/wiki/content/skill_source.ex, wiki:server/lib/wiki/content/page.ex]
reviewed: 2026-10-25T21:20Z
---

## What it is
`wiki check` runs every rule a page must follow before it can be published. In code it is the Elixir module `Wiki.Content.Check`.

## What it does
It checks that: header fields and kinds are valid; the five required sections are present and not empty; every `[[link]]`, `fed_by` and `feeds` points to a real page; `fed_by` and `feeds` agree in both directions; there are no orphan pages (pages nothing links to), except actors and outside things; the privacy scan finds no keys, tokens, passwords, phone numbers or e-mail addresses other than Giovanni's (the patterns are the file `privacy-patterns.tsv` of workflow-memory, copied to `server/priv/` and compared by the gate); a function listed on a page and mentioned by two other pages gets its own page (the promotion rule); every page has a review time, a date or a date and minute in UTC (Coordinated Universal Time, the same clock time everywhere) that is not in the future, which is the time [[wiki-stale]] compares the sources with; a skill page has a Steps section with the skill's own definition; the first use of every listed acronym comes with its full name; and the German and Portuguese translations exist and match the current English. With `--local` it also checks that the sources and memory entries exist.

## How it does it
It consists of pure functions over the loaded content and returns a sorted list of lines in the form `file: problem`. Continuous integration (CI, automatic checks on GitHub) runs it without `--local`, because GitHub cannot see Giovanni's other private repositories.

## Where it sits in the pipeline
The first step of `wiki publish`, and part of the [[wiki-quality-gate]].

## Who receives its output
The [[wiki-cli]] (publishing refuses on any problem).

## Notes

For skill pages, [[wiki-skill-source]] requires the complete `SKILL.md` file for each declared skill source, including the description and instructions. Every copy must have a matching SHA-256 (Secure Hash Algorithm 256) fingerprint (a value calculated from its text to detect changes), and both translations must retain exactly the same originals. Local mode also reads each source file and compares its complete text with the copy. Without local sources the checker validates presence and fingerprints, but cannot prove freshness. The parser respects code fences, so source headings and example links are not treated as wiki structure. Privacy checks still scan the full copied text.
