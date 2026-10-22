---
id: skills
title: Skills
aliases: [Claude skills]
kind: project
project: none
status: active
location: home:.claude/skills
fed_by: []
feeds: []
sources: [home:.claude/skills]
---

## What it is
Giovanni's Claude skills: packaged instructions that Claude loads when a task of their kind comes up. The local copies for Claude Code live in `~/.claude/skills`; the Claude app has its own copies ([[claude-ai-skills]]).

## What it does
Encode how Giovanni wants recurring tasks done: German training, clinical answers, article appraisal, applications to Germany, Magic: The Gathering, browser safety, laptop repair, and the development process (brainstorming, debugging, verification, building skills).

## How it does it
Each skill is a folder with a `SKILL.md` (a name, a description that decides when it triggers, then the instructions). New or rebuilt skills go through [[skill-skill-forge]]. The folder was once filled by the retired pipeline ([[retired-workflow-pipeline]]); the skills are now real folders.

## Where it sits in the pipeline
Beside every task: a skill is loaded by the Claude instance when its description matches the request.

## Who receives its output
[[claude-code]], [[remote-assistant]] and (through their copies) [[claude-app]].

## Notes
- [[skill-brainstorming]]
- [[skill-systematic-debugging]]
- [[skill-verification-before-completion]]
- [[skill-adb-android-control]]
- [[skill-skill-forge]]
- [[skill-alemao-goethe-fsp]]
- [[skill-consulta-clinica]]
- [[skill-analise-artigo-cientifico]]
- [[skill-candidatura-alemanha]]
- [[skill-bias-risk-triage]]
- [[skill-browser-automacao-segura]]
- [[skill-click-protocol]]
- [[skill-minimize-site-approvals]]
- [[skill-ligamagic-listas]]
- [[skill-ligamagic-replicar-carrinho-nas-lojas]]
- [[skill-regras-magic]]
- [[skill-reparo-kubuntu]]
