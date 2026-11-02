---
id: checks-status-quo
lang: de
source_hash: 4aabc030f0c3
title: status-quo: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer des Repositorys `status-quo` (siehe [[status-quo-design]] und [[status-quo-layout]]), eines Rust-Workspaces, der aus [[project-template]] gestartet wurde. Es liegt im privaten GitHub-Repository `yujideluca/status-quo`. Der Lauf der kontinuierlichen Integration beim ersten Commit bestand am 2026-11-02; Branch-Schutz lässt sich bei einem privaten Repository im kostenlosen Tarif nicht aktivieren, daher schlägt die Prüfung `protecao-de-branch` weiter fehl.

## What it does
Das Gate (`tools/quality_gate.sh`) führt fünf Schritte nacheinander aus: Rust-Formatierung (`cargo fmt --check`), Compiler-Diagnose ohne zugelassene Warnungen (clippy) samt der gesamten Testsuite, eine projekteigene Grenzprüfung (`tools/rust_architecture.rs`), Anforderungs-Rückverfolgbarkeit und die Fitness-Obergrenze für die Gate-Dauer (1200 Sekunden). Am 2026-11-02 bestanden alle fünf.

Ein optionaler sechster Schritt läuft nur, wenn die Variable `STATUS_QUO_E2E=1` gesetzt ist: `tools/ui_e2e.sh`, der Desktop-End-to-End-Test des echten Trays (er pausiert das laufende Tray, steuert eine private Kopie mit einer virtuellen Maus und schreibt `build/e2e/report.json`). Er ist optional, weil er eine Wayland-Sitzung, ein beschreibbares `/dev/uinput` und `spectacle` braucht; ein normaler Lauf und der Lauf der kontinuierlichen Integration (CI, ohne Desktop) lassen ihn deshalb aus, und das Skript überspringt sich selbst mit Begründung, wenn etwas fehlt. Der Test gehört nicht zur Fünf-Schritte-Definition des Bestehens: Er ergänzt das Gate, indem er prüft, was kein Unit-Test kann, und `docs/MAINTENANCE.md` Abschnitt 7 verlangt ihn vor dem Abschluss einer größeren Tray-Änderung und vor einem Release. Ein echter Lauf am 2026-11-02 bestand 22 Prüfungen. Seine CPU-Prüfung im Leerlauf ist eine Obergrenze von 2 %, während das 1-%-Ziel von SQ-23 (der Anforderung an die Leerlaufkosten) als Datum festgehalten und weiterhin verfehlt wird (1,30 % eines Kerns). Einzelheiten: [[status-quo]].

Die Grenzprüfung existiert, weil der gemeinsame Prüfer (`pipeline-check` v0.4.0) nur Java und Kotlin untersucht. Sie weist grafische, Datei-, Prozess- oder Netzwerkabhängigkeiten in den drei portablen Paketen zurück, erlaubt im wiederverwendbaren Tray nur die Oberflächenbibliothek egui und hat eigene Selbsttests, die Fehler einpflanzen und deren Zurückweisung verlangen. Alle 29 Anforderungen (Gruppe SQ; SQ-29 liegt zum Zeitpunkt der Prüfung im nicht committeten Arbeitsverzeichnis) in `docs/REQUIREMENTS.md` haben einen Test mit einem eigenständigen Kommentar `// REQ SQ-n`; die Suche deckt `.rs`-Dateien unter `crates` und `tools` ab. Der Wortlaut von SQ-29 wurde am 2026-11-02 ersetzt (Edit tray als freie Leinwand, Entscheidung ADR-0005 (Architecture Decision Record), siehe [[status-quo]]); seine Markierung steht in `crates/core/tests/behavior.rs`, `crates/tray/src/layout.rs` und `crates/tray/tests/layout.rs`, und `docs/TRACEABILITY.md` führt dafür `behavior.rs, layout.rs` auf. Das Gate wurde für diese Seitenaktualisierung nicht ausgeführt. Ein Tag belegt, dass ein Test existiert, nicht dass sich der echte Desktop richtig verhält; Fensterstapelung, Start beim Login und die Ressourcengrenzen brauchen daher eigene Beobachtung (die Leerlauf-CPU liegt derzeit bei 2,05 % eines Kerns bei einem Ziel von 1 %).

## How it does it
CI (Continuous Integration) nutzt den Standard-Workflow (`pipeline-check --mode ci`, höchstens 60 Minuten) und ergänzt einen Browser-Build für das Ziel `wasm32`. `pipeline-check.toml` nennt das Projekt, verweist auf das Repository `yujideluca/status-quo`, verlangt die Prüfung `gate` auf `main` und führt `tools/hooks/pre-push` für den Shell-Prüfer auf. Vier ADRs (Architecture Decision Records) existieren, dazu eine leere Vorlage `docs/adr/0000-template.md`: 0001 (Entscheidungen festhalten), 0002 (portable Rust-Widgets), 0003 (das Programm misst, der Skill urteilt) und 0004 (Host-Kompatibilitätsschicht).

Drei Dokumente in `docs/` stützen die Prüfungen. `TRACEABILITY.md` wird von `pipeline-check --traceability` erzeugt: eine Zeile je Anforderung mit den Testdateien, die ihre Markierung tragen (SQ-8 nennt zum Beispiel `lifecycle.rs`, `models.rs`, `workers.rs`). `TESTES-AUTOMATIZADOS.md`, auf Portugiesisch geschrieben, ist die Aufzeichnung der fehlerfindenden Tests: eine Tabelle von Risiken (Konfiguration, Vertrag, Ansichtsmodelle in `crates/widgets/tests/models.rs`, Persistenz, Quellen, Transport, Tray, Grenzprüfung, Browser-Wiederverwendung) gegen Testdatei und erwartetes Verhalten, danach die ersten Fünf-Minuten-Ressourcenläufe (2,05 % eines Kerns, 115 MiB) und die Beobachtungen zur Host-Kompatibilitätsschicht. Sie hält fest, dass weder ein Abdeckungsprozentsatz noch ein Mutationswert erfasst wurde; der einzige mutationsartige Beleg ist ein Lauf der Grenzprüfung mit eingepflanzten Fehlern. `MAINTENANCE.md` enthält die Methode der Vorlage für Schulden, die monatliche Prüfung und `pipeline-check`.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
