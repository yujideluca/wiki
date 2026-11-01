---
id: wiki-quality-gate
lang: de
source_hash: 4d1ac0bcadfd
title: Wiki Quality Gate
---

## What it is
Das Quality Gate ist die eine Definition von „bestanden“ des Wikis, abgeleitet aus dem [[template-quality-gate]]. Die CI (Continuous Integration, die automatischen Prüfungen auf GitHub) führt dasselbe Skript aus.

## What it does
Es führt fünf Schritte aus. (1) Die Elixir-Tests (`mix test`: Prüfer, Build, Veraltung, Hook, Veröffentlichen, Anmelde-Tor, Köder). (2) Die Elm-Tests (`elm-test`) und einen optimierten Elm-Build. (3) Die Anforderungsrückverfolgung ([[check-traceability]]), die auch fehlschlägt, wenn die neu erzeugte `docs/TRACEABILITY.md` von der eingecheckten abweicht. (4) `wiki check` auf dem echten Inhalt, nachdem die Datei mit den Datenschutzmustern `server/priv/privacy-patterns.tsv` mit der Kopie in workflow-memory verglichen wurde (auf dem Laptop). (5) Fitnessprüfungen, Grenzwerte, die das Projekt gesund halten: die Grenzwerte in `pipeline-check.toml`, gemessen von [[pipeline-check]] (die Architekturregel, shellcheck auf den Skripten, keine Quelldatei über 800 Zeilen, das Gate unter 1200 Sekunden) und das optimierte App-Bündel höchstens 200.000 Byte komprimiert.

## How it does it
Es ist ein [Bash](https://www.gnu.org/software/bash/)-Skript. Auf GitHub führt es `wiki check` ohne `--local` aus, weil die anderen privaten Repositories dort nicht sichtbar sind.

## Where it sits in the pipeline
Vor dem Veröffentlichen von Codeänderungen und bei jedem Push.

## Who receives its output
[[github]] (das CI-Ergebnis).

## Notes
Der Regressionstest für Zustandsschreibvorgänge nutzt `server/test/support/stamp_writer.exs`: Zwei unabhängige Elixir-Laufzeiten schreiben jeweils 20.000 Veröffentlichungszeitpunkte über das echte Modul. Er prüft, dass parallele Assistentenprozesse ohne Umbenennungskollision enden, einen gültigen Zeitpunkt und keine temporären Dateien hinterlassen. Diese Testdatei gehört zum Qualitäts-Gate und ist kein undokumentiertes neues Programm. Die Abdeckungsmessung ist getrennt: Das Standard-Gate führt Tests aus, ohne die voreingestellte Abdeckungsschwelle von Mix zu ändern.
