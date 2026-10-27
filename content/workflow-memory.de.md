---
id: workflow-memory
lang: de
source_hash: 1bbd85413101
title: workflow-memory (gemeinsames Gedächtnis)
---

## What it is
workflow-memory ist das gemeinsame, langlebige Gedächtnis aller Claude-Assistenten, die Giovanni nutzt. Ein Claude-Chat vergisst normalerweise alles, wenn er endet; dieses Projekt sorgt dafür, dass eine einmal geäußerte Vorliebe („antworte in der Sprache, in der ich geschrieben habe“) auch Monate später in einem anderen Chat auf einem anderen Gerät noch gilt. Es ist ein öffentliches Repository (`yujideluca/workflow-memory`, seit 2026-10-25) und liegt in `~/dev/workflow-memory`. Es hat absichtlich keinen Branch-Schutz: Sein Auftrag `mem` pusht abgeleitete Dateien nach `main`, und eine verlangte Prüfung würde sie ablehnen; deshalb übernimmt die lokale Prüfung vor dem Push, und die `pipeline-check.toml` hält die Ausnahme fest ([[maintenance-pipeline]]). Es ersetzte das stillgelegte Protokoll aus [[retired-workflow-pipeline]].

## Flow
trigger t1: Giovanni nennt eine Korrektur oder eine dauerhafte Vorliebe | [[giovanni]]
step s1: Claude Code schreibt es mit mem; die Claude-App über den Connector | [[mem]], [[mem-github-connector]]
step s2: Eine neue Datei kommt ins Protokoll und wird nie mehr bearbeitet | [[events-log]]
step s3: Eine GitHub-Aktion prüft die Datei und baut die lesbaren Ansichten neu | [[mem-action]], [[memory-views]]
step s4: memory-fold liest das Protokoll und ermittelt den aktuellen Stand, die jüngste Entscheidung gewinnt | [[memory-fold]]
trigger t2: Ein neuer Chat beginnt | [[claude-code]]
step s5: Der Start-Hook gibt die Zusammenfassung aus | [[hook-session-start]], [[session-brief]]
product p1: Jede Claude-Instanz befolgt die Vorliebe in späteren Chats
product p2: Eine Prüfdatei, die auf Giovanni wartet | [[memory-views]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s3 -> p2
s4 -> s5
t2 -> s5
s5 -> p1

## What it does
Es bewahrt Vorlieben, Fakten, Entscheidungen und offene Punkte (noch zu erledigende Dinge) auf und zeigt die relevanten zu Beginn jedes Chats als [[session-brief]]. Es ist der einzige Kanal zwischen den verschiedenen Claude-Instanzen ([[claude-code]], dem [[remote-assistant]] und der [[claude-app]]); das ist Entscheidung ADR-0003 in [[memory-adrs]] (ein ADR, „Architecture Decision Record“, ist eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält).

## How it does it
Das Gedächtnis ist ein Protokoll: Jeder Eintrag ist eine neue Datei, die danach nie bearbeitet wird, abgelegt in [[events-log]]. Eine Funktion, [[memory-fold]], liest das gesamte Protokoll und berechnet den aktuellen Stand (bei jedem Thema gewinnt die jüngste Entscheidung). Eine GitHub Action ([[mem-action]], ein automatischer Auftrag auf GitHub) erzeugt die lesbaren Dateien in [[memory-views]] neu. Claude Code schreibt mit dem Befehl [[mem]] und drei Hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); die Claude-App schreibt über [[mem-github-connector]]. Alles ist in schlichtem Python geschrieben (nur dessen Standardbibliothek), und [[mem-validator]] hält Geheimnisse und Kontaktdaten anderer Personen fern.

## Where it sits in the pipeline
Unter jedem anderen Projekt: Sie lesen ihre Standardwerte daraus und melden mit `mem use` zurück.

## Who receives its output
Jede Claude-Instanz über den Brief; [[giovanni]] über die Prüfdatei in [[memory-views]].
