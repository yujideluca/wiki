---
id: new-project
lang: de
source_hash: 13e440ae47d0
title: Ein neues Projekt starten (Golden Path)
---

## What it is
Diese Seite listet die Schritte, denen jedes neue Softwareprojekt von Giovanni folgt, damit es mit Tests, Quality Gate, automatischen Prüfungen und festgehaltenen Entscheidungen beginnt, statt sie später nachzurüsten.

## What it does
Sie macht aus einer genehmigten Idee ein privates Repository, in dem die Praktiken von [[project-template]] schon vorhanden sind.

## How it does it
Zuerst kommt der Entwurf (mit der Brainstorming-Skill), Giovanni wählt die Programmiersprache, und dann wird die Vorlage kopiert und ausgefüllt.

## Where it sits in the pipeline
Vor der ersten Codezeile jedes neuen Projekts. Das [[wiki]] wurde am 2026-10-22 so gebaut.

## Who receives its output
Ein neues Projekt-Repository auf [[github]].

## Steps
1. Brainstorming, was gewünscht ist, und Größe einschätzen ([[skill-brainstorming]]); ein Projekt bekommt ein schriftliches Entwurfsdokument, das Giovanni genehmigt.
2. Giovanni wählt die Programmiersprache(n) ([[work-ask-language]]).
3. `cp -r ~/dev/project-template ~/dev/NewProject`, dann ein frisches `git init -b main` ([[project-template]]).
4. CLAUDE.md, Abschnitt 1 von DESIGN.md, die ersten Anforderungen samt Tests, die Gate-Schritte ([[template-quality-gate]]) und ADR-0002 für die Technik ausfüllen (ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält).
5. Das private GitHub-Repository anlegen, pushen, prüfen, dass der erste CI-Lauf (Continuous Integration: automatische Prüfungen) grün ist, und die Labels `debt idea P1 P2 P3` anlegen ([[github]]).
6. Vollständig bauen, dann den Debug-Durchgang der ersten Linie machen ([[skill-verification-before-completion]]).
7. Die Seiten des Projekts in dieses Wiki aufnehmen ([[end-of-task]]).
