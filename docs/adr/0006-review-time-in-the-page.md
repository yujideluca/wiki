# ADR-0006: Record the review time in the page; a page is stale when a source changed after it

- **Status:** accepted
- **Date:** 2026-10-24
- **Type (ISO/IEC/IEEE 14764):** corrective
- **Decided by:** Giovanni (owner) / proposed by Claude Code

## Context

`wiki stale` is meant to say which pages describe code that has since changed. It decided this by comparing the
last commit time of each source file with the last commit time of the page file. That compares two clocks, and the
page's clock moves for reasons that have nothing to do with checking the page against its sources: a rewrite of
the wording, a translation fix, a hash bump.

What happened on 2026-10-24: one commit rewrote all 154 pages in plain language (14:44). From then on every page
was "newer" than every source, so `wiki stale` printed "no stale pages" while the Stop hook, which compares
against the last `wiki publish`, still listed pages. Counting afterwards: 38 of the 140 pages with sources had a
source commit after their text was last written and before that rewrite, and `wiki stale` could not see any of
them. Three more facts made the blind spot wider:

- 34 pages name sources under the home folder (skills, scripts, systemd units). The home folder is not a git
  repository, so these pages could never be reported stale at all.
- `Stale.pages`, the function behind `wiki stale`, had no requirement and no test, so nothing noticed that it
  answered a different question from the one it was named for.
- A publish with the message `review: no page change` silenced the Stop hook for every page, with no record of which
  pages were really checked.

A sample of three of the 38 pages showed no wrong claim: the hidden pages are a review queue, not 38 known errors.
That is the point: the tool could not tell "checked and right" from "touched".

## Decision

The page itself records when it was last checked against its sources.

- Header field `reviewed` (already used for pages without sources) is required on every page. It is a UTC date
  (`2026-10-24`, meaning the start of that day) or a UTC date and minute (`2026-10-24T18:30Z`). It may not be in the
  future. Only the person or skill that really compared the page with its sources sets it.
- `wiki stale` lists a page when any of its sources changed after `reviewed`. The page file's own commits are never
  used. A source in git changes at the time of its last commit. A source outside git changes at the newest
  modification time of its file or folder.
- `wiki stale` prints the source and both times, and exits 1 when it lists a page (0 when none).
- The Stop hook keeps its own question (what changed since the last publish) and now tells Claude to record a page it
  checked and found right by setting its `reviewed` time, which is a page change; the publish message
  `review: no page change` stays only for changes that no page describes (for example a data file).
- The skill `wiki-page-writer` sets `reviewed` as the last step of verifying a page, and never on a page it did not
  verify.

## Alternatives considered

- **Keep the commit-time comparison and ignore commits that touch many pages** — a guess about what a bulk commit
  means; the next kind of commit that is not a review would break it again.
- **Store each source's commit hash in the page** — exact, but a page with sources in three repositories would carry
  three hashes that change on every source commit, and the header becomes noise.
- **A separate ledger file of reviews** — a second place to keep in step with the pages; the page is already the
  unit that is checked.
- **Date only, no time of day** — a source commit on the same day as the review would be invisible. The incident
  was a single-day event, so the time of day is needed.
- **Make `wiki publish` refuse while any page is stale** — a fix to one page would be blocked by an unrelated stale
  page. Staleness is reported, not enforced at publish; `wiki check` enforces only that the review time exists.

## Consequences

Easier: `wiki stale` answers the question its name asks, for every page, including pages whose sources are not in
git. A bulk rewrite no longer hides anything.

Harder: a page must be reviewed to be marked reviewed; a mass edit of `reviewed` without checking would defeat the
mechanism, and no program can tell (the skill forbids it). Pages whose sources change often (a whole source
folder) are listed often.

Kept true by: REQ CO-6 (every page has a valid, non-future review time), ST-1 (page commits never clear it; the 14:44
incident is a test), ST-2 (sources outside git), ST-3 (output and exit code), UP-3 (hook message). Tests:
`server/test/stale_test.exs`, `server/test/check_test.exs`, `server/test/build_test.exs`.

## Update 2026-10-24

A review time with minutes covers its whole minute: a source change made earlier in that minute is not "after" the
review (the first implementation compared with the start of the minute, so it was, which contradicted the rule that a
change in the same minute is not seen). A date alone still means the start of that day. Test: `server/test/stale_test.exs`
(ST-1, "a review at minute M covers all of that minute").
