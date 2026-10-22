---
id: quizapp-adrs
lang: de
source_hash: 62f2358d7d92
title: QuizApp-ADRs
aliases: [Architekturentscheidungen]
---

## What it is
Die Architekturentscheidungen von [[quizapp]] (`docs/adr/`): eine kurze Datei pro struktureller Entscheidung, mit Kontext, Entscheidung, Alternativen und Folgen.

## What it does
0001 Entscheidungen festhalten · 0002 Kotlin + Compose · 0003 reiner deterministischer Planer · 0004 Update-Feed · 0005 Release-Kanäle · 0006 Web-Zwilling · 0007 Abstandsregeln · 0008 QS mit Anforderungen zuerst · 0009 reines Core-Modul · 0010 Fortschrittssicherung · 0011 Freigabe nach angepassten Tests · 0012 herunterladbarer Fragenbestand ([[question-pack]]).

## How it does it
MADR-Format (gekürzt), aus `docs/adr/0000-template.md`; eine strukturelle Änderung bekommt ihr ADR im selben Commit.

## Where it sits in the pipeline
Neben [[quizapp-design-doc]]; das Muster stammt aus [[project-template]].

## Who receives its output
Claude und Giovanni, wenn eine Entscheidung hinterfragt wird.
