---
id: progress-store
lang: de
source_hash: 3effa5327449
title: ProgressStore (progress.json)
---

## What it is
Wo [[quizapp]] den Planungszustand jeder Karte ablegt (`CardProgress`: Phase, Schritt, Leichtigkeit, Abstand, Fälligkeit, Fehler, Pausierung/Entfernung): eine JSON-Datei auf dem Handy.

## What it does
Speichert nach jeder Antwort und lädt beim Start. Eine beschädigte Datei wird im Kanal STORAGE protokolliert und als leer behandelt, statt abzustürzen.

## How it does it
`FileProgressStore` schreibt die Datei atomar neu (Temporärdatei + Umbenennen), sodass ein Absturz sie nie halb geschrieben zurücklässt. Hinter der Schnittstelle `ProgressStore`; Tests nutzen `InMemoryProgressStore`; `replaceAll` spielt einen Import in einem Schreibvorgang ein.

## Where it sits in the pipeline
Unter [[study-controller]]: geschrieben nach [[spaced-repetition-scheduler]], gelesen von [[study-pipeline]].

## Who receives its output
[[study-pipeline]] (nächste Sitzung) und [[progress-backup]] (Export).
