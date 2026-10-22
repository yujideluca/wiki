---
id: memory-views
lang: de
source_hash: 7e1ec6a36a63
title: views/ (BRIEF, PREFERENCES, REVIEW)
---

## What it is
Die erzeugten, schreibgeschützten Dateien von [[workflow-memory]]: `BRIEF.md` (was Chats der Claude-App lesen), `PREFERENCES.md`, `REVIEW.md` (die einzige Liste, die Giovanni braucht).

## What it does
BRIEF enthält die gerankten Einträge, offene Punkte und am Ende, wie ein Chat eine Korrektur festhält. REVIEW listet Konflikte, als falsch markierte Einträge, Dateien in Quarantäne, Vorschläge des Sammlers und Warnungen.

## How it does it
Nie von Hand bearbeitet: neu gebaut von `mem build` und von [[mem-action]] bei jedem Push und täglich; die CI schlägt fehl, wenn eine Ansicht bearbeitet wurde (`build --check`).

## Where it sits in the pipeline
Die Ausgabeseite des Gedächtnisses, für Leser, die `mem` nicht ausführen können.

## Who receives its output
[[claude-app]] (BRIEF über den GitHub-Connector) und [[giovanni]] (REVIEW).
