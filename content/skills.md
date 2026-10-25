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
reviewed: 2026-10-25T14:46Z
---

## What it is
A skill is a packaged set of instructions that Claude loads when a task of that kind comes up ([skills documentation](https://docs.claude.com/en/docs/claude-code/skills)). Think of it as a recipe book chapter that Claude reads only when the request matches: a chapter on correcting German, one on debugging, one on laptop repair. Each skill is a folder containing a file `SKILL.md`: first a name, then a "description" that decides when the skill is loaded, then the instructions. Giovanni's skills are kept in `~/.claude/skills`; the Claude app has its own copies ([[claude-ai-skills]]).

## What it does
The skills encode how Giovanni wants recurring tasks done: German training, clinical answers, appraisal of scientific articles, applications to Germany, Magic: The Gathering, safe browser automation, laptop repair, and the development process (brainstorming, debugging, verification, maintenance reviews, building tests and building skills). Each skill has a page in this wiki that contains its own definition, so you never need to open the `SKILL.md` file to understand it.

## How it does it
Claude sees the list of names and descriptions in every chat; when a request matches a description, it loads that skill's full text and follows it. New or rebuilt skills go through [[skill-skill-forge]]. The folder was once filled by the retired pipeline ([[retired-workflow-pipeline]]); the skills are now ordinary folders.

## Where it sits in the pipeline
Beside every task: a skill is loaded by the Claude instance when its description matches the request.

## Who receives its output
[[claude-code]], the [[remote-assistant]] and, through their copies, the [[claude-app]].

## Notes
- [[skill-brainstorming]]
- [[skill-systematic-debugging]]
- [[skill-verification-before-completion]]
- [[skill-adb-android-control]]
- [[skill-skill-forge]]
- [[skill-wiki-page-writer]]
- [[skill-revisao-manutencao]]
- [[skill-gerar-teste-automatizado]]
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

The 20 locally maintained skills have separate installed Claude and Codex copies, in `~/.claude/skills` and `~/.agents/skills`. Their pages now retain both complete original `SKILL.md` files in Notes, beside the translated explanations. This includes the entire frontmatter description and instructions, rather than only a trigger summary. Referenced auxiliary files are not embedded. The complete-source rule and its checks are described in [[wiki-content]] and [[wiki-skill-source]].
