# Wiki content work

Read `CLAUDE.md` for the project structure, chosen languages, quality gate and existing content rules. Use `wiki-page-writer` for page work.

## Complete skill pages (CO-10)

When a page has `kind: skill`, locate and read its complete installed `SKILL.md` before writing. Use the page's sources and location, and search installed skill folders when needed. Document separate Claude and Codex versions explicitly when both exist.

Keep the readable explanation and Steps. In Notes, include the complete original source file: its frontmatter description, every instruction, example, limit and reference path. A shortened description, summary or link alone does not meet this rule. Retain the same original source in German and Portuguese pages, introduced in the page's language; translate the surrounding explanation. Referenced auxiliary files are not automatically included in this source copy.

Each copy uses a fenced block with info `skill-source <repo:path/to/SKILL.md> <sha256>`. Choose a backtick fence longer than any run inside the source. Compute the fingerprint over the entire text after normalizing line endings to LF and adding a final newline only when absent. List each original file in `sources`. Never truncate a source to satisfy validation; report unavailable or privacy-blocked sources.

Refresh copies whenever the sources change. Run `wiki check --local`: it compares the copies to the installed files and checks that translations retain them. The check without local files validates presence and fingerprints, but cannot verify freshness against unavailable sources.

## Flow chart on the big concepts (FL-1, FL-2)

A page of kind `actor`, `project`, `process` or `skill` has a `## Flow` section right after `## What it is`: a flowchart read top to bottom. Start from what starts the chain (`trigger`, a pill), follow what it engages (`step`; `decide` for a question, a diamond, with a labelled arrow for each answer), and end with what the chain leaves behind (`product`, a double box). For a skill the chain is its activation trigger, its own development sequence and where its output goes. One line per box and one per arrow:

    trigger t1: What starts it | [[page-that-starts-it]]
    step s1: What it does, in a few words | [[page-it-engages]], [[another]]
    decide d1: A question?
    product p1: What it leaves behind | [[page]]

    t1 -> s1
    s1 -> d1
    d1 -yes-> p1

Rules: 2 page links at most per box, labels up to 120 characters in plain words (no acronym before the page explains it), 18 boxes at most, no loops (write a repeat in the text), every box reachable from a trigger, every decision with two or more labelled arrows. Translations keep the same ids, kinds, links and arrows and translate only the words and the arrow labels. `wiki check` enforces all of it (`server/lib/wiki/content/flow.ex`); the format is in ADR-0007 and the page `wiki-flow-view`.

## Architecture and practices on project and program pages (PJ-1, PJ-2, PJ-4)

A page of kind `program` has `## Architecture` too (PJ-4) but not the practices. A page of kind `project` that lives in a repository (not `location: home:...`) has `## Architecture` after `## Flow` and `## Engineering practices` after `## Who receives its output`. Architecture is two C4 diagrams in the flow's line format, `### Context` (exactly one `system` box among `person` and `external` boxes) and `### Containers` (`container` and `store` boxes), a box written `kind id: Name — what it does | [[page]]`, every arrow labelled with what the relation is for (`a -reads-> b`), no loops, 14 boxes at most. Practices has the six parts of project-template in this order: `### Principles`, `### Decisions`, `### Requirements`, `### Quality gate`, `### Continuous integration`, `### Maintenance`. Translations keep the same boxes, links, arrows and six parts. Take the facts from the repository's `DESIGN.md`, `CLAUDE.md`, `docs/adr/`, `docs/REQUIREMENTS.md`, `tools/quality_gate.sh` and workflow; format in ADR-0008 and the page `wiki-flow-view`. `wiki check` enforces it (`server/lib/wiki/content/architecture.ex`, `practices.ex`).
