# ADR-0009: A review claim is checked when it is published; wiki sources follow commit order; the publish stamp does not hide unreviewed work

- **Status:** accepted
- **Date:** 2026-11-01
- **Type (ISO/IEC/IEEE 14764):** corrective
- **Decided by:** Giovanni (owner) / proposed and implemented by Claude Code on the owner's request

## Context

On 2026-11-01 a session wrote two pages, `status-quo-design` and `status-quo-layout`, set `reviewed: 2026-11-01T20:06Z`
and published them with `wiki publish`; a second publish at 20:09 UTC added only a `since:` line. The session
reported "no stale pages" before the second commit and did not run `wiki stale` again. Afterwards both pages were
listed, and so were pages of other work. Three separate gaps explain how this passed the workflow:

1. **A page can never be newer than its own commit.** `reviewed` is typed before the commit that carries it, so a
   source inside the wiki repository is always "changed after the review" by the minutes between typing and
   committing. This hit (a) a page that listed its own file as a source, which can never be satisfied, and (b) two
   pages that list each other, and (c) any later commit that touched only `since:` or `reviewed:`, which says
   nothing about what the page describes.
2. **Nothing checked the claim.** `wiki publish` ran `wiki check` (format) but never asked whether a page whose
   `reviewed` line it was committing was actually up to date. The Stop hook looks at code commits in other
   repositories, not at pages, so a wiki-only session was never questioned.
3. **One shared stamp.** `~/.local/state/wiki/last_publish` is one number for all sessions. Any publish moved it
   forward, so a publish by session B hid the unreviewed code changes of session A from the Stop hook.

## Decision

- `wiki stale` ignores a page's own file as a source.
- A source that is a page of the wiki repository (`wiki:content/<id>.md`) changes only when something other than its
  `reviewed` or `since` lines changed.
- A source in the wiki repository is covered by a review older than its commit only when the commit that last changed
  its text is the very commit that last set the page's `reviewed` line (one atomic change, so the reviewer had that
  text in front of them). There is no grace period: a source commit by anyone else, a minute after the review or
  before the review commit, keeps the page stale until it is compared again. Sources in other repositories and
  outside git keep the plain time rule of ADR-0006.
- `wiki publish` commits, then refuses to push when any `reviewed` line in the unpushed commits is behind a source
  that existed when the commit was made (`Stale.claimed/2`). It names the page and the source.
- The publish stamp moves forward only when no page is still behind a change, and no new file is left uncovered, since
  the previous stamp (`Stale.record_publish/2`), and the hook names a page only when it is really behind.
- The stamp is read safely: missing means "never published" (silent); empty, torn, non-numeric, zero, negative or
  far-future content is reported by the hook once per session and rewritten by the next publish. Both state files
  are written by rename, and a state file that cannot be written never suppresses the message.

## Consequences

- A page checked and found right can be published in the same commit as the sources it describes.
- A metadata-only commit does not stale a neighbour; a text change still does.
- A false `reviewed` still cannot be detected when the sources are older than the typed time; the claim check only
  proves the time is not older than a source. Comparing the text remains the reviewer's job.
- A session that publishes while another session's code changes are unreviewed leaves the stamp where it was, so
  the next session's hook names those pages once more. That is intended.
- Same-commit coverage assumes the publish commit holds only the reviewer's own content edits; `wiki publish` stages `content/` as a whole, so another session's uncommitted page edits would ride along (accepted, as before).
- Not done: the hook does not list all stale pages (the review queue stays visible through `wiki stale`).
