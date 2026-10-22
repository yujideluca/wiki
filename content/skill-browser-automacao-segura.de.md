---
id: skill-browser-automacao-segura
lang: de
source_hash: 06b05fc87539
title: Skill: browser-automacao-segura (safe browser automation)
---

## What it is
Die Sicherheitsregeln für jede Aktion in einem Browser (eingebauter Browser der App oder Claude in Chrome), besonders Sammelaktionen, Löschungen, Massenbearbeitungen und Skripte auf Seiten. Auf Portugiesisch geschrieben.

## What it does
Vermeidet Dialoge, die die Sitzung einfrieren, Schleifen und zerstörerische Fehler; fragt vor allem Unumkehrbaren.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/browser-automacao-segura`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Vor und während jeder Browser-Automatisierung.

## Who receives its output
Die Browsersitzung; [[skill-click-protocol]] und [[skill-minimize-site-approvals]] verweisen bei Warnungen und zerstörerischen Aktionen auf sie.
