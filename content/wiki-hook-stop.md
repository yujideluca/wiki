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
The safety net of the update chain: a Claude Code Stop hook (`wiki hook-stop`) that catches a forgotten wiki update in the same session.

## What it does
When Claude finishes a turn, it looks at the repos under `~/dev` that some page names as a source. If, since the last `wiki publish`, commits touched a page's sources or added files no page covers, it blocks the stop (exit 2) and tells Claude which pages to update. It never blocks before the first publish, for repos the wiki does not cover, twice in one session for the same changes, or when a stop hook is already active, so it cannot loop and never fires for German, clinical or other non-code chats.

## How it does it
Read-only git; state in `~/.local/state/wiki/` (last publish time, sessions already blocked). Data folders that change all the time (memory events and views, quiz backups, the release feed) are listed in `content/_ignore.txt` and not watched file by file. If no page needs to change, Claude still runs `wiki publish -m "review: no page change"` to record that it checked.

## Where it sits in the pipeline
Runs at the end of every turn, next to the memory's [[hook-stop]].

## Who receives its output
[[claude-code]] (the message).
