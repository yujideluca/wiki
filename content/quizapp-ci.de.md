---
id: quizapp-ci
lang: de
source_hash: ce8cd806b16b
title: QuizApp CI (GitHub Actions)
---

## What it is
Das ist der GitHub-Actions-Workflow von [[quizapp]] (Datei `.github/workflows/quality-gate.yml`). [GitHub Actions](https://docs.github.com/en/actions) führt automatische Aufträge auf GitHubs Rechnern aus. Dieser Workflow ist CI (Continuous Integration): Er führt bei jeder Änderung das [[quizapp-quality-gate]] aus und zeigt ein grünes oder rotes Zeichen.

## What it does
Bei jedem Push und Pull Request (einem Vorschlag, eine Änderung zu übernehmen) führt er das vollständige Gate ohne die Mutationsprüfung aus. Jeden Montag führt er es mit der Mutationsprüfung aus, sodass ein Test, der eine Regel nicht mehr schützt, innerhalb einer Woche auffällt. Nach dem Push muss der Lauf grün sein.

## How it does it
Er richtet Java 21, Gradle und Node 22 ein (eine JavaScript-Laufzeit), checkt den passenden Zweig des Web-Zwillings aus (`web-<versionName>`, falls vorhanden, sonst `main`) und führt dann [[pipeline-check]] aus, das dasselbe Gate-Skript wie auf dem Laptop einmal ausführt und die Architektur-, Fitness- und Berichtsprüfungen ergänzt. Eine `falha` (Fehlschlag) lässt den Auftrag `gate` fehlschlagen, den der Branch-Schutz von GitHub verlangen sollte.

## Where it sits in the pipeline
Nach jedem Push zu [[github]].

## Who receives its output
[[github]] (das grüne oder rote Zeichen) und Claude, das es prüfen muss.
