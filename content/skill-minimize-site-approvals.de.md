---
id: skill-minimize-site-approvals
lang: de
source_hash: 3fd4bc27e59e
title: Skill: minimize-site-approvals
---

## What it is
Ein Planungsschritt vor dem Surfen, damit Giovanni möglichst selten auf „Genehmigen“ klickt.

## What it does
Plant die Domains vorab, fragt einmal seitenweit an, bevorzugt Werkzeuge ohne Genehmigung. Sie umgeht nie Genehmigungen oder die Sicherheitsprüfung der Seite.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/minimize-site-approvals`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Vor und während jeder Browser-Automatisierung.

## Who receives its output
Die Browsersitzung und Giovanni (weniger Abfragen).
