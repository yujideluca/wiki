---
id: question-pack
lang: de
source_hash: b3d89d910ee5
title: Fragenpaket (ContentPack)
aliases: [Fragenbestand]
---

## What it is
Der Fragenbestand von [[quizapp]] als ein versioniertes Paket aus sieben Dateien (`vocab/*.json` und `i18n/*.json`), beschrieben von einem Manifest, `content.json` (ADR-0012, 22.10.2026).

## What it does
Das Manifest nennt das Dateiformat (`schema`, derzeit 1 = `CONTENT_SCHEMA`), die Version des Bestands (`contentVersion`, steigt um eins, sobald sich eine Datei ändert) und die SHA-256 jeder Datei. `validateContentPack` nimmt ein Paket nur an, wenn jede Datei gelistet ist, zu ihrer Prüfsumme passt, sich lesen lässt und jeder Modus mindestens eine Frage behält; `shouldDownloadContent` entscheidet, ob sich das Herunterladen eines Pakets aus dem Feed lohnt.

## How it does it
Reines Kotlin in [[quizapp-core]], getestet von `ContentPackTest` und fünf Mutanten in [[mutation-check]] (Anforderungen QP-1..QP-4). Das in die APK eingebaute Paket ist `assets/content.json`, gepflegt von [[content-manifest]]. Ein neuer Modus oder ein neues Feld in den Dateien ist keine Bestandsänderung: Das braucht ein App-Release und ein höheres Schema, das ältere Apps ignorieren.

## Where it sits in the pipeline
Zwischen dem Inhalts-Build ([[build-vocab]], [[content-manifest]]) und dem [[question-pool-updater]] der App.

## Who receives its output
[[question-pool-updater]], der damit heruntergeladene Pakete prüft und installiert.
