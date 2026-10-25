---
id: wiki
lang: de
source_hash: d3d738b452f0
title: Wiki (diese Seite)
---

## What it is
Diese Website ist ein Wiki: eine Enzyklopädie aller Projekte, Programme, Skills und Abläufe in Giovannis Systemen, mit einer Karte, die zeigt, wie sie zusammenhängen. Jedes Thema hat seine eigene Seite, so geschrieben, dass ein Leser, der nichts über das System oder seine Fachsprache weiß, folgen kann. Ein Wort neu? Öffne das [[glossary]], das die auf den Seiten verwendeten Begriffe erklärt. Das Repository `yujideluca/wiki` ist öffentlich (seit 2026-10-25), der Ordner ist `~/dev/wiki`, und das Projekt wurde am 2026-10-22 aus [[project-template]] gestartet.

## What it does
Es lässt Giovanni eine Architekturfrage nach einer Suche und höchstens zwei Klicks beantworten: Suche mit Vorschlägen beim Tippen, über einen Punkt der Karte fahren, um in vier Kästen zu sehen, was er ist, auf den Punkt klicken für die vollständige Seite ([[wiki-frontend]]). Es wird am Ende jeder Aufgabe automatisch aktuell gehalten ([[end-of-task]]).

## How it does it
Der Inhalt besteht aus Markdown-Textdateien, jede mit einem kleinen Kopf ([[wiki-content]]); sie werden von [[wiki-check]] geprüft und von [[wiki-build]] in JSON-Daten (JavaScript Object Notation) verwandelt. Der sichtbare Teil ist in Elm geschrieben ([[wiki-frontend]]); der Server ist in Elixir geschrieben ([[wiki-server]]) und lässt nur ein Google-Konto hinein, allen anderen zeigt er einen Köder ([[wiki-router]], [[decoy-page]]). Im Internet ist es über [[tailscale-funnel]] erreichbar. Die Sprachen sind Englisch, Deutsch und brasilianisches Portugiesisch.

## Where it sits in the pipeline
Neben [[workflow-memory]]: Das Gedächtnis enthält Regeln und Vorlieben, das Wiki beschreibt, was es gibt und wie es funktioniert, und verlinkt auf Gedächtniseinträge, statt sie zu kopieren.

## Who receives its output
[[giovanni]], im Browser auf dem Laptop oder dem Handy.
