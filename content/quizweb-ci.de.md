---
id: quizweb-ci
lang: de
source_hash: 18f913bdb0c7
title: QuizWeb-CI (GitHub Actions)
---

## What it is
Der GitHub-Actions-Workflow von [[quizweb]].

## What it does
Führt bei jedem Push und Pull-Request die ganze Web-Testsuite aus: Domäne, gemeinsame Konformitätsvektoren, Inhalte, i18n und Architekturregeln.

## How it does it
Der eingebaute Testläufer von Node 22 (`npm test` = `node --test`), keine Abhängigkeiten zu installieren.

## Where it sits in the pipeline
Nach jedem Push zu [[github]].

## Who receives its output
[[github]].
