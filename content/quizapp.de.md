---
id: quizapp
lang: de
source_hash: 6017163b5528
title: QuizApp (German Quiz, Android)
---

## What it is
QuizApp („German Quiz“) ist eine Android-App, mit der Giovanni Deutsch für das Niveau B2 der Goethe-Prüfung paukt. Sie funktioniert offline und nutzt Spaced Repetition im Stil von [Anki](https://apps.ankiweb.net/): ein Verfahren, bei dem gut beantwortete Fragen nach immer längeren Pausen wiederkommen und falsch beantwortete bald ([Spaced Repetition](https://en.wikipedia.org/wiki/Spaced_repetition)). Das Repository ist `yujideluca/german-quiz`, der Ordner `~/dev/QuizApp`, der Paketname der App `dev.yuji.quiz`. Sie ist außerdem das Referenzprojekt dafür, wie Giovannis Projekte gebaut werden.

## Flow
trigger t1: Giovanni öffnet die App auf dem Handy | [[phone]]
step s1: Wählt einen der fünf Lernmodi | [[game-modes]]
step s2: Der Planer wählt die nächste Frage aus dem Pool | [[spaced-repetition-scheduler]]
step s3: Giovanni antwortet; der Prüfer bewertet | [[answer-grader]]
decide d1: Richtig und schnell?
step s4: Die Karte rückt auf Tage, Wochen, Monate hinaus
step s5: Die Karte kommt bald wieder
step s6: Tagesziel und Serienkalender werden aktualisiert | [[daily-goal]], [[activity-calendar]]
trigger t2: Ein neues Fragenpaket wird veröffentlicht | [[question-pack]]
step s7: Die App holt das Paket, ohne neue App-Version
trigger t3: Giovanni bittet um eine Änderung | [[giovanni]]
step s8: Die Änderung nimmt den Release-Weg, erst Beta, dann stabil | [[quizapp-release]]
product p1: Lernfortschritt, auf Wunsch gesichert | [[progress-backup]]
product p2: Eine neue Beta- oder stabile App auf dem Handy | [[update-client]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -ja-> s4
d1 -nein-> s5
s4 -> s6
s5 -> s6
s6 -> p1
t2 -> s7
s7 -> s2
t3 -> s8
s8 -> p2

## What it does
Sie bietet fünf Lernmodi über einen kuratierten B2-Inhaltspool ([[game-modes]]): der/die/das, Präpositionen, Pluralformen, Präteritum und „Fehler finden“. Falsche oder langsame Antworten kommen bald wieder; bekannte Karten rücken auf Tage, Wochen und Monate hinaus ([[spaced-repetition-scheduler]]). Sie hat ein Tagesziel und einen Serienkalender ([[daily-goal]], [[activity-calendar]]), eine Sicherung des Fortschritts ([[progress-backup]]) und Updates aus der App heraus ([[update-client]]). Seit 2026-10-22 kann der Fragenpool ohne neue App-Version wachsen: Neue [[question-pack]]s kommen aus dem Update-Feed ([[question-pool-updater]], [[publish-content]]).

## How it does it
Sie ist in [Kotlin](https://kotlinlang.org/) mit [Jetpack Compose](https://developer.android.com/compose) (Androids moderne Art, Bildschirme zu zeichnen) geschrieben und in zwei Gradle-Module geteilt (getrennt gebaute Teile): [[quizapp-core]] (reine Kotlin-Logik: Scheduler, Bewerter, Warteschlange, Sitzung, Inhalt) und [[quizapp-app]] (Android-Bildschirme, Speicher, Updates). Der Inhalt wird von [[build-vocab]] aus tabulatorgetrennten Textdateien gebaut. Jede Änderung geht Anforderung → Test → Code, besteht das [[quizapp-quality-gate]] und erreicht das Handy zuerst über den Beta-Kanal ([[release-channels]], [[quizapp-release]]). Entwurf und Entscheidungen stehen in [[quizapp-design-doc]] und [[quizapp-adrs]].

## Where it sits in the pipeline
Sie ist Giovannis wichtigstes Lernwerkzeug. Ihr Web-Zwilling ist [[quizweb]], der sich genauso verhalten muss ([[check-web-sync]]). Releases gehen über den [[release-feed]] hinaus.

## Who receives its output
Giovanni, auf dem [[phone]]; [[quizweb]] erhält ihre Regeln, Testvektoren und Übersetzungen.
