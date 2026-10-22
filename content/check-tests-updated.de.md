---
id: check-tests-updated
lang: de
source_hash: 8d4861f789e2
title: check_tests_updated.sh
---

## What it is
Die Prüfung hinter ADR-0011: Eine neue Version darf Nutzer nur erreichen, wenn sie Tests überstand, die für ihre Änderung angepasst wurden.

## What it does
Vergleicht den zu veröffentlichenden Commit mit dem letzten stabilen Release: Hat sich Code oder Inhalt geändert, aber kein Test, lehnt sie ab (Exit 1).

## How it does it
Bash über `git diff --name-only BASE HEAD`, trennt Hauptcode von Testordnern.

## Where it sits in the pipeline
Ausgeführt von `promote` in [[publish-apk]], Teil von [[quizapp-release]].

## Who receives its output
[[publish-apk]].
