---
id: release-feed
lang: de
source_hash: 11a253fb56fb
title: german-quiz-releases (Update-Feed)
aliases: [Release-Repo]
---

## What it is
Das öffentliche GitHub-Repo `yujideluca/german-quiz-releases` (lokaler Klon `~/dev/german-quiz-releases`), das nur die neueste APK und ihr Manifest `latest.json` enthält (versionCode, versionName, sha256, Commit) und seit 22.10.2026 einen Ordner `content/` mit dem neuesten [[question-pack]].

## What it does
Ist der Auto-Update-Feed, den die App liest. Zwei Branches: `main` = stabil (was Nutzer bekommen) und `bleeding-edge` = Beta ([[release-channels]]).

## How it does it
Nur [[publish-apk]] (die APK) und [[publish-content]] (das Fragenpaket) schreiben hinein.

## Where it sits in the pipeline
Zwischen [[publish-apk]] auf dem Laptop und [[update-client]] auf dem Handy.

## Who receives its output
[[update-client]] in jeder installierten Kopie.
