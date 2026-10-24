---
id: publish-content
lang: de
source_hash: ea321bd2e361
title: publish_content.sh
---

## What it is
`publish_content.sh` veröffentlicht einen neuen Fragenpool, ohne eine neue APK (Android Package, die installierbare App-Datei) zu bauen. Das ist durch Entscheidung ADR-0012 möglich (ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält).

## What it does
`publish_content.sh beta` prüft den committeten Pool und legt ihn im Ordner `content/` des [[release-feed]] auf dem Zweig `bleeding-edge` ab, wo die Beta-App ihn findet. `publish_content.sh promote` (Giovannis Entscheidung, genau wie bei einer APK) kopiert genau dieses Paket auf den Zweig `main` für die stabile App und legt dieselben Dateien auf die Webversion ([[quizweb]]).

## How it does it
[Bash](https://www.gnu.org/software/bash/). Der Webschritt arbeitet in einem temporären Worktree (eine zweite ausgecheckte Kopie) von `origin/main` des Web-Repositorys, sodass ein Web-Port, der auf einem Zweig `web-<version>` wartet, nicht gestört wird.

## Where it sits in the pipeline
Der Weg nur für Inhalte im [[quizapp-release]]: TSV-Dateien (tabulatorgetrennte Werte) bearbeiten → [[build-vocab]] → Commit → dieses Skript.

## Who receives its output
Der [[release-feed]] (beide Zweige) und [[quizweb-content]].
