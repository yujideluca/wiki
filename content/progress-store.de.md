---
id: progress-store
lang: de
source_hash: 56b13d56398d
title: ProgressStore (progress.json)
---

## What it is
Hier hält [[quizapp]] den Planungszustand jeder Karte fest (`CardProgress`: Phase, Schritt, Ease, Intervall, Fälligkeit, Lapses und ob die Karte pausiert oder entfernt ist). Es ist eine einzige [JSON](https://en.wikipedia.org/wiki/JSON)-Datei (JavaScript Object Notation, ein Klartext-Datenformat), `progress.json`, auf dem Handy.

## What it does
Es speichert nach jeder Antwort und lädt beim Start. Ist die Datei beschädigt, wird das Problem im Kanal STORAGE protokolliert und die Datei als leer behandelt, statt die App abstürzen zu lassen.

## How it does it
`FileProgressStore` schreibt die Datei atomar neu: Zuerst wird eine temporäre Datei geschrieben und dann umbenannt, sodass ein Absturz nie eine halb geschriebene Datei hinterlassen kann. Es sitzt hinter der Schnittstelle `ProgressStore` (ein Versprechen, was ein Speicher können muss), sodass Tests einen einfachen `InMemoryProgressStore` benutzen; `replaceAll` wendet einen Sicherungsimport in einem Schreibvorgang an.

## Where it sits in the pipeline
Unter dem [[study-controller]]: geschrieben nach dem [[spaced-repetition-scheduler]], gelesen von der [[study-pipeline]].

## Who receives its output
Die [[study-pipeline]] (nächste Sitzung) und die [[progress-backup]] (Export).
