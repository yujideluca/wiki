---
id: quizweb-ci
lang: de
source_hash: c75b158fcffa
title: QuizWeb CI (GitHub Actions)
---

## What it is
Das ist der GitHub-Actions-Workflow von [[quizweb]] (Datei `.github/workflows/test.yml`). [GitHub Actions](https://docs.github.com/en/actions) führt automatische Aufträge auf GitHubs Rechnern aus; dieser Auftrag ist CI (Continuous Integration), die automatischen Prüfungen bei jeder Änderung.

## What it does
Er führt bei jedem Push und Pull Request (einem Vorschlag, eine Änderung zu übernehmen) die gesamte Web-Testsuite aus: Domäne, gemeinsame Konformitätsvektoren, Inhalt, i18n und Architekturregeln. Danach prüft [[pipeline-check]] die Grenzen des Projekts: keine Quelldatei über 600 Zeilen, das Gate unter 300 Sekunden und `shellcheck` auf den Skripten; eine `falha` (Fehlschlag) lässt den Auftrag fehlschlagen.

## How it does it
Er richtet Node 22 und Rust ein (mit einem Cache für das gebaute Programm) und führt `tools/pipeline-check.sh --mode ci` aus, das `tools/quality_gate.sh` einmal ausführt und dann die Fitnessprüfungen hinzufügt. Das Gate nutzt den in Node 22 eingebauten Test-Runner (`npm test` = `node --test`), sodass der Web-Code keine Abhängigkeiten zu installieren hat; Rust wird nur gebraucht, um [[pipeline-check]] zu bauen. Der Auftrag heißt `test`, und der Branch-Schutz von GitHub sollte ihn verlangen.

## Where it sits in the pipeline
Nach jedem Push zu [[github]].

## Who receives its output
[[github]].
