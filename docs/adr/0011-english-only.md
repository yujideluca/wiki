# ADR-0011: Write the wiki in English only

- **Status:** accepted
- **Date:** 2026-11-06
- **Type (ISO/IEC/IEEE 14764):** perfective
- **Decided by:** Giovanni (2026-11-06, asked for the wiki to be exclusively in English; no further reason was given); carried out by Claude Code.
  Supersedes the language rules of [ADR-0004](0004-content-format.md) (three languages, `source_hash`).

## Context

ADR-0004 made English the source and required a German and a Brazilian Portuguese version of every page. Each
translation carried the `source_hash` of the English text, so a changed English page failed `wiki check` until both
translations were rewritten and re-hashed. The interface was also available in three languages, with a language
switch and a setting kept in the browser. The rule was written into the instructions every assistant reads
(`CLAUDE.md`, `AGENTS.md`, two skills, memory rules and the Stop hook), so changing it changes how every Claude Code
and Codex session ends a task.

## Decision

- The wiki is English only. A page is one file, `content/<id>.md`. There is no other language version.
- `wiki check` refuses a file named `<id>.<language>.md` (for example `.de` or `.pt-BR`) and its message says to
  delete it and keep the text in the English page (requirement LG-1, test `check_test.exs`). A stray translation can
  therefore never be published by mistake, including by a session that started before this decision.
- The interface and the articles are English only: no language type, switch or stored setting in the front end, one
  interface-text module (`UiText`), one article file per page (`data/pages/<id>.json`) and one text per node in
  `graph.json` (LG-2, BU-1; tests `WikiTests.elm`, `map_css_test.exs`, `build_test.exs`).
- Removed with it: `source_hash`, the translation checks, requirement FL-2 (a translated flow keeps the English
  boxes) and the translation clauses of CO-10, PJ-1, PJ-2, AR-1, AR-2, FL-3, PJ-3 and MP-9.
- Every instruction that told an assistant to write translations (`~/.claude/CLAUDE.md`, `~/AGENTS.md`,
  `~/.codex/AGENTS.md`, `AGENTS.md`, `CLAUDE.md`, the Stop hook text, the `wiki-page-writer` and `skill-forge`
  skills, the memory rules) says English only.

## Alternatives considered

- **Keep the translations but stop requiring them** — pages would drift out of date silently, and a reader would
  meet old text in another language with no sign it is old.
- **Generate the translations in the build** — adds a dependency on a translation service for a wiki whose only reader
  chose English.

## Consequences

- Easier: one page per concept, no hash to maintain, less to write at the end of a task, and `wiki publish` can no
  longer fail on a translation.
- Harder: nothing in the wiki is available in German or Portuguese any more; if that is wanted again it needs a new
  decision and the old files, which stay in git history (tag `backup/before-english-only`).
- Kept true by: `check_test.exs` (LG-1), `WikiTests.elm` and `map_css_test.exs` (LG-2), `build_test.exs` (BU-1).
