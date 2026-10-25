---
id: study-view-model
lang: de
source_hash: f058106c75c3
title: StudyViewModel (UI-Zustand)
---

## What it is
Ein [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel) ist der Teil einer Android-App, der Daten für die Bildschirme aufbereitet und Bildschirmdrehungen übersteht. Das StudyViewModel ist das eine ViewModel von [[quizapp]]; es stellt den Compose-Bildschirmen einen „versiegelten“ `UiState` bereit (UI heißt Benutzeroberfläche; versiegelt heißt, er kann nur einer aus einer festen Liste von Fällen sein: `ModeSelect`, `Studying`, `Finished`, `Settings`, `Failed`).

## What it does
Es verwandelt die Ergebnisse des [[study-controller]] in das, was die Bildschirme zeigen: den Startbildschirm (Kalender, Tagesziel, Moduskarten), die Frage mit Feedback (grün oder rot, die Erklärung, automatisches Weiter nach 0,5 s außer bei Fehler finden), die Einstellungen und das Update-Popup.

## How it does it
Es übersteht die Neuerzeugung des Bildschirms, die bei einem Sprachwechsel passiert. Text, den es selbst erzeugt, läuft über seinen Helfer `t()`, der die richtige Sprache wählt. Die `UiState`-Typen stehen in `UiState.kt` und der Update-Ablauf (den Feed fragen, das Popup, die APK laden, Android Package, die installierbare App-Datei) in `AppUpdater.kt`, sodass das ViewModel unter 300 Zeilen bleibt; ein vom Update-Ablauf geladener Fragenpool wird an es zurückgegeben, und es entscheidet, wann das Deck ersetzt werden darf ([[question-pool-updater]]). Die Bildschirme skalieren mit der Bildschirmhöhe (`ScreenScale`), und ein „Screen-fit“-Test prüft, dass auf hohen Handys nichts unterhalb des sichtbaren Bereichs verborgen ist.

## Where it sits in the pipeline
Die Spitze der App: `ui → StudyController`.

## Who receives its output
Giovanni auf dem [[phone]].
