---
id: codex-skills
title: Codex skills
aliases: []
kind: project
project: codex-skills
status: active
location: codex-skills:README.md
fed_by: []
feeds: [codex]
sources: [codex-skills:README.md, codex-skills:manifest.json, codex-skills:DESIGN.md]
reviewed: 2026-10-27T01:34Z
---

## What it is
A private repository of Codex-owned adaptations of Giovanni’s Claude skills. A skill is a saved recipe that the assistant reads when its description matches a task. The project preserves Claude originals and gives Codex independently maintained instructions.

## Flow
trigger t1: A Claude skill changes | [[skills]]
step s1: codex-skillsctl compares the source with its stored fingerprint | [[codex-skillsctl]]
decide d1: Did the source change?
step s2: Reports the change without overwriting the Codex adaptation
step s3: The adaptation and its baseline are updated by hand
step s4: The quality gate runs on every push to GitHub
step s5: codex-skillsctl installs the adaptations, reversibly
trigger t2: Giovanni asks Codex for a task that matches a skill description
step s6: Codex reads the installed adaptation
product p1: Nothing to do: adaptations stay as they are
product p2: Up-to-date adaptations with fresh fingerprints
product p3: The task result, or a report of a missing capability

t1 -> s1
s1 -> d1
d1 -yes-> s2
d1 -no-> p1
s2 -> s3
s3 -> s4
s4 -> s5
s4 -> p2
s5 -> s6
t2 -> s6
s6 -> p3

## Architecture
### Context
person g: Giovanni — reviews each adaptation | [[giovanni]]
system s: codex-skills — Codex's own adapted skills
external c: Claude skills — the originals, read only | [[skills]]
external x: Codex — finds and loads the skills | [[codex]]

g -adapts by hand-> s
c -is copied as snapshots into-> s
s -installs skills for-> x

### Containers
person g: Giovanni | [[giovanni]]
store sr: sources/ — exact snapshots of the Claude skills
store mf: manifest.json — fingerprints, source paths, limits
store sk: skills/ — the adapted skills Codex owns
container ct: skillsctl — checks, reports drift, installs, rolls back | [[codex-skillsctl]]
external lv: Skill links Codex can discover | [[codex]]

g -adapts-> sk
g -runs-> ct
ct -compares with-> sr
ct -records fingerprints in-> mf
ct -validates-> sk
ct -installs, with backups-> lv

## What it does
Keeps 26 adaptations, complete source baselines and content fingerprints. A fingerprint is a calculated value that detects changed files. Reports source changes without overwriting adaptations. Vendor document skills remain under their existing owners.

## How it does it
Repository: `yujideluca/codex-skills`; folder: `~/dev/codex-skills`. Python manages validation and reversible installation through [[codex-skillsctl]]. The quality gate, a command that decides whether a change passes, is `tools/quality_gate.sh`; GitHub runs it on every push. Start with README.md and AGENTS.md.

## Where it sits in the pipeline
Claude source folders feed manual review, then Codex skill folders feed the installer. [[skills]] lists the adapted instructions.

## Who receives its output
Codex reads the installed skills. The user receives task results and reports of missing capabilities.

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
1. **Codex owns the adaptations**: the Claude originals are read-only inputs, never merged automatically and never read as live instructions.
2. **Nothing is installed unchecked**: `skillsctl check` validates every skill and installation keeps backups that can be rolled back.
3. **Requirement, then test, then code**: tests carry `REQ CS-N`, checked by the traceability step of the gate.
4. **The gate decides**: `tools/quality_gate.sh` is the only definition of passing, and continuous integration runs it.

### Decisions
Three architecture decision records (ADRs, short notes that keep the reasons for a decision) in `docs/adr/`: 0002 Codex-owned adaptations with explicit capability discovery; 0003 a program measures and a skill judges. `DESIGN.md` holds the diagram and the decision log.

### Requirements
8 requirements (prefix CS) in `docs/REQUIREMENTS.md`. Each has a test tagged `REQ CS-N`, and the traceability check ([[check-traceability]]) fails when one has none.

### Quality gate
The gate runs `skillsctl check`; the unit tests; a mutation check (faults planted on purpose must be caught); requirement traceability; and the fitness functions.

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` runs the gate on GitHub for every push, through `pipeline-check` pinned in `pipeline-check.version`.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` (P1 to P3) under the [[maintenance-policy]]. The [[monthly-architecture-review]] checks the project every month; the next is due 2026-11-22.

## Notes

The full command and rollback instructions are in README.md. Installation receipts stay outside version control. Missing browser, Google or scheduling capabilities remain explicit limitations.

[[skill-adb-android-control]], [[skill-alemao-goethe-fsp]], [[skill-analise-artigo-cientifico]], [[skill-bias-risk-triage]], [[skill-brainstorming]], [[skill-browser-automacao-segura]], [[skill-candidatura-alemanha]], [[skill-click-protocol]], [[skill-consulta-clinica]], [[skill-deutsch-gespraech-memory]], [[skill-gerar-teste-automatizado]], [[skill-google-workspace]], [[skill-gui-code-protocol]], [[skill-import-memory]], [[skill-ligamagic-listas]], [[skill-ligamagic-replicar-carrinho-nas-lojas]], [[skill-minimize-site-approvals]], [[skill-morning]], [[skill-regras-magic]], [[skill-reparo-kubuntu]], [[skill-revisao-manutencao]], [[skill-setup-writing-style]], [[skill-skill-forge]], [[skill-systematic-debugging]], [[skill-verification-before-completion]], [[skill-wiki-page-writer]]


The read-only `doctor` command checks installed skill links, duplicate discovery names and source changes. A duplicate means two available instruction packages use the same name. A source change means the current Claude files differ from the recorded baseline. The explicit `prefer_bundled` setting selects Codex’s bundled skill-creator and preserves the shadowing Codex-side copy in a rollback backup, only after checking that the bundled replacement exists. The audit and remaining backup/document integration proposals are recorded in `codex-skills:docs/WORKFLOW-AUDIT.md`.
