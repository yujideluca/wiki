---
id: memory-views
lang: de
source_hash: fa3c669cc5eb
title: views/ (BRIEF, PREFERENCES, REVIEW)
---

## What it is
Der Ordner `views/` enthält die lesbaren Zusammenfassungen von [[workflow-memory]]. Sie werden erzeugt, nie von Hand geschrieben: `BRIEF.md` (was Chats in der [[claude-app]] lesen), `rules/TAG.md` (eine Datei je Art von Aufgabe, mit dem vollen Wortlaut ihrer Regeln), `PREFERENCES.md` (alle geltenden Vorlieben) und `REVIEW.md` (die einzige Liste, die Giovannis Aufmerksamkeit braucht). Sie sind für Leser da, die den Befehl [[mem]] nicht ausführen können.

## What it does
BRIEF enthält die Regeln, die immer gelten, einen Index der Aufgabenarten (Tags), die offenen Punkte und am Ende Anweisungen, wie ein Chat eine Korrektur festhält. Ein Chat, der eine Aufgabe einer Art beginnen will, holt `rules/TAG.md` für diesen Tag, so wie der Befehl [[mem-rules]] Claude Code bedient. REVIEW listet alles, was eine menschliche Entscheidung braucht: Konflikte zwischen Schreibern, als falsch markierte Einträge, unter Quarantäne gestellte Dateien, Vorschläge des automatischen Harvesters und Warnungen (zum Beispiel eine Regel ohne Tag).

## How it does it
Die Dateien werden von `mem build` und von [[mem-action]] bei jedem Push und einmal täglich neu erzeugt. Die Continuous Integration (CI, automatische Prüfungen bei jedem Push) schlägt fehl, wenn jemand eine Ansicht von Hand geändert hat; das erkennt `build --check`, das neu erzeugt und vergleicht.

## Where it sits in the pipeline
Die Ausgabeseite des Gedächtnisses.

## Who receives its output
Die [[claude-app]] (BRIEF, über den GitHub-Connector) und [[giovanni]] (REVIEW).
