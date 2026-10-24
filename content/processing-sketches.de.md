---
id: processing-sketches
lang: de
source_hash: 081a1bc48616
title: Processing-Skizzen
---

## What it is
Kleine Programme für generative Kunst in Processing (eine Java-basierte Zeichensprache) in `~/dev/processing-sketches`.

## What it does
Zeichnet die Heighway-Drachenkurve in zwei Varianten: [[drachenkurve]] (als App exportiert, hat das Startsymbol von QuizApp gerendert) und [[drachenfraktal]].

## How it does it
Jede Skizze ist eine `.pde`-Datei in eigenem Ordner; `drachenkurve` hat einen exportierten Build. Seit 2026-10-24 ist der Ordner ein privates GitHub-Repository (`yujideluca/processing-sketches`) mit Tor, CI und der Pre-Push-Prüfung von [[pipeline-check]]; Build-Ausgaben werden ignoriert.

## Where it sits in the pipeline
Am Rand der anderen Projekte; die einzige Verbindung ist das Symbol von [[quizapp]].

## Who receives its output
[[quizapp]] (sein Startsymbol).
