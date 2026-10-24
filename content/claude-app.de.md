---
id: claude-app
lang: de
source_hash: aff0088ffa10
title: Claude-App (claude.ai)
---

## What it is
Die Claude-App ist Claude so, wie Giovanni es auf claude.ai nutzt, auf dem Handy und im Browser, einschließlich „Projekten“ (gespeicherten Chat-Räumen mit eigenen Anweisungen). Sie unterscheidet sich in einem wichtigen Punkt von [[claude-code]]: Sie kann den Laptop nicht erreichen, also dort weder Programme ausführen noch Projektdateien lesen.

## What it does
Sie dient für Gespräch, Schreiben und Lernen: Deutschübungen ([[skill-alemao-goethe-fsp]]), klinische Fragen ([[skill-consulta-clinica]]) und Bewerbungen in Deutschland ([[skill-candidatura-alemanha]]).

## How it does it
Ein kurzer Text, der einmal in die Einstellungen von claude.ai eingefügt wurde ([[claude-ai-settings-pointer]]), lässt jeden Chat über den GitHub-Connector (eine Erweiterung, mit der die App Dateien in GitHub lesen und schreiben kann) die Datei `views/BRIEF.md` aus [[workflow-memory]] lesen. Wenn Giovanni sie korrigiert, hält sie die Korrektur fest, indem sie eine neue Ereignisdatei anlegt ([[mem-github-connector]]). Ihre Skills sind die claude.ai-Kopien aus [[claude-ai-skills]].

## Where it sits in the pipeline
Außerhalb des Laptops. Ihre einzige gemeinsame Schnittstelle mit den anderen Claude-Instanzen ist [[workflow-memory]] (entschieden in ADR-0003; ein ADR ist eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält).

## Who receives its output
Das Gedächtnisprotokoll [[events-log]], über den GitHub-Connector.
