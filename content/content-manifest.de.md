---
id: content-manifest
lang: de
source_hash: 0cfc9ba99ce3
title: content_manifest.py
---

## What it is
`content_manifest.py` ist das Skript, das das Manifest des Fragenpools, `app/src/main/assets/content.json`, mit den Pool-Dateien im Gleichstand hält. Ein Manifest ist eine Liste, die die Dateien eines Pakets beschreibt und wie man sie überprüft.

## What it does
Es schreibt den SHA-256 jeder Pool-Datei (SHA-256, Secure Hash Algorithm 256, erzeugt einen kurzen Fingerabdruck des Dateiinhalts; ändert sich ein Byte, ändert sich der Fingerabdruck völlig, siehe [SHA-2](https://en.wikipedia.org/wiki/SHA-2)) und erhöht `contentVersion` nur dann um eins, wenn sich wirklich eine Datei geändert hat. Die Option `--check` endet mit Code 1, wenn das Manifest nicht zu den Dateien passt.

## How it does it
[Python](https://www.python.org/) nur mit seiner Standardbibliothek. Sein `SCHEMA = 1` muss gleich `CONTENT_SCHEMA` im [[question-pack]] sein (beide werden zusammen erhöht, wenn sich das Dateiformat ändert). Es wird von [[build-vocab]] aufgerufen; der Modus `--check` läuft im [[quizapp-quality-gate]].

## Where it sits in the pipeline
Direkt nach [[build-vocab]] in der Inhaltspipeline.

## Who receives its output
Das [[question-pack]] (das in die App eingebaute Manifest) und das [[quizapp-quality-gate]].
