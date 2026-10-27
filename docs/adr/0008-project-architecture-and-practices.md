# ADR-0008: Project pages show a C4 diagram and the project-template practices

- **Status:** accepted
- **Date:** 2026-10-27
- **Type (ISO/IEC/IEEE 14764):** perfective
- **Decided by:** Giovanni (owner) / proposed by Claude Code

## Context

`project-template` gives every software project the same habits: principles that a check enforces, a design file with C4
diagrams, architecture decision records, requirements with tagged tests, a quality gate, continuous integration and a
maintenance policy. The project pages of the wiki described what a project does but not this structure, so Giovanni had to
open each repository to see it. Giovanni asked that project pages contain the C4-style diagram and the other data.

## Decision

A page of kind `project` that lives in a repository gets two sections. `## Architecture` holds the two C4 diagrams that matter
most, context and containers, written in the same line format as the flow with five box words (`person`, `system`,
`container`, `store`, `external`). `## Engineering practices` holds the six parts of project-template, always in the same
order. `wiki check` requires both and checks their form; the front end draws the diagrams with the flow code.

## Alternatives

- **Mermaid** (the tool the design files use): needs a JavaScript library on a page that is otherwise Elm only, and the same
  fragile-dependency worry that ruled out dagre in ADR-0007.
- **A picture file per project**: cannot be checked, cannot link boxes to pages and drifts from the text.
- **Only link to the repository's `DESIGN.md`**: the repositories are private, so the reader still has to open them.

## Consequences

- The diagrams are text, checked and translated like any section; a translation keeps boxes, links and arrows.
- The practices text can drift from the repositories; each page lists the repository files as sources, so the wiki's
  stale-page check flags it when they change.
- Projects that are only a folder of the laptop (`location: home:...`) are exempt.
