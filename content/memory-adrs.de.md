---
id: memory-adrs
lang: de
source_hash: 0ea9e0759545
title: ADRs von workflow-memory
---

## What it is
ADRs („Architecture Decision Records“) sind kurze Notizen, eine pro wichtiger Entscheidung, die die Gründe festhalten, damit später niemand raten muss. Diese Seite behandelt die ADRs von [[workflow-memory]]: 0001 Entscheidungen auf diese Weise festhalten; 0002 das Ereignisprotokoll; 0003 die Rollen von Giovanni und den Claude-Instanzen.

## What it does
ADR-0002 sagt, dass das Gedächtnis ein reines Anhänge-Protokoll ist (nur neue Dateien kommen hinzu, alte ändern sich nie), das eine reine Funktion in den aktuellen Stand verwandelt, statt eines Protokolls zwischen Maschinen. ADR-0003 sagt: Giovanni entscheidet und genehmigt; [[claude-code]] baut; der [[remote-assistant]] erledigt kurze Aufgaben nach denselben Regeln; die [[claude-app]] führt Gespräche und schreibt nur Gedächtnisereignisse. Die Instanzen sprechen nie direkt miteinander: workflow-memory ist ihre einzige gemeinsame Schnittstelle, und neue Projekte starten aus [[project-template]].

## How it does it
Jedes Prinzip wird durch einen Test oder einen Continuous-Integration-Auftrag durchgesetzt, der in der CLAUDE.md des Repositorys genannt ist; die Entscheidungen werden also geprüft und nicht nur aufgeschrieben.

## Where it sits in the pipeline
Hinter jeder Regel in diesem Wiki darüber, wer was darf.

## Who receives its output
Alle Claude-Instanzen und Giovanni.
