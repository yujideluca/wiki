---
id: global-codex-agents
lang: de
source_hash: 509ce5e8da10
title: Globale Codex-AGENTS.md
---

## What it is
`~/.codex/AGENTS.md` ist Giovannis Klartextdatei mit Anweisungen für Codex, den Programmierassistenten. Sie beschreibt, wie der Assistent auf dem Laptop arbeitet, vorhandene Arbeit schützt und Ergebnisse nachweist. Sie ist von Claudes globalen Anweisungen in [[global-claude-md]] getrennt.

## What it does
Die Datei verbindet Codex mit [[workflow-memory]], der gemeinsamen Aufzeichnung von Präferenzen und offenen Aufgaben, und dem Wiki-Abschlussprozess ([[end-of-task]]). Das Gedächtnis liefert Vorgaben, niemals eine Erlaubnis. Die einleitenden Anweisungen beschreiben das Erfassen von Korrekturen, den Bericht über verwendete Einträge und den Schutz privater Informationen; erzeugte Gedächtnisordner werden über Befehle verwaltet statt von Hand bearbeitet.

Der Abschnitt `Terminal task progress` beschreibt die feste Fortschrittszeile in [[codex-pbar]]: Der Assistent erfasst erledigte Schritte und schätzt die Restzeit. Nur erledigte Arbeit erhöht den Zähler. Blockierte Aufgaben pausieren den Countdown, und automatische Dokumentationsnacharbeiten behalten den ursprünglichen Aufgabenzähler. Die getrennte native Anzeige [[codex-status-line]] zeigt Nutzungskontingente (verbleibende Kontobudgets) und Kontextgröße (die Textmenge, die das Modell auf einmal nutzen kann).

## How it does it
`Working standard` beschränkt Giovannis Hilfe zunächst auf Administratorzugang, Zugangsdaten und wesentliche Entwicklungsentscheidungen. Drei Unterabschnitte ordnen die weitere Arbeit:

- `Mistakes you have made (do not repeat)` bündelt Lehren aus früheren Fehlern. Die Nachweisregeln unterscheiden tatsächliche Ergebnisse von Einstellungen oder einzelnen Tests, verlangen den produktiven Befehl und seine Umgebung und prüfen Verhalten über die Zeit, etwa nach erneutem Laden oder gleichzeitigen Schreibzugriffen. Die Diagnoseregeln behandeln wiederkehrende Hindernisse an ihrer Ursache, statt dasselbe Hindernis erneut aufzuschreiben. Ein echtes Zugangs- oder Entscheidungshindernis erhält eine konkrete Handlung, einen Prüfbefehl und eine offene Aufgabe. Die Schutzregeln bewahren gemeinsame Zustandsdateien, Änderungen anderer Sitzungen, in der Projektdokumentation angegebene Quellen für Zugangsdaten und die Dateianordnung des Benutzers. Die Entscheidungsregeln behalten erforderliche Skill-Freigaben bei, legen Einschränkungen des Umfangs und Datenänderungen offen, bevorzugen eine kleine umkehrbare Anpassung im erlaubten Rahmen und verlangen eine aktuelle Prüfung, bevor ein Werkzeug oder eine Datei als vorhanden gilt. Ein Skill ist eine gespeicherte Anleitung für eine bestimmte Aufgabe; seine vorgeschriebene Freigabe gilt auch ohne anwesenden Benutzer.
- `Reporting` macht Ergebnisse beurteilbar. Zuerst kommt das Ergebnis, dann `Found along the way:` für unerwartete Befunde und `Verified by:` für relevante Prüfungen und deren Grenzen. Datenaufgaben erklären Eingaben, Ausgaben und jeden geänderten, übersprungenen oder beibehaltenen Datensatz. Ein harmloses Werkzeugproblem erhält höchstens eine kurze Schlussnotiz.
- `Closing a task and asking questions` hält jedes Repository auf einem einzigen Zweig, `main`; ein Zweig lebt nur, solange die kontinuierliche Integration (CI, die automatischen Prüfungen von GitHub) einen Commit prüft. Außerdem unterscheidet er wegwerfbare Testumgebungen von Änderungen am echten System. Echte Änderungen umfassen einen Bericht über die Gedächtnisnutzung, Wiki-Arbeit in einem getrennten Arbeitsverzeichnis und [[pipeline-check]], das Programm für die automatisierten Projektprüfungen. Der Zweigschutz, also Repository-Regeln, die Änderungen vor bestandenen Pflichtprüfungen verhindern, wird nicht umgangen. Fragen nennen Kontext, Optionen und Empfehlung in dieser Reihenfolge.

## Where it sits in the pipeline
Die Anweisungen begleiten die Arbeit und den Bericht. Die einleitenden Wiki-Anweisungen verlangen englische Seiten sowie deutsche und brasilianisch-portugiesische Fassungen vor `wiki publish`. Der Assistent aktualisiert den Prüfzeitpunkt einer Seite, nachdem er sie mit ihren Quellen verglichen hat. Der Stop-Hook, ein beim Sitzungsende automatisch ausgeführter Befehl, erinnert an ausstehende Dokumentation ([[wiki-hook-stop]]).

Auch eine Übergabe wegen Sandbox-Grenzen umfasst die Wiki- und Gedächtnis-Abschlussarbeit vor der Schlussnachricht. Kann die Dokumentation selbst nicht veröffentlicht werden, bereitet Codex die Änderungen in einem getrennten Arbeitsverzeichnis vor und erfasst und meldet diese Grenze.

## Who receives its output
Codex liest die Datei; Giovanni erhält Arbeit, Nachweise und notwendige Entscheidungsfragen. Diese Seite erklärt die Gruppen der Quelle, statt deren nummerierte Regeln zu wiederholen. Die installierte Datei bleibt die Quelle der genauen Anweisungen.
