---
id: progress-backup
lang: de
source_hash: 772f585f0b80
title: Fortschrittssicherung
---

## What it is
Einstellungen > Sicherung in [[quizapp]] exportiert Giovannis Lernfortschritt als eine [JSON](https://en.wikipedia.org/wiki/JSON)-Datei (JavaScript Object Notation, ein Klartext-Datenformat) und kann ihn wiederherstellen (Entscheidung ADR-0010; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Sie ist das Sicherheitsnetz gegen ein Zurücksetzen des Handys oder ein riskantes Release.

## What it does
Sie exportiert und importiert die Formatversion, den Zustand jeder Karte, den Antwortverlauf, das Tagesziel und das Thema. Ein Import ersetzt den aktuellen Fortschritt in einem einzigen Schreibvorgang, sodass er entweder ganz oder gar nicht funktioniert.

## How it does it
Der Code, der den Fortschritt in die Datei und zurück wandelt (der Codec), liegt in [[quizapp-core]]. Dateien laufen über die Dokumentenauswahl von Android (`CreateDocument` und `OpenDocument`), sodass der Nutzer Handyspeicher oder Google Drive wählt und die App keine Speicherberechtigung braucht.

## Where it sits in the pipeline
Sie liest den [[progress-store]] und den [[training-store]]; ihre Dateien landen auf dem Handy, in Google Drive oder in [[quiz-backups]].

## Who receives its output
Giovanni (die Datei) und [[quiz-backups]] auf dem Laptop.
