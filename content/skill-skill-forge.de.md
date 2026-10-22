---
id: skill-skill-forge
lang: de
source_hash: c1492845672e
title: Skill: skill-forge
---

## What it is
Die vollständige Pipeline, um einen Skill für Giovanni zu erstellen oder neu zu bauen.

## What it does
Anforderungsanalyse, drei konkurrierende Versionen, Tests, Verträglichkeitsprüfung mit den anderen Skills, dann Validierung und Verpackung über skill-creator. Kleine Änderungen an einem Skill nehmen nur skill-creator.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/skill-forge`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Wie jeder neue oder neu gebaute Skill entsteht.

## Who receives its output
Der Ordner [[skills]] (und die Kopien der Claude-App, [[claude-ai-skills]]).
