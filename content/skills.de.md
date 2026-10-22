---
id: skills
lang: de
source_hash: 1bd4b01afaa7
title: Skills
---

## What it is
Giovannis Claude-Skills: gebündelte Anleitungen, die Claude lädt, wenn eine passende Aufgabe kommt. Die lokalen Kopien für Claude Code liegen in `~/.claude/skills`; die Claude-App hat eigene Kopien ([[claude-ai-skills]]).

## What it does
Halten fest, wie Giovanni wiederkehrende Aufgaben erledigt haben will: Deutschtraining, klinische Antworten, Artikelbewertung, Bewerbungen in Deutschland, Magic: The Gathering, Browser-Sicherheit, Laptop-Reparatur und den Entwicklungsprozess (Brainstorming, Fehlersuche, Verifikation, Skill-Bau).

## How it does it
Jeder Skill ist ein Ordner mit einer `SKILL.md` (Name, eine Beschreibung, die bestimmt, wann er greift, dann die Anleitung). Neue oder neu gebaute Skills laufen über [[skill-skill-forge]]. Früher füllte die stillgelegte Pipeline den Ordner ([[retired-workflow-pipeline]]); heute sind es echte Ordner.

## Where it sits in the pipeline
Neben jeder Aufgabe: Die Claude-Instanz lädt einen Skill, wenn seine Beschreibung zur Anfrage passt.

## Who receives its output
[[claude-code]], [[remote-assistant]] und (über ihre Kopien) [[claude-app]].

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
