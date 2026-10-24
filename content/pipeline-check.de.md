---
id: pipeline-check
lang: de
source_hash: 982d0c28d29d
title: pipeline-check
aliases: [report.json]
---

## What it is
Ein Rust-Programm, das ein Projekt misst und dafür sorgt, dass die Maschine – nicht Claudes Gewohnheit – einen schlechten Merge ablehnt (ADR-0013). Es ersetzt `fitness_check.py`. Die Sprache hat Giovanni gewählt.

## What it does
Schreibt `build/pipeline-check/report.json` (Projekt, Datum, Modus `local` oder `ci`, Prüfungen mit Status `ok`/`aviso`/`falha`/`pulado`, Wert und Grenze sowie einen `dora`-Block) und endet mit 1, wenn eine Prüfung `falha` ist; eine Warnung lässt nie scheitern. Prüfungen: das Projekt-Tor ([[quizapp-quality-gate]]) läuft einmal; die Architekturprüfung (kein Import von `android.*` oder `androidx.*` in `:core`, aus dem Quelltext gelesen); Fitnessfunktionen mit Warnung ab 80 % der Grenze und Fehler bei 100 %; DORA-Werte aus Git, dem Release-Feed und dem Entscheidungslog; und nur im lokalen Modus, ob der letzte CI-Lauf grün ist und der Branch-Schutz den Job `gate` verlangt (nur lesend, über `gh`). Eine Prüfung, die nicht laufen konnte, ist `pulado`, nie `ok`; ist sie verpflichtend, ist sie `falha`.

## How it does it
Rust mit `serde`, `toml` und `clap`; `git` und `gh` werden als Prozesse aufgerufen. Die Grenzen stehen in `pipeline-check.toml` und ändern sich nur durch Giovanni mit einer Zeile im Entscheidungslog. `tools/pipeline-check.sh` baut und startet es; das Tor ruft es mit `--measure-only` auf (keine Rekursion). Anforderungen PC-1..PC-11, Tests mit `REQ` markiert. Es hat zuerst den eigenen Prozess durchlaufen: Der Skill [[skill-gerar-teste-automatizado]] schrieb fehlersuchende Tests (`tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`), die sechs Fehler fanden (alle behoben), und eine handgemachte Mutationsprüfung (`mutants.py`) fängt jeden eingepflanzten Fehler.

## Where it sits in the pipeline
Die CI führt es statt des bloßen Tors aus ([[quizapp-ci]]); Claude startet es zu Beginn jeder [[skill-revisao-manutencao]]. Teil der [[maintenance-pipeline]]. Das Programm liegt nur einmal in einem eigenen öffentlichen Repository (`yujideluca/pipeline-check`); [[project-template]], [[quizapp]], [[wiki]], [[quizweb]], [[workflow-memory]], [[remote-terminal]] und [[processing-sketches]] legen einen Tag in `pipeline-check.version` fest (jetzt v0.2.0) und behalten nur ihre eigene `pipeline-check.toml` und ein kleines Startskript. Es läuft auch als Git-Pre-Push-Hook (`--pre-push`), der einen Push von `main` stoppt, wenn eine Prüfung fehlschlägt, weil der Branch-Schutz bei privaten Repositories im kostenlosen Tarif nicht verfügbar ist. Warum ein Repository statt Kopien: ADR-0003 in diesem Repository.

## Who receives its output
[[quizapp-ci]] (rote oder grüne Markierung) und [[skill-revisao-manutencao]] (liest `report.json`, misst nie neu).

## Functions
- `classify`: ok unter dem Warnanteil, aviso bis zur Grenze, falha ab der Grenze
- `arch::check`: Import-Scan des reinen Moduls und seiner Build-Datei
- `dora::compute`: Takt, Durchlaufzeit, Nacharbeit und Vorbeugungsanteil, `null` ohne Daten
