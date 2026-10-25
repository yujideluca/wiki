---
id: workflow-memory
lang: de
source_hash: 055ea82e3582
title: workflow-memory (gemeinsames Gedächtnis)
---

## What it is
workflow-memory ist das gemeinsame, langlebige Gedächtnis aller Claude-Assistenten, die Giovanni nutzt. Ein Claude-Chat vergisst normalerweise alles, wenn er endet; dieses Projekt sorgt dafür, dass eine einmal geäußerte Vorliebe („antworte in der Sprache, in der ich geschrieben habe“) auch Monate später in einem anderen Chat auf einem anderen Gerät noch gilt. Es ist ein öffentliches Repository (`yujideluca/workflow-memory`, seit 2026-10-25) und liegt in `~/dev/workflow-memory`. Es ersetzte das stillgelegte Protokoll aus [[retired-workflow-pipeline]].

## What it does
Es bewahrt Vorlieben, Fakten, Entscheidungen und offene Punkte (noch zu erledigende Dinge) auf und zeigt die relevanten zu Beginn jedes Chats als [[session-brief]]. Es ist der einzige Kanal zwischen den verschiedenen Claude-Instanzen ([[claude-code]], dem [[remote-assistant]] und der [[claude-app]]); das ist Entscheidung ADR-0003 in [[memory-adrs]] (ein ADR, „Architecture Decision Record“, ist eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält).

## How it does it
Das Gedächtnis ist ein Protokoll: Jeder Eintrag ist eine neue Datei, die danach nie bearbeitet wird, abgelegt in [[events-log]]. Eine Funktion, [[memory-fold]], liest das gesamte Protokoll und berechnet den aktuellen Stand (bei jedem Thema gewinnt die jüngste Entscheidung). Eine GitHub Action ([[mem-action]], ein automatischer Auftrag auf GitHub) erzeugt die lesbaren Dateien in [[memory-views]] neu. Claude Code schreibt mit dem Befehl [[mem]] und drei Hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); die Claude-App schreibt über [[mem-github-connector]]. Alles ist in schlichtem Python geschrieben (nur dessen Standardbibliothek), und [[mem-validator]] hält Geheimnisse und Kontaktdaten anderer Personen fern.

## Where it sits in the pipeline
Unter jedem anderen Projekt: Sie lesen ihre Standardwerte daraus und melden mit `mem use` zurück.

## Who receives its output
Jede Claude-Instanz über den Brief; [[giovanni]] über die Prüfdatei in [[memory-views]].
