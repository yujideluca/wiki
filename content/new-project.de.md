---
id: new-project
lang: de
source_hash: 5fe0aa8b2e7c
title: Ein neues Projekt beginnen (goldener Pfad)
aliases: [neues Projekt]
---

## What it is
Die Schritte, denen jedes neue Softwareprojekt von Giovanni folgt, damit es mit Tests, Tor, CI und festgehaltenen Entscheidungen startet.

## What it does
Macht aus einer genehmigten Idee ein privates Repo mit den Praktiken der Vorlage.

## How it does it
Zuerst der Entwurf (Brainstorming-Skill), Sprache von Giovanni gewählt, dann [[project-template]] kopieren und ausfüllen.

## Where it sits in the pipeline
Vor der ersten Codezeile jedes neuen Projekts. Das [[wiki]] entstand so am 22.10.2026.

## Who receives its output
Ein neues Projekt-Repo auf [[github]].

## Steps
1. Klären, was gewollt ist, und die Größe bestimmen ([[skill-brainstorming]]); ein Projekt bekommt ein schriftliches Entwurfsdokument, das Giovanni genehmigt.
2. Giovanni wählt die Programmiersprache(n) ([[work-ask-language]]).
3. `cp -r ~/dev/project-template ~/dev/NeuesProjekt`, frisches `git init -b main` ([[project-template]]).
4. CLAUDE.md, DESIGN.md Abschnitt 1, die ersten Anforderungen mit Tests, die Schritte des Tors ([[template-quality-gate]]) und ADR-0002 zum Stack ausfüllen.
5. Das private GitHub-Repo anlegen, pushen, prüfen, dass der erste CI-Lauf grün ist, die Labels `debt idea P1 P2 P3` anlegen ([[github]]).
6. Vollständig bauen, dann der erste Debug-Durchgang ([[skill-verification-before-completion]]).
7. Die Seiten des Projekts in dieses Wiki aufnehmen ([[end-of-task]]).
