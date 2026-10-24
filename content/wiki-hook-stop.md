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
---

## What it is
A "Stop hook" is a small program that [[claude-code]] runs automatically whenever it finishes a reply ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)). This one, `wiki hook-stop`, is the safety net of the wiki update chain: it catches a forgotten wiki update in the same session, while Claude still remembers what it did.

## What it does
When Claude finishes a turn, it looks at the repositories under `~/dev` that some wiki page names as a source. If since the last `wiki publish` there are commits that touched a page's sources, or added files that no page covers, it blocks the stop (exit code 2) and tells Claude which pages to update. It never blocks before the first publish, for repositories the wiki does not cover, twice in one session for the same changes, or when a stop hook is already active, so it cannot loop. It never fires for German, clinical or other non-code chats.

## How it does it
It uses read-only git, and keeps its state in `~/.local/state/wiki/` (the time of the last publish and the sessions already blocked). Data folders that change all the time (the memory events and views, quiz backups, the release feed) are listed in `content/_ignore.txt` and are not watched file by file. If no page needs to change, Claude still runs `wiki publish -m "review: no page change"` to record that it checked.

## Where it sits in the pipeline
It runs at the end of every turn, next to the memory's [[hook-stop]].

## Who receives its output
[[claude-code]] (the message).
