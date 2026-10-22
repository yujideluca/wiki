---
id: publish-apk
lang: de
source_hash: eaf1591f7392
title: publish_apk.sh
---

## What it is
Das Release-Skript von [[quizapp]]: baut eine signierte Release-APK und veröffentlicht sie in [[release-feed]].

## What it does
Führt zuerst [[quizapp-quality-gate]] aus; veröffentlicht eine Beta in `bleeding-edge`; `publish_apk.sh promote` hebt eine Beta nach stabil `main`, wenn das Tor mit Mutationsprüfung und [[check-tests-updated]] besteht (ADR-0011). Die Freigabe entscheidet Giovanni, ohne Mindestzeit in Beta.

## How it does it
Gradle-Release-Build, signiert mit [[signing-key]]; schreibt versionCode und SHA-256 in `latest.json` und pusht das Feed-Repo.

## Where it sits in the pipeline
Der letzte Schritt von [[quizapp-release]].

## Who receives its output
[[release-feed]].
