---
id: release-feed
lang: de
source_hash: a13c9c788bc7
title: german-quiz-releases (Update-Feed)
aliases: [Release-Repo]
---

## What it is
Das öffentliche GitHub-Repo `yujideluca/german-quiz-releases` (lokaler Klon `~/dev/german-quiz-releases`), das nur die neueste APK und ihr Manifest `latest.json` enthält (versionCode, versionName, sha256, Commit).

## What it does
Ist der Auto-Update-Feed, den die App liest. Zwei Branches: `main` = stabil (was Nutzer bekommen) und `bleeding-edge` = Beta ([[release-channels]]).

## How it does it
Nur [[publish-apk]] schreibt hinein: baut, schreibt versionCode und SHA-256 und pusht.

## Where it sits in the pipeline
Zwischen [[publish-apk]] auf dem Laptop und [[update-client]] auf dem Handy.

## Who receives its output
[[update-client]] in jeder installierten Kopie.
