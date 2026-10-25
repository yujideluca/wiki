---
id: wiki-skill-source
title: Complete skill source checker
aliases: [SkillSource, skill_source.ex]
kind: module
project: wiki
status: active
location: wiki:server/lib/wiki/content/skill_source.ex
fed_by: []
feeds: []
sources: [wiki:server/lib/wiki/content/skill_source.ex, wiki:server/lib/wiki/content/page.ex, wiki:server/test/skill_source_test.exs]
memory: [#12386c]
reviewed: 2026-10-25T14:46Z
---

## What it is
`Wiki.Content.SkillSource` is the Elixir module that checks whether a skill page contains its complete original instruction files. A skill is a packaged set of task instructions. Its `SKILL.md` contains the description used to select it and the instructions followed after selection.

## What it does
It requires a complete copy for every `SKILL.md` in a skill page's `sources`. It checks each copy's SHA-256 (Secure Hash Algorithm 256) fingerprint (a value calculated from its whole text to detect changes), description and instructions, and identical originals in both translations. Local mode also reads the installed files and compares the whole text. Errors block publishing. Without local files the fingerprint cannot prove freshness.

## How it does it
The writer locates and reads the source first, following [[skill-wiki-page-writer]]. It copies the original into Notes in a fenced code block marked `skill-source <repo:path/to/SKILL.md> <sha256>`. The fence is longer than any backtick run inside the original. Line endings become LF and a final newline is added only when absent. The parser preserves source headings and nested examples as text. Translations retain the originals in their source language. Referenced auxiliary files are not included automatically. Privacy checks still scan all copied text.

## Where it sits in the pipeline
Called by [[wiki-check]] for skill pages. The [[wiki-hook-stop]] reminder routes the writer to this rule, defined in [[wiki-content]] and the project's `AGENTS.md`.

## Who receives its output
[[wiki-check]] receives the errors; [[wiki-cli]] refuses to publish pages that fail.

## Functions
- `check`: validates a skill page and its translations; reads installed originals only in local mode.

## Notes

A skill page is identified by `kind: skill` in its header. Run `wiki check --local` to enable local mode, which reads installed source files; an unreadable file is an error. A path such as `home:.agents/skills/example/SKILL.md` starts at the user's home folder; `wiki:path` starts in `~/dev/wiki`, and other repository names start in the matching folder under `~/dev`. Copies belong under the page heading `## Notes`. The translations are `<id>.de.md` (German) and `<id>.pt-BR.md` (Brazilian Portuguese); a missing translation is an error in the overall checker. LF means line feed, the newline character used by the copied text. Privacy checks reject secrets and contact data about other people, even inside source copies. Checks without `--local` do not read installed originals and give no freshness warning when fingerprints match; successful validation in that mode alone does not establish freshness.
