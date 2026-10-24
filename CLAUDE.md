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
- Never force-push. Ask Giovanni before anything outward-facing or destructive.
