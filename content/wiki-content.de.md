---
id: wiki-content
lang: de
source_hash: 476989c4168a
title: Wiki-Inhalte (Markdown-Seiten)
aliases: [Seiten]
---

## What it is
Die Quelle dieses Wikis: eine Markdown-Datei pro Begriff in `content/` (Englisch), mit Übersetzungen `<id>.de.md` und `<id>.pt-BR.md`, sowie `_kinds.json`, die offene Liste der Arten und ihrer Farben.

## What it does
Jede Seite hat einen Kopfteil (`id, title, aliases, kind, project, status, location, fed_by, feeds, sources, memory, since, until, reviewed`) und feste Abschnitte: Was es ist, Was es tut, Wie es das tut, Wo es in der Pipeline steht, Wer seine Ausgabe erhält, dazu optional Schritte (Ablaufseiten), Funktionen und Anmerkungen.

## How it does it
Links im Obsidian-Stil `[[id]]`; `fed_by`/`feeds` sind die Pipeline-Kanten und müssen in beide Richtungen übereinstimmen. `sources` sind `repo:pfad`, damit eine Codeänderung die Seite als veraltet markieren kann. Übersetzungen speichern einen Hash des englischen Textes, aus dem sie entstanden. Seiten sagen, was existiert; Regeln liegen im Gedächtnis und werden per #Code verlinkt.

## Where it sits in the pipeline
Von [[claude-code]] am Ende jeder Aufgabe geschrieben ([[end-of-task]]); geprüft von [[wiki-check]]; von [[wiki-build]] in Daten verwandelt.

## Who receives its output
[[wiki-check]] und [[wiki-build]].
