---
id: publish-content
lang: de
source_hash: 55f080e0d7e3
title: publish_content.sh
aliases: [Fragen veröffentlichen]
---

## What it is
Veröffentlicht einen neuen Fragenbestand ohne neue APK (ADR-0012).

## What it does
`publish_content.sh beta` prüft den committeten Bestand und legt ihn in den Ordner `content/` von [[release-feed]] auf `bleeding-edge`, wo die Beta-App ihn findet. `publish_content.sh promote` (Giovannis Entscheidung, wie bei einer APK) kopiert genau dieses Paket nach `main` für die stabile App und legt dieselben Dateien in die Webversion ([[quizweb]]).

## How it does it
Bash; der Web-Schritt arbeitet in einem temporären Worktree von `origin/main` des Web-Repos, sodass eine auf einem Branch `web-<version>` wartende Portierung nicht gestört wird.

## Where it sits in the pipeline
Der reine Inhaltsweg von [[quizapp-release]]: TSV bearbeiten → [[build-vocab]] → committen → dieses Skript.

## Who receives its output
[[release-feed]] (beide Branches) und [[quizweb-content]].
