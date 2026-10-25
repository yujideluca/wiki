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
reviewed: 2026-10-25T20:41Z
---

## What it is
A Python command for checking, installing and restoring the skill files in [[codex-skills]]. It manages files and links; it does not execute the skills.

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
