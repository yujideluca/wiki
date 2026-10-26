---
id: codex-pbar
lang: de
source_hash: b0ea5e03eb1e
title: Codex-Aufgabenfortschritt im Terminal
---

## What it is
Eine feste Zeile am unteren Rand von Giovannis Codex-Terminal zeigt den Aufgabenfortschritt und die geschätzte Restzeit. Der Python-Quellcode liegt in `~/dev/codex-pbar`. Der Einstieg steht in `README.md`. Diese Anzeige ist von der Claude-Terminalanzeige [[pbar]] getrennt.

## What it does
Die Zeile bleibt sichtbar, während Codex arbeitet oder wartet. Sie übernimmt Claudes kompakten Stil: eine grüne Progress-Beschriftung auf normalem Terminalhintergrund, Mittelpunkte als Trenner, Prozentwert, erledigte Aufgaben und geschätzte Restzeit. Ein Blockbalken wird nicht gezeichnet. Zwei erledigte von fünf Schritten erscheinen als `Progress: [ 40%] 2/5 tasks`. Zeitablauf allein erhöht den Fortschritt nicht. Läuft die Schätzung ab, erscheint `over by` mit der überschrittenen Zeit. Ohne Aufgabenplan steht dort `No active task`. Ein ausdrücklich abgeschlossener Auftrag bleibt bis zur nächsten Aufgabe sichtbar.

## How it does it
Der installierte Starter `codex` öffnet interaktive Sitzungen in tmux, einem Programm, das Terminalprogramme nach dem Trennen weiterlaufen lässt (siehe [[glossary]]). Ein eigener Server `codex-status` reserviert die unterste Zeile außerhalb von Codex' Zeichenfläche. Die native Einstellung `task-progress` bleibt bestehen; die feste Zeile benötigt das Planungswerkzeug des Modells nicht. Jede Terminalsitzung besitzt eine eigene Zuordnung, damit parallele Aufgaben keine Zähler teilen.

Der Agent aktualisiert den lokalen Befehl `codex-task-progress set --done 2 --total 5 --eta 300 --label 'Testing'`. `--eta` gibt die Restzeit in Sekunden an; `--new` beginnt eine neue Aufgabe. Anweisungen in beiden lokalen `AGENTS.md`-Dateien weisen dem Agenten die Pflege zu. Der Zustand wird durch Ersetzen einer vollständigen privaten Datei unter `~/.local/share/codex-pbar/tasks/` gespeichert; unvollständige Schreibvorgänge ersetzen keinen gültigen Zustand. Beschriftungen sind kurze Aufgabenbeschreibungen. Es kommen keine Modellanfragen oder Netzwerkdienste hinzu.

Die Installation speichert den Pfad des ursprünglichen Programms und ersetzt die Verknüpfung `~/.local/bin/codex` durch einen Starter. Nichtinteraktive Befehle wie `codex exec` und `codex --version` behalten Argumente und Rückgabestatus. Das Originalprogramm, Hooks und Freigabeeinstellungen bleiben unverändert. Ersetzt eine Codex-Installation den Starter, muss die Installation erneut ausgeführt werden. `CODEX_PBAR_DISABLE=1 codex` umgeht die Anzeige. Bereits laufende Terminalprogramme werden nicht nachträglich eingebettet; eine über diesen Starter geöffnete Terminaloberfläche kann dieselbe Unterhaltung fortsetzen, ohne einen neuen Auftrag zu starten.

## Where it sits in the pipeline
Die Anzeige läuft im Laptop-Terminal. Das Quality Gate, die automatisierten Prüfungen vor einem Abschluss, führt Tests und gezielt eingebaute Fehler über [[pipeline-check]] aus. Die Live-Prüfung öffnet eine bestehende Unterhaltung ohne neue Nachricht, lehnt einen Ordnerauswahldialog als falschen Erfolg ab, prüft zwei Breiten und eine Ruhephase und speichert die Terminalaufnahme unter `build/`.

## Who receives its output
Giovanni liest die Zeile. Der Agent kann `codex-task-progress show` prüfen. Die ältere Implementierung als Desktopfenster wird durch diese Terminalinstallation nicht aktiviert.

## Notes
Installation aus `~/dev/codex-pbar`: `PYTHONPATH=src .venv/bin/python -m codex_pbar.terminal install`. Mit `Ctrl-b d` trennen und mit `tmux -L codex-status attach` wieder verbinden. Die Restzeit ist eine Prognose des Agenten, keine gemessene Zusage. Token-, Kontext- und Kontingentfelder werden nicht ergänzt.


Grenzen bei Fehlern: Die feste Zeile benötigt den installierten Starter und tmux. Bei fehlender oder beschädigter Zustandsdatei sind die Werte unbekannt. Fehlt tmux, erscheint ein Fehler. Erst das ausdrückliche Melden aller Schritte als erledigt setzt 100%. Neue Terminals erhalten getrennte Kennungen; zwei Ansichten derselben fortgesetzten Unterhaltung teilen absichtlich den Aufgabenzähler. Der Code der Desktop-Anzeige bleibt im Repository; dieser Installer startet ihn nicht.


Projektdateien: `AGENTS.md` verweist Mitwirkende auf `CLAUDE.md` mit Python-Architektur, Datenschutzgrenzen und vorgeschriebenen Prüfungen. `DESIGN.md` hält den aktuellen Terminalaufbau und Entscheidungen fest. `docs/2026-10-25-codex-pbar-design.md` bewahrt den ursprünglichen Desktopentwurf; die neuere Terminalentscheidung steht in `docs/adr/0004-persistent-terminal-footer.md`. `docs/REQUIREMENTS.md` enthält PB-1 bis PB-10 für die erhaltene Desktopanzeige und die Terminalfunktionen. `docs/MAINTENANCE.md` beschreibt monatliche Prüfungen und technische Schulden. `.github/workflows/quality-gate.yml` startet die gemeinsame Prüfung bei Pushes und Pull Requests und bewahrt den Bericht vierzehn Tage auf. `.gitignore` schließt virtuelle Umgebungen, Python-Zwischenspeicher, Abdeckungsdateien und Buildausgaben einschließlich privater Terminalaufnahmen von der Versionsverwaltung aus.


Prüfdateien: `docs/TESTES-AUTOMATIZADOS.md` beschreibt Teststrategie, bekannte Lücken und Terminalprüfungen. Die erzeugte Datei `docs/TRACEABILITY.md` ordnet PB-1 bis PB-10 ihren Tests zu. `pipeline-check.toml` wählt die vorgeschriebene Prüfung, verbietet Importe von Netzwerkbibliotheken im Quellverzeichnis, setzt eine Grenze von 1200 Sekunden und nennt die GitHub-Prüfung. `pipeline-check.version` bindet das gemeinsame Prüfprogramm an `v0.5.0`; `tools/pipeline-check.sh` verwendet diese Version statt einer kopierten Implementierung. `pyproject.toml` beschreibt Python und die festgelegten Anzeige- und Testabhängigkeiten.

Entscheidungsdateien: `docs/adr/README.md` erklärt Architekturentscheidungsprotokolle, kurze Dateien mit Gründen für Strukturentscheidungen; `0000-template.md` liefert das Format. `0001-record-decisions.md` verlangt diese Aufzeichnungen; `0002-python-transcript-companion.md` hält den ursprünglichen Desktopaufbau fest; `0003-program-measures-skill-judges.md` trennt automatische Messung von Wartungsurteilen. Die Terminalentscheidung steht in `0004-persistent-terminal-footer.md`. Die Module in `src/codex_pbar/` enthalten neben dem Terminaleinstieg weiterhin Desktopleser, Zustand und Anzeige; `tests/` und `tools/` enthalten Prüfungen und Installer. `upstream/` bewahrt den archivierten Claude-Quellcode, der nicht ausgeführt wird.


Blockierte Benutzeraufträge pausieren den Countdown und zeigen `Blocked`; die überschrittene Zeit läuft nicht weiter. `codex-task-progress clear` entfernt einen veralteten Zähler der zugeordneten Sitzung. Eine Begrüßung benötigt keinen Aufgabenplan. Automatische Dokumentations-Hooks behalten den primären Aufgabenzähler statt ihn durch Dokumentationsarbeit zu ersetzen.

`task-progress` ist ein Eintrag in `tui.status_line` in `~/.codex/config.toml`; [[codex-status-line]] beschreibt die anderen nativen Felder. Neue Unterhaltungen bekommen unterschiedliche Kennungen. `codex resume <Unterhaltungs-UUID>` verwendet die Kennung dieser Unterhaltung; zwei mit derselben Kennung fortgesetzte Ansichten teilen den Zähler. Zum Pausieren die unvollständige Aufgabe mit einer Beschriftung beginnend mit `Blocked:` aktualisieren, etwa `codex-task-progress set --done 2 --total 5 --eta 300 --label 'Blocked: waiting for access'`.

Die globale Anweisungsdatei [[global-codex-agents]] beschreibt, wie der Assistent den Aufgabenfortschritt pflegt. Bei dieser Prüfung ist `codex-pbar.service`, der ältere Desktopfenster-Dienst, maskiert und inaktiv: Seine Dienstdatei verweist auf `/dev/null`, wodurch er nicht gestartet werden kann. Die aktive Terminalzeile verwendet stattdessen den Starter.

Das Terminal lässt sich ohne zweites Codex-Frontend prüfen: Ein nur lesender Client verbindet sich über `tmux -L codex-status attach-session -r -f ignore-size -t SESSION` mit der bestehenden tmux-Sitzung. `SESSION` bezeichnet die Sitzung, deren Fußzeilenbefehl die aktuelle `CODEX_PBAR_SESSION` enthält. Der Client sendet keine Eingaben; `ignore-size` verhindert, dass seine Größenänderung das Arbeitsterminal verändert. Am 2026-10-26 zeigte diese Prüfung die feste Fußzeile bei 116×53 und 70×35, im Leerlauf und nach Neuzeichnen. Die breite Ansicht zeigte außerdem die nativen Restbudgets für fünf Stunden und die Woche sowie belegten Kontext und Kontextkapazität. Das ältere `tools/terminal_smoke.py` startet ein zweites Codex-Frontend und endet derzeit an der Sitzungssperre; das beweist nicht, dass die Fußzeile im bestehenden Terminal fehlt.

Jedes neue interaktive Terminal aktiviert vor dem Verbinden die Mausweiterleitung von tmux und richtet Mausradbindungen ein. Fordert eine Vollbildanwendung keine Mausereignisse an, werden Aufwärts- und Abwärtsscrollen zu Bild auf und Bild ab. Anwendungen mit eigener Mausverarbeitung und der Kopiermodus von tmux behalten ihre normalen Mausereignisse. Die frühere Korrektur mit eingeschalteter Mausweiterleitung war weiterhin installiert, reichte aber für Codex im Vollbildmodus ohne Mausverarbeitung nicht aus; ihr Test prüfte nur die Einstellung statt der Bewegung des Verlaufs. Eine Prüfung im laufenden Terminal zeigte vor der Ergänzung keine Bewegung und danach das Zurückscrollen in die frühere Antwort. Regressionstests mit echten Terminalereignissen prüfen beide Wege bei zwei Größen auf jeweils neuen, isolierten Servern. Zwei gezielte Fehler ersetzen die Bildtasten durch Pfeiltasten und müssen erkannt werden. Ein physischer Neustart wurde nicht getestet. Für die Textauswahl von Konsole beim Ziehen die Umschalttaste gedrückt halten. Der Starter richtet die Bindungen bei jeder neuen Sitzung ein; auch der laufende dedizierte Server wurde ohne Codex-Neustart korrigiert.
