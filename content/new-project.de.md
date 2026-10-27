---
id: new-project
lang: de
source_hash: 8caa3586a33a
title: Ein neues Projekt starten (Golden Path)
---

## What it is
Diese Seite listet die Schritte, denen jedes neue Softwareprojekt von Giovanni folgt, damit es mit Tests, Quality Gate, automatischen Prüfungen und festgehaltenen Entscheidungen beginnt, statt sie später nachzurüsten.

## Flow
trigger t1: Giovanni möchte ein neues Softwareprojekt | [[giovanni]]
step s1: Sammelt Ideen und schätzt den Umfang; Giovanni genehmigt einen schriftlichen Entwurf | [[skill-brainstorming]]
step s2: Giovanni wählt die Programmiersprachen | [[work-ask-language]]
step s3: Kopiert die Vorlage in einen neuen Ordner und startet eine frische Git-Historie | [[project-template]]
step s4: Füllt CLAUDE.md, DESIGN.md, Anforderungen, Gate, Grenzen, Entscheidungsnotiz aus | [[template-quality-gate]], [[fitness-check]]
step s5: Legt das private GitHub-Repository an, pusht, erste automatische Prüfungen grün | [[github]], [[maintenance-pipeline]]
step s6: Baut alles durchgehend, dann die erste Fehlersuche | [[skill-verification-before-completion]]
step s7: Fügt die Seiten des Projekts diesem Wiki hinzu | [[end-of-task]]
product p1: Ein privates Repository mit Tests, Gate und festgehaltenen Entscheidungen von Anfang an
product p2: Das Projekt im Wiki dokumentiert | [[wiki]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> s6
s6 -> p1
s6 -> s7
s7 -> p2

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
4. CLAUDE.md, Abschnitt 1 von DESIGN.md, die ersten Anforderungen samt Tests, die Gate-Schritte ([[template-quality-gate]]), die Grenzen in `pipeline-check.toml` ([[fitness-check]]) und ADR-0002 für die Technik ausfüllen (ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält).
5. Das private GitHub-Repository anlegen, pushen, prüfen, dass der erste CI-Lauf (Continuous Integration: automatische Prüfungen) grün ist, die Labels `debt idea P1 P2 P3` anlegen ([[github]]) und die lokale Prüfung vor dem Push mit `git config core.hooksPath tools/hooks` einschalten ([[maintenance-pipeline]]).
6. Vollständig bauen, dann den Debug-Durchgang der ersten Linie machen ([[skill-verification-before-completion]]).
7. Die Seiten des Projekts in dieses Wiki aufnehmen ([[end-of-task]]).
