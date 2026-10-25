---
id: quizapp
lang: de
source_hash: 6330a9bcc42e
title: QuizApp (German Quiz, Android)
---

## What it is
QuizApp („German Quiz“) ist eine Android-App, mit der Giovanni Deutsch für das Niveau B2 der Goethe-Prüfung paukt. Sie funktioniert offline und nutzt Spaced Repetition im Stil von [Anki](https://apps.ankiweb.net/): ein Verfahren, bei dem gut beantwortete Fragen nach immer längeren Pausen wiederkommen und falsch beantwortete bald ([Spaced Repetition](https://en.wikipedia.org/wiki/Spaced_repetition)). Das Repository ist `yujideluca/german-quiz`, der Ordner `~/dev/QuizApp`, der Paketname der App `dev.yuji.quiz`. Sie ist außerdem das Referenzprojekt dafür, wie Giovannis Projekte gebaut werden.

## What it does
Sie bietet fünf Lernmodi über einen kuratierten B2-Inhaltspool ([[game-modes]]): der/die/das, Präpositionen, Pluralformen, Präteritum und „Fehler finden“. Falsche oder langsame Antworten kommen bald wieder; bekannte Karten rücken auf Tage, Wochen und Monate hinaus ([[spaced-repetition-scheduler]]). Sie hat ein Tagesziel und einen Serienkalender ([[daily-goal]], [[activity-calendar]]), eine Sicherung des Fortschritts ([[progress-backup]]) und Updates aus der App heraus ([[update-client]]). Seit 2026-10-22 kann der Fragenpool ohne neue App-Version wachsen: Neue [[question-pack]]s kommen aus dem Update-Feed ([[question-pool-updater]], [[publish-content]]).

## How it does it
Sie ist in [Kotlin](https://kotlinlang.org/) mit [Jetpack Compose](https://developer.android.com/compose) (Androids moderne Art, Bildschirme zu zeichnen) geschrieben und in zwei Gradle-Module geteilt (getrennt gebaute Teile): [[quizapp-core]] (reine Kotlin-Logik: Scheduler, Bewerter, Warteschlange, Sitzung, Inhalt) und [[quizapp-app]] (Android-Bildschirme, Speicher, Updates). Der Inhalt wird von [[build-vocab]] aus tabulatorgetrennten Textdateien gebaut. Jede Änderung geht Anforderung → Test → Code, besteht das [[quizapp-quality-gate]] und erreicht das Handy zuerst über den Beta-Kanal ([[release-channels]], [[quizapp-release]]). Entwurf und Entscheidungen stehen in [[quizapp-design-doc]] und [[quizapp-adrs]].

## Where it sits in the pipeline
Sie ist Giovannis wichtigstes Lernwerkzeug. Ihr Web-Zwilling ist [[quizweb]], der sich genauso verhalten muss ([[check-web-sync]]). Releases gehen über den [[release-feed]] hinaus.

## Who receives its output
Giovanni, auf dem [[phone]]; [[quizweb]] erhält ihre Regeln, Testvektoren und Übersetzungen.
