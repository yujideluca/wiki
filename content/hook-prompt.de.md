---
id: hook-prompt
lang: de
source_hash: 0e6998e9e11d
title: UserPromptSubmit-Hook (mem hook-prompt)
---

## What it is
Ein Hook ist ein kleines Programm, das [[claude-code]] bei einem bestimmten Ereignis automatisch ausführt ([Hooks erklärt](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Dieser läuft bei jeder Nachricht, die Giovanni sendet: der Befehl `mem hook-prompt`, mit einem Zeitlimit von 10 Sekunden.

## What it does
Er gibt den Text der Nachricht an den [[mem-harvester]], der nach einer von Giovanni geäußerten Vorliebe sucht und sie festhält, damit eine einmal genannte Regel nicht vergessen wird. Der Hook selbst gibt nichts aus.

## How it does it
Er ist so gebaut, dass er nie im Weg steht. Jeder Fehler geht ins Hook-Log, und das Programm endet immer mit Exit-Code 0 (die Zahl, mit der ein Programm „alles in Ordnung“ meldet); ein Fehler hier kann also nie verhindern, dass eine Nachricht Claude erreicht. Nachrichten über 1500 Zeichen werden nicht auf Vorlieben untersucht, weil sie eingefügte Dokumente oder von einem Programm geschriebene Prompts sind.

## Where it sits in the pipeline
Zwischen Giovannis Nachricht und dem Modell: Die Nachricht wird im Vorbeigehen gelesen.

## Who receives its output
Der [[mem-harvester]].
