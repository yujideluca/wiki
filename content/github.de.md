---
id: github
lang: de
source_hash: de00c5204bb2
title: GitHub
---

## What it is
Wo alle Repositorys von Giovanni liegen (Konto `yujideluca`): german-quiz, german-quiz-web, german-quiz-releases, workflow-memory, project-template und wiki (privat, wo etwas Persönliches drin ist).

## What it does
Hostet den Code, führt CI aus (GitHub Actions), liefert [[github-pages]] aus und ist die Brücke, über die die [[claude-app]] ins Gedächtnis schreibt ([[mem-github-connector]]).

## How it does it
Claude Code pusht über SSH; nie Force-Push (eine feste Vorliebe).

## Where it sits in the pipeline
Die Sicherung außerhalb des Laptops und der Treffpunkt aller Projekte.

## Who receives its output
Die Claude-Instanzen, [[github-pages]] und die Update-Prüfung des Handys ([[update-client]]).
