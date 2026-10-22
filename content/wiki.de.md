---
id: wiki
lang: de
source_hash: 7b48652c48e1
title: Wiki (diese Seite)
---

## What it is
Diese Seite: ein Wiki aller Projekte, Programme, Skills und Abläufe in Giovannis Systemen, mit einer Karte im Stil von Dark, die zeigt, wie sie zusammenhängen. Repo `yujideluca/wiki` (privat), Ordner `~/dev/wiki`. Am 22.10.2026 aus [[project-template]] gestartet.

## What it does
Lässt Giovanni eine Architekturfrage nach einer Suche und höchstens zwei Klicks beantworten: Suche mit Autovervollständigung, über einen Punkt fahren zeigt in vier Kästen, was er ist, ein Klick öffnet den Artikel ([[wiki-frontend]]). Bleibt automatisch aktuell, am Ende jeder Aufgabe ([[end-of-task]]).

## How it does it
Inhalte sind Markdown-Dateien mit Kopfteil ([[wiki-content]]), geprüft von [[wiki-check]] und von [[wiki-build]] in JSON verwandelt. Das Frontend ist in Elm geschrieben ([[wiki-frontend]]), das Backend in Elixir ([[wiki-server]]) mit Google-Anmeldung für ein Konto und einer Attrappe für alle anderen ([[wiki-router]], [[decoy-page]]). Im Web erreichbar über [[tailscale-funnel]]. Sprachen: Englisch, Deutsch, brasilianisches Portugiesisch.

## Where it sits in the pipeline
Neben [[workflow-memory]]: Das Gedächtnis hält Regeln und Vorlieben, das Wiki beschreibt, was existiert und wie es funktioniert, und verlinkt Gedächtniseinträge, statt sie zu kopieren.

## Who receives its output
[[giovanni]], im Browser auf dem Laptop oder dem Handy.
