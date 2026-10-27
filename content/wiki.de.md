---
id: wiki
lang: de
source_hash: cd94dada8617
title: Wiki (diese Seite)
---

## What it is
Diese Website ist ein Wiki: eine Enzyklopädie aller Projekte, Programme, Skills und Abläufe in Giovannis Systemen, mit einer Karte, die zeigt, wie sie zusammenhängen. Jedes Thema hat seine eigene Seite, so geschrieben, dass ein Leser, der nichts über das System oder seine Fachsprache weiß, folgen kann. Ein Wort neu? Öffne das [[glossary]], das die auf den Seiten verwendeten Begriffe erklärt. Das Repository `yujideluca/wiki` ist öffentlich (seit 2026-10-25), der Ordner ist `~/dev/wiki`, und das Projekt wurde am 2026-10-22 aus [[project-template]] gestartet.

## Flow
trigger t1: Claude beendet eine Aufgabe, die ein System verändert hat | [[end-of-task]]
step s1: Schreibt Markdown-Seiten, jede mit kleinem Kopf | [[wiki-content]]
step s2: wiki check wendet die Inhaltsregeln an | [[wiki-check]]
decide d1: Bestehen die Regeln?
step s3: wiki build macht aus den Seiten Daten | [[wiki-build]]
step s4: Nur content/ wird committet und hochgeladen | [[github]]
step s5: Der Server liefert aus: Giovannis Google-Konto kommt rein, andere sehen eine Attrappe | [[wiki-router]], [[decoy-page]]
trigger t2: Giovanni öffnet das Wiki | [[giovanni]]
step s6: Sucht, fährt über die Karte, klickt einen Punkt | [[wiki-frontend]]
product p1: Veröffentlichung abgelehnt, mit Liste der Probleme
product p2: Eine Seite, die die Architekturfrage beantwortet

t1 -> s1
s1 -> s2
s2 -> d1
d1 -nein-> p1
d1 -ja-> s3
s3 -> s4
s4 -> s5
t2 -> s5
s5 -> s6
s6 -> p2

## Architecture
### Kontext
person g: Giovanni — liest die Seiten am Laptop oder Handy | [[giovanni]]
person c: Claude Code — schreibt die Seiten am Ende jeder Aufgabe | [[claude-code]]
system w: Wiki — die Seiten, die Karte und die Prüfungen
external f: Tailscale Funnel — die öffentliche Webadresse | [[tailscale-funnel]]
external o: Google-Anmeldung — beweist, dass es Giovanni ist | [[google-oauth-client]]
external h: GitHub — bewahrt den Verlauf der Seiten | [[github]]

g -öffnet-> f
f -leitet Anfragen weiter an-> w
c -veröffentlicht Seiten in-> w
w -fragt, wer da ist-> o
w -schickt die Seiten an-> h

### Container
person g: Giovanni — im Browser | [[giovanni]]
person c: Claude Code — am Ende einer Aufgabe | [[claude-code]]
container fe: Elm-Frontend — die Karte und die Artikel | [[wiki-frontend]]
container sv: Elixir-Server — Anmeldetor, Tarnseite, Dateien | [[wiki-server]]
container cli: Der Befehl wiki — prüfen, veröffentlichen, Hook | [[wiki-cli]]
store pg: Seiten — Markdown-Dateien in drei Sprachen | [[wiki-content]]
store st: Gebaute Seite — die Datendateien, die das Frontend liest | [[wiki-site]]
external o: Google-Anmeldung | [[google-oauth-client]]

g -benutzt-> fe
g -meldet sich an über-> sv
fe -liest-> st
sv -liefert aus-> st
sv -fragt-> o
c -führt aus-> cli
cli -liest und prüft-> pg
cli -baut-> st

## What it does
Es lässt Giovanni eine Architekturfrage nach einer Suche und höchstens zwei Klicks beantworten: Suche mit Vorschlägen beim Tippen, über einen Punkt der Karte fahren, um in vier Kästen zu sehen, was er ist, auf den Punkt klicken für die vollständige Seite ([[wiki-frontend]]). Auf einem Handy füllt die Karte den Bildschirm mit einer Suchleiste oben, und das Antippen eines Punkts öffnet eine Sprechblase mit seiner Beschreibung; auf einem Desktop wird die Karte durch eine Linse gesehen, und ihre Punkte dehnen sich elastisch, wenn man sie zieht ([[wiki-map-view]]). Es wird am Ende jeder Aufgabe automatisch aktuell gehalten ([[end-of-task]]). Für das ganze System auf einer Seite beginnt man mit [[system-overview]].

## How it does it
Der Inhalt besteht aus Markdown-Textdateien, jede mit einem kleinen Kopf ([[wiki-content]]); sie werden von [[wiki-check]] geprüft und von [[wiki-build]] in JSON-Daten (JavaScript Object Notation) verwandelt. Der sichtbare Teil ist in Elm geschrieben ([[wiki-frontend]]); der Server ist in Elixir geschrieben ([[wiki-server]]) und lässt nur ein Google-Konto hinein, allen anderen zeigt er einen Köder ([[wiki-router]], [[decoy-page]]). Im Internet ist es über [[tailscale-funnel]] erreichbar. Die Sprachen sind Englisch, Deutsch und brasilianisches Portugiesisch.

## Where it sits in the pipeline
Neben [[workflow-memory]]: Das Gedächtnis enthält Regeln und Vorlieben, das Wiki beschreibt, was es gibt und wie es funktioniert, und verlinkt auf Gedächtniseinträge, statt sie zu kopieren.

## Who receives its output
[[giovanni]], im Browser auf dem Laptop oder dem Handy.

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Prinzipien
1. **Anforderung, dann Test, dann Code**: Jedes Versprechen ist eine Zeile in `docs/REQUIREMENTS.md`; die Rückverfolgbarkeitsprüfung im Gate kontrolliert sie.
2. **Standardmäßig verweigern**: Ohne Giovannis geprüfte Google-Sitzung wird nichts Echtes ausgeliefert; die Tests von Anmeldetor und Tarnseite prüfen das.
3. **Inhalte folgen den Regeln, bevor sie veröffentlicht werden**: `wiki check` weist eine schlechte Seite ab, und `wiki publish` läuft bei einem Problem nicht.
4. **Das Gate entscheidet**: `tools/quality_gate.sh` ist die einzige Definition von „bestanden“, und die kontinuierliche Integration führt dasselbe Skript aus.
5. **Entscheidungen stehen dort, wo der Code ist**: eine Zeile im Entscheidungsprotokoll von `DESIGN.md` und für Strukturelles ein Architekturentscheidungsprotokoll.

### Entscheidungen
Die Entwurfsdatei `DESIGN.md` enthält die C4-Diagramme und ein Entscheidungsprotokoll, neueste zuerst, jede Zeile mit ihrer Wartungsart. Architekturentscheidungsprotokolle (kurze Notizen, die die Gründe einer Entscheidung bewahren) in `docs/adr/`: 0002 Elm-Frontend und Elixir-Backend; 0003 ein Anmeldetor mit Tarnseite für alle anderen; 0004 Seiten als Markdown mit Kopfzeile, vor dem Veröffentlichen geprüft; 0005 ein Programm misst und ein Skill urteilt; 0006 die Prüfzeit steht in der Seite; 0007 der Flussdiagramm-Abschnitt. Siehe auch die [[monthly-architecture-review]].

### Anforderungen
71 Anforderungen in `docs/REQUIREMENTS.md`, gruppiert durch ein Zwei-Buchstaben-Präfix (Anmeldung AU, Tarnseite DC, Inhalt CO, Flussdiagramme FL, Projektseiten PJ, Karte MP, Handy-Layout MB und weitere). Jede hat einen Test mit dem Tag `REQ <ID>`, und die Rückverfolgbarkeitsprüfung ([[check-traceability]]) schlägt fehl, wenn eine keinen hat.

### Quality Gate
[[wiki-quality-gate]] ist ein Skript mit fünf Schritten: die Elixir-Tests; die Elm-Tests und der optimierte Build; die Rückverfolgbarkeit der Anforderungen; die Inhaltsregeln (`wiki check`); die Fitnessfunktionen (größte Datei, Gate-Dauer, Bundle-Größe).

### Kontinuierliche Integration
Kontinuierliche Integration (CI) heißt automatische Prüfungen bei jedem Push. Der Workflow `quality-gate.yml` auf GitHub installiert Erlang, Elixir, Node und Elm und führt das Gate über `pipeline-check` bei jedem Push und Pull Request aus. Ein Commit erreicht `main` erst, wenn das Gate auf genau diesem Commit grün ist.

### Wartung
Technische Schulden werden als GitHub-Issues mit dem Label `debt` (P1 bis P3) nach der [[maintenance-policy]] geführt. Die [[monthly-architecture-review]] prüft das Projekt jeden Monat; die nächste ist am 22.11.2026 fällig.
