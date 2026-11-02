---
id: checks-quizapp
lang: de
source_hash: 17e0d9e79e7c
title: QuizApp: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer und Regeln von [[quizapp]], der Android-Lern-App (Repository `german-quiz`, Ordner `QuizApp`). Sie hat das größte Gate aller Projekte und als einzige Prüfungen, die eine Veröffentlichung auf einem Handy schützen.

## What it does
Das Gate hat sieben Schritte plus einen optionalen achten, in dieser Reihenfolge: (1) Core- und App-Tests mit Abdeckung; (2) Abdeckungsschwellen, 90 % der Zeilen in den Logikpaketen und keine Datei unter 80 % (`tools/check_coverage.py`); (3) die Tests des Web-Zwillings; (4) die gemeinsamen Konformitätsvektoren `scheduler` und `daily_bar` müssen in App und Web Byte für Byte gleich sein ([[quizweb-conformance]]); (5) Anforderungs-Rückverfolgbarkeit, die auch fehlschlägt, wenn die neu erzeugte `docs/TRACEABILITY.md` nicht committet ist; (6) Android-Lint, bei dem Fehler durchfallen; (7) Fitness-Funktionen und die Prüfung des Manifests des Fragenpools ([[content-manifest]]); eine Zeitgrenze von 1200 Sekunden beendet das Gate; (8) mit `--mutation` müssen alle absichtlich gepflanzten Fehler in Scheduler, Grader, Queue, Session, Stores und Web-Zwilling entdeckt werden ([[mutation-check]]).

Limits in `pipeline-check.toml`: keine Kotlin-Datei über 400 Zeilen (in `core/src` und `app/src`), das Release-APK (Android Package) höchstens 3.000.000 Bytes, das Gate höchstens 1200 Sekunden, und kein Import von `android` oder `androidx` im Modul `core` (die Regel des reinen Cores, ADR-0009, Architecture Decision Record). Release-Regeln: Eine Version darf erst nach dem Gate mit Mutation und `tools/check_tests_updated.sh` von Beta zu Stable befördert werden (Code geändert, also muss sich auch ein Test geändert haben, ADR-0011), und `tools/check_web_sync.sh` bestätigt, dass der Web-Zwilling übereinstimmt ([[check-web-sync]], [[check-tests-updated]]). Die Textprüfung `check_errors_languagetool.py` hat eine eigene Seite ([[check-errors-languagetool]]). Die Abstandsregeln (ADR-0007) stehen an erster Stelle und werden von benannten Tests bewacht. Dreizehn ADRs sind in [[quizapp-adrs]] aufgelistet.

## How it does it
CI (Continuous Integration) führt dasselbe Gate über `pipeline-check` bei jedem Push und Pull Request aus, und jeden Montag mit der Mutationsprüfung ([[quizapp-ci]]). Sie holt den Web-Branch `web-<versionName>`, wenn er existiert, sonst `main`. Der CI-Job `gate` ist eine Pflichtprüfung auf `main` ([[maintenance-pipeline]]). Mehr Details: [[quizapp-quality-gate]], [[quizapp-requirements]].

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
