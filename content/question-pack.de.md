---
id: question-pack
lang: de
source_hash: ef34fd9016cc
title: Fragenpaket (ContentPack)
---

## What it is
Das Fragenpaket (Codename `ContentPack`) ist der Fragenpool von [[quizapp]] als ein versioniertes Paket: sieben Dateien (`vocab/*.json` und `i18n/*.json`), beschrieben durch ein Manifest, `content.json` (Entscheidung ADR-0012, 2026-10-22; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Da es ein Paket ist, lässt es sich ersetzen, ohne eine neue App zu veröffentlichen.

## What it does
Das Manifest nennt das Dateiformat (`schema`, derzeit 1, gleich `CONTENT_SCHEMA`), die Poolversion (`contentVersion`, die bei jeder Dateiänderung steigt (QP-4; das committete Paket hat Version 4)) und den SHA-256 jeder Datei (SHA-256, Secure Hash Algorithm 256, ein Fingerabdruck des Dateiinhalts). Die Funktion `validateContentPack` akzeptiert ein Paket nur, wenn jede Datei aufgeführt ist, zu ihrem Fingerabdruck passt und sich parsen lässt und jeder Modus noch mindestens eine Frage hat. `shouldDownloadContent` entscheidet, ob sich das Herunterladen eines im Feed gefundenen Pakets lohnt.

## How it does it
Es ist reines Kotlin in [[quizapp-core]], getestet durch `ContentPackTest` und fünf Mutanten im [[mutation-check]] (Anforderungen QP-1 bis QP-4): vier in `ContentPack.kt` (ein Paket gleicher Version wird erneut geladen, ein veraltetes Paket wird dem eingebauten vorgezogen, Prüfsummen werden nicht verglichen, ein Paket, das einen Modus leert, wird akzeptiert) und eines in `ContentStore.kt` der App (ein veraltetes oder unlesbares heruntergeladenes Paket bleibt auf dem Datenträger). Alle fünf stehen in `tools/mutation_check.py`; der am 2026-11-02 geänderte Web-Zwilling-Fehler betrifft das Paket nicht. Das in die App eingebaute Paket ist `assets/content.json`, gepflegt von [[content-manifest]]. Ein neuer Modus oder ein neues Feld in den Dateien ist keine Pooländerung: Dafür braucht es eine App-Version und ein höheres Schema, das ältere Apps ignorieren.

## Where it sits in the pipeline
Zwischen dem Inhaltsbau ([[build-vocab]], [[content-manifest]]) und dem [[question-pool-updater]] der App.

## Who receives its output
Der [[question-pool-updater]], der es nutzt, um heruntergeladene Pakete zu prüfen und zu installieren.
