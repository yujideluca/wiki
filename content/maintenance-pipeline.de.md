---
id: maintenance-pipeline
lang: de
source_hash: 5ff1ffa0a867
title: Wartungs-Pipeline (erst messen, dann urteilen)
---

## What it is
So werden Giovannis Softwareprojekte wartbar gehalten: Ein Programm misst und blockiert, eine Skill urteilt und schlägt vor, und beide sprechen nur über eine Datei miteinander, `report.json`. Die Trennung ist gewollt (ADR-0013 in QuizApp; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält): Zahlen sollen von einer Maschine kommen, die man nicht überreden kann, und das Urteil von Claude, das sie abwägen kann.

## What it does
Sie macht die Regeln aus [[maintenance-policy]] zu etwas, das eine Maschine durchsetzt: Der CI-Auftrag (Continuous Integration, automatische Prüfungen bei jedem Push) schlägt bei einer `falha` (Fehlschlag) fehl, und der Monats-Review liest dieselben Zahlen, statt von Hand zu messen.

## How it does it
[[pipeline-check]] läuft in der CI und auf dem Laptop; [[skill-revisao-manutencao]] liest seinen Bericht. Das Programm wird nicht in Projekte kopiert: Es lebt in einem eigenen Repository, `yujideluca/pipeline-check`, und jedes Projekt legt in `pipeline-check.version` eine Version fest. Um einen Merge wirklich zu blockieren, muss der Branch-Schutz von GitHub den CI-Auftrag verlangen, und das ändert nur Giovanni. Bei einem privaten Repository eines kostenlosen GitHub-Tarifs ist dieser Schutz nicht verfügbar (GitHub antwortet mit Fehler 403); deshalb stoppt eine lokale Prüfung vor dem Push (`pipeline-check --pre-push`, aktiviert mit `git config core.hooksPath tools/hooks`) den Push von `main`, wenn eine Prüfung fehlschlägt. Giovanni hat die lokale Prüfung am 2026-10-24 gewählt. Am 2026-10-25 entschied Giovanni stattdessen, die Repositories, die Schutz brauchen, öffentlich zu machen, weil GitHub den Branch-Schutz (eine Einstellung, die Änderungen an `main` verweigert, bis genannte Prüfungen bestanden sind) bei öffentlichen Repositories des kostenlosen Tarifs akzeptiert. Seitdem ist der CI-Auftrag `gate` in german-quiz (dem Projekt QuizApp), remote-terminal, wiki und processing-sketches eine verlangte Prüfung auf `main`, und `pipeline-check` meldet dort `protecao-de-branch` als `ok` (`ok`: die Prüfung ist bestanden). workflow-memory ist öffentlich, aber noch nicht geschützt: Sein Auftrag `mem` pusht abgeleitete Dateien direkt nach `main`, mit dem eingebauten Token von GitHub, und eine verlangte Prüfung könnte diese Pushes blockieren; deshalb muss Giovanni entscheiden, wie damit umgegangen wird. Die Prüfung vor dem Push bleibt bestehen. Sie wurde zuerst auf [[quizapp]] angewandt, dann in die anderen Projekte und nach [[project-template]] kopiert.

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
