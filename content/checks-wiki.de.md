---
id: checks-wiki
lang: de
source_hash: 04e6fb3724bc
title: Wiki: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer des [[wiki]], der Seite, die Sie gerade lesen. Es ist in Elixir (Back End) und Elm (Front End) geschrieben und das Projekt mit den meisten Inhaltsregeln.

## What it does
Das Gate hat fünf Schritte: (1) Elixir-Tests (Prüfer, Build, Veraltung, Hook, Veröffentlichung, Login-Schranke, Attrappe); (2) Elm-Tests und ein optimierter Elm-Build; (3) Anforderungs-Rückverfolgbarkeit mit der committeten Matrix; (4) `wiki check` auf dem echten Inhalt, nachdem die Datei der Datenschutzmuster mit der in workflow-memory verglichen wurde; (5) Fitness-Limits: keine Elixir- oder Elm-Datei über 800 Zeilen, das komprimierte Elm-Bundle (`app.js`) höchstens 200.000 Bytes, das Gate höchstens 1200 Sekunden.

`wiki check` ([[wiki-check]]) erzwingt: die nötigen Kopffelder und fünf Abschnitte auf jeder Seite; Links und die Symmetrie von `fed_by` und `feeds`; verwaiste Seiten; den Datenschutz-Scan ([[security-layers]]); die Beförderung einer von zwei Seiten erwähnten Funktion zu einer eigenen Seite; eine `reviewed`-Zeit, die nicht in der Zukunft liegt; vorhandene Quellen; beim ersten Gebrauch ausgeschriebene Akronyme; `Steps` auf Skill-Seiten; die vollständige `SKILL.md`-Kopie mit ihrem SHA-256-Fingerabdruck (Secure Hash Algorithm 256) auf Skill-Seiten; ein Flow-Diagramm auf Seiten für Akteur, Projekt, Prozess und Skill; Architecture und Engineering practices auf Projektseiten; und Übersetzungen mit gleicher Struktur und richtigem `source_hash`. Die Zugriffsregeln AU-1 bis AU-6 und DC-1 sind Tests in `server/test/router_test.exs` und `decoy_test.exs`.

## How it does it
CI führt das Gate im Modus `ci` aus, der die Prüfungen überspringt, die andere private Repositories brauchen ([[wiki-quality-gate]]). Der Job `gate` ist eine Pflichtprüfung auf `main`. Veröffentlicht wird mit `wiki publish`, das bei jedem Problem von `wiki check` ablehnt ([[wiki-cli]]).

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
