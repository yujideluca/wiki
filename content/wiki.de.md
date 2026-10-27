---
id: wiki
lang: de
source_hash: 396431135113
title: Wiki (diese Seite)
---

## What it is
Diese Website ist ein Wiki: eine Enzyklopädie aller Projekte, Programme, Skills und Abläufe in Giovannis Systemen, mit einer Karte, die zeigt, wie sie zusammenhängen. Jedes Thema hat seine eigene Seite, so geschrieben, dass ein Leser, der nichts über das System oder seine Fachsprache weiß, folgen kann. Ein Wort neu? Öffne das [[glossary]], das die auf den Seiten verwendeten Begriffe erklärt. Das Repository `yujideluca/wiki` ist öffentlich (seit 2026-10-25), der Ordner ist `~/dev/wiki`, und das Projekt wurde am 2026-10-22 aus [[project-template]] gestartet.

## Flow
trigger t1: Claude beendet eine Aufgabe, die ein System verändert hat | [[end-of-task]]
step s1: Schreibt Markdown-Seiten, jede mit kleinem Kopf | [[wiki-content]]
step s2: wiki check wendet die Inhaltsregeln an | [[wiki-check]]
decide d1: Bestehen die Regeln?
step s3: wiki build macht aus den Seiten Daten | [[wiki-build]]
step s4: Nur content/ wird committet und hochgeladen | [[github]]
step s5: Der Server liefert aus: Giovannis Google-Konto kommt rein, andere sehen eine Attrappe | [[wiki-router]], [[decoy-page]]
trigger t2: Giovanni öffnet das Wiki | [[giovanni]]
step s6: Sucht, fährt über die Karte, klickt einen Punkt | [[wiki-frontend]]
product p1: Veröffentlichung abgelehnt, mit Liste der Probleme
product p2: Eine Seite, die die Architekturfrage beantwortet

t1 -> s1
s1 -> s2
s2 -> d1
d1 -nein-> p1
d1 -ja-> s3
s3 -> s4
s4 -> s5
t2 -> s5
s5 -> s6
s6 -> p2

## What it does
Es lässt Giovanni eine Architekturfrage nach einer Suche und höchstens zwei Klicks beantworten: Suche mit Vorschlägen beim Tippen, über einen Punkt der Karte fahren, um in vier Kästen zu sehen, was er ist, auf den Punkt klicken für die vollständige Seite ([[wiki-frontend]]). Auf einem Handy füllt die Karte den Bildschirm mit einer Suchleiste oben, und das Antippen eines Punkts öffnet eine Sprechblase mit seiner Beschreibung; auf einem Desktop wird die Karte durch eine Linse gesehen, und ihre Punkte dehnen sich elastisch, wenn man sie zieht ([[wiki-map-view]]). Es wird am Ende jeder Aufgabe automatisch aktuell gehalten ([[end-of-task]]).

## How it does it
Der Inhalt besteht aus Markdown-Textdateien, jede mit einem kleinen Kopf ([[wiki-content]]); sie werden von [[wiki-check]] geprüft und von [[wiki-build]] in JSON-Daten (JavaScript Object Notation) verwandelt. Der sichtbare Teil ist in Elm geschrieben ([[wiki-frontend]]); der Server ist in Elixir geschrieben ([[wiki-server]]) und lässt nur ein Google-Konto hinein, allen anderen zeigt er einen Köder ([[wiki-router]], [[decoy-page]]). Im Internet ist es über [[tailscale-funnel]] erreichbar. Die Sprachen sind Englisch, Deutsch und brasilianisches Portugiesisch.

## Where it sits in the pipeline
Neben [[workflow-memory]]: Das Gedächtnis enthält Regeln und Vorlieben, das Wiki beschreibt, was es gibt und wie es funktioniert, und verlinkt auf Gedächtniseinträge, statt sie zu kopieren.

## Who receives its output
[[giovanni]], im Browser auf dem Laptop oder dem Handy.
