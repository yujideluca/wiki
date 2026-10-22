---
id: content-manifest
lang: de
source_hash: 04934e577615
title: content_manifest.py
---

## What it is
Das Skript, das das Manifest des Fragenbestands, `app/src/main/assets/content.json`, mit den Bestandsdateien im Gleichschritt hält.

## What it does
Schreibt die SHA-256 jeder Bestandsdatei und erhöht `contentVersion` nur um eins, wenn sich eine Datei geändert hat. `--check` endet mit 1, wenn das Manifest nicht zu den Dateien passt.

## How it does it
Python-Standardbibliothek; `SCHEMA = 1` muss `CONTENT_SCHEMA` in [[question-pack]] entsprechen (beide zusammen erhöhen, wenn sich das Dateiformat ändert). Von [[build-vocab]] ausgeführt; `--check` läuft im [[quizapp-quality-gate]].

## Where it sits in the pipeline
Direkt nach [[build-vocab]] in der Inhaltspipeline.

## Who receives its output
[[question-pack]] (das eingebaute Manifest) und [[quizapp-quality-gate]].
