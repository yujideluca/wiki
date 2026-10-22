---
id: skill-brainstorming
lang: de
source_hash: b7a8b25f9c96
title: Skill: brainstorming
---

## What it is
Der Prozess-Skill vor jedem Neubau: herausfinden, was Giovanni wirklich will und warum, bevor Code existiert.

## What it does
Stellt jeweils eine offene Frage, spiegelt das Verständnis zurück, bietet einen visuellen Begleiter an (ein Browser-Tab mit Entwürfen), wenn Sehen hilft, bestimmt die Größe (schnelle Aufgabe, kleine Änderung, Projekt mit schriftlichem Entwurf), lässt einen frischen Prüfer den Entwurf lesen und sperrt das Bauen bis zu Giovannis Freigabe. Seit 22.10.2026 fragt er auch nach der Programmiersprache ([[work-ask-language]]).

## How it does it
Eine `SKILL.md` in `~/.claude/skills/brainstorming`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt. Adaptiert aus obra/superpowers 7.0.0 (MIT).

## Where it sits in the pipeline
Teil des Entwicklungsprozesses in Claude Code, in jedem Projekt genutzt.

## Who receives its output
Giovanni (Fragen und Entwurfsdokument) und der folgende Bau.
