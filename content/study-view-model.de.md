---
id: study-view-model
lang: de
source_hash: fa832083ac66
title: StudyViewModel (Oberflächenzustand)
aliases: [Bildschirme]
---

## What it is
Das einzige ViewModel von [[quizapp]]: Es stellt den Compose-Bildschirmen einen versiegelten `UiState` bereit (`ModeSelect`, `Studying`, `Finished`, `Settings`, `Failed`).

## What it does
Übersetzt Ergebnisse von [[study-controller]] in das, was die Bildschirme zeigen: Startbildschirm (Kalender, Tagesziel, Moduskarten), Frage mit Rückmeldung (grün/rot, Erklärung, automatisches Weiter nach 0,5 s außer bei Fehler finden), Einstellungen und Update-Fenster.

## How it does it
Übersteht den Neuaufbau der Activity bei Sprachwechsel; eigene Texte laufen über seinen Helfer `t()`. Bildschirme skalieren mit der Höhe (`ScreenScale`); der Screen-Fit-Test prüft, dass auf hohen Handys nichts unter dem Rand verschwindet.

## Where it sits in the pipeline
Die Spitze der App: `ui → StudyController`.

## Who receives its output
Giovanni auf dem [[phone]].
