---
id: checks-quizweb
lang: de
source_hash: aea4741f3451
title: QuizWeb: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer von [[quizweb]], dem Web-Zwilling der Quiz-App: einer als PWA (Progressive Web App) installierbaren Webseite, die sich wie die Android-App verhalten muss.

## What it does
Das Gate hat zwei Schritte: `npm test` (der reine Node-Testläufer, ohne Abhängigkeiten) und `pipeline-check --measure-only`. Die Testdateien sind domain, controller, daily-bar, content, i18n, conformance, bughunt und architecture. Der Architekturtest ist eine als Test geschriebene Fitness-Funktion: Jedes Quellmodul hat einen Eintrag in einer Erlaubnisliste, wer wen importieren darf, sodass eine neue Datei einen bewussten Eintrag braucht; nur `app.js` darf die Seite berühren und nur `store.js` den Browser-Speicher. Limits: keine JavaScript-Datei über 600 Zeilen in `src/`, das Gate höchstens 300 Sekunden. Die Konformitätsvektoren werden mit der App geteilt; das Gate der App vergleicht sie Byte für Byte ([[quizweb-conformance]]).

## How it does it
Der CI-Workflow heißt `test` (nicht `gate`), und die Pflichtprüfung in `pipeline-check.toml` ist `test` ([[quizweb-ci]]). Das Web-Projekt hat keinen Rückverfolgbarkeits-Abschnitt: Seine Versprechen werden in der Liste von QuizApp verfolgt, deren Rückverfolgbarkeitsschritt den Web-Testordner liest (Label `web`, Ordner über `QUIZWEB_TESTS` benannt). Das Erhöhen der Version in `sw.js` (dem Service Worker, [[quizweb-service-worker]]) gehört zu jeder Portierung.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
