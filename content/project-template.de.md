---
id: project-template
lang: de
source_hash: 0fd304447a02
title: project-template (Golden Path)
---

## What it is
project-template ist der Ausgangspunkt für jedes neue Softwareprojekt von Giovanni. Es ist ein fertiger Ordner (`~/dev/project-template`, Repository `yujideluca/project-template`), der die guten Arbeitsgewohnheiten schon enthält, sodass der richtige Weg auch der schnellste ist. Er wurde im Wartungs- und Evolutions-Review vom 2026-10-22 gewählt, und [[quizapp]] war das Referenzprojekt, aus dem er herausgezogen wurde.

## What it does
Ein neues Projekt bekommt vom ersten Tag an: Prinzipien, die jeweils durch eine Prüfung durchgesetzt werden; eine Entwurfsdatei mit Diagrammen (im Stil des [C4-Modells](https://c4model.com/), gezeichnet mit [Mermaid](https://mermaid.js.org/)) und ein Entscheidungsprotokoll; ADRs (Architecture Decision Records, kurze Notizen, die die Gründe von Entscheidungen festhalten); eine Anforderungsliste mit zugeordneten getaggten Tests ([[check-traceability]]); ein Quality Gate (ein Skript, das „bestanden“ definiert, [[template-quality-gate]]); CI (Continuous Integration: automatische Prüfungen bei jedem Push) sowie die Richtlinie für technische Schulden und Reviews ([[maintenance-policy]]).

## How it does it
Der Ordner wird mit `cp -r` in einen neuen Projektordner kopiert. In der ersten Sitzung füllt Claude die CLAUDE.md des Projekts (seine Anweisungsdatei), Abschnitt 1 der Entwurfsdatei, die ersten Anforderungen, die Schritte des Gates und ADR-0002 für die gewählte Technik aus und legt dann das private GitHub-Repository mit seinen Labels an ([[new-project]]). Davor wählt Giovanni die Programmiersprache ([[work-ask-language]]). Das Wartungsprogramm [[pipeline-check]] wird nicht ins Projekt kopiert: Der Ordner enthält die Datei `pipeline-check.version` (am 2026-10-24 `v0.4.0`), das Startskript `tools/pipeline-check.sh`, das diese Version von `yujideluca/pipeline-check` einmal holt und baut (dafür braucht der Rechner Rust, `cargo` und git), die Grenzen in `pipeline-check.toml` und eine lokale Prüfung vor dem Push in `tools/hooks/pre-push`, die mit `git config core.hooksPath tools/hooks` eingeschaltet wird.

## Where it sits in the pipeline
Vor jedem neuen Projekt. Dieses [[wiki]] war das erste Projekt, das daraus gestartet wurde.

## Who receives its output
Neue Projekte wie das [[wiki]]; Verbesserungen aus laufenden Projekten fließen beim [[monthly-architecture-review]] in die Vorlage zurück.
