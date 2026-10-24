---
id: maintenance-pipeline
lang: de
source_hash: de72ae0e0f79
title: Wartungspipeline (erst messen, dann urteilen)
aliases: [Wartungsprozess]
---

## What it is
So bleiben Giovannis Softwareprojekte wartbar: ein Programm misst und blockiert, ein Skill urteilt und schlägt vor, und beide sprechen nur über `report.json` miteinander.

## What it does
Macht aus den Regeln der [[maintenance-policy]] etwas, das eine Maschine durchsetzt: Der CI-Job scheitert bei einem `falha`, und die monatliche Überprüfung liest dieselben Zahlen, statt von Hand zu messen.

## How it does it
[[pipeline-check]] läuft in der CI und auf dem Laptop; [[skill-revisao-manutencao]] liest den Bericht. Einen Merge zu blockieren braucht außerdem einen Branch-Schutz, der den CI-Job verlangt; den ändert nur Giovanni. Bei einem privaten Repository im kostenlosen GitHub-Tarif gibt es diesen Schutz nicht (GitHub antwortet 403); ein roter CI-Lauf allein stoppt einen Merge also noch nicht. Optionen: GitHub Pro, ein öffentliches Repository oder eine lokale Prüfung vor dem Push. Zuerst auf [[quizapp]] angewandt, dann auf die anderen Projekte und in [[project-template]] kopiert.

## Where it sits in the pipeline
Zwischen jedem Push und der monatlichen Überprüfung: [[quizapp-ci]], dann [[monthly-architecture-review]].

## Who receives its output
Giovanni.

## Steps
1. Ein Push startet den CI-Job `gate`, der [[pipeline-check]] ausführt.
2. Jedes `falha` lässt den Job scheitern; der Branch-Schutz stoppt den Merge.
3. Ein `aviso` lässt nie scheitern, erscheint aber im Bericht.
4. Bei der monatlichen Überprüfung macht [[skill-revisao-manutencao]] aus Warnungen und Fehlern priorisierte `debt`-Vorschläge.
5. Giovanni entscheidet; der Skill trägt eine Zeile Präventiv ins Entscheidungslog ein und veröffentlicht das Wiki.
