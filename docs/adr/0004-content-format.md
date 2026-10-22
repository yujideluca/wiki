# ADR-0004: Content as Markdown pages with a header, checked before publishing

- **Status:** accepted
- **Date:** 2026-10-22
- **Type (ISO/IEC/IEEE 14764):** initial
- **Decided by:** Giovanni (granularity option A, promotion rule, three languages, update tied to `mem use`);
  format proposed by Claude Code

## Context

Claude writes the wiki after every task, so the format must be easy to write and easy to check, and independent of
the site's code.

## Decision

- One file per concept, `content/<id>.md`, header (`id, title, aliases, kind, project, status, location, fed_by,
  feeds, tags, sources, memory, since, until, reviewed`) and fixed sections (what, does, how, where, receives;
  optional steps, functions, notes). Links `[[id]]`; kinds in `content/_kinds.json`.
- English is the source of truth; `<id>.de.md` and `<id>.pt-BR.md` carry the `source_hash` of the English text.
- `sources` are `repo:path` (or `home:path`); pages without sources need `reviewed` and show "may be stale" after
  30 days.
- Granularity: option A (D11) plus promotion (D12).
- `wiki check` enforces all of it; `wiki publish` = check (local) → build → commit `content/` only → push.
- A Claude Code Stop hook (`wiki hook-stop`) blocks once per session when covered code changed after the last
  publish.

## Alternatives considered

- **Generating pages from code** (option B) — thousands of thin pages; rejected by Giovanni.
- **A database or a wiki engine** — harder to review in git and to check automatically.

## Consequences

The `site/` folder is derived and not committed. Translating every page is part of every update; the hash makes a
forgotten translation fail the check instead of drifting silently.
