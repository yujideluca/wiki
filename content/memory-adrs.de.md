---
id: memory-adrs
lang: de
source_hash: 8ab2016c765b
title: ADRs von workflow-memory
---

## What it is
ADRs („Architecture Decision Records“, Architekturentscheidungsprotokolle) sind kurze Notizen, eine je wichtiger Entscheidung, die die Gründe festhalten, damit später niemand raten muss. Diese Seite behandelt die ADRs von [[workflow-memory]]: 0001 Entscheidungen so festhalten; 0002 das Ereignislog; 0003 die Rollen von Giovanni und den Claude-Instanzen; 0004 ein Programm misst und ein Skill urteilt; 0005 die Startkurzfassung kürzen und das Gedächtnis nach Werkzeug trennen; 0006 ein Ereignis kann nie später sein als der Moment, in dem es gelesen wird; 0007 Regeln werden nach Art der Aufgabe geholt.

## What it does
ADR-0002 sagt, dass das Gedächtnis ein reines Anhänge-Protokoll ist (nur neue Dateien kommen hinzu, alte ändern sich nie), das eine reine Funktion in den aktuellen Stand verwandelt, statt eines Protokolls zwischen Maschinen. ADR-0003 sagt: Giovanni entscheidet und genehmigt; [[claude-code]] baut; der [[remote-assistant]] erledigt kurze Aufgaben nach denselben Regeln; die [[claude-app]] führt Gespräche und schreibt nur Gedächtnisereignisse. Die Instanzen sprechen nie direkt miteinander: workflow-memory ist ihre einzige gemeinsame Schnittstelle, und neue Projekte starten aus [[project-template]]. ADR-0004 sagt, dass ein deterministisches Programm, [[pipeline-check]], misst und blockiert, während der Skill [[skill-revisao-manutencao]] dessen Bericht liest und nur Vorschläge macht; das Programm lebt in einem eigenen Repository und jedes Projekt legt sich auf eine Version fest, statt es zu kopieren ([[maintenance-pipeline]]). ADR-0005 (26.10.2026) kürzt den Start-Brief: Der Harvester ignoriert erzeugte Prompts, Codex nutzt seinen eigenen Geltungsbereich `instance:codex`, und der Brief war nach `/clear` kürzer (ADR-0007 machte später den ganzen Brief kurz). ADR-0006 (30.10.2026) behebt ein Uhrenproblem: Ein Schreiber ohne verlässliche Uhr, etwa die [[claude-app]], kann ein Ereignis Minuten in der Zukunft stempeln, und ein Test wählte dieses Ereignis einmal als „neuestes“ und schlug fehl. Code und Tests nutzen jetzt den Pfad, den `mem add` ausgibt, statt der Sortierreihenfolge des Protokolls, und beim Lesen wird jede Ereigniszeit auf die aktuelle Zeit begrenzt (der ursprüngliche Stempel bleibt als `ts_claimed` erhalten); so kann ein Schreiber mit falscher Uhr die Reihenfolge nicht durcheinanderbringen. Ein Stempel, der mehr als einen Tag voraus liegt, wird weiterhin unter Quarantäne gestellt. ADR-0007 (05.11.2026) antwortet auf einen Fehler vom 04.11.2026: Ein automatisches Schutzprogramm sperrte Giovannis Sitzungen, und die Regeln, die das verhindert hätten, gab es, sie erreichten die Chats aber nie, weil der Start-Brief etwa 17 KB (Kilobyte) groß war und ein Chat nur die ersten 2 KB sieht. Jetzt trägt jede Regel Tags (die Arten von Aufgabe, für die sie wichtig ist); der Brief gibt nur die wenigen `always`-Regeln und einen Index der Tags aus, und [[mem-rules]] gibt die vollen Regeln einer Aufgabenart aus, wenn Claude eine beginnt.

## How it does it
Jedes Prinzip wird durch einen Test oder einen Continuous-Integration-Auftrag durchgesetzt, der in der CLAUDE.md des Repositorys genannt ist; die Entscheidungen werden also geprüft und nicht nur aufgeschrieben.

## Where it sits in the pipeline
Hinter jeder Regel in diesem Wiki darüber, wer was darf.

## Who receives its output
Alle Claude-Instanzen und Giovanni.
