---
id: distractor-factory
lang: de
source_hash: 910c9f11949d
title: DistractorFactory
---

## What it is
Die `DistractorFactory` erzeugt die falschen Antwortoptionen jeder Frage. Ein „Distraktor“ muss plausibel genug sein, um den Spieler nachdenken zu lassen, darf aber nie versehentlich richtig sein.

## What it does
Bei Präpositionen zieht sie aus den gebräuchlichen Präpositionen, ohne die richtige Antwort und alles, was ebenfalls passen würde. Bei Pluralen nutzt sie deutsche Pluralmuster (-e, -en, -er, Umlaut), wobei -n nur nach -e und -s nur nach Vokalen steht, damit Fälschungen wie „Tischn“ nie auftauchen. Beim Präteritum bietet sie die regularisierte schwache Form, das Partizip II, das Präsens und den Infinitiv an.

## How it does it
Die Auswahl wird aus dem Eintrag „geseedet“ (eine feste Startzahl für die Zufallsauswahl), sodass eine Karte immer dieselben Optionen zeigt. Das macht Tests und Fehlerberichte reproduzierbar.

## Where it sits in the pipeline
In der Inhaltspipeline, aufgerufen von der [[card-factory]].

## Who receives its output
Die [[card-factory]].
