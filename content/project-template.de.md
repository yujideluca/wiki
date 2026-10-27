---
id: project-template
lang: de
source_hash: 7bc0abd9aeaa
title: project-template (Golden Path)
---

## What it is
project-template ist der Ausgangspunkt für jedes neue Softwareprojekt von Giovanni. Es ist ein fertiger Ordner (`~/dev/project-template`, Repository `yujideluca/project-template`), der die guten Arbeitsgewohnheiten schon enthält, sodass der richtige Weg auch der schnellste ist. Er wurde im Wartungs- und Evolutions-Review vom 2026-10-22 gewählt, und [[quizapp]] war das Referenzprojekt, aus dem er herausgezogen wurde.

## Flow
trigger t1: Ein neues Projekt beginnt | [[new-project]]
step s1: Der Vorlagenordner wird in einen neuen Projektordner kopiert
step s2: Es bringt erzwungene Prinzipien, Entwurf, markierte Tests, Gate und Schuldenregeln mit | [[template-quality-gate]], [[maintenance-policy]]
step s3: Claude füllt CLAUDE.md, Entwurfsdatei, erste Anforderungen und Gate-Schritte aus
step s4: Das private Repository und seine Labels werden angelegt
step s5: Das Projekt hält eine pipeline-check-Version fest; das Programm selbst wird nicht kopiert | [[pipeline-check]]
trigger t2: Ein laufendes Projekt findet eine bessere Praxis | [[monthly-architecture-review]]
step s6: Die Verbesserung wird in die Vorlage übernommen
product p1: Ein neues Projekt, das mit den guten Gewohnheiten beginnt | [[wiki]]
product p2: Eine bessere Vorlage für das nächste Projekt

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> p1
t2 -> s6
s6 -> p2

## What it does
Ein neues Projekt bekommt vom ersten Tag an: Prinzipien, die jeweils durch eine Prüfung durchgesetzt werden; eine Entwurfsdatei mit Diagrammen (im Stil des [C4-Modells](https://c4model.com/), gezeichnet mit [Mermaid](https://mermaid.js.org/)) und ein Entscheidungsprotokoll; ADRs (Architecture Decision Records, kurze Notizen, die die Gründe von Entscheidungen festhalten); eine Anforderungsliste mit zugeordneten getaggten Tests ([[check-traceability]]); ein Quality Gate (ein Skript, das „bestanden“ definiert, [[template-quality-gate]]); CI (Continuous Integration: automatische Prüfungen bei jedem Push) sowie die Richtlinie für technische Schulden und Reviews ([[maintenance-policy]]).

## How it does it
Der Ordner wird mit `cp -r` in einen neuen Projektordner kopiert. In der ersten Sitzung füllt Claude die CLAUDE.md des Projekts (seine Anweisungsdatei), Abschnitt 1 der Entwurfsdatei, die ersten Anforderungen, die Schritte des Gates und ADR-0002 für die gewählte Technik aus und legt dann das private GitHub-Repository mit seinen Labels an ([[new-project]]). Davor wählt Giovanni die Programmiersprache ([[work-ask-language]]). Das Wartungsprogramm [[pipeline-check]] wird nicht ins Projekt kopiert: Der Ordner enthält die Datei `pipeline-check.version` (am 2026-10-24 `v0.4.0`), das Startskript `tools/pipeline-check.sh`, das diese Version von `yujideluca/pipeline-check` einmal holt und baut (dafür braucht der Rechner Rust, `cargo` und git), die Grenzen in `pipeline-check.toml` und eine lokale Prüfung vor dem Push in `tools/hooks/pre-push`, die mit `git config core.hooksPath tools/hooks` eingeschaltet wird.

## Where it sits in the pipeline
Vor jedem neuen Projekt. Dieses [[wiki]] war das erste Projekt, das daraus gestartet wurde.

## Who receives its output
Neue Projekte wie das [[wiki]]; Verbesserungen aus laufenden Projekten fließen beim [[monthly-architecture-review]] in die Vorlage zurück.
