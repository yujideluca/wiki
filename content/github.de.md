---
id: github
lang: de
source_hash: dc942668d021
title: GitHub
---

## What it is
[GitHub](https://github.com/) ist eine Website, die Projekte von Programmierern online speichert und die vollständige Geschichte jeder Änderung festhält (sie baut auf [Git](https://git-scm.com/) auf, dem Werkzeug zur Versionsverwaltung). Ein so gespeichertes Projekt heißt Repository. Alle Repositories von Giovanni liegen unter dem Konto `yujideluca`: german-quiz, german-quiz-web, german-quiz-releases, workflow-memory, project-template und dieses Wiki. Solche mit Persönlichem sind privat.

## What it does
Es hostet den Code, führt die automatischen Prüfungen namens CI (Continuous Integration) über GitHub Actions aus, liefert statische Websites aus ([[github-pages]]) und ist die Brücke, über die die [[claude-app]] ins Gedächtnis schreiben kann ([[mem-github-connector]]).

## How it does it
[[claude-code]] lädt per SSH hoch (Push; Secure Shell, ein verschlüsseltes Anmeldeverfahren mit Schlüsseln statt Passwörtern). Es erzwingt nie einen Push (Force-Push), der die Geschichte auf dem Server überschreiben würde; das ist eine dauerhafte Vorgabe von Giovanni.

## Where it sits in the pipeline
Es ist die Sicherung außerhalb des Laptops und der Treffpunkt jedes Projekts.

## Who receives its output
Die Claude-Instanzen, [[github-pages]] und die Update-Prüfung des Handys ([[update-client]]).
