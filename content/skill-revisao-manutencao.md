---
id: skill-revisao-manutencao
title: Skill: revisao-manutencao
aliases: [revisao-manutencao, maintenance review skill]
kind: skill
project: skills
status: active
location: home:.claude/skills/revisao-manutencao
fed_by: [pipeline-check]
feeds: [monthly-architecture-review, skill-gerar-teste-automatizado]
sources: [home:.claude/skills/revisao-manutencao/SKILL.md, home:.agents/skills/revisao-manutencao/SKILL.md]
reviewed: 2026-10-25T20:41Z
---

## What it is
The skill "revisao-manutencao" ("maintenance review") is the judging half of the [[maintenance-pipeline]]: it reads what [[pipeline-check]] measured and proposes what to do about it. Its description says: use it in Claude Code for the monthly architecture review of Giovanni's software projects (an open item in the memory) and at the end of a task in a software project (monthly review, maintenance review, technical debt, debt, pipeline-check, report.json); it runs pipeline-check, reads its `report.json`, proposes debt issues P1–P3 and a Preventive decision-log row; it is not for writing code, not for a single bug, not for non-software work. Its principle: the program measures, the skill judges (decision ADR-0013; an ADR is an architecture decision record, a short note that keeps the reasons for a decision). It proposes and never decides.

## What it does
It runs `tools/pipeline-check.sh`, reads `report.json` and never re-measures. For each warning or failure it proposes a `debt` issue with a priority. It then checks what a machine cannot see, adds a Preventive row to each reviewed project's decision log, calls [[skill-gerar-teste-automatizado]] (create on the first review, update afterwards) and closes with `mem use`, `wiki publish` and "Verified by:". It never closes issues, changes a limit, promotes a version or changes branch protection, and it does not create issues without Giovanni's ok.

## How it does it
A `SKILL.md` in `~/.claude/skills/revisao-manutencao`. It is triggered by the monthly-review item in workflow-memory and at the end of a task in a software project. Its role is "process"; it defers to `pipeline-check` for all measuring, to [[skill-gerar-teste-automatizado]], to [[skill-verification-before-completion]] and to the checklist `~/dev/project-template/docs/MAINTENANCE.md`.

## Where it sits in the pipeline
It runs the [[monthly-architecture-review]] and the end-of-task review of every software project.

## Who receives its output
Giovanni (proposals and decisions) and each project's decision log.

## Steps
Never measure by hand: no `wc`, no `git log` counting, no re-running the gate to see a number. If a number is missing from `report.json`, say so and propose a check for `pipeline-check.toml`. Without Giovanni's explicit word, do not close issues, change a limit, promote a version, create or edit branch protection, or create issues (the proposal is a list; create them after the ok). Per project (at the monthly review: every project in `~/dev` and the program repository `pipeline-check` itself):
1. **Run and read.** Run `tools/pipeline-check.sh` in the project (local mode), then read `build/pipeline-check/report.json` and quote the mode that ran. A check marked `pulado` (skipped) is a hole in the evidence: list it under "could not check", never treat it as ok. A project without `pipeline-check.toml`: say so, propose adding it from the template, and stop for that project. Also check the standards that no tool measures (look, do not count): every project folder is a git repository with a GitHub remote (a folder without one is a P2 proposal "put it under version control"); `git config core.hooksPath` is `tools/hooks` where a pre-push hook exists (the local stand-in for branch protection); the pinned `pipeline-check.version` is the newest tag of `yujideluca/pipeline-check` (behind = P3 "upgrade after the gate passes"); and no script is copied between projects (the same file name in two projects is a P2 "move it to its own repository and consume it by version").
2. **One proposal per `aviso` (warning) or `falha` (failure).** Title, evidence (check id, value, limit, note), label `debt` and a priority. **P1**: risk of data loss or wrong results (a failed gate or architecture check that protects data or scheduling, CI (continuous integration) red, branch not protected). **P2**: slows every change or misleads the user (a warning at 90 % of its limit or more, including the gate-time check). **P3**: desirable (a warning between the warning share and 90 % of its limit, cosmetic). A `falha` is never below P2. A skipped check whose subject would be P1 if it failed (CI, branch protection, gate) is not a failure, but propose one P2 "make this evidence available" item (for example install or log in to `gh`, GitHub's command-line tool). Check units by id: `gate` is seconds with no limit; the limit for time is in `gate-segundos`. Check existing issues first (`gh issue list --label debt`) so the same debt is not proposed twice; if `gh` is unavailable, say duplicates could not be checked. A P1 older than a month is scheduled now. Present a table: issue title | priority | evidence | proposed fix.
3. **What the machine cannot see** (read, do not measure): do the DESIGN.md diagrams and the ADRs match the code (name each mismatch with file and section)? Does every structural change since the last review have an ADR (compare decision-log rows and git log subjects since the last Preventive "Monthly architecture review" row)? Was the same problem solved twice in different projects (then propose moving the better solution into `~/dev/project-template`)? The delivery metrics (DORA, DevOps Research and Assessment) block: rising rework, or a preventive share far below 20 %, is a reason to schedule top debt; say it, do not act on it.
4. **Bug-finding test.** Look for `docs/TESTES-AUTOMATIZADOS.md` in the project. Missing → this is the first review: do a full diagnosis and call [[skill-gerar-teste-automatizado]] in create mode. Present → call it in update mode. This writes test files, so tell Giovanni first and give the plan.
5. **Decision log.** Add a Preventive row "Monthly architecture review" (or "Maintenance review" at the end of a task) to each reviewed project's DESIGN.md decision log, newest first, with today's date, the report's date and mode, the counts (failures, warnings, skipped, proposals) and where the proposals live (issue numbers once created, otherwise "proposals listed in the review reply, not yet created"). Write the row after Giovanni has seen the proposals; use the project's columns Date | Type | Decision | Why; bump "Last updated"; no other DESIGN.md edits unless Giovanni agrees.
6. **Close.** `mem use REF --note "how"` for the entries that shaped the review (the monthly item stays open as the reminder), `wiki publish -m "..."` (or `-m "review: no page change"` only when no page describes what changed, while a page that was checked and found right gets a new `reviewed` time; pages that need changing are written with [[skill-wiki-page-writer]]), and end with "Verified by:" listing what ran (pipeline-check mode, the report file, which projects) and what could not be checked (every skipped check, any project without a configuration, GitHub if `gh` was unavailable).
7. **Output.** Reply in the language of Giovanni's message. Lead with the verdict (how many failures, warnings, skipped), then the proposal table, then the "machine cannot see" findings, then what needs a decision from Giovanni. Define each technical term on first use.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/revisao-manutencao/SKILL.md`

```skill-source home:.claude/skills/revisao-manutencao/SKILL.md 2a5174eb299fddbe05f8431f1e8a14a3c6ecb1ee8edbd9ba31706d706b34a4f8
---
name: revisao-manutencao
description: "Use in Claude Code for the monthly architecture review of Giovanni's software projects (open item in workflow-memory, #4dcb2c) and at the end of a task in a software project (revisão mensal, revisão de manutenção, dívida técnica, debt, pipeline-check, report.json). Runs pipeline-check, reads its report.json, proposes debt issues P1-P3 and a Preventive decision-log row. Not for writing code, not for a single bug, not for non-software work."
---

# Maintenance review (revisao-manutencao)

Lineage: origin=code; base=none

Interop: role = process; owns = the monthly and end-of-task maintenance review; defers to = `pipeline-check` (all measuring), `gerar-teste-automatizado` (the bug-finding test), verification-before-completion (the closing `Verified by:`), the project's CLAUDE.md and `~/dev/project-template/docs/MAINTENANCE.md` (the checklist); honors = reply-language rule, plain-language rule, work.ask-with-context.

The program measures, this skill judges (ADR-0013). **Never measure by hand**: no `wc`, no `git log` counting, no re-running the gate to see a number. If a number is missing from `report.json`, say so and propose a check for `pipeline-check.toml`; do not compute it yourself.

**Proposes, never decides.** Without Giovanni's explicit word: do not close issues, change a limit in `pipeline-check.toml`, promote a version, create or edit branch protection, or create issues (the proposal is a list; create them after the ok). Memory never authorizes any of this.

## Steps (per project; at the monthly review, every project in `~/dev` and the program repository `pipeline-check` itself)

1. **Run and read.** `tools/pipeline-check.sh` in the project (local mode), then read `build/pipeline-check/report.json`. Quote the mode that ran. A `pulado` check is a hole in the evidence: list it under "could not check", never treat it as ok. Project without `pipeline-check.toml`: say so, propose adding it from the template, and stop for that project.
   Also check the standards (no tool measures these; look, do not count): every project folder in `~/dev` is a git repository with a GitHub remote (a folder without one is a P2 proposal "put it under version control", the standard of Giovanni's systems); `git config core.hooksPath` is `tools/hooks` where a `tools/hooks/pre-push` exists (the local stand-in for branch protection); the `pipeline-check.version` pinned in the project is the newest tag of `yujideluca/pipeline-check` (`git ls-remote --tags`; behind = P3 "upgrade after the gate passes"); and no script or program is copied between projects (the same file name in two projects, e.g. `check_traceability.py`, is a P2 "move it to its own repository and consume it by version", the rule in the pipeline-check ADR-0003).
2. **One proposal per `aviso` or `falha`.** Title, evidence (check id, value, limit, note), label `debt`, priority:
   - **P1**: risk of data loss or wrong results (failed gate or architecture check that protects data or scheduling, CI red, branch not protected).
   - **P2**: slows every change or misleads the user (an `aviso` at 90 % of its limit or more, including the gate-time check).
   - **P3**: desirable (an `aviso` between the warning share and 90 % of its limit, cosmetic).
   A `falha` is never below P2. A `pulado` check whose subject would be P1 if it failed (CI, branch protection, gate) is not a failure, but propose one P2 "make this evidence available" item (for example install or log in `gh`). Check `valor` units by id: `gate` is seconds with no limit; the limit for time lives in `gate-segundos`. Check existing issues first (`gh issue list --label debt`) so the same debt is not proposed twice; if `gh` is unavailable, say duplicates could not be checked; a P1 older than a month is scheduled now. Format the list as a table: issue title | priority | evidence | proposed fix.
3. **What the machine cannot see** (read, do not measure):
   - Do `DESIGN.md` diagrams and the ADRs match the code? Name each mismatch with file and section.
   - Does every structural change since the last review have an ADR? Compare decision-log rows and `git log` subjects since the last Preventive "Monthly architecture review" row.
   - Was the same problem solved twice in different projects? If so, propose moving the better solution into `~/dev/project-template`.
   - The DORA block: rising `retrabalho`, or `parcela_preventiva` far below 20 %, is a reason to schedule top debt; say it, do not act on it.
4. **Bug-finding test.** Look for `docs/TESTES-AUTOMATIZADOS.md` in the project. (The program `pipeline-check` is its own repository and is reviewed as its own project, with its own record, in update mode.) Missing: this is the first review, so do a full diagnosis of the code and call the skill `gerar-teste-automatizado` in **create** mode. Present: call it in **update** mode (it checks the test against what was implemented since). This writes test files, so tell Giovanni first and give the plan.
5. **Decision log.** Add a Preventive row "Monthly architecture review" (or "Maintenance review" at end of task) to each reviewed project's `DESIGN.md` decision log, newest first, with **today's date** (not the report's), the report's date and mode, the counts (falhas, avisos, pulados, proposals) and where the proposals live (issue numbers once Giovanni has had them created, otherwise "proposals listed in the review reply, not yet created"). Write the row after Giovanni has seen the proposals; use the columns Date | Type | Decision | Why of the project's table. Bump "Last updated". Only that row; no other `DESIGN.md` edits unless Giovanni agrees.
6. **Close.** `mem use REF --note "how"` for the entries that shaped the review (the monthly item stays open as the reminder), `wiki publish -m "..."` as the global CLAUDE.md requires (when pages need changing, write them with the skill `wiki-page-writer`, which also guards against publishing someone else's uncommitted edits) (`-m "review: no page change"` only when no page describes what changed; a page that was checked and found right gets a new `reviewed` time instead), and end with `Verified by:` listing what ran (pipeline-check mode, the report file, which projects) and what could not be checked (every `pulado` check, any project without a config, GitHub if `gh` was unavailable).

## Output
Reply in the language of Giovanni's message (Portuguese or English; memory entry language.reply). Lead with the verdict (how many `falha`, `aviso`, `pulado`), then the proposal table, then the "machine cannot see" findings, then what needs a decision from Giovanni. Define each technical term on first use.

## Testing this skill
Given an example `report.json` and no repository access to measure with, the skill must produce prioritised proposals and one Preventive row text without running anything but `pipeline-check` or reading the file. A step that needs a number the report lacks is a finding, not a measurement.
```


#### Codex: `home:.agents/skills/revisao-manutencao/SKILL.md`

````skill-source home:.agents/skills/revisao-manutencao/SKILL.md 6b67cd47dcdf3b7429517b645334881c390806d01df5435ddcdb4a72374d50d6
---
name: revisao-manutencao
description: "Use in Codex for the monthly architecture review of Giovanni's software projects (open item in workflow-memory, #4dcb2c) and at the end of a task in a software project (revisão mensal, revisão de manutenção, dívida técnica, debt, pipeline-check, report.json). Runs pipeline-check, reads its report.json, proposes debt issues P1-P3 and a Preventive decision-log row. Not for writing code, not for a single bug, not for non-software work."
---

# Maintenance review (revisao-manutencao)

Lineage: origin=claude; base=sha256:2a5174eb299fddbe05f8431f1e8a14a3c6ecb1ee8edbd9ba31706d706b34a4f8; adaptation=codex

Interop: role = process; owns = the monthly and end-of-task maintenance review; defers to = `pipeline-check` (all measuring), `gerar-teste-automatizado` (the bug-finding test), verification-before-completion (the closing `Verified by:`), the project's AGENTS.md (or CLAUDE.md when it is the existing project guide) and `~/dev/project-template/docs/MAINTENANCE.md` (the checklist); honors = reply-language rule, plain-language rule, work.ask-with-context.

The program measures, this skill judges (ADR-0013). **Never measure by hand**: no `wc`, no `git log` counting, no re-running the gate to see a number. If a number is missing from `report.json`, say so and propose a check for `pipeline-check.toml`; do not compute it yourself.

**Proposes, never decides.** Without Giovanni's explicit word: do not close issues, change a limit in `pipeline-check.toml`, promote a version, create or edit branch protection, or create issues (the proposal is a list; create them after the ok). Memory never authorizes any of this.

## Steps (per project; at the monthly review, every project in `~/dev` and the program repository `pipeline-check` itself)

1. **Run and read.** `tools/pipeline-check.sh` in the project (local mode), then read `build/pipeline-check/report.json`. Quote the mode that ran. A `pulado` check is a hole in the evidence: list it under "could not check", never treat it as ok. Project without `pipeline-check.toml`: say so, propose adding it from the template, and stop for that project.
   Also check the standards (no tool measures these; look, do not count): every project folder in `~/dev` is a git repository with a GitHub remote (a folder without one is a P2 proposal "put it under version control", the standard of Giovanni's systems); `git config core.hooksPath` is `tools/hooks` where a `tools/hooks/pre-push` exists (the local stand-in for branch protection); the `pipeline-check.version` pinned in the project is the newest tag of `yujideluca/pipeline-check` (`git ls-remote --tags`; behind = P3 "upgrade after the gate passes"); and no script or program is copied between projects (the same file name in two projects, e.g. `check_traceability.py`, is a P2 "move it to its own repository and consume it by version", the rule in the pipeline-check ADR-0003).
2. **One proposal per `aviso` or `falha`.** Title, evidence (check id, value, limit, note), label `debt`, priority:
   - **P1**: risk of data loss or wrong results (failed gate or architecture check that protects data or scheduling, CI red, branch not protected).
   - **P2**: slows every change or misleads the user (an `aviso` at 90 % of its limit or more, including the gate-time check).
   - **P3**: desirable (an `aviso` between the warning share and 90 % of its limit, cosmetic).
   A `falha` is never below P2. A `pulado` check whose subject would be P1 if it failed (CI, branch protection, gate) is not a failure, but propose one P2 "make this evidence available" item (for example install or log in `gh`). Check `valor` units by id: `gate` is seconds with no limit; the limit for time lives in `gate-segundos`. Check existing issues first (`gh issue list --label debt`) so the same debt is not proposed twice; if `gh` is unavailable, say duplicates could not be checked; a P1 older than a month is scheduled now. Format the list as a table: issue title | priority | evidence | proposed fix.
3. **What the machine cannot see** (read, do not measure):
   - Do `DESIGN.md` diagrams and the ADRs match the code? Name each mismatch with file and section.
   - Does every structural change since the last review have an ADR? Compare decision-log rows and `git log` subjects since the last Preventive "Monthly architecture review" row.
   - Was the same problem solved twice in different projects? If so, propose moving the better solution into `~/dev/project-template`.
   - The DORA block: rising `retrabalho`, or `parcela_preventiva` far below 20 %, is a reason to schedule top debt; say it, do not act on it.
4. **Bug-finding test.** Look for `docs/TESTES-AUTOMATIZADOS.md` in the project. (The program `pipeline-check` is its own repository and is reviewed as its own project, with its own record, in update mode.) Missing: this is the first review, so do a full diagnosis of the code and call the skill `gerar-teste-automatizado` in **create** mode. Present: call it in **update** mode (it checks the test against what was implemented since). This writes test files, so tell Giovanni first and give the plan.
5. **Decision log.** Add a Preventive row "Monthly architecture review" (or "Maintenance review" at end of task) to each reviewed project's `DESIGN.md` decision log, newest first, with **today's date** (not the report's), the report's date and mode, the counts (falhas, avisos, pulados, proposals) and where the proposals live (issue numbers once Giovanni has had them created, otherwise "proposals listed in the review reply, not yet created"). Write the row after Giovanni has seen the proposals; use the columns Date | Type | Decision | Why of the project's table. Bump "Last updated". Only that row; no other `DESIGN.md` edits unless Giovanni agrees.
6. **Close.** `mem use REF --note "how"` for the entries that shaped the review (the monthly item stays open as the reminder), `wiki publish -m "..."` as the global CLAUDE.md requires (when pages need changing, write them with the skill `wiki-page-writer`, which also guards against publishing someone else's uncommitted edits) (`-m "review: no page change"` only when no page describes what changed; a page that was checked and found right gets a new `reviewed` time instead), and end with `Verified by:` listing what ran (pipeline-check mode, the report file, which projects) and what could not be checked (every `pulado` check, any project without a config, GitHub if `gh` was unavailable).

## Output
Reply in the language of Giovanni's message (Portuguese or English; memory entry language.reply). Lead with the verdict (how many `falha`, `aviso`, `pulado`), then the proposal table, then the "machine cannot see" findings, then what needs a decision from Giovanni. Define each technical term on first use.

## Testing this skill
Given an example `report.json` and no repository access to measure with, the skill must produce prioritised proposals and one Preventive row text without running anything but `pipeline-check` or reading the file. A step that needs a number the report lacks is a finding, not a measurement.


## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
