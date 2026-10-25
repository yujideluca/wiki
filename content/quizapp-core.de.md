---
id: quizapp-core
lang: de
source_hash: f46e9385279e
title: QuizApp-Modul :core
---

## What it is
Das Modul `:core` ist die „reine Kotlin“-Hälfte von [[quizapp]]: die gesamte Lernlogik, ohne jeden Teil von Android. Dass sie „rein“ ist, erzwingt der Build: Ein `import android.*` in diesem Modul lässt sich schlicht nicht kompilieren (Entscheidung ADR-0009; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Ein Gradle-Modul ist ein Teil des Projekts, der für sich gebaut wird.

## What it does
Es enthält die Domäne (die Regeln des Lernens: Karten, Fortschritt, den [[spaced-repetition-scheduler]], den [[answer-grader]], die [[study-pipeline]], die [[study-session]], das [[daily-goal]], den [[activity-calendar]] und den Codec der [[progress-backup]]), die Inhaltsschicht ([[card-factory]], [[distractor-factory]], die Parser sowie Prüfung und Wahl des Fragenpakets, [[question-pack]]) und die Debug-Kanäle ([[study-debug-log]]).

## How it does it
Kleine reine Funktionen werden zu Pipelines verkettet (eine Funktion ist „rein“, wenn dieselbe Eingabe immer dieselbe Ausgabe ergibt und sich sonst nichts ändert), Daten sind unveränderlich, und die Zeit wird über eine `Clock` hineingereicht, damit Tests sie steuern können. Abgedeckt ist es durch einfache JVM-Unit-Tests (sie laufen auf der Java Virtual Machine, ohne Emulator oder Handy) in `core/src/test`, die das [[quizapp-quality-gate]] ausführt; der [[fitness-check]] stellt außerdem sicher, dass das Modul frei von Android bleibt.

## Where it sits in the pipeline
Die innere Schicht: `ui → StudyController → domain/content/data`. Nichts in `:core` hängt vom App-Modul ab.

## Who receives its output
[[quizapp-app]], vor allem der [[study-controller]].

## Functions
- `Clock`: eingereichte Zeitquelle, damit Tests die Zeit steuern
- `CardAvailability` / `foldForSearch`: welche Karten pausiert oder entfernt sind; akzentfreie Suche („stuhle“ findet „Stühle“, und das ß zählt als „ss“: „strasse“ findet „Straße“)
- `HeatColor`: Farbverlauf des Serienkalenders
- `AppUpdate` / `shouldCheckForUpdate`: Update-Regeln (höchstens einmal pro 30 s)
- `SchedulerConfig`, `GraderConfig`: die einstellbaren Zahlen
- `ContentTranslations`: englische Erklärtexte auf de/pt/es
- `ContentPack`: das Fragenpaket (Manifest, Dateiliste, Prüfsummenprüfung, `prefersDownloaded`: ein geladenes Paket ersetzt das eingebaute nur, wenn es neuer ist)
- `VocabularyParsers`, `VocabularyModels`: JSON-Vokabular (JavaScript Object Notation) zu Kotlin-Objekten
