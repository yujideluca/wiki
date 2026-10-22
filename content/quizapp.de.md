---
id: quizapp
lang: de
source_hash: dcad0403eab5
title: QuizApp (German Quiz, Android)
---

## What it is
Eine Offline-Android-App zum Üben von B2-Deutsch mit Anki-artiger verteilter Wiederholung. Repo `yujideluca/german-quiz`, Ordner `~/dev/QuizApp`, Paket `dev.yuji.quiz`. Sie ist das Referenzprojekt dafür, wie Giovannis Projekte gebaut werden.

## What it does
Fünf Lernmodi über einen festen B2-Bestand ([[game-modes]]): der/die/das, Präpositionen, Pluralformen, Präteritum und Fehler finden. Falsche oder langsame Antworten kommen bald wieder; bekannte Karten rücken auf Tage, Wochen und Monate ([[spaced-repetition-scheduler]]). Tagesziel und Serienkalender ([[daily-goal]], [[activity-calendar]]), Sicherung ([[progress-backup]]) und Updates in der App ([[update-client]]).

## How it does it
Kotlin + Jetpack Compose in zwei Gradle-Modulen: [[quizapp-core]] (reines Kotlin: Planer, Bewerter, Warteschlange, Sitzung, Inhalte) und [[quizapp-app]] (Android-Oberfläche, Speicher, Updates). Inhalte entstehen aus TSV-Dateien durch [[build-vocab]]. Jede Änderung läuft Anforderung → Test → Code durch [[quizapp-quality-gate]] und erreicht das Handy zuerst über den Beta-Kanal ([[release-channels]], [[quizapp-release]]). Entwurf und Entscheidungen: [[quizapp-design-doc]] und [[quizapp-adrs]].

## Where it sits in the pipeline
Giovannis wichtigstes Lernwerkzeug; ihr Web-Zwilling ist [[quizweb]], der sich gleich verhalten muss ([[check-web-sync]]). Versionen gehen über [[release-feed]] hinaus.

## Who receives its output
Giovanni auf dem [[phone]]; [[quizweb]] erhält Regeln, Testvektoren und Übersetzungen.
