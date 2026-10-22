---
id: publish-content
lang: de
source_hash: 78163a96bc6d
title: publish_content.sh
aliases: [Fragen veröffentlichen]
---

## What it is
Veröffentlicht einen neuen Fragenbestand ohne neue APK (ADR-0012).

## What it does
`publish_content.sh beta` prüft den committeten Bestand und legt ihn in den Ordner `content/` von [[release-feed]] auf `bleeding-edge`, wo die Beta-App ihn findet. `publish_content.sh promote` (Giovannis Entscheidung, wie bei einer APK) kopiert genau dieses Paket nach `main` für die stabile App und legt dieselben Dateien in die Webversion ([[quizweb]]).

## How it does it
Bash; der Web-Schritt arbeitet in einem temporären Worktree von `origin/main` des Web-Repos, sodass eine auf einem Branch `web-<version>` wartende Portierung nicht gestört wird. `beta` führt zuerst die Core-Tests aus (dieselben Prüfungen, die die App bei einem Download macht) und lehnt eine Bestandsversion ab, die schon auf `bleeding-edge` liegt; `promote` lehnt ab, wenn `bleeding-edge` keinen neueren Bestand als `main` hat. Mit `FEED_DIR` (und `WEB_DIR`) schreibt es stattdessen in einen Sandbox-Klon; zusammen mit einem Debug-Build, der einen lokalen Feed liest (`-PfeedUrl`), lässt sich ein Bestand auf dem Handy testen, ohne ihn zu veröffentlichen.

## Where it sits in the pipeline
Der reine Inhaltsweg von [[quizapp-release]]: TSV bearbeiten → [[build-vocab]] → committen → dieses Skript.

## Who receives its output
[[release-feed]] (beide Branches) und [[quizweb-content]].
