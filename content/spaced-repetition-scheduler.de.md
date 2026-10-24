---
id: spaced-repetition-scheduler
lang: de
source_hash: ff1ac9e54dfb
title: SpacedRepetitionScheduler
---

## What it is
Der Scheduler ist das Herz von [[quizapp]]: eine reine Funktion `(progress, grade, now, config) → progress`, die entscheidet, wann eine Karte wiederkommt. Er ist eine Variante des Algorithmus SM-2 (SuperMemo 2, ein früher [Spaced-Repetition](https://en.wikipedia.org/wiki/SuperMemo)-Ansatz, den viele Karteikarten-Programme nutzen) mit den Standardparametern von [Anki](https://apps.ankiweb.net/).

## What it does
Er führt eine Karte durch Phasen: NEW → LEARNING → REVIEW (RELEARNING nach einem Lapse, also einer falschen Antwort auf eine bekannte Karte). Die erste richtige Antwort schickt eine Karte auf 3 Tage; jede weitere richtige Antwort multipliziert das Intervall mit der „Ease“ (also 3 → 8 → 20 → 50 → 125 Tage). Eine falsche Antwort auf eine neue Karte wiederholt sich nach 10 Minuten, nie früher (Entscheidung ADR-0007, „die Abstandsregeln“; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält).

## How it does it
Er liest nie selbst die Uhr und hat kein zufälliges „Fuzz“ in den Intervallen, ist also vollständig deterministisch (Entscheidung ADR-0003). Die Start-Ease ist 2,5, das Minimum 1,3, der Easy-Bonus 1,3 und der Hard-Faktor 1,2 (alles in `SchedulerConfig`). Das Verhalten ist festgenagelt durch die Tests `SpacingRulesTest` und `PeriodizationSimulationTest`, durch gemeinsame Konformitätsvektoren mit [[quizweb-domain]] und durch den [[mutation-check]].

## Where it sits in the pipeline
Direkt nach dem [[answer-grader]] in der Antwort-Pipeline; seine Ausgabe ist der neue `CardProgress`, den der [[study-controller]] speichert.

## Who receives its output
Der [[study-controller]] (und über ihn der [[progress-store]]).
