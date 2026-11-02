---
id: checks-radiology-crawler
lang: de
source_hash: a64c9b7582f0
title: radiology-crawler: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer des Repositorys des Radiologie-Crawlers (`radiology-crawler`, in seiner Konfiguration `radiology-report-matcher` genannt), der Python-Werkzeuge, die öffentliche Radiologietexte für den geplanten Befund-Abgleich sammeln und auswerten ([[radiology-report-matcher]], [[radiopaedia-crawler]]).

## What it does
Das Gate hat vier Schritte: (0) `check_dependencies.py`: Jeder Drittanbieter-Import steht in `requirements.txt` (oder in `requirements-optional.txt`, wenn er nur in einem try-Block mit Ersatz genutzt wird), und jedes `pip install` in einem Workflow ist `pip install -r requirements.txt` (Prinzip 11, hinzugefügt, nachdem ein CI-Lauf an einem fehlenden Paket scheiterte); (1) `compileall` und die Tests mit pytest; (2) Anforderungs-Rückverfolgbarkeit (die Gruppen AN, CW, DP, LG, TL, WS); (3) Fitness-Limits: keine Python-Datei über 800 Zeilen, das Gate höchstens 1200 Sekunden. Regeln in `CLAUDE.md`, jede mit den Tests, die sie prüfen: Der Crawler befolgt `robots.txt` (CW-1 bis CW-3); jeder Codex-Aufruf ist eine frische Sitzung unter 250.000 Tokens (TL-2, TL-5); keine persönlichen oder Patientendaten im Repository oder in Protokollen; heruntergeladene Seiten und Datenbanken kommen nie in git; der Stand der statistischen Analyse steht in `docs/analysis-status.json`.

## How it does it
CI (Continuous Integration) installiert aus `requirements.txt` und führt `pipeline-check --mode ci` aus (höchstens 60 Minuten). Seine `pipeline-check.toml` hat keinen GitHub-Abschnitt, daher wird Branch-Schutz dort nicht gelesen. Drei ADRs existieren.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
