---
id: quizapp-adrs
lang: de
source_hash: a87bec97fb85
title: QuizApp-ADRs
---

## What it is
Ein ADR (Architecture Decision Record) ist eine kurze Notiz zu einer wichtigen Entscheidung: der Kontext, die Entscheidung, die erwogenen Alternativen und die Folgen. Das sind die ADRs von [[quizapp]] im Ordner `docs/adr/`, eine Datei pro struktureller Entscheidung.

## What it does
Sie halten fest: 0001 Entscheidungen festhalten · 0002 Kotlin + Compose · 0003 reiner deterministischer Scheduler · 0004 Update-Feed · 0005 Release-Kanäle · 0006 Web-Zwilling · 0007 Abstandsregeln · 0008 Anforderungen zuerst in der Qualitätssicherung · 0009 reines Core-Modul · 0010 Fortschrittssicherung · 0011 Befördern nach aktualisierten Tests · 0012 herunterladbarer Fragenpool ([[question-pack]]).

## How it does it
Sie nutzen das MADR-Format (Markdown Architectural Decision Records, in gekürzter Form), ausgehend von `docs/adr/0000-template.md`. Eine strukturelle Änderung bekommt ihr ADR im selben Commit wie die Änderung, sodass der Grund nie vom Code getrennt wird.

## Where it sits in the pipeline
Neben dem [[quizapp-design-doc]]; das Muster stammt aus [[project-template]].

## Who receives its output
Claude und Giovanni, wann immer eine Entscheidung in Frage gestellt wird.
