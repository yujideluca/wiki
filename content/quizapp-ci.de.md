---
id: quizapp-ci
lang: de
source_hash: 73e65377dc3d
title: QuizApp-CI (GitHub Actions)
---

## What it is
Der GitHub-Actions-Workflow von [[quizapp]]: Er führt [[quizapp-quality-gate]] auf GitHubs Rechnern aus.

## What it does
Bei jedem Push und Pull-Request: das ganze Tor ohne Mutation. Jeden Montag: mit Mutationsprüfung, damit ein Test, der eine Regel nicht mehr schützt, innerhalb einer Woche auffällt. Nach dem Push muss der Lauf grün sein.

## How it does it
Richtet Java 21, Gradle und Node 22 ein, checkt den passenden Web-Branch aus (`web-<versionName>`, falls vorhanden, sonst `main`) und führt dasselbe Skript wie auf dem Laptop aus.

## Where it sits in the pipeline
Nach jedem Push zu [[github]].

## Who receives its output
[[github]] (grüne oder rote Markierung) und Claude, der sie prüfen muss.
