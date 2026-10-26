---
id: machine-bootstrap
lang: de
source_hash: 14fbba7251ed
title: machine-bootstrap (die Einrichtung des Laptops wiederherstellen)
---

## What it is
`machine-bootstrap` zeichnet die Einrichtung von Giovannis Laptop ([[acer-nitro]]) auf, um sie nach einer Neuinstallation des Betriebssystems oder auf einem anderen Computer wiederherzustellen. Es nutzt Pythons Standardbibliothek und ein Bash-Startskript. Das lokale Repository liegt in `~/dev/machine-bootstrap`; es hat derzeit weder Commits noch ein entferntes Repository. Einstieg ist `docs/RESTORE.md`; `docs/MANUAL.md` enthält die ausführliche Anleitung und Fehlerfälle.

## What it does
`python3 -m mb` hat acht Unterbefehle. `capture` zeichnet Pakete, Repositories und erlaubte Einstellungen in `state/` auf. `status` meldet Änderungen seit dieser Aufzeichnung. `install-timer` aktiviert eine wöchentliche Hintergrundprüfung. `restore` zeigt einen Plan und führt ihn erst mit `--apply` aus. `secrets-backup` verschlüsselt Schlüssel und Zugänge; `secrets-restore` stellt ein Archiv wieder her. `data-backup` kopiert persönliche Ordner. `scan` prüft die aufgezeichneten Einstellungen auf Geheimnisse.

## How it does it
Die Einstellungsdatei `mb.toml` nennt die erlaubten Dateien und die Rezepte zur Werkzeuginstallation. Ein Rezept hat einen Prüfbefehl und einen Installationsbefehl. Die Aufzeichnung lehnt Dateien ab, die der Geheimnisscanner erkennt. Die Wiederherstellung installiert zuerst Paketquellen, dann Pakete, frühe Rezepte, Apps, Repositories und Werkzeugrezepte; Einstellungen schreibt sie zuletzt. Abweichende vorhandene Einstellungen erhalten eine datierte `.mb-bak`-Kopie. Bootloader-Pakete, die bestimmen, wie der Computer startet, sind ausgeschlossen. `--profile new` schließt auch hardwarespezifische Treiber und Einstellungen aus. `bootstrap.sh` installiert fehlende Voraussetzungen vor der Wiederherstellung.

Geheimnisarchive nutzen GnuPG, das als `gpg` aufgerufene Verschlüsselungsprogramm. Giovanni tippt eine Passphrase, die weder gespeichert noch als Befehlsargument übergeben wird. Die Sicherung schreibt ein verschlüsseltes Archiv, entschlüsselt es zum Vergleich mit den Originalen und lädt dann die Google-Drive-Kopie mit rclone, einem Dateikopierwerkzeug, hoch und prüft sie. Das externe Laufwerk wird anhand seiner Dateisystemkennung gefunden. Die Sicherung persönlicher Dateien lehnt ein nicht eingehängtes Ziel oder zu wenig Platz ab, behält ältere überschriebene Dateien und löscht keine Zieldateien. `--verify` vergleicht Prüfsummen; `--bulk` schließt große ersetzbare Ordner ein.

## Where it sits in the pipeline
Es zeichnet [[laptop-setup]] auf und baut die Einrichtung nach einer Neuinstallation wieder auf. Die Anforderungen `MB-1` bis `MB-16` sind die prüfbaren Versprechen in `docs/REQUIREMENTS.md`. Das Qualitäts-Gate, die Prüfungen, die über das Bestehen entscheiden, ist `tools/quality_gate.sh`: Unit-Tests, Shell-Prüfungen, Geheimnissuche, Zuordnung der Anforderungen zu Tests und Größenlimits. [[pipeline-check]] führt es aus. Das Entscheidungsprotokoll der Quelle dokumentiert einen Lauf auf einer sauberen virtuellen Maschine mit Ubuntu 26.04 und 27 erfolgreichen Prüfungen am 2026-10-25; diese Prüfung las den Eintrag und das Testskript, wiederholte jedoch nicht die ganze Wiederherstellung. Private Repositories und das echte Passphrase-Archiv waren von diesem dokumentierten Nachweis ausgeschlossen.

## Who receives its output
Giovanni und der Assistent bei der Wiederherstellung. Die dokumentierte Reihenfolge: Werkzeug beschaffen, Schlüssel wiederherstellen, Programme und Einstellungen wiederherstellen, persönliche Dateien zurückkopieren.

## Notes
Browserprofile, Spielinstallationen und die eigenen Einstellungen des Handys sind nicht enthalten. Die aktuelle Aufzeichnungskonfiguration enthält `.codex/skills`, lässt aber `.agents/skills` aus; die Wiederherstellung der verwalteten Codex-Skill-Verknüpfungen ist damit nicht nachgewiesen. Diese Lücke steht im Ablauf-Audit von [[codex-skills]]. Downloadrezepte hängen von externen Adressen ab; eine frühere erfolgreiche Wiederherstellung beweist daher keinen künftigen Erfolg. Diese Prüfung erstellte kein echtes Geheimnisarchiv und testete keine Wiederherstellung auf einem neuen Computer.

`python3 -m mb` wird in `~/dev/machine-bootstrap` ausgeführt. Erlaubte Einstellungen sind etwa `.bashrc` und Konfigurationsdateien der Desktopoberfläche. Frühe Rezepte richten App-Stores vor den Apps ein; spätere Rezepte installieren Werkzeuge nach dem Klonen der Repositories. Die Laufwerkskennung steht als `[data].ssd_uuid` und das Cloudziel als `[secrets].gdrive_path` in `mb.toml`. Archive liegen unter `machine-bootstrap/secrets/` auf dem Laufwerk, persönliche Dateien unter `machine-bootstrap/home/`. Ein fehlgeschlagener Schritt erscheint als `[FAIL]`; ohne `--stop-on-error` läuft die Wiederherstellung weiter. Ursache beheben und erneut starten: erledigte Schritte werden übersprungen. Skill-Verknüpfungen sind Dateisystemverweise, über die Codex die von [[codex-skillsctl]] verwalteten Anleitungsordner findet.
