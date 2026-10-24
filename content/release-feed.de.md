---
id: release-feed
lang: de
source_hash: 1e0d55392911
title: german-quiz-releases (Update-Feed)
---

## What it is
Der „Update-Feed“ ist das öffentliche GitHub-Repository `yujideluca/german-quiz-releases` (lokaler Klon `~/dev/german-quiz-releases`). Er enthält nur die neueste APK (Android Package, die installierbare App-Datei) und ihre Beschreibungsdatei `latest.json` (versionCode, versionName, sha256-Fingerabdruck, Commit). Seit 2026-10-22 hat er außerdem einen Ordner `content/` mit dem neuesten [[question-pack]].

## What it does
Er ist das, was die Apps bei der Update-Prüfung lesen. Es gibt zwei Zweige: `main` ist der stabile Kanal (was die Nutzer bekommen) und `bleeding-edge` der Beta-Kanal ([[release-channels]]).

## How it does it
Er wird nur von [[publish-apk]] (die APK) und [[publish-content]] (das Fragenpaket) beschrieben, sodass nichts anderes ändern kann, was die Apps herunterladen.

## Where it sits in the pipeline
Zwischen [[publish-apk]] auf dem Laptop und dem [[update-client]] auf dem Handy.

## Who receives its output
Der [[update-client]] in jeder installierten Kopie und der [[question-pool-updater]].
