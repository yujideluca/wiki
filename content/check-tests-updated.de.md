---
id: check-tests-updated
lang: de
source_hash: 7a6a1315851f
title: check_tests_updated.sh
---

## What it is
`check_tests_updated.sh` ist die Prüfung hinter Entscheidung ADR-0011 (ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Die Regel: Eine neue Version von [[quizapp]] darf Nutzer nur erreichen, wenn sie Tests überstanden hat, die für das Geänderte aktualisiert wurden. Sonst könnten alte Tests bestehen, während das neue Verhalten gar nicht getestet ist.

## What it does
Sie vergleicht den zu veröffentlichenden Commit mit dem letzten stabilen Release. Wurde Code oder Inhalt geändert, aber kein Test, verweigert sie und endet mit Code 1.

## How it does it
Ein [Bash](https://www.gnu.org/software/bash/)-Skript über `git diff --name-only BASE HEAD` (die Liste der Dateien, die sich zwischen zwei Punkten der Geschichte unterscheiden), das Hauptcode von Testordnern trennt.

## Where it sits in the pipeline
Von `promote` in [[publish-apk]] ausgeführt, als Teil des [[quizapp-release]].

## Who receives its output
[[publish-apk]].
