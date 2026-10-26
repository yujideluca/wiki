---
id: question-pack
lang: de
source_hash: 8dc167b6ca04
title: Fragenpaket (ContentPack)
---

## What it is
Das Fragenpaket (Codename `ContentPack`) ist der Fragenpool von [[quizapp]] als ein versioniertes Paket: sieben Dateien (`vocab/*.json` und `i18n/*.json`), beschrieben durch ein Manifest, `content.json` (Entscheidung ADR-0012, 2026-10-22; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Da es ein Paket ist, lässt es sich ersetzen, ohne eine neue App zu veröffentlichen.

## What it does
Das Manifest nennt das Dateiformat (`schema`, derzeit 1, gleich `CONTENT_SCHEMA`), die Poolversion (`contentVersion`, die bei jeder Dateiänderung um eins steigt) und den SHA-256 jeder Datei (SHA-256, Secure Hash Algorithm 256, ein Fingerabdruck des Dateiinhalts). Die Funktion `validateContentPack` akzeptiert ein Paket nur, wenn jede Datei aufgeführt ist, zu ihrem Fingerabdruck passt und sich parsen lässt und jeder Modus noch mindestens eine Frage hat. `shouldDownloadContent` entscheidet, ob sich das Herunterladen eines im Feed gefundenen Pakets lohnt.

## How it does it
Es ist reines Kotlin in [[quizapp-core]], getestet durch `ContentPackTest` und vier Mutanten im [[mutation-check]] (Anforderungen QP-1 bis QP-4). Das in die App eingebaute Paket ist `assets/content.json`, gepflegt von [[content-manifest]]. Ein neuer Modus oder ein neues Feld in den Dateien ist keine Pooländerung: Dafür braucht es eine App-Version und ein höheres Schema, das ältere Apps ignorieren.

## Where it sits in the pipeline
Zwischen dem Inhaltsbau ([[build-vocab]], [[content-manifest]]) und dem [[question-pool-updater]] der App.

## Who receives its output
Der [[question-pool-updater]], der es nutzt, um heruntergeladene Pakete zu prüfen und zu installieren.
