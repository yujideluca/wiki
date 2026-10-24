---
id: memory-views
lang: de
source_hash: c96f2378e789
title: views/ (BRIEF, PREFERENCES, REVIEW)
---

## What it is
Der Ordner `views/` enthält die lesbaren Zusammenfassungen von [[workflow-memory]]. Sie werden erzeugt und nie von Hand geschrieben: `BRIEF.md` (was Chats in der [[claude-app]] lesen), `PREFERENCES.md` (alle dauerhaften Vorlieben) und `REVIEW.md` (die einzige Liste, die Giovannis Aufmerksamkeit braucht). Sie sind für Leser da, die den Befehl [[mem]] nicht ausführen können.

## What it does
BRIEF enthält die gerankten Einträge, die offenen Punkte und am Ende eine Anleitung, wie ein Chat eine Korrektur festhält. REVIEW listet alles, was eine menschliche Entscheidung braucht: Konflikte zwischen Schreibern, als falsch markierte Einträge, Dateien in Quarantäne, Vorschläge des automatischen Harvesters und Warnungen.

## How it does it
Die Dateien werden von `mem build` und von [[mem-action]] bei jedem Push und einmal täglich neu erzeugt. Die Continuous Integration (CI, automatische Prüfungen bei jedem Push) schlägt fehl, wenn jemand eine Ansicht von Hand geändert hat; das erkennt `build --check`, das neu erzeugt und vergleicht.

## Where it sits in the pipeline
Die Ausgabeseite des Gedächtnisses.

## Who receives its output
Die [[claude-app]] (BRIEF, über den GitHub-Connector) und [[giovanni]] (REVIEW).
