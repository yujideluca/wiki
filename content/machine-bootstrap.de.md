---
id: machine-bootstrap
lang: de
source_hash: 3121f5ef9454
title: machine-bootstrap (die Einrichtung des Laptops wiederherstellen)
---

## What it is
`machine-bootstrap` zeichnet die Einrichtung von Giovannis Laptop ([[acer-nitro]]) auf, um sie nach einer Neuinstallation des Betriebssystems oder auf einem anderen Computer wiederherzustellen. Es nutzt Pythons Standardbibliothek und ein Bash-Startskript. Das lokale Repository liegt in `~/dev/machine-bootstrap`; der öffentliche Quellcode liegt in [yujideluca/machine-bootstrap](https://github.com/yujideluca/machine-bootstrap). Erfasste Einstellungen und Paketlisten sind öffentlich; verschlüsselte Archive und Zugangsdaten sind ausgeschlossen. Einstieg ist `docs/RESTORE.md`; `docs/MANUAL.md` enthält die ausführliche Anleitung und Fehlerfälle.

## Flow
trigger t1: Giovanni will die Laptop-Einrichtung festhalten oder wiederherstellen | [[acer-nitro]]
decide d1: Festhalten oder wiederherstellen?
step s1: capture erfasst Pakete, Repositories, erlaubte Einstellungen; der Scanner weist Geheimnisse ab
step s2: status und ein wöchentlicher Timer melden Änderungen seit der Aufnahme
step s3: restore gibt einen Plan aus
decide d2: Fügt Giovanni --apply hinzu?
step s4: Installiert Quellen, Pakete, Werkzeuge, Repositories; Einstellungen zuletzt, mit .mb-bak-Kopien
step s5: Geheimnisse kommen aus dem verschlüsselten Archiv zurück; persönliche Ordner werden zurückkopiert
trigger t2: Giovanni sichert Schlüssel, Logins und persönliche Ordner
step s6: secrets-backup verschlüsselt Schlüssel und Logins; data-backup kopiert die Ordner
product p1: Ein öffentlicher Stand von Paketen und Einstellungen, ohne Geheimnisse
product p2: Nur ein Plan: nichts am Laptop verändert
product p3: Ein wiederhergestellter Laptop
product p4: Verschlüsselte Archive und kopierte Ordner, außerhalb des öffentlichen Repositorys

t1 -> d1
d1 -festhalten-> s1
d1 -wiederherstellen-> s3
s1 -> s2
s2 -> p1
s3 -> d2
d2 -nein-> p2
d2 -ja-> s4
s4 -> s5
s5 -> p3
t2 -> s6
s6 -> p4

## Architecture
### Kontext
person g: Giovanni — sichert und stellt wieder her | [[giovanni]]
system m: machine-bootstrap — baut die Einrichtung des Laptops wieder auf
external pc: Der Computer — Pakete, Einstellungen, Dienste | [[acer-nitro]]
external gh: GitHub — bewahrt den erfassten Zustand | [[github]]
external ssd: Externe Platte — verschlüsselte Schlüssel und persönliche Dateien
external gd: Google Drive — eine zweite Kopie der verschlüsselten Schlüssel

g -sichert und stellt wieder her mit-> m
m -liest und baut wieder auf-> pc
m -legt den Zustand ab in-> gh
m -speichert verschlüsselte Schlüssel auf-> ssd
m -speichert verschlüsselte Schlüssel auf-> gd

### Container
person g: Giovanni | [[giovanni]]
container cl: Befehlszeile — Befehle und Passphrase-Abfrage
container pl: Plan — der Bau ist rein, nur execute ändert etwas
container cp: Erfassung — kopiert nur, was die Erlaubnisliste nennt
container sb: Geheimnis-Sicherung — verschlüsseltes Archiv der Schlüssel und Anmeldungen
container db: Datensicherung — Vorabprüfung, dann Kopie
container fa: Fakten — wie die Maschine aussieht
container sc: Geheimnis-Scanner — weist alles ab, was geheim aussieht
store ss: state/ — was die Erfassung schreibt, in git gehalten
store cf: mb.toml — die Erlaubnisliste

g -führt aus-> cl
cl -plant mit-> pl
cl -erfasst mit-> cp
cl -sichert Schlüssel mit-> sb
cl -sichert Dateien mit-> db
cl -liest die Liste aus-> cf
pl -fragt-> fa
pl -liest-> ss
cp -fragt-> fa
cp -prüft mit-> sc
cp -schreibt-> ss

## What it does
`python3 -m mb` hat acht Unterbefehle. `capture` zeichnet Pakete, Repositories und erlaubte Einstellungen in `state/` auf. `status` meldet Änderungen seit dieser Aufzeichnung. `install-timer` aktiviert eine wöchentliche Hintergrundprüfung. `restore` zeigt einen Plan und führt ihn erst mit `--apply` aus. `secrets-backup` verschlüsselt Schlüssel und Zugänge; `secrets-restore` stellt ein Archiv wieder her. `data-backup` kopiert persönliche Ordner. `scan` prüft die aufgezeichneten Einstellungen auf Geheimnisse.

## How it does it
Die Einstellungsdatei `mb.toml` nennt die erlaubten Dateien und die Rezepte zur Werkzeuginstallation. Ein Rezept hat einen Prüfbefehl und einen Installationsbefehl. Die Aufzeichnung lehnt Dateien ab, die der Geheimnisscanner erkennt. Die Wiederherstellung installiert zuerst Paketquellen, dann Pakete, frühe Rezepte, Apps, Repositories und Werkzeugrezepte; Einstellungen schreibt sie zuletzt. Abweichende vorhandene Einstellungen erhalten eine datierte `.mb-bak`-Kopie. Bootloader-Pakete, die bestimmen, wie der Computer startet, sind ausgeschlossen. `--profile new` schließt auch hardwarespezifische Treiber und Einstellungen aus. `bootstrap.sh` installiert fehlende Voraussetzungen vor der Wiederherstellung.

Geheimnisarchive nutzen GnuPG, das als `gpg` aufgerufene Verschlüsselungsprogramm. Giovanni tippt eine Passphrase, die weder gespeichert noch als Befehlsargument übergeben wird. Die Sicherung schreibt ein verschlüsseltes Archiv, entschlüsselt es zum Vergleich mit den Originalen und lädt dann die Google-Drive-Kopie mit rclone, einem Dateikopierwerkzeug, hoch und prüft sie. Das externe Laufwerk wird anhand seiner Dateisystemkennung gefunden. Die Sicherung persönlicher Dateien lehnt ein nicht eingehängtes Ziel oder zu wenig Platz ab, behält ältere überschriebene Dateien und löscht keine Zieldateien. `--verify` vergleicht Prüfsummen; `--bulk` schließt große ersetzbare Ordner ein.

## Where it sits in the pipeline
Es zeichnet [[laptop-setup]] auf und baut die Einrichtung nach einer Neuinstallation wieder auf. Die Anforderungen `MB-1` bis `MB-16` sind die prüfbaren Versprechen in `docs/REQUIREMENTS.md`. Das Qualitäts-Gate, die Prüfungen, die über das Bestehen entscheiden, ist `tools/quality_gate.sh`: Unit-Tests, Shell-Prüfungen, Geheimnissuche, Zuordnung der Anforderungen zu Tests und Größenlimits. [[pipeline-check]] führt es aus. Das Entscheidungsprotokoll der Quelle dokumentiert einen Lauf auf einer sauberen virtuellen Maschine mit Ubuntu 26.04 und 27 erfolgreichen Prüfungen am 2026-10-25; diese Prüfung las den Eintrag und das Testskript, wiederholte jedoch nicht die ganze Wiederherstellung. Private Repositories und das echte Passphrase-Archiv waren von diesem dokumentierten Nachweis ausgeschlossen.

## Who receives its output
Giovanni und der Assistent bei der Wiederherstellung. Die dokumentierte Reihenfolge: Werkzeug beschaffen, Schlüssel wiederherstellen, Programme und Einstellungen wiederherstellen, persönliche Dateien zurückkopieren.

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Prinzipien
1. **Anforderung, dann Test, dann Code**: geprüft vom Rückverfolgbarkeitsschritt des Gates.
2. **Planen ist rein, das System wird an einer Stelle berührt**: `build_plan` liest nur; nur `execute` ändert etwas, und der Befehlsausführer ist ein Pflichtargument. Die Tests übergeben einen Ausführer, der den Test scheitern lässt, wenn er aufgerufen wird.
3. **Nichts Geheimes in git**: Erfassung ist eine Erlaubnisliste plus ein Scanner, und das Gate durchsucht `state/`. Geheimnisse gehen nur durch die verschlüsselte Sicherung.
4. **Das Gate entscheidet**: `tools/quality_gate.sh` ist die einzige Definition von „bestanden“, und die kontinuierliche Integration führt es aus.
5. **Nur die virtuelle Maschine beweist eine Wiederherstellung**: Nach Änderung eines Rezepts, des Plans oder von `bootstrap.sh` läuft `tools/vm-test.sh`, und das Ergebnis kommt ins Entscheidungsprotokoll.
6. **Ein Werkzeug, das mehrere Projekte nutzen, lebt nur einmal**, in einem eigenen Repository, nach Version festgelegt.
7. **Entscheidungen stehen dort, wo der Code ist**: Entscheidungsprotokoll und für Strukturelles ein Architekturentscheidungsprotokoll.

### Entscheidungen
Fünf Architekturentscheidungsprotokolle (kurze Notizen, die die Gründe einer Entscheidung bewahren) in `docs/adr/`: 0002 Python nur mit Standardbibliothek plus ein kleiner Bash-Starter; 0003 ein Programm misst und ein Skill urteilt; 0004 Erfassung per Erlaubnisliste und Ablehnung von allem, was der Geheimnis-Scanner meldet; 0005 Schlüssel und Anmeldungen in einem passphrase-verschlüsselten Archiv an zwei Orten. `DESIGN.md` enthält die Diagramme, auch die Wiederherstellungsreihenfolge, und das Entscheidungsprotokoll.

### Anforderungen
16 Anforderungen (Präfix MB) in `docs/REQUIREMENTS.md`. Jede hat einen Test mit dem Tag `REQ MB-N`, und die Rückverfolgbarkeitsprüfung ([[check-traceability]]) schlägt fehl, wenn eine keinen hat.

### Quality Gate
Das Gate hat drei Schritte: die Unit-Tests, eine Shell-Skript-Prüfung von `bootstrap.sh` und der Geheimnis-Scan von `state/`; die Rückverfolgbarkeit der Anforderungen; und die Fitnessfunktionen (Grenzen in `pipeline-check.toml`, auch die Gate-Dauer).

### Kontinuierliche Integration
Kontinuierliche Integration (CI) heißt automatische Prüfungen bei jedem Push. Der Workflow `quality-gate.yml` führt das Gate bei jedem Push auf GitHub aus, über `pipeline-check`, festgelegt in `pipeline-check.version`.

### Wartung
Technische Schulden werden als GitHub-Issues mit dem Label `debt` (P1 bis P3) nach der [[maintenance-policy]] geführt. Die [[monthly-architecture-review]] prüft das Projekt jeden Monat; die nächste ist am 22.11.2026 fällig.

## Notes
Browserprofile, Spielinstallationen und die eigenen Einstellungen des Handys sind nicht enthalten. Die aktuelle Aufzeichnungskonfiguration enthält `.codex/skills`, lässt aber `.agents/skills` aus; die Wiederherstellung der verwalteten Codex-Skill-Verknüpfungen ist damit nicht nachgewiesen. Diese Lücke steht im Ablauf-Audit von [[codex-skills]]. Downloadrezepte hängen von externen Adressen ab; eine frühere erfolgreiche Wiederherstellung beweist daher keinen künftigen Erfolg. Auf dem Laufwerk liegt ein Geheimnisarchiv vom 2026-10-26; eine Wiederherstellung damit auf einem neuen Computer wurde nicht getestet. `DESIGN.md` hält fest, dass der Hauptzweig (main) des öffentlichen Repositorys die GitHub-Actions-Prüfung `gate` verlangt, dies auch für Administratoren gilt und Force-Pushes sowie das Löschen des Zweigs verboten sind. Das Repository enthält außerdem `docs/PRIVACY.md`, den Datenschutzhinweis einer persönlichen Google-OAuth-Anwendung (Open Authorization, ein Standard, um Zugriff ohne Weitergabe des Passworts zu erlauben; die Identität, mit der [rclone](https://rclone.org/) auf Google Drive zugreift), die die gemeinsame von rclone ersetzt; er nennt, dass die Anwendung alle Dateien des autorisierenden Drive-Kontos ansehen und verwalten darf, dass der Ablauf verschlüsselte Archive hochlädt und vorhandene Drive-Sicherungen nicht löscht und dass Zugangsdaten und Tokens in der privaten rclone-Konfiguration bleiben. Ein Upload damit wurde nicht getestet.

`python3 -m mb` wird in `~/dev/machine-bootstrap` ausgeführt. Erlaubte Einstellungen sind etwa `.bashrc` und Konfigurationsdateien der Desktopoberfläche. Frühe Rezepte richten App-Stores vor den Apps ein; spätere Rezepte installieren Werkzeuge nach dem Klonen der Repositories. Die Laufwerkskennung steht als `[data].ssd_uuid` und das Cloudziel als `[secrets].gdrive_path` in `mb.toml`. Archive liegen unter `machine-bootstrap/secrets/` auf dem Laufwerk, persönliche Dateien unter `machine-bootstrap/home/`. Ein fehlgeschlagener Schritt erscheint als `[FAIL]`; ohne `--stop-on-error` läuft die Wiederherstellung weiter. Ursache beheben und erneut starten: erledigte Schritte werden übersprungen. Skill-Verknüpfungen sind Dateisystemverweise, über die Codex die von [[codex-skillsctl]] verwalteten Anleitungsordner findet.

Die lokale Datei `pipeline-check.toml` nennt nun `yujideluca/machine-bootstrap`, den Zweig `main` und die erforderliche Prüfung `gate`. Im lokalen Modus prüft das Werkzeug sowohl das jüngste GitHub-Testergebnis als auch den aktiven Zweigschutz; der Bericht vom 2026-10-26 zeigt beides als `ok` (bestanden).

Eine eigene Google-Autorisierungsanwendung ist im Projekt `rclone-personal-backup-512812` registriert. Die Anwendung ist im Produktionsmodus veröffentlicht. Ihr Desktop-Client kennzeichnet die lokale rclone-Installation bei Google-Zugriffsanfragen. Die Google-Nutzerdatenrichtlinie wurde angenommen und der vollständige Drive-Zugriff mit Giovannis Zustimmung konfiguriert. Der öffentliche Datenschutzhinweis liegt als `docs/PRIVACY.md` im Bootstrap-Repository. Die rclone-Verbindung verwendet jetzt diesen Desktop-Client und ein am 2026-10-26 heruntergeladenes Ersatzgeheimnis. Google hat den Ersatz bei einer erneuten Anmeldung angenommen. Die private Konfiguration liegt in `~/.config/rclone/rclone.conf` und ist nur für ihren Besitzer lesbar. Giovanni hat vollständigen Drive-Zugriff erlaubt; eine erneute Google-Anmeldung hat die Berechtigung `drive` erteilt. Die vorhandene verschlüsselte Sicherung ist erreichbar: Ihre vollständigen Metadaten entsprechen der gespeicherten Ausgangsaufnahme, und das Herunterladen ihrer 174220 Bytes ergibt dieselbe SHA-256-Prüfsumme (Secure Hash Algorithm 256), einen Wert zum Erkennen von Inhaltsänderungen. Der Vergleich fand vorher und nachher eine unveränderte Datei. Bei dieser Prüfung wurde keine neue Sicherung hochgeladen. Der Widerruf des ursprünglichen Geheimnisses wurde nicht bestätigt.
