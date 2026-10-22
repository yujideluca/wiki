---
id: check-web-sync
lang: de
source_hash: 33975fd54a76
title: check_web_sync.sh
aliases: [Web-Abgleich]
---

## What it is
Die Prüfung, dass die Webversion immer der Nutzerversion der Android-App entspricht (ADR-0006).

## What it does
Endet mit Exit 2 und nennt den Rückstand, wenn sich eine Vokabel- oder Übersetzungsdatei zwischen [[vocab-assets]] und `vocab/` bzw. `i18n/` im Web unterscheidet, die Menge der Modi abweicht (Speicher-IDs von `GameMode` gegen `MODES` in [[quizweb-domain]]) oder der Web-Klon nicht committete oder nicht gepushte Arbeit hat.

## How it does it
Bash vergleicht Dateien in `~/dev/QuizApp` und `~/dev/QuizWeb`. Die Lösung: Änderung nach QuizWeb portieren, `VERSION` in `sw.js` erhöhen, `npm test`, committen und pushen.

## Where it sits in the pipeline
Am Ende von `promote` in [[publish-apk]].

## Who receives its output
[[publish-apk]] und Claude (was zu portieren ist).
