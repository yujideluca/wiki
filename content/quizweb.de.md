---
id: quizweb
lang: de
source_hash: fdecab89a4c6
title: QuizWeb (German Quiz, Web)
---

## What it is
QuizWeb ist die Webversion des Deutsch-Quiz, gemacht, damit sie auf einem iPhone funktioniert. Sie ist eine PWA (Progressive Web App: eine Webseite, die sich wie eine App auf dem Handy installieren lässt und offline weiterläuft, siehe [PWA](https://en.wikipedia.org/wiki/Progressive_web_app)), ausgeliefert von [[github-pages]]. Das Repository ist `yujideluca/german-quiz-web`, der Ordner `~/dev/QuizWeb`. Sie ist der „Web-Zwilling“ von [[quizapp]].

## What it does
Sie hat dieselben fünf Modi, denselben Scheduler, dasselbe Tagesziel und denselben Serienkalender wie [[quizapp]] und funktioniert offline. Der Fortschritt liegt im Browser des jeweiligen Geräts und ist von der Android-App getrennt; Einstellungen > Sicherung speichert und stellt ihn wieder her.

## How it does it
Sie ist schlichtes JavaScript in ES-Modulen (die Standardart, JavaScript in Dateien zu teilen), ohne Build-Schritt und ohne Abhängigkeiten. Die Teile sind: [[quizweb-domain]] (reine Logik), [[quizweb-content]], [[quizweb-controller]], [[quizweb-store]] und [[quizweb-app]] (die letzten beiden sind die einzigen Module, die den Browser berühren) sowie der Offline-Cache [[quizweb-service-worker]]. Der Test `tests/architecture.test.js` legt fest, wer wen importieren darf, und [[quizweb-ci]] führt bei jedem Push `npm test` und die Grenzen von [[pipeline-check]] aus.

## Where it sits in the pipeline
Sie ist der Zwilling von [[quizapp]] (Entscheidung ADR-0006 dort; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält): Sie liest dieselben Vokabeldateien und dieselben Konformitätsvektoren, und [[check-web-sync]] in QuizApp vergleicht sie. QuizWeb folgt nur der veröffentlichten Version der App: Ein Port einer App-Version, die noch in der Beta ist, wartet auf einem Zweig `web-<version>` und wird nach `main` gemergt, wenn die App befördert wird.

## Who receives its output
Giovannis iPhone oder jeder Browser, über [[github-pages]].
