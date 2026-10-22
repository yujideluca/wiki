---
id: skill-verification-before-completion
lang: de
source_hash: fe762a95f051
title: Skill: verification-before-completion
---

## What it is
Die Regel, dass Belege vor jeder Behauptung kommen, eine Arbeit sei fertig, behoben oder bestanden.

## What it does
Bevor „fertig“ gesagt oder committet wird: die Prüfbefehle ausführen und ihre Ausgabe lesen. Liefert die Zeile „Verified by:“ am Ende jedes Berichts an Giovanni, die auch nennt, was nicht geprüft werden konnte.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/verification-before-completion`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Teil des Entwicklungsprozesses in Claude Code, in jedem Projekt genutzt.

## Who receives its output
Giovanni (der Bericht) und der Commit.
