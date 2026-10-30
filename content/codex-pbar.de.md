---
id: codex-pbar
lang: de
source_hash: 6dc14b007e82
title: Codex-Aufgabenfortschritt im Terminal
---

## What it is
Eine feste Zeile am unteren Rand von Giovannis Codex-Terminal zeigt den Aufgabenfortschritt und die geschätzte Restzeit. Der Python-Quellcode liegt in `~/dev/codex-pbar`. Der Einstieg steht in `README.md`. Diese Anzeige ist von der Claude-Terminalanzeige [[pbar]] getrennt.

## Flow
trigger t1: Giovanni startet codex in einem Terminal | [[global-codex-agents]]
step s1: Der codex-Starter hüllt die Sitzung in tmux ein
step s2: Ein eigener codex-status-Server reserviert die unterste Terminalzeile | [[codex-status-line]]
step s3: Jedes Terminal erhält eine eigene Kennung, die Fußzeile und Aufgabenstand verbindet
step s5: Ein Beobachter neben Codex erfasst laufende Befehle und liest das Gesprächsprotokoll
trigger t2: Codex beginnt eine Aufgabe mit mehreren Schritten
step s4: Der Agent führt codex-task-progress set aus: erledigt, gesamt, Restsekunden, Beschriftung
decide d1: Gibt es einen aktiven Aufgabenplan?
decide d3: Läuft gerade ein Befehl?
decide d2: Ist die Zeitschätzung abgelaufen?
product p1: Fußzeile zeigt Prozent, erledigte Aufgaben und Restzeit
product p2: Fußzeile zeigt over by und die Überzeit
product p3: Fußzeile meldet No active task
product p4: Fußzeile zeigt Prozent und Restzeit des Befehls, beim ersten Lauf die Laufzeit
product p5: Fußzeile zeigt die Sitzungszeile mit Ordner, Modell, Kontext und Nutzung

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s5
s5 -> d1
t2 -> s4
s4 -> d1
d1 -ja-> d2
d1 -nein-> d3
d2 -nein-> p1
d2 -ja-> p2
d3 -ja-> p4
d3 -nein-> p5
d3 -noch nichts-> p3

## Architecture
### Kontext
person g: Giovanni — arbeitet mit Codex in einem Terminal | [[giovanni]]
system p: codex-pbar — zeigt den Aufgabenfortschritt unter dem Terminal
external a: Globale Codex-Anweisungen — sagen Codex, Meilensteine zu melden | [[global-codex-agents]]
external x: Codex — der Assistent, der die Arbeit macht | [[codex]]
external t: tmux-Terminal — hat die Zeile, in der die Fußzeile gezeichnet wird

a -weist an-> x
x -meldet Meilensteine an-> p
p -zeichnet die Fußzeile in-> t
g -liest die Fußzeile in-> t

### Container
person g: Giovanni | [[giovanni]]
external x: Codex-Sitzungsdateien | [[codex]]
container rd: Inkrementeller Leser — der einzige Code, der Sitzungsdateien öffnet
container co: Reiner Sitzungszustand — behält keinen Prompt- und Werkzeugtext
container ap: Desktop-Fenster — erhalten, nicht eingeschaltet
container wt: Beobachter im Starter — laufende Befehle, Modell, Kontext und Nutzung
container ft: Terminal-Fußzeile — Aufgaben, laufender Befehl oder Sitzungszeile
store ts: Privater Aufgabenzustand — von Meilenstein-Updates geschrieben
store hs: Private Zeitverlaufsdaten — gehasht
store ws: Privater Beobachterzustand — beim Sitzungsende gelöscht

rd -liest-> x
rd -aktualisiert-> co
rd -ergänzt-> hs
co -speist-> ap
ft -liest-> ts
wt -liest-> x
wt -ergänzt-> hs
wt -schreibt-> ws
ft -liest-> ws
g -sieht-> ft

## What it does
Die Zeile bleibt sichtbar, während Codex arbeitet oder wartet. Sie übernimmt Claudes kompakten Stil: eine grüne Progress-Beschriftung auf normalem Terminalhintergrund, Mittelpunkte als Trenner, Prozentwert, erledigte Aufgaben und geschätzte Restzeit. Ein Blockbalken wird nicht gezeichnet. Zwei erledigte von fünf Schritten erscheinen als `Progress: [ 40%] 2/5 tasks`. Zeitablauf allein erhöht den Fortschritt nicht. Läuft die Schätzung ab, erscheint `over by` mit der überschrittenen Zeit. Ein ausdrücklich abgeschlossener Auftrag bleibt zwei Minuten oder bis zur nächsten Aufgabe sichtbar.

Die Fußzeile braucht keine Mitarbeit des Agenten. Ist kein Aufgabenplan aktiv, zeigt sie wie Claudes Leiste, was gerade geschieht. Läuft in Codex ein Befehl, zeigt sie dieselbe Beschriftung mit Prozentwert und Restzeit, gelernt aus früheren Läufen dieses Programms, zum Beispiel `Progress: [ 36%] ~7s left · sleep 12`; beim ersten Lauf steht dort `Progress: [ ?? ] 4s · sleep 12 (first run)`. Befehle unter drei Sekunden erscheinen nie. Läuft nichts, zeigt sie eine Sitzungszeile: Ordner, Git-Zweig, Modell, einen Kontextbalken und Balken für das Fünf-Stunden- und das Wochenfenster der Nutzung samt Rücksetzzeit. Was nicht passt, entfällt, das Unwichtigste zuerst. `No active task` erscheint nur, solange es noch keinen Ordner zum Anzeigen gibt oder der Beobachter nicht läuft. Diese Zeitschätzung gilt für einen Befehl, nie für die ganze Aufgabe.

## How it does it
Der installierte Starter `codex` öffnet interaktive Sitzungen in tmux, einem Programm, das Terminalprogramme nach dem Trennen weiterlaufen lässt (siehe [[glossary]]). Ein eigener Server `codex-status` reserviert die unterste Zeile außerhalb von Codex' Zeichenfläche. Die native Einstellung `task-progress` bleibt bestehen; die feste Zeile benötigt das Planungswerkzeug des Modells nicht. Jede Terminalsitzung besitzt eine eigene Zuordnung, damit parallele Aufgaben keine Zähler teilen.

Neben Codex führt derselbe Starterprozess einmal pro Sekunde einen Beobachter aus; es gibt also keinen zusätzlichen Hintergrunddienst, und er endet mit der Sitzung. Er sieht sich die Prozesse unter Codex an, findet die Shell jedes Befehls, benennt das Programm (zum Beispiel `sleep 12` oder `python3 -m pytest`) und misst seine Dauer. Abgeschlossene Dauern kommen in eine private Verlaufsdatei, die nur einen Hash jedes Programmnamens enthält. Der Beobachter liest außerdem die von Codex geöffnete Gesprächsdatei, bei langen nur die letzten 4 MiB, für Modell, Ordner, Kontextnutzung und Nutzungsgrenzen; Prompt- und Werkzeugtext behält er nicht. Das Ergebnis liegt in einer privaten Datei unter `~/.local/share/codex-pbar/tasks/`, die die Fußzeile liest. Ist diese Datei älter als wenige Sekunden, ignoriert die Fußzeile sie.

Der Agent aktualisiert den lokalen Befehl `codex-task-progress set --done 2 --total 5 --eta 300 --label 'Testing'`. `--eta` gibt die Restzeit in Sekunden an; `--new` beginnt eine neue Aufgabe. Anweisungen in beiden lokalen `AGENTS.md`-Dateien weisen dem Agenten die Pflege zu. Der Zustand wird durch Ersetzen einer vollständigen privaten Datei unter `~/.local/share/codex-pbar/tasks/` gespeichert; unvollständige Schreibvorgänge ersetzen keinen gültigen Zustand. Beschriftungen sind kurze Aufgabenbeschreibungen. Es kommen keine Modellanfragen oder Netzwerkdienste hinzu.

Die Installation speichert den Pfad des ursprünglichen Programms und ersetzt die Verknüpfung `~/.local/bin/codex` durch einen Starter. Nichtinteraktive Befehle wie `codex exec` und `codex --version` behalten Argumente und Rückgabestatus. Das Originalprogramm, Hooks und Freigabeeinstellungen bleiben unverändert. Ersetzt eine Codex-Installation den Starter, muss die Installation erneut ausgeführt werden. `CODEX_PBAR_DISABLE=1 codex` umgeht die Anzeige. Bereits laufende Terminalprogramme werden nicht nachträglich eingebettet; eine über diesen Starter geöffnete Terminaloberfläche kann dieselbe Unterhaltung fortsetzen, ohne einen neuen Auftrag zu starten.

## Where it sits in the pipeline
Die Anzeige läuft im Laptop-Terminal. Das Quality Gate, die automatisierten Prüfungen vor einem Abschluss, führt Tests und gezielt eingebaute Fehler über [[pipeline-check]] aus. Die Live-Prüfung öffnet eine bestehende Unterhaltung ohne neue Nachricht, lehnt einen Ordnerauswahldialog als falschen Erfolg ab, prüft zwei Breiten und eine Ruhephase und speichert die Terminalaufnahme unter `build/`.

## Who receives its output
Giovanni liest die Zeile. Der Agent kann `codex-task-progress show` prüfen. Die ältere Implementierung als Desktopfenster wird durch diese Terminalinstallation nicht aktiviert.

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Prinzipien
1. **Anforderungen gehen Änderungen voraus**: Tests tragen `REQ PB-N`, und der Rückverfolgbarkeitsschritt des Gates schlägt fehl, wenn eine keinen hat.
2. **Reine Module bleiben frei von GUI- und Netzcode**: Zustand und Leser werden mit gewöhnlichen Unit-Tests geprüft, Zweigabdeckung ist Pflicht.
3. **Nichts Privates wird behalten**: keine Modell- oder Netzaufrufe, keine Lesezugriffe auf Anmeldedaten und keine rohen Werkzeugargumente oder -ausgaben im gespeicherten Status oder Verlauf.
4. **Das Gate entscheidet**: `tools/quality_gate.sh` ist die einzige Definition von „bestanden“, und die kontinuierliche Integration führt es aus.

### Entscheidungen
Fünf Architekturentscheidungsprotokolle (kurze Notizen, die die Gründe einer Entscheidung bewahren) in `docs/adr/`: 0002 ein Python-Desktop-Begleiter, der Sitzungsdateien liest; 0003 ein Programm misst und ein Skill urteilt; 0004 die dauerhafte Terminal-Fußzeile in einer eigenen tmux-Zeile, an ihre Sitzung gebunden; 0005 automatischer Fortschritt durch einen Beobachter im Starter. `DESIGN.md` enthält das Diagramm und das Entscheidungsprotokoll.

### Anforderungen
11 Anforderungen (Präfix PB) in `docs/REQUIREMENTS.md`. Jede hat einen Test mit dem Tag `REQ PB-N`, und die Rückverfolgbarkeitsprüfung ([[check-traceability]]) schlägt fehl, wenn eine keinen hat.

### Quality Gate
Das Gate führt die Unit-Tests mit mindestens 85 % Zweigabdeckung für Zustands- und Lesemodul aus; eine Mutationsprüfung (absichtlich eingebaute Fehler müssen auffallen); einen Fenster-Rauchtest ohne Bildschirm; die Rückverfolgbarkeit der Anforderungen; und die Fitnessfunktionen.

### Kontinuierliche Integration
Kontinuierliche Integration (CI) heißt automatische Prüfungen bei jedem Push. Der Workflow `quality-gate.yml` führt das Gate bei jedem Push auf GitHub aus, über `pipeline-check`, festgelegt in `pipeline-check.version`.

### Wartung
Technische Schulden werden als GitHub-Issues mit dem Label `debt` (P1 bis P3) nach der [[maintenance-policy]] geführt. Die [[monthly-architecture-review]] prüft das Projekt jeden Monat; die nächste ist am 22.11.2026 fällig.

## Notes
Installation aus `~/dev/codex-pbar`: `PYTHONPATH=src .venv/bin/python -m codex_pbar.terminal install`. Mit `Ctrl-b d` trennen und mit `tmux -L codex-status attach` wieder verbinden. Die Restzeit ist eine Prognose des Agenten, keine gemessene Zusage.


Grenzen bei Fehlern: Die feste Zeile benötigt den installierten Starter und tmux. Bei fehlender oder beschädigter Zustandsdatei sind die Werte unbekannt. Fehlt tmux, erscheint ein Fehler. Erst das ausdrückliche Melden aller Schritte als erledigt setzt 100%. Neue Terminals erhalten getrennte Kennungen; zwei Ansichten derselben fortgesetzten Unterhaltung teilen absichtlich den Aufgabenzähler. Der Code der Desktop-Anzeige bleibt im Repository; dieser Installer startet ihn nicht.


Projektdateien: `AGENTS.md` verweist Mitwirkende auf `CLAUDE.md` mit Python-Architektur, Datenschutzgrenzen und vorgeschriebenen Prüfungen. `DESIGN.md` hält den aktuellen Terminalaufbau und Entscheidungen fest. `docs/2026-10-25-codex-pbar-design.md` bewahrt den ursprünglichen Desktopentwurf; die neueren Terminalentscheidungen stehen in `docs/adr/0004-persistent-terminal-footer.md`. `docs/REQUIREMENTS.md` enthält PB-1 bis PB-11 für die erhaltene Desktopanzeige, die Terminalfunktionen und die automatische Fußzeile. `docs/MAINTENANCE.md` beschreibt monatliche Prüfungen und technische Schulden. `.github/workflows/quality-gate.yml` startet die gemeinsame Prüfung bei Pushes und Pull Requests und bewahrt den Bericht vierzehn Tage auf. `.gitignore` schließt virtuelle Umgebungen, Python-Zwischenspeicher, Abdeckungsdateien und Buildausgaben einschließlich privater Terminalaufnahmen von der Versionsverwaltung aus.


Prüfdateien: `docs/TESTES-AUTOMATIZADOS.md` beschreibt Teststrategie, bekannte Lücken und Terminalprüfungen. Die erzeugte Datei `docs/TRACEABILITY.md` ordnet PB-1 bis PB-11 ihren Tests zu. `pipeline-check.toml` wählt die vorgeschriebene Prüfung, verbietet Importe von Netzwerkbibliotheken im Quellverzeichnis, setzt eine Grenze von 1200 Sekunden und nennt die GitHub-Prüfung. `pipeline-check.version` bindet das gemeinsame Prüfprogramm an `v0.5.0`; `tools/pipeline-check.sh` verwendet diese Version statt einer kopierten Implementierung. `pyproject.toml` beschreibt Python und die festgelegten Anzeige- und Testabhängigkeiten.

Entscheidungsdateien: `docs/adr/README.md` erklärt Architekturentscheidungsprotokolle, kurze Dateien mit Gründen für Strukturentscheidungen; `0000-template.md` liefert das Format. `0001-record-decisions.md` verlangt diese Aufzeichnungen; `0002-python-transcript-companion.md` hält den ursprünglichen Desktopaufbau fest; `0003-program-measures-skill-judges.md` trennt automatische Messung von Wartungsurteilen. Die Terminalentscheidungen stehen in `0005-automatic-footer-progress.md` und `0004-persistent-terminal-footer.md`. Die Module in `src/codex_pbar/` enthalten neben dem Terminaleinstieg weiterhin Desktopleser, Zustand und Anzeige; `tests/` und `tools/` enthalten Prüfungen und Installer. `upstream/` bewahrt den archivierten Claude-Quellcode, der nicht ausgeführt wird.


Blockierte Benutzeraufträge pausieren den Countdown und zeigen `Blocked`; die überschrittene Zeit läuft nicht weiter. `codex-task-progress clear` entfernt einen veralteten Zähler der zugeordneten Sitzung. Eine Begrüßung benötigt keinen Aufgabenplan. Automatische Dokumentations-Hooks behalten den primären Aufgabenzähler statt ihn durch Dokumentationsarbeit zu ersetzen.

`task-progress` ist ein Eintrag in `tui.status_line` in `~/.codex/config.toml`; [[codex-status-line]] beschreibt die anderen nativen Felder. Neue Unterhaltungen bekommen unterschiedliche Kennungen. `codex resume <Unterhaltungs-UUID>` verwendet die Kennung dieser Unterhaltung; zwei mit derselben Kennung fortgesetzte Ansichten teilen den Zähler. Zum Pausieren die unvollständige Aufgabe mit einer Beschriftung beginnend mit `Blocked:` aktualisieren, etwa `codex-task-progress set --done 2 --total 5 --eta 300 --label 'Blocked: waiting for access'`.

Die globale Anweisungsdatei [[global-codex-agents]] beschreibt, wie der Assistent den Aufgabenfortschritt pflegt. Bei dieser Prüfung ist `codex-pbar.service`, der ältere Desktopfenster-Dienst, maskiert und inaktiv: Seine Dienstdatei verweist auf `/dev/null`, wodurch er nicht gestartet werden kann. Die aktive Terminalzeile verwendet stattdessen den Starter.

Das Terminal lässt sich ohne zweites Codex-Frontend prüfen: Ein nur lesender Client verbindet sich über `tmux -L codex-status attach-session -r -f ignore-size -t SESSION` mit der bestehenden tmux-Sitzung. `SESSION` bezeichnet die Sitzung, deren Fußzeilenbefehl die aktuelle `CODEX_PBAR_SESSION` enthält. Der Client sendet keine Eingaben; `ignore-size` verhindert, dass seine Größenänderung das Arbeitsterminal verändert. Am 2026-10-26 zeigte diese Prüfung die feste Fußzeile bei 116×53 und 70×35, im Leerlauf und nach Neuzeichnen. Die breite Ansicht zeigte außerdem die nativen Restbudgets für fünf Stunden und die Woche sowie belegten Kontext und Kontextkapazität. Das ältere `tools/terminal_smoke.py` startet ein zweites Codex-Frontend und endet derzeit an der Sitzungssperre; das beweist nicht, dass die Fußzeile im bestehenden Terminal fehlt.

Jedes neue interaktive Terminal aktiviert vor dem Verbinden die Mausweiterleitung von tmux und richtet Mausradbindungen ein. In Codex im Vollbildmodus ohne Mausverarbeitung sendet jeder Schritt native Mausradereignisse für jeweils eine Zeile, insgesamt ein Viertel der aktuellen Höhe des Terminalbereichs, abgerundet auf mindestens eine Zeile. tmux berechnet die Anzahl bei jedem Schritt neu; Größenänderungen passen die Schrittweite automatisch an. Dabei gilt die Standardgeschwindigkeit von Codex mit einer Zeile pro Mausereignis. Anwendungen mit eigener Mausverarbeitung und der Kopiermodus von tmux behalten ihre normalen Ereignisse. Der frühere Rückgriff auf ganze Seiten stellte das Scrollen wieder her, ließ jeden Schritt aber zu weit springen. Tests mit echten Terminalereignissen prüfen nun beide Richtungen bei Höhen von 24, 18 und 3 Zeilen; gezielte Fehler ändern den Divisor oder kehren eine Richtung um. Für die Textauswahl von Konsole beim Ziehen die Umschalttaste gedrückt halten. Der Starter richtet die Bindungen bei jeder neuen Sitzung ein; der laufende Server wird ohne Codex-Neustart korrigiert.

Das Reparaturskript `~/fixes/codex-touchpad-scroll.sh` richtet die gepflegten Mausradbindungen auf dem laufenden dedizierten Server erneut ein. Die Option `--undo` stellt dort die früheren Bindungen wieder her; spätere Starts richten die Korrektur weiterhin ein. `~/fixes/LEIAME.md` hält Ursache, Prüfungen und Grenzen des Rückgängigmachens fest.

Giovanni bestätigte, dass die Viertelseitenbewegung passt. Eine Aufnahme der laufenden Sitzung maß 13 Zeilen pro Schritt in einem Bereich mit 52 Zeilen. Eine neue Sitzung über den installierten Starter bewegte in beiden Richtungen sieben Zeilen bei einer Bereichshöhe von 29 Zeilen, ohne eine Modellanfrage. Der Ablauf zur kontinuierlichen Integration installiert tmux; fehlt es, schlägt der Regressionstest fehl, statt übersprungen zu werden. Ein physischer Neustart wurde nicht getestet.

Eine Live-Prüfung am 30.10.2026 startete ein echtes Codex-Terminal über den Starter: Ein Befehl `sleep 12` zeigte beim ersten Lauf `first run` mit Laufzeit, der zweite Lauf zeigte Prozentwert und Restzeit, die Leerlaufzeile zeigte Ordner, Modell, Kontext und beide Nutzungsbalken. Aktive Aufgabenmeilensteine hatten Vorrang, und Codex' übliche Strg-C-Behandlung blieb unverändert. Vor dieser Änderung gestartete Terminals behalten die alte Fußzeile bis zum Neustart.
