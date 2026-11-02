---
id: checks-status-quo
lang: de
source_hash: 4b5f386286df
title: status-quo: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer des Repositorys `status-quo` (siehe [[status-quo-design]] und [[status-quo-layout]]), eines Rust-Workspaces, der aus [[project-template]] gestartet wurde. Zum Zeitpunkt des Schreibens hatte es keine Commits, daher sind seine Prüfungen teils die noch nicht ausgefüllten Platzhalter der Vorlage.

## What it does
Das Gate enthält noch den Vorlagenschritt `echo "TODO: build and run the test suite"`, also laufen noch keine Tests; der Rückverfolgbarkeitsschritt und der Fitness-Schritt sind echt. Es hat 25 Anforderungen (Gruppe SQ) in `docs/REQUIREMENTS.md`. Seine `pipeline-check.toml` nennt das Projekt noch `<project name>` und setzt nur die Obergrenze für die Gate-Dauer (1200 Sekunden). In seiner `CLAUDE.md` hat Prinzip 2 („Logik ist framework-frei“) noch den Platzhalter `<name the pure module/package>`. Das sind auszufüllende Lücken, keine geltenden Regeln.

## How it does it
CI (Continuous Integration) nutzt den Standard-Workflow (`pipeline-check --mode ci`, höchstens 60 Minuten). Es hat keinen GitHub-Abschnitt in der Konfiguration. Zwei ADRs (0001 und 0003, Architecture Decision Records) existieren.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
