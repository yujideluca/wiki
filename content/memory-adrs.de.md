---
id: memory-adrs
lang: de
source_hash: 763826d6bfb8
title: ADRs von workflow-memory
---

## What it is
ADRs („Architecture Decision Records“) sind kurze Notizen, eine pro wichtiger Entscheidung, die die Gründe festhalten, damit später niemand raten muss. Diese Seite behandelt die ADRs von [[workflow-memory]]: 0001 Entscheidungen auf diese Weise festhalten; 0002 das Ereignisprotokoll; 0003 die Rollen von Giovanni und den Claude-Instanzen; 0004 ein Programm misst und ein Skill urteilt; 0006 ein Ereignis kann nie später sein als der Moment, in dem es gelesen wird.

## What it does
ADR-0002 sagt, dass das Gedächtnis ein reines Anhänge-Protokoll ist (nur neue Dateien kommen hinzu, alte ändern sich nie), das eine reine Funktion in den aktuellen Stand verwandelt, statt eines Protokolls zwischen Maschinen. ADR-0003 sagt: Giovanni entscheidet und genehmigt; [[claude-code]] baut; der [[remote-assistant]] erledigt kurze Aufgaben nach denselben Regeln; die [[claude-app]] führt Gespräche und schreibt nur Gedächtnisereignisse. Die Instanzen sprechen nie direkt miteinander: workflow-memory ist ihre einzige gemeinsame Schnittstelle, und neue Projekte starten aus [[project-template]]. ADR-0004 sagt, dass ein deterministisches Programm, [[pipeline-check]], misst und blockiert, während der Skill [[skill-revisao-manutencao]] dessen Bericht liest und nur Vorschläge macht; das Programm lebt in einem eigenen Repository und jedes Projekt legt sich auf eine Version fest, statt es zu kopieren ([[maintenance-pipeline]]). ADR-0005 (26.10.2026) kürzt den Start-Brief: Der Harvester ignoriert erzeugte Prompts, Codex nutzt seinen eigenen Geltungsbereich `instance:codex`, und der Brief ist nach `/clear` kürzer. ADR-0006 (30.10.2026) behebt ein Uhrenproblem: Ein Schreiber ohne verlässliche Uhr, etwa die [[claude-app]], kann ein Ereignis Minuten in der Zukunft stempeln, und ein Test wählte dieses Ereignis einmal als „neuestes“ und schlug fehl. Code und Tests nutzen jetzt den Pfad, den `mem add` ausgibt, statt der Sortierreihenfolge des Protokolls, und beim Lesen wird jede Ereigniszeit auf die aktuelle Zeit begrenzt (der ursprüngliche Stempel bleibt als `ts_claimed` erhalten); so kann ein Schreiber mit falscher Uhr die Reihenfolge nicht durcheinanderbringen. Ein Stempel, der mehr als einen Tag voraus liegt, wird weiterhin unter Quarantäne gestellt.

## How it does it
Jedes Prinzip wird durch einen Test oder einen Continuous-Integration-Auftrag durchgesetzt, der in der CLAUDE.md des Repositorys genannt ist; die Entscheidungen werden also geprüft und nicht nur aufgeschrieben.

## Where it sits in the pipeline
Hinter jeder Regel in diesem Wiki darüber, wer was darf.

## Who receives its output
Alle Claude-Instanzen und Giovanni.
