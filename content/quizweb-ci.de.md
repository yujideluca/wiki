---
id: quizweb-ci
lang: de
source_hash: 5c99d45dbbea
title: QuizWeb CI (GitHub Actions)
---

## What it is
Das ist der GitHub-Actions-Workflow von [[quizweb]] (Datei `.github/workflows/test.yml`). [GitHub Actions](https://docs.github.com/en/actions) führt automatische Aufträge auf GitHubs Rechnern aus; dieser Auftrag ist CI (Continuous Integration), die automatischen Prüfungen bei jeder Änderung.

## What it does
Er führt bei jedem Push und Pull Request (einem Vorschlag, eine Änderung zu übernehmen) die gesamte Web-Testsuite aus: Domäne, gemeinsame Konformitätsvektoren, Inhalt, i18n und Architekturregeln.

## How it does it
Er nutzt den in Node 22 eingebauten Test-Runner (`npm test` = `node --test`), sodass keine Abhängigkeiten zu installieren sind.

## Where it sits in the pipeline
Nach jedem Push zu [[github]].

## Who receives its output
[[github]].
