---
id: codex-skillsctl
title: Codex skills manager
aliases: []
kind: program
project: codex-skills
status: active
location: codex-skills:tools/skillsctl.py
fed_by: []
feeds: []
sources: [codex-skills:tools/skillsctl.py, codex-skills:manifest.json, codex-skills:DESIGN.md]
reviewed: 2026-10-27T01:45Z
---

## What it is
A Python command for checking, installing and restoring the skill files in [[codex-skills]]. It manages files and links; it does not execute the skills.

## Architecture
### Context
person g: Giovanni — runs the checks and installs | [[giovanni]]
system s: skillsctl — checks, installs and restores skill files
external r: codex-skills repository — the adapted skills | [[codex-skills]]
external c: Claude skills — the originals, read only | [[skills]]
external x: Codex — discovers the installed links | [[codex]]

g -runs-> s
s -manages the skills in-> r
s -compares with-> c
s -installs links for-> x

### Containers
person g: Giovanni | [[giovanni]]
container cm: Commands — check, report drift, install, roll back
store sr: Source baselines — exact copies of the Claude skills
store mf: Manifest — fingerprints of the files
store sk: Adapted skills — the 26 that Codex owns
store bk: Backups — made before each install
external lv: Skill links Codex can discover | [[codex]]

g -runs-> cm
cm -compares with-> sr
cm -records fingerprints in-> mf
cm -validates-> sk
cm -saves-> bk
cm -installs links in-> lv

## What it does
Keeps 26 adaptations, complete source baselines and content fingerprints. A fingerprint is a calculated value that detects changed files. Reports source changes without overwriting adaptations. Vendor document skills remain under their existing owners.

## How it does it
Repository: `yujideluca/codex-skills`; folder: `~/dev/codex-skills`. Python manages validation and reversible installation through [[codex-skillsctl]]. The quality gate, a command that decides whether a change passes, is `tools/quality_gate.sh`; GitHub runs it on every push. Start with README.md and AGENTS.md.

## Where it sits in the pipeline
Claude source folders feed manual review, then Codex skill folders feed the installer. [[skills]] lists the adapted instructions.

## Who receives its output
Codex reads the installed skills. The user receives task results and reports of missing capabilities.

## Notes

The full command and rollback instructions are in README.md. Installation receipts stay outside version control. Missing browser, Google or scheduling capabilities remain explicit limitations.

[[skill-adb-android-control]], [[skill-alemao-goethe-fsp]], [[skill-analise-artigo-cientifico]], [[skill-bias-risk-triage]], [[skill-brainstorming]], [[skill-browser-automacao-segura]], [[skill-candidatura-alemanha]], [[skill-click-protocol]], [[skill-consulta-clinica]], [[skill-deutsch-gespraech-memory]], [[skill-gerar-teste-automatizado]], [[skill-google-workspace]], [[skill-gui-code-protocol]], [[skill-import-memory]], [[skill-ligamagic-listas]], [[skill-ligamagic-replicar-carrinho-nas-lojas]], [[skill-minimize-site-approvals]], [[skill-morning]], [[skill-regras-magic]], [[skill-reparo-kubuntu]], [[skill-revisao-manutencao]], [[skill-setup-writing-style]], [[skill-skill-forge]], [[skill-systematic-debugging]], [[skill-verification-before-completion]], [[skill-wiki-page-writer]]


The read-only `doctor` command checks installed skill links, duplicate discovery names and source changes. A duplicate means two available instruction packages use the same name. A source change means the current Claude files differ from the recorded baseline. The explicit `prefer_bundled` setting selects Codex’s bundled skill-creator and preserves the shadowing Codex-side copy in a rollback backup, only after checking that the bundled replacement exists. The audit and remaining backup/document integration proposals are recorded in `codex-skills:docs/WORKFLOW-AUDIT.md`.
