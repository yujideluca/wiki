# Wiki: working notes for Claude Code

A wiki of every project, program, skill and process in Giovanni's systems, with a Dark-style map of how they
connect. Giovanni reads it to answer architecture questions; Claude writes it at the end of every task. Runs on the
laptop as `wiki.service` (Elixir, 127.0.0.1:4180) and is published at https://yuji-nitro.tailed3a22.ts.net through
Tailscale Funnel, behind Google sign-in for yujideluca@gmail.com only. Design: `docs/2026-10-22-wiki-design.md`.

## Principles (each one is checked by something)

1. **Requirement, then test, then code**: `docs/REQUIREMENTS.md` → test tagged `REQ <ID>` → code. Checked by
   `tools/pipeline-check.sh --traceability` in the gate.
2. **Default deny**: without Giovanni's verified Google session nothing real is served (decoy or 404). Checked by
   `server/test/router_test.exs` (AU-1..AU-6) and `server/test/decoy_test.exs` (DC-1).
3. **Content follows the rules before it is published**: `wiki check` (links, symmetry, sections, privacy,
   promotion, translations). `wiki publish` refuses on any problem.
4. **The gate decides**: `tools/quality_gate.sh` is the only definition of passing; CI runs it through `pipeline-check` (own repository, pinned in `pipeline-check.version`) on every push (limits in `pipeline-check.toml`, ADR-0005).
5. **Decisions are written where the code is**: decision-log row with its Type in `DESIGN.md`, an ADR for
   structural ones.

## Working rules

- Languages (Giovanni's choice): front end **Elm** (`frontend/`), back end **Elixir** (`server/`), and the maintenance
  tool `pipeline-check` (own repository `yujideluca/pipeline-check`) in **Rust** (Giovanni's choice, ADR-0005). Do not add code in another language without
  asking (memory key `work.ask-language`).
- Build and test: `tools/quality_gate.sh`. Reinstall the server, the `wiki` command and the service:
  `tools/install.sh`. After pushing, the CI run must be green.
- Content: `content/<id>.md` (English, source of truth) plus `<id>.de.md` and `<id>.pt-BR.md`, each translation
  with the `source_hash` of the English text (`wiki check` prints the expected hash when it is outdated). Format
  and rules: the page `wiki-content` and `server/lib/wiki/content/check.ex`.
- Granularity (D11): a page for every project, program, module, skill, hook, service, data store, actor and
  process, and for a function that is an entry point, passes data between modules, or came up in a decision or
  conversation. Other functions go in the `## Functions` list of their module page. Anything that grows past
  that line gets its own page (D12; `wiki check` enforces the "mentioned by two pages" part).
- Write every page for a reader who knows nothing about the system or its technical language: explain a term where it first appears and link complex ones to a definition (an outside source or the `glossary` page); spell out an acronym at its first use on each page (add new ones to `content/_acronyms.tsv`); a skill page carries the skill's own rules or steps in `## Steps`. `wiki check` enforces the acronym and Steps rules.
- Pages say what exists and how it works; rules and preferences stay in workflow-memory and are linked by
  `#code` in the `memory:` field. No secrets, keys, or clinical, secret or contact data about other people.
- Secrets live only in `~/.config/wiki/oauth.env` and `secret.env` (mode 600). Never print or commit them.
- After coding anything, do a first-line debug pass: gate, `tools/install.sh`, then the real flow in Chrome
  (decoy logged out, map, hover, click, languages, phone width).
- Keep `DESIGN.md` current in the same commit as any design change; structural changes get an ADR.
- Publishing: `wiki publish -m "..."`. The commit's `Co-Authored-By` line is never fixed by the tool: pass `--co-author "Name <email>"` (or set `WIKI_CO_AUTHOR`) with the exact attribution line your own session was given (Claude Code: the one in its system reminder; Codex: its own, if any), and leave it out when you have none (UP-4).
- Never force-push. Ask Giovanni before anything outward-facing or destructive.
- One branch: `main` (memory key `work.single-branch`). A branch exists only for the minutes CI needs on a commit: push it, wait for the green `gate` on that exact commit, push the same commit to `main`, then delete the branch (local and remote) and its worktree. Never push to `main` before the gate has run on the commit. Deploy from `main`: `tools/install.sh` builds `site/` there.

## Complete skill pages (CO-10)

For `kind: skill`, follow the complete-source rule in `AGENTS.md`: locate and read the entire installed `SKILL.md`, include its full description and instructions beside the readable explanation, and preserve the same originals in all three language versions. Include separate Claude and Codex sources when both exist. Summaries alone do not pass. `wiki check --local` compares each copy with its source.

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
