---
id: pipeline-check
lang: de
source_hash: 46fe897f0496
title: pipeline-check
---

## What it is
pipeline-check ist ein Programm, in [Rust](https://www.rust-lang.org/) geschrieben (die Sprache war Giovannis Wahl), das ein Softwareprojekt vermisst und dafür sorgt, dass eine Maschine, nicht Claudes gute Gewohnheit, einen schlechten Merge verweigert (Entscheidung ADR-0013 in QuizApp; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Es ersetzte das ältere Python-Skript `fitness_check.py`.

## What it does
Es schreibt `build/pipeline-check/report.json`: Projekt, Datum, Modus (`local` oder `ci`), eine Liste von Prüfungen mit jeweils einem Status (`ok`, `aviso` = Warnung, `falha` = Fehlschlag, `pulado` = übersprungen), einem Wert und einer Grenze, dazu einen `dora`-Block mit Lieferkennzahlen (DORA: DevOps Research and Assessment). Es endet mit Code 1, wenn eine Prüfung `falha` ist; eine Warnung lässt nie fehlschlagen. Die Prüfungen sind:
- das eigene Quality Gate des Projekts ([[quizapp-quality-gate]]), einmal ausgeführt;
- die Architekturprüfung: Im Modul `:core` darf kein Import `android.*` oder `androidx.*` vorkommen; das wird aus dem Quellcode gelesen;
- Fitnessfunktionen (automatische Grenzen, etwa für die Dateigröße), mit Warnung ab 80 % einer Grenze und Fehlschlag bei 100 %;
- DORA-Zahlen aus Git, dem Release-Feed und dem Entscheidungsprotokoll;
- und nur im lokalen Modus, ob der letzte Lauf der Continuous Integration (CI, automatische Prüfungen auf GitHub) grün ist und ob der Branch-Schutz den Auftrag `gate` verlangt (nur lesend, über den Befehl `gh` von GitHub). Ein Repository, das den Schutz nicht haben kann, hält den Grund mit `protection_exception` im Abschnitt `[github]` seiner `pipeline-check.toml` fest; die Prüfung ist dann `aviso` (eine Warnung, die den Lauf nicht scheitern lässt), nennt den Grund und ist nie `ok`.
- wenn das Projekt in seiner `pipeline-check.toml` einen Abschnitt `[shellcheck]` hat: ob seine Shell-Skripte `shellcheck` bestehen (ein Programm, das Fehler in Shell-Skripten findet). Geprüft wird jede von git verfolgte `.sh`-Datei plus die dort aufgelisteten Zusatzdateien, mit der gewählten Strenge (Anforderung PC-15, Version v0.4.0). Ein sauberer Lauf ist `ok`, ein Fund ist `falha` und nennt den ersten, und ein Rechner ohne `shellcheck` ergibt `pulado`.
Eine Prüfung, die nicht laufen konnte, ist `pulado`, nie `ok`; war sie verlangt, zählt sie als `falha`.

Neben dem Bericht hat das Programm zwei weitere Modi: `--traceability` prüft, ob jede Anforderung einen Test hat ([[check-traceability]], PC-14), und `--pre-push` ist der unten beschriebene git-Hook (PC-13). Mit `--no-github` fragt es nie GitHub (PC-12).

## How it does it
Es ist Rust mit den Bibliotheken `serde`, `toml` und `clap` und startet `git` und `gh` als eigene Prozesse. Die Grenzen stehen in `pipeline-check.toml` jedes Projekts und werden nur von Giovanni geändert, mit einer Zeile im Entscheidungsprotokoll. Das Skript `tools/pipeline-check.sh` baut und startet es; das Gate ruft es mit `--measure-only` auf, damit es das Gate nicht erneut ausführt (keine Rekursion). Seine eigenen Anforderungen (PC-1 bis PC-15) haben mit `REQ` getaggte Tests. Es durchlief zuerst seinen eigenen Prozess: Die Skill [[skill-gerar-teste-automatizado]] schrieb fehlersuchende Tests (Protokoll in `tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`), die sechs Fehler fanden, alle behoben, und eine selbstgebaute Mutationsprüfung (`mutants.py`, die absichtlich Fehler einbaut) fängt jeden eingebauten Fehler.

## Where it sits in the pipeline
Die CI führt es statt des bloßen Gates aus ([[quizapp-ci]]), und Claude startet es zu Beginn jeder [[skill-revisao-manutencao]]; es ist Teil der [[maintenance-pipeline]]. Das Programm existiert nur einmal, in einem eigenen öffentlichen Repository (`yujideluca/pipeline-check`). [[project-template]], [[quizapp]], das [[wiki]], [[quizweb]], [[workflow-memory]], [[remote-terminal]] und [[processing-sketches]] legen jeweils in einer Datei `pipeline-check.version` einen Versions-Tag fest (v0.5.0 in workflow-memory, v0.4.0 in den anderen) und behalten nur ihre eigene `pipeline-check.toml` und ein kleines Runner-Skript. Es läuft auch als Git-Pre-Push-Hook (`--pre-push`), der den Push von `main` stoppt, wenn eine Prüfung fehlschlägt, weil der Branch-Schutz bei privaten Repositories im kostenlosen Tarif nicht verfügbar ist. Warum ein Repository statt Kopien: ADR-0003 in jenem Repository. Das Repository steht unter der MIT-Lizenz (eine kurze, freizügige Lizenz: Jeder darf die Software nutzen, kopieren und ändern, solange der Copyright-Hinweis erhalten bleibt); sie wurde am 2026-10-25 in der Datei `LICENSE` und in `Cargo.toml` festgelegt.

## Who receives its output
[[quizapp-ci]] (das rote oder grüne Zeichen) und [[skill-revisao-manutencao]] (die `report.json` liest und nie erneut misst).

## Functions
- `classify`: ok unter dem Warnanteil, aviso bis zur Grenze, falha ab der Grenze
- `arch::check`: Import-Scan des reinen Moduls und seiner Build-Datei
- `dora::compute`: Häufigkeit, Durchlaufzeit, Nacharbeit und Präventivanteil, `null` ohne Daten
