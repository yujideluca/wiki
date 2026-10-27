---
id: maintenance-pipeline
lang: de
source_hash: 66c2e90145c8
title: Wartungs-Pipeline (erst messen, dann urteilen)
---

## What it is
So werden Giovannis Softwareprojekte wartbar gehalten: Ein Programm misst und blockiert, eine Skill urteilt und schlägt vor, und beide sprechen nur über eine Datei miteinander, `report.json`. Die Trennung ist gewollt (ADR-0013 in QuizApp; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält): Zahlen sollen von einer Maschine kommen, die man nicht überreden kann, und das Urteil von Claude, das sie abwägen kann.

## Flow
trigger t1: Jemand pusht in das Repository eines Projekts | [[quizapp-ci]]
step s1: Der Prüf-Job gate führt pipeline-check aus | [[pipeline-check]]
decide d1: Schlägt eine Prüfung fehl (falha)?
step s2: Branch-Schutz oder die lokale Pre-Push-Prüfung stoppt den Merge | [[maintenance-policy]]
step s3: Warnungen (aviso) erscheinen in report.json, lassen aber nie scheitern
trigger t2: Die monatliche Überprüfung ist fällig | [[monthly-architecture-review]]
step s4: Der Review-Skill macht aus Warnungen und Fehlern priorisierte Schuldenvorschläge | [[skill-revisao-manutencao]]
step s5: Giovanni entscheidet, was geschieht | [[giovanni]]
product p1: Eine Änderung, die alle Prüfungen bestanden hat
product p2: Ein blockierter Push
product p3: Schulden-Issues und eine Preventive-Zeile im Entscheidungsprotokoll

t1 -> s1
s1 -> d1
d1 -ja-> s2
d1 -nein-> s3
s2 -> p2
s3 -> p1
s3 -> s4
t2 -> s4
s4 -> s5
s5 -> p3

## What it does
Sie macht die Regeln aus [[maintenance-policy]] zu etwas, das eine Maschine durchsetzt: Der CI-Auftrag (Continuous Integration, automatische Prüfungen bei jedem Push) schlägt bei einer `falha` (Fehlschlag) fehl, und der Monats-Review liest dieselben Zahlen, statt von Hand zu messen.

## How it does it
[[pipeline-check]] läuft in der CI und auf dem Laptop; [[skill-revisao-manutencao]] liest seinen Bericht. Das Programm wird nicht in Projekte kopiert: Es lebt in einem eigenen Repository, `yujideluca/pipeline-check`, und jedes Projekt legt in `pipeline-check.version` eine Version fest. Um einen Merge wirklich zu blockieren, muss der Branch-Schutz von GitHub den CI-Auftrag verlangen, und das ändert nur Giovanni. Bei einem privaten Repository eines kostenlosen GitHub-Tarifs ist dieser Schutz nicht verfügbar (GitHub antwortet mit Fehler 403); deshalb stoppt eine lokale Prüfung vor dem Push (`pipeline-check --pre-push`, aktiviert mit `git config core.hooksPath tools/hooks`) den Push von `main`, wenn eine Prüfung fehlschlägt. Giovanni hat die lokale Prüfung am 2026-10-24 gewählt. Am 2026-10-25 entschied Giovanni stattdessen, die Repositories, die Schutz brauchen, öffentlich zu machen, weil GitHub den Branch-Schutz (eine Einstellung, die Änderungen an `main` verweigert, bis genannte Prüfungen bestanden sind) bei öffentlichen Repositories des kostenlosen Tarifs akzeptiert. Seitdem ist der CI-Auftrag `gate` in german-quiz (dem Projekt QuizApp), remote-terminal, wiki und processing-sketches eine verlangte Prüfung auf `main`, und `pipeline-check` meldet dort `protecao-de-branch` als `ok` (`ok`: die Prüfung ist bestanden). workflow-memory bleibt absichtlich ungeschützt: Ein Test auf einem Wegwerf-Branch hat gezeigt, dass GitHub den Push seines Auftrags `mem` (er schickt abgeleitete Dateien direkt nach `main`, mit dem eingebauten Token von GitHub) ablehnt, wenn `gate` verlangt wird, und dass GitHub diesem eingebauten Token bei einem persönlichen Konto keine Ausnahme von der Regel erlaubt. Giovanni hat gewählt, dort die lokale Prüfung vor dem Push beizubehalten. Seit pipeline-check v0.5.0 hält die `pipeline-check.toml` von workflow-memory das mit `protection_exception` fest, und der Bericht zeigt `protecao-de-branch` als `aviso` (eine Warnung, die den Lauf nicht scheitern lässt) mit dem Grund. Sie wurde zuerst auf [[quizapp]] angewandt, dann in die anderen Projekte und nach [[project-template]] kopiert.

## Where it sits in the pipeline
Zwischen jedem Push und dem Monats-Review: [[quizapp-ci]], dann [[monthly-architecture-review]].

## Who receives its output
Giovanni.

## Steps
1. Ein Push startet den CI-Auftrag `gate`, der [[pipeline-check]] ausführt.
2. Jede `falha` lässt den Auftrag fehlschlagen; der Branch-Schutz (oder die lokale Prüfung vor dem Push) stoppt den Merge.
3. Ein `aviso` (Warnung) lässt nie fehlschlagen, erscheint aber im Bericht.
4. Beim Monats-Review macht [[skill-revisao-manutencao]] aus Warnungen und Fehlschlägen priorisierte `debt`-Vorschläge.
5. Giovanni entscheidet; die Skill trägt eine Präventiv-Zeile ins Entscheidungsprotokoll ein und veröffentlicht das Wiki.
