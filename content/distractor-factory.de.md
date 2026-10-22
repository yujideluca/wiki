---
id: distractor-factory
lang: de
source_hash: c0cc2484b2db
title: DistractorFactory
aliases: [Ablenker, falsche Optionen]
---

## What it is
Erzeugt die falschen Antwortmöglichkeiten jeder Frage: plausibel, aber nie zufällig richtig.

## What it does
Präpositionen: aus häufigen Präpositionen, ohne die Antwort und alles ebenfalls Gültige. Plurale: aus deutschen Pluralmustern (-e, -en, -er, Umlaut), -n nur nach -e und -s nur nach Vokalen, damit Fälschungen wie „Tischn“ nie erscheinen. Präteritum: die regularisierte schwache Form, Partizip II, Präsens und Infinitiv.

## How it does it
Aus dem Eintrag geseedet, sodass eine Karte immer dieselben Optionen zeigt (reproduzierbare Tests und Fehlerberichte).

## Where it sits in the pipeline
Innerhalb der Inhaltspipeline, aufgerufen von [[card-factory]].

## Who receives its output
[[card-factory]].
