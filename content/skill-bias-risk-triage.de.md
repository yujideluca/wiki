---
id: skill-bias-risk-triage
lang: de
source_hash: 2fe25bf6ee86
title: Skill: bias-risk-triage
---

## What it is
Eine stille Prüfung vor der Antwort auf kurze Faktenfragen.

## What it does
Sucht nach Verzerrung, Mythen, Verschwörung, Veraltetem oder hohem Einsatz und legt fest, wie gründlich geprüft wird (Stufen T0–T3). Sie bestimmt nur die Mindestprüftiefe, nie das Format; Fach-Skills wie [[skill-consulta-clinica]] behalten ihr Format.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/bias-risk-triage`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Vor kurzen Faktenantworten, in jedem Chat.

## Who receives its output
Die folgende Antwort (ihre Tiefe).
