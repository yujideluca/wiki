---
id: workflow-memory
lang: de
source_hash: ef53006f253a
title: workflow-memory (gemeinsames Gedächtnis)
---

## What it is
workflow-memory ist das gemeinsame, langlebige Gedächtnis aller Claude-Assistenten, die Giovanni nutzt. Ein Claude-Chat vergisst normalerweise alles, wenn er endet; dieses Projekt sorgt dafür, dass eine einmal geäußerte Vorliebe („antworte in der Sprache, in der ich geschrieben habe“) auch Monate später in einem anderen Chat auf einem anderen Gerät noch gilt. Es ist ein öffentliches Repository (`yujideluca/workflow-memory`, seit 2026-10-25) und liegt in `~/dev/workflow-memory`. Es hat absichtlich keinen Branch-Schutz: Sein Auftrag `mem` pusht abgeleitete Dateien nach `main`, und eine verlangte Prüfung würde sie ablehnen; deshalb übernimmt die lokale Prüfung vor dem Push, und die `pipeline-check.toml` hält die Ausnahme fest ([[maintenance-pipeline]]). Es ersetzte das stillgelegte Protokoll aus [[retired-workflow-pipeline]].

## Flow
trigger t1: Giovanni nennt eine Korrektur oder eine dauerhafte Vorliebe | [[giovanni]]
step s1: Claude Code schreibt es mit mem; die Claude-App über den Connector | [[mem]], [[mem-github-connector]]
step s2: Eine neue Datei kommt ins Protokoll und wird nie mehr bearbeitet | [[events-log]]
step s3: Eine GitHub-Aktion prüft die Datei und baut die lesbaren Ansichten neu | [[mem-action]], [[memory-views]]
step s4: memory-fold liest das Protokoll und ermittelt den aktuellen Stand, die jüngste Entscheidung gewinnt | [[memory-fold]]
trigger t2: Ein neuer Chat beginnt | [[claude-code]]
step s5: Der Start-Hook gibt die Zusammenfassung aus | [[hook-session-start]], [[session-brief]]
product p1: Jede Claude-Instanz befolgt die Vorliebe in späteren Chats
product p2: Eine Prüfdatei, die auf Giovanni wartet | [[memory-views]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s3 -> p2
s4 -> s5
t2 -> s5
s5 -> p1

## Architecture
### Kontext
person g: Giovanni — nennt Vorlieben und Korrekturen | [[giovanni]]
external c: Claude Code — liest die Kurzfassung, schreibt Ereignisse | [[claude-code]]
external x: Codex — dasselbe, mit eigenem Gedächtnisbereich | [[codex]]
system w: workflow-memory — das gemeinsame Gedächtnis von Giovannis Systemen
external h: GitHub — führt die Prüfungen aus und bewahrt den Verlauf | [[github]]

g -sagt-> c
g -sagt-> x
c -schreibt Ereignisse nach und liest die Kurzfassung aus-> w
x -schreibt Ereignisse nach und liest die Kurzfassung aus-> w
w -wird geprüft und neu gebaut auf-> h

### Container
person g: Giovanni | [[giovanni]]
external c: Claude Code | [[claude-code]]
container hk: Hook beim Chat-Start — gibt die Kurzfassung aus | [[hook-session-start]]
container m: Befehl mem — fügt Ereignisse hinzu, faltet sie, sucht | [[mem]]
store ev: Ereignisprotokoll — eine Datei pro Ereignis, nur anhängen | [[events-log]]
store vw: Ansichten — abgeleitete Zusammenfassungen, nie von Hand bearbeitet | [[memory-views]]
container ci: GitHub-Job — baut die Ansichten neu, weist Änderungen an alten Ereignissen ab | [[mem-action]]

g -sagt-> c
c -startet-> hk
c -führt aus-> m
hk -fragt die Kurzfassung ab-> m
m -ergänzt-> ev
m -baut neu-> vw
ci -prüft-> ev
ci -baut neu-> vw

## What it does
Es bewahrt Vorlieben, Fakten, Entscheidungen und offene Punkte (noch zu erledigende Dinge) auf und zeigt die relevanten zu Beginn jedes Chats als [[session-brief]]. Es ist der einzige Kanal zwischen den verschiedenen Claude-Instanzen ([[claude-code]], dem [[remote-assistant]] und der [[claude-app]]); das ist Entscheidung ADR-0003 in [[memory-adrs]] (ein ADR, „Architecture Decision Record“, ist eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält).

## How it does it
Das Gedächtnis ist ein Protokoll: Jeder Eintrag ist eine neue Datei, die danach nie bearbeitet wird, abgelegt in [[events-log]]. Eine Funktion, [[memory-fold]], liest das gesamte Protokoll und berechnet den aktuellen Stand (bei jedem Thema gewinnt die jüngste Entscheidung). Eine GitHub Action ([[mem-action]], ein automatischer Auftrag auf GitHub) erzeugt die lesbaren Dateien in [[memory-views]] neu. Claude Code schreibt mit dem Befehl [[mem]] und drei Hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); die Claude-App schreibt über [[mem-github-connector]]. Alles ist in schlichtem Python geschrieben (nur dessen Standardbibliothek), und [[mem-validator]] hält Geheimnisse und Kontaktdaten anderer Personen fern.

## Where it sits in the pipeline
Unter jedem anderen Projekt: Sie lesen ihre Standardwerte daraus und melden mit `mem use` zurück.

## Who receives its output
Jede Claude-Instanz über den Brief; [[giovanni]] über die Prüfdatei in [[memory-views]].

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Prinzipien
1. **Ereignisse werden nur angehängt**: Ein Job der kontinuierlichen Integration weist die Änderung einer alten Ereignisdatei ab.
2. **Ansichten sind abgeleitet**: Ein Test scheitert, wenn eine Ansicht von Hand bearbeitet wurde, und die Ansichten werden bei jedem Push neu gebaut.
3. **Die Reihenfolge der Lieferung spielt nie eine Rolle**: Tests prüfen, dass das Falten des Protokolls in jeder Reihenfolge dasselbe Ergebnis liefert.
4. **Giovannis eigene Worte haben Vorrang vor dem Sammler**: Ein Test prüft, dass ein automatischer Eintrag nie einen von ihnen überschreibt.
5. **Keine Geheimnisse oder Kontaktdaten**: Ein Datenschutztest prüft die Grenze, und ein ungültiges Ereignis kommt in Quarantäne.
6. **Dieses Repository ist die einzige Schnittstelle zwischen den Claude-Instanzen**: kein neues Protokoll.

### Entscheidungen
Fünf Architekturentscheidungsprotokolle (kurze Notizen, die die Gründe einer Entscheidung bewahren) in `docs/adr/`, [[memory-adrs]]: 0002 ein nur anhängbares Ereignisprotokoll, von einer reinen Funktion gefaltet, statt eines Protokolls; 0003 die Rollen von Giovanni und den Claude-Instanzen; 0004 ein Programm misst und ein Skill urteilt; 0005 die Startkurzfassung kürzen und das Gedächtnis nach Werkzeug trennen. Der Entwurf, die Regeln der Faltung und die bekannten Grenzen stehen in `docs/DESIGN.md` (ein `DESIGN.md` im Hauptordner mit Entscheidungsprotokoll gibt es noch nicht).

### Anforderungen
Es gibt keine Anforderungsliste. Die obigen Prinzipien werden durch benannte Tests in `tests/` festgehalten (zum Beispiel die Tests zu Reihenfolge-Unabhängigkeit, Datenschutz und Sammler), die das Gate ausführt.

### Quality Gate
Das Gate hat zwei Schritte: die Unit-Tests des Gedächtnisses (`python3 -m unittest discover`) und die Fitnessprüfungen von `pipeline-check`.

### Kontinuierliche Integration
Kontinuierliche Integration (CI) heißt automatische Prüfungen bei jedem Push. Zwei Workflows laufen auf GitHub: `quality-gate.yml` führt das Gate aus, und `mem.yml` prüft, dass Ereignisse nur angehängt werden und die Ansichten neu gebaut werden ([[mem-action]]). Dieses Repository hat absichtlich keinen Branch-Schutz: Sein Job schiebt die abgeleiteten Dateien nach `main`.

### Wartung
Technische Schulden werden als GitHub-Issues mit dem Label `debt` (P1 bis P3) nach der [[maintenance-policy]] geführt. Die [[monthly-architecture-review]] prüft das Projekt jeden Monat; die nächste ist am 22.11.2026 fällig.
