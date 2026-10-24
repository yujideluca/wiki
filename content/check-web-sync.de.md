---
id: check-web-sync
lang: de
source_hash: 1178303a41ce
title: check_web_sync.sh
---

## What it is
`check_web_sync.sh` prüft, dass die Webversion ([[quizweb]]) immer zur Nutzerversion (stabil) der Android-App passt (Entscheidung ADR-0006; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Ohne sie könnten die beiden „Zwillinge“ langsam auseinanderdriften.

## What it does
Es endet mit Code 2 und sagt, was zurückliegt, wenn: sich eine Vokabel- oder Übersetzungsdatei zwischen [[vocab-assets]] und den Ordnern `vocab/` und `i18n/` des Webs unterscheidet; sich die Menge der Modi unterscheidet (die `GameMode`-Speicher-IDs gegen `MODES` in [[quizweb-domain]]); oder der Web-Klon nicht committete oder nicht gepushte Arbeit hat.

## How it does it
Ein [Bash](https://www.gnu.org/software/bash/)-Skript, das Dateien in `~/dev/QuizApp` und `~/dev/QuizWeb` vergleicht. Die Lösung ist, die Änderung nach QuizWeb zu übertragen, `VERSION` in `sw.js` zu erhöhen (siehe [[quizweb-service-worker]]), `npm test` auszuführen, zu committen und zu pushen.

## Where it sits in the pipeline
Am Ende von `promote` in [[publish-apk]].

## Who receives its output
[[publish-apk]] und Claude (das erfährt, was zu übertragen ist).
