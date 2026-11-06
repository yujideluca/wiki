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
sources: [wiki:server/lib/wiki/content/stale.ex, wiki:server/lib/wiki/content/sources.ex, wiki:server/lib/wiki/content/page.ex, wiki:docs/adr/0006-review-time-in-the-page.md, wiki:docs/adr/0009-stale-review-claims-and-shared-publish-stamp.md, wiki:docs/2026-11-01-wiki-stale-audit.md]
reviewed: 2026-11-06T18:12Z
---

## What it is
`wiki stale` is the command that lists the wiki pages that may be out of date because a file they describe changed after the page was last checked against it. It is one of the commands of [[wiki-cli]] and shares its code file with the Stop hook ([[wiki-hook-stop]]), but it asks a different question.

## What it does
Every page records in its `reviewed` header field when it was last compared with its sources: a date and minute in UTC (Coordinated Universal Time, the same clock time everywhere), such as `2026-10-24T18:30Z`, or a date alone, which means the start of that day. For every page with sources the command looks at each file or folder named in `sources` (written `repo:path`). If any of them changed after the `reviewed` time, the page is listed with the newest such source and both times, for example `quizapp: QuizApp:DESIGN.md changed 2026-10-24 16:43 UTC, after the review of 2026-10-22 16:33 UTC`. A page with sources and no usable `reviewed` is listed as never compared. With nothing to list it prints "no stale pages" and exits with 0; otherwise it exits with 1, so a script can test the result (requirements ST-1, ST-2 and ST-3).

## How it does it
For a source inside a git repository (git is the tool that saves every change as a commit), "changed" means the time of the last commit that touches the file or folder. For a source outside git, such as a skill or a script under the home folder, it means the newest modification time of the file, or of the folder and everything in it. The page file's own commits are never used: a rewrite of many pages, a wording fix or publication alone does not establish a review. Only the person or assistant that actually compared the page with its sources sets a new `reviewed` time, which clears the page.

The first version compared the last commit time of the source with the last commit time of the page file. On 2026-10-24 one commit rewrote all 154 pages, so that version listed nothing while 38 of the 140 pages with sources had a source change that no one had checked, and it could never list the 34 pages whose sources are outside git. The decision record `docs/adr/0006-review-time-in-the-page.md` explains the change.

The command looks at time, not at what the page says: a change to a source that the page does not describe still lists the page until someone reviews it. A review at a given minute covers that whole minute, so a change in that minute is not seen; nor are edits not yet committed in a repository, or a new file that no page names (the Stop hook watches for new files).

Since 2026-11-01 (ADR-0009, an architecture decision record: a short note that keeps the reasons for a decision) three exact rules cover sources that live in the wiki's own repository, with no grace period. A page that lists its own file as a source is not listed because of it. A source that is itself a wiki page counts as changed only when more than its `reviewed` or `since` lines changed. And because a review time is typed before the commit that carries it, a source whose text was changed by the very commit that last set the page's `reviewed` line is covered; a source changed by any other commit, even one minute after the review, keeps the page listed until it is compared again. `wiki publish` also checks every `reviewed` line it is about to push: if a source that already existed is newer than the review it refuses, names the page and the source, and pushes nothing (requirements ST-4, ST-5 and ST-6).

## Where it sits in the pipeline
A manual check, run by an assistant at the start and the end of the work of [[skill-wiki-page-writer]], and whenever Giovanni wants to know how far the wiki is behind the code.

## Who receives its output
Whoever ran it (an assistant or Giovanni), through [[wiki-cli]].

## Notes
The audit of 2026-11-01 found both missed reviews and false stale results. A shared publication timestamp could hide another session's pending work, and publishing did not validate new review claims. Self-sources, metadata-only commits, missing or malformed state, linked worktrees and changes in the timestamp's second required separate handling. Nine pages needed text corrections; six matched their sources and needed a recorded review. The committed evidence and page reconciliation are in `docs/2026-11-01-wiki-stale-audit.md`.

The source changes for the checker, flow view, memory validator and progress tools carry Claude Sonnet 5.5 coauthor trailers (`3c12c76`, `12b5342`, `6a57d87`, `f2b0389` in their respective repositories). This identifies assistant-associated source commits, not every later session. This Codex conversation also confirmed its own missed final check after `5b3ff90`. Unversioned configuration does not provide reliable exact-session attribution; the configured Git author is not proof that Giovanni performed an assistant's work.

For an isolated worktree, `wiki:` sources resolve through the selected `WIKI_ROOT`, the folder being checked and published. Other sources still use the declared development root. This lets a new source file be checked before it reaches the primary checkout. Removing a valid source reference merely to pass the check is not the repair. State files use temporary names containing process identity and a runtime counter before atomic rename (replacing the destination in one filesystem operation), so independent assistant processes cannot collide.
