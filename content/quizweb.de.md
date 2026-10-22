---
id: quizweb
lang: de
source_hash: e4103e50ee47
title: QuizWeb (German Quiz, Web)
aliases: [Web-Zwilling]
---

## What it is
Die iPhone-freundliche Webversion des Deutschquiz: eine PWA (eine Webseite, die sich wie eine App installieren lässt), ausgeliefert von [[github-pages]]. Repo `yujideluca/german-quiz-web`, Ordner `~/dev/QuizWeb`.

## What it does
Dieselben fünf Modi, derselbe Planer, Tagesziel und Serienkalender wie [[quizapp]], offline. Der Fortschritt liegt im Browser des Geräts und ist von der Android-App getrennt; Einstellungen > Sicherung speichert und stellt ihn wieder her.

## How it does it
Reine ES-Module ohne Build-Schritt und ohne Abhängigkeiten: [[quizweb-domain]] (reine Logik), [[quizweb-content]], [[quizweb-controller]], [[quizweb-store]] und [[quizweb-app]] (die einzigen Module, die den Browser berühren), dazu der Offline-Cache [[quizweb-service-worker]]. `tests/architecture.test.js` legt fest, wer wen importieren darf; [[quizweb-ci]] führt bei jedem Push `npm test` aus.

## Where it sits in the pipeline
Der Zwilling von [[quizapp]] (dort ADR-0006): Er liest dieselben Vokabeldateien und dieselben Konformitätsvektoren, und [[check-web-sync]] in QuizApp vergleicht sie. Die Portierung einer App-Version, die noch in Beta ist, wartet auf einem Branch `web-<version>` und wird bei der Freigabe in `main` gemergt.

## Who receives its output
Giovannis iPhone oder jeder Browser, über [[github-pages]].
