# ADR-0007: A `## Flow` section drawn as a flowchart by the wiki itself

- **Status:** accepted
- **Date:** 2026-10-27
- **Type (ISO/IEC/IEEE 14764):** perfective
- **Decided by:** Giovanni (owner) / proposed by Claude Code

## Context

Giovanni asked for big-picture pages: the pages of the big concepts (Claude Code, Codex, skill-forge and the like) should
show a flowchart of the chain of events that engages the concept, what it engages and what the chain produces, in a way
that explains itself. Until now a page could only show text, links and, for a process, the step-through box. The wiki is
a custom Elm app with its own Markdown rendering, so a diagram needs a decision about its source format and its drawing.

## Decision

- **Source:** each such page has a `## Flow` section (right after "What it is") written as plain lines: one line per box
  (`trigger`, `step`, `decide`, `product`, then an id, the label and `| [[page]]` links) and one line per arrow
  (`a -> b`, `d -yes-> b`). The text is parsed twice, by `Wiki.Content.Flow` (the checks) and by `Flow.elm` (the
  drawing); both are tested on the same example.
- **Who needs it:** pages of kind actor, project, process and skill (`wiki check`, FL-1). A translation keeps the same
  boxes, links and arrows and changes only the words (FL-2).
- **Drawing:** `FlowView.elm` draws SVG from the Elm view, top to bottom: a pill for what starts the chain, a
  diamond for a question, a double box for an end product, boxes coloured by the kind of their first linked page,
  arrows drawn with elm-visualization's `Shape.bumpYCurve`, a legend underneath (FL-3).
- **Layout:** `Flow.elm` places the boxes itself: longest-path rows, a stopover for every arrow that skips a row, the
  barycenter method for the order inside a row, and an isotonic regression (pool adjacent violators) for the columns
  (FL-4). No layout package is used.
- **Page shape:** a loop is not allowed in a flow (it is written in the text); at most 18 boxes, labels up to 120
  characters, two page links per box, and no acronym in a label before it is explained (labels come before the
  definitions on the page).
- **Related:** `index.html` carries `<meta name="darkreader-lock">`, so the Dark Reader browser extension does not
  recolour the wiki's own dark theme; it inverted the light fills of the chart and made them unreadable.

## Alternatives considered

- **elm-dagre** (`goyalarchit/elm-dagre`, a pure-Elm Sugiyama layout): the closest package, but it has few users and its
  last update was in 2024. Giovanni asked not to depend on a package that may break and leave a bigger problem later.
- **Only elm-visualization:** the version in use (2.4.3) has tree layouts, scales and curves, but no layered layout for a
  graph with merges and questions (it has no Sankey module either). Its `Shape.bumpYCurve` is used for the arrows; the
  placing is our own small module.
- **Mermaid or another JavaScript library through a port:** adds a language and a runtime dependency to a project
  that is Elm and Elixir only, and the boxes could not be translated or linked as easily.
- **Hand-drawn SVG files:** free layout, but not translated, not clickable and out of date as soon as the chain changes.
- **ASCII art in a code block:** no code change, but plain, breaks on a phone and has no links.

## Consequences

Easier: the chain of a concept is one list of lines in the page, checked by `wiki check` for structure and links, and drawn
the same way everywhere, in the three languages. Harder: a flow must be kept true when the chain changes, and no
program can tell whether its words are right (the writing rule in CLAUDE.md asks for it). Our own layout is code to
maintain; it is small (about 400 lines), pure and tested. A chart wider than a phone screen scrolls inside its box.

Kept true by: REQ FL-1, FL-2 (`server/test/flow_test.exs`), FL-3, FL-4 (`frontend/tests/FlowTests.elm`).
