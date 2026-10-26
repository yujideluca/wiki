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
sources: [wiki:server/lib/wiki/content/stale.ex, wiki:server/lib/wiki/content/sources.ex, wiki:server/lib/wiki/content/page.ex, wiki:docs/adr/0006-review-time-in-the-page.md]
reviewed: 2026-10-26T18:31Z
---

## What it is
`wiki stale` is the command that lists the wiki pages that may be out of date because a file they describe changed after the page was last checked against it. It is one of the commands of [[wiki-cli]] and shares its code file with the Stop hook ([[wiki-hook-stop]]), but it asks a different question.

## What it does
Every page records in its `reviewed` header field when it was last compared with its sources: a date and minute in UTC (Coordinated Universal Time, the same clock time everywhere), such as `2026-10-24T18:30Z`, or a date alone, which means the start of that day. For every page with sources the command looks at each file or folder named in `sources` (written `repo:path`). If any of them changed after the `reviewed` time, the page is listed with the newest such source and both times, for example `quizapp: QuizApp:DESIGN.md changed 2026-10-24 16:43 UTC, after the review of 2026-10-22 16:33 UTC`. A page with sources and no usable `reviewed` is listed as never compared. With nothing to list it prints "no stale pages" and exits with 0; otherwise it exits with 1, so a script can test the result (requirements ST-1, ST-2 and ST-3).

## How it does it
For a source inside a git repository (git is the tool that saves every change as a commit), "changed" means the time of the last commit that touches the file or folder. For a source outside git, such as a skill or a script under the home folder, it means the newest modification time of the file, or of the folder and everything in it. The page file's own commits are never used: a rewrite of many pages, a fixed translation or a publish is not a review. Only a person or Claude who really compared the page with its sources sets a new `reviewed` time, which clears the page.

The first version compared the last commit time of the source with the last commit time of the page file. On 2026-10-24 one commit rewrote all 154 pages, so that version listed nothing while 38 of the 140 pages with sources had a source change that no one had checked, and it could never list the 34 pages whose sources are outside git. The decision record `docs/adr/0006-review-time-in-the-page.md` explains the change.

The command looks at time, not at what the page says: a change to a source that the page does not describe still lists the page until someone reviews it. A review at a given minute covers that whole minute, so a change in that minute is not seen; nor are edits not yet committed in a repository, or a new file that no page names (the Stop hook watches for new files).

## Where it sits in the pipeline
A manual check, run by Claude at the start and the end of the work of [[skill-wiki-page-writer]], and whenever Giovanni wants to know how far the wiki is behind the code.

## Who receives its output
Whoever ran it (Claude or Giovanni), through [[wiki-cli]].
