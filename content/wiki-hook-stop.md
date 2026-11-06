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
sources: [wiki:server/lib/wiki/content/stale.ex, wiki:server/lib/wiki/content/memo.ex, wiki:docs/adr/0009-stale-review-claims-and-shared-publish-stamp.md, home:.claude/settings.json, home:.codex/hooks.json]
reviewed: 2026-11-06T21:22Z
---

## What it is
A "Stop hook" is a small program an assistant runs automatically when it finishes a reply ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Both [[claude-code]] and [[codex]] invoke `wiki hook-stop` through their installed hooks. It catches a forgotten wiki update in the same session, while the assistant still knows what it changed.

## What it does
When an assistant finishes a turn, it checks the repositories under `~/dev` that wiki pages name as sources. Unreviewed source changes or new files without a page block the stop (exit code 2) and identify the work to review. An invalid publication timestamp always produces a diagnostic once per session. Without a publication timestamp, it derives obligations from pages still behind their sources; it stays silent only when none is behind. It does not block for repositories absent from the wiki's source list, twice in one session for the same changes, or when a stop hook is already active. A chat that changes no covered code creates no new trigger of its own; earlier unpublished changes can still trigger the reminder.

## How it does it
It uses read-only git, and keeps its state in `~/.local/state/wiki/` (the time of the last publish and the sessions already blocked). Data folders that change all the time (the memory events and views, quiz backups, the release feed) are listed in `content/_ignore.txt` and are not watched file by file. The message it prints tells the assistant to record a page it checked and found right by setting that page's `reviewed` time (record the time only after comparing the sources, see [[wiki-stale]]), and to run `wiki publish -m "review: no page change"` only when what changed is described by no page, for example a data file. It also tells the session to add `--co-author "Name <email>"` to `wiki publish` with the attribution line that session was given, and to leave it out when it has none ([[wiki-cli]]).

Speed (requirement UP-8): one run asks the same questions many times, because many pages share sources. While the hook runs, a small cache (`Wiki.Content.Memo`) keeps each answer to a git query or a "where does this path really point" question, so each is asked once; outside the hook nothing is cached. Paths are resolved inside the program with the same answers as the `realpath -m` command, instead of starting that command each time. This cut a run from about 4,500 started programs and 22 to 28 seconds (the hook's time limit is 30 seconds) to about 1,250 git calls and 11 seconds, with the same message.

## Where it sits in the pipeline
It runs at the end of every turn, next to the memory's [[hook-stop]].

## Who receives its output
[[claude-code]] or [[codex]], whichever invoked the hook, receives the message.

## Notes
Since 2026-11-01 (ADR-0009, an architecture decision record) the stamp this hook compares against is shared by every session, so it moves forward after a publish only when no page is still behind a change and no new file is left uncovered since the previous stamp; one session's publish can no longer hide another session's unreviewed work. The hook also names a page only when it is really behind its sources, finds repositories with git itself (so linked worktrees count), and includes changes made in the same second as the stamp. If the stamp file was never written, the hook lists the pages that are behind their sources and stays silent only when there are none. A stamp that is empty, cut off, not a number, zero, negative or in the future (even one minute ahead) is always reported once per session, together with that list; a publish never overwrites a missing or broken stamp while a page is behind a source, only a verified clean state sets a fresh one. Both state files are written by rename, and a state file that cannot be written never hides the message (requirement UP-7).

`wiki stale` checks every page independently of publication. The hook checks changes since the publication baseline, filters named pages through the same stale-page rules, and additionally detects new files without pages. It does not flag a named page solely because a change happened inside the minute its review covers. Same-second detection refers to the publication baseline, not to a stricter review clock. Compare source history and page text before recording a new review. Before 2026-10-24 source commits were compared with page commits, allowing rewrites alone to hide older changes; the page's own `reviewed` field replaced that behavior ([[wiki-stale]]).

The reminder explicitly routes skill pages to the complete-source rule: locate and read the complete `SKILL.md`, include its full description and all instructions with a fingerprint (a value calculated from the full text to detect changes) on the page, then run `wiki check --local`. It also says that the wiki is English only: one file per page, and no `.de` or `.pt-BR` file. It points to `AGENTS.md` and [[skill-wiki-page-writer]]. The hook reminds the writer; it does not generate page text itself.

Configuration: `home:` names files under the user's home folder; other repository aliases normally name folders under `~/dev`, overridden by `WIKI_DEV_ROOT`. `WIKI_ROOT` selects the wiki folder and its `wiki:` sources; the default is `~/dev/wiki`. Claude Code invokes the command from `~/.claude/settings.json`; Codex from `~/.codex/hooks.json`. The list `content/_ignore.txt` excludes data paths from the hook's changed-file scan, not from manual source review. Requirement `UP-7` names the tested promise that publications preserve unfinished obligations; its full wording is in `docs/REQUIREMENTS.md`.
