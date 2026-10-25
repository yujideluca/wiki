---
id: publish-apk
lang: de
source_hash: 414254b7f0d5
title: publish_apk.sh
---

## What it is
`publish_apk.sh` ist das Release-Skript von [[quizapp]]. Es baut eine signierte Release-APK (Android Package, die installierbare App-Datei) und veröffentlicht sie im [[release-feed]].

## What it does
Es führt zuerst das [[quizapp-quality-gate]] aus. Dann veröffentlicht es eine Beta auf dem Zweig `bleeding-edge`. Der Befehl `publish_apk.sh promote` baut die stabile App und veröffentlicht sie auf dem stabilen Zweig `main`, aber nur, wenn `bleeding-edge` genau diesen Commit enthält (damit ausgeliefert wird, was getestet wurde), nachdem das Gate mit Mutationsprüfung und [[check-tests-updated]] bestanden wurden (Entscheidung ADR-0011; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Befördern ist Giovannis Entscheidung, ohne Mindestzeit in der Beta.

## How it does it
Ein Gradle-Release-Build, signiert mit dem [[signing-key]]. Es schreibt versionCode und SHA-256-Fingerabdruck (Secure Hash Algorithm 256) in `latest.json` und pusht das Feed-Repository.

## Where it sits in the pipeline
Der letzte Schritt des [[quizapp-release]].

## Who receives its output
Der [[release-feed]].
