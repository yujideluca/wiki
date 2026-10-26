---
id: wiki-hook-stop
title: Wiki Stop hook (safety net)
aliases: [wiki hook-stop, Stale]
kind: hook
project: wiki
status: active
location: wiki:server/lib/wiki/content/stale.ex
fed_by: [claude-code-settings]
feeds: [claude-code]
sources: [wiki:server/lib/wiki/content/stale.ex]
reviewed: 2026-10-26T18:31Z
---

## What it is
A "Stop hook" is a small program that [[claude-code]] runs automatically whenever it finishes a reply ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)). This one, `wiki hook-stop`, is the safety net of the wiki update chain: it catches a forgotten wiki update in the same session, while Claude still remembers what it did.

## What it does
When Claude finishes a turn, it looks at the repositories under `~/dev` that some wiki page names as a source. If since the last `wiki publish` there are commits that touched a page's sources, or added files that no page covers, it blocks the stop (exit code 2) and tells Claude which pages to update. It never blocks before the first publish, for repositories the wiki does not cover, twice in one session for the same changes, or when a stop hook is already active, so it cannot loop. A chat that changes no covered code creates no new trigger of its own; earlier unpublished changes can still trigger the reminder.

## How it does it
It uses read-only git, and keeps its state in `~/.local/state/wiki/` (the time of the last publish and the sessions already blocked). Data folders that change all the time (the memory events and views, quiz backups, the release feed) are listed in `content/_ignore.txt` and are not watched file by file. The message it prints tells Claude to record a page it checked and found right by setting that page's `reviewed` time (the edit is the review, see [[wiki-stale]]), and to run `wiki publish -m "review: no page change"` only when what changed is described by no page, for example a data file. It also tells the session to add `--co-author "Name <email>"` to `wiki publish` with the attribution line that session was given, and to leave it out when it has none ([[wiki-cli]]).

## Where it sits in the pipeline
It runs at the end of every turn, next to the memory's [[hook-stop]].

## Who receives its output
[[claude-code]] (the message).

## Notes
`wiki stale` and this hook answer two different questions, so a page can be listed by one and not by the other. `wiki stale` asks, page by page: "did a source change after the time the page says it was last checked (its `reviewed` field)?" It does not depend on publishing. The hook asks: "since the last `wiki publish`, did a project get commits that touch a page's sources, or add files no page covers?" It is the safety net for what `wiki stale` cannot see: a change in the same minute as a review, a new file that no page names, and the work of the current session. When the hook flags a page, read the `git log` of the source repository and compare it with the page text; if the page is right, set its `reviewed` time. Before 2026-10-24 `wiki stale` compared the commit time of the source with that of the page file, so a rewrite of many pages hid every earlier change, and this hook was the only thing that still saw them (see [[wiki-stale]]).

The reminder explicitly routes skill pages to the complete-source rule: locate and read the complete `SKILL.md`, include its full description and all instructions with a fingerprint in English and both translations, then run `wiki check --local`. It points to `AGENTS.md` and [[skill-wiki-page-writer]]. The hook reminds the writer; it does not generate page text itself.
