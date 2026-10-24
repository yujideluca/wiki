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

## Notes
`wiki stale` and this hook answer two different questions, so they can disagree. `wiki stale` asks, page by page: "did a source file get a commit (a saved change in git) after the page's own last commit?" The hook asks: "since the last `wiki publish`, did a project get commits that touch a page's sources, or add files no page covers?" Because `wiki stale` looks at commit times, not at what the page says, any later commit of the page (for example a rewrite of many pages, or a publish) makes it look fresh even if the text misses the change; it also never lists new files that no page covers. The hook compares with the time of the last publish, so it still sees those changes, but a `wiki publish -m "review: no page change"` silences it for them whether or not the pages are right. Pages do not carry a per-page review date (none of the 139 pages with sources has a `reviewed:` field), so the wiki cannot tell "reviewed and correct" from "touched". When the hook flags a page that `wiki stale` calls fresh, read the `git log` of the source repository since the page last changed and compare it with the page text.
