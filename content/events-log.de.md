---
id: events-log
lang: de
source_hash: 85eff78ad105
title: events/ (das Gedächtnisprotokoll)
---

## What it is
Der Ordner `events/` ist das Gedächtnis selbst: eine Markdown-Datei pro Ereignis, abgelegt in `events/JJJJ/MM/` und benannt `<Zeit>-<Instanz>-<6 Zeichen>.md`. Der Dateiname ist die ID des Ereignisses, sein letztes Segment der `#code`, den man im Brief sieht. Ein „Ereignis“ (Event) hält fest, dass etwas geschehen ist, etwa „Giovanni hat diese Vorliebe geäußert“.

## What it does
Er enthält jede Vorliebe, jeden Fakt, jede Entscheidung, Aufgabe und Notiz, dazu „Steuer“-Ereignisse, die den Zustand anderer ändern (Feedback, Claim, Done, Forget, Use, Archive, Reopen, Rescope). Dateien werden nie bearbeitet oder gelöscht, sodass zwei Schreiber nie in Konflikt geraten können (Entscheidung ADR-0002 in [[memory-adrs]]; ein ADR, „Architecture Decision Record“, ist eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält).

## How it does it
Jede Datei hat einen Kopf (`type`, `scope`, `key`, `owner`, `instance`, `ts` und optional `supersedes`, `target`, `signal`, `category`), gefolgt von ein bis zwei Sätzen. Ein Auftrag der Continuous Integration (CI, automatische Prüfungen bei jedem Push) namens `append-only` weist jede Änderung an einer bestehenden Datei zurück. Ungültige Dateien verschiebt [[mem-validator]] in einen Ordner `quarantine/`.

## Where it sits in the pipeline
Geschrieben von [[mem]] auf dem Laptop und von [[mem-github-connector]] für die Claude-App; gelesen von [[memory-fold]].

## Who receives its output
[[memory-fold]] und [[mem-action]].
