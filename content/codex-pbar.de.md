---
id: codex-pbar
lang: de
source_hash: bcee08701c85
title: Codex-Statusfenster
---

## What it is
Codex Status ist ein kleines Desktopfenster, das Giovanni zeigt, was Codex gerade tut und wie viel Gesprächskapazität und Kontokontingent noch verfügbar sind. Der Quelltext liegt in `~/dev/codex-pbar` und in einem [GitHub-Repository](https://github.com/yujideluca/codex-pbar). Es übernimmt Zeichenhilfen der Claude-Statusleiste [[pbar]]. Installation und Befehle stehen in `README.md` des Repositorys.

## What it does
Es zeigt Projektordner, Versionskontrollzweig (eine getrennte Entwicklungslinie), Modell, aktive Werkzeugaufrufe, ungefähre Kontextbelegung (die Gesprächsinformationen der letzten Modellanfrage), Nutzungszeiträume (die Zeitspannen, über die ein Kontingent gemessen wird) und deren Rücksetzzeit. Sitzungen bleiben getrennt. Der Zeitbalken nutzt mindestens drei frühere erfolgreiche Aufrufe mit demselben Projekt und gehashten Argumenten; ein Hash ist ein Fingerabdruck, der das Speichern der ursprünglichen Argumente vermeidet. Er schätzt die Dauer eines Werkzeugaufrufs, nicht den Abschluss der gesamten Aufgabe. Unbekannte Werte bleiben unbekannt. Nach fünfzehn Minuten ohne Ereignis gilt eine Sitzung als veraltet.

## How it does it
Python liest die lokalen Codex-Sitzungsdateien datensatzweise. Das Format hängt von der Codex-Version ab; das Leseprogramm wurde mit Version 0.164.0 getestet. Unbekannte Datensätze werden ignoriert, fehlerhafte oder übergroße gezählt. Zugangsdaten werden nicht geöffnet; Modell- und Netzwerkanfragen gibt es nicht. Private lokale Dateien unter `~/.local/share/codex-pbar` enthalten Anzeigestatus und gehashte Laufzeiten, aber keine Prompts, ursprünglichen Argumente oder Werkzeugausgaben.

PySide6, eine Python-Bibliothek für Fenster, zeichnet die Anzeige. Ein Benutzerdienst, ein Hintergrundprogramm unter dem Linux-Dienstverwalter systemd, startet mit dem grafischen Desktop und nach einem Absturz neu. Das Fenster erscheint beim Start eines Codex-Hintergrundprozesses (des Programms, das die Unterhaltung ausführt) oder einer neuen Gesprächsrunde. Schließen blendet es aus; der Menüeintrag **Codex Status** oder `codex-pbar --show` öffnet es wieder. `codex-pbar --json` liefert lokale Diagnosedaten ohne Fenster. Das Installationsprogramm bewahrt Codex-Einstellungen und Freigaberegeln. Die Qualitätsprüfung, die automatisch über das Bestehen einer Änderung entscheidet, führt Tests, Abdeckungsmessung, neun gezielte Fehlereinbauten (absichtliche Fehler, die Tests erkennen müssen), eine Fensterdarstellung und die Zuordnung von Anforderungen zu Tests mit [[pipeline-check]] aus. Wartende Freigaben werden nicht erraten; ein gestarteter Shell-Prozess kann länger als sein Werkzeugaufruf laufen.

## Where it sits in the pipeline
Es läuft neben Codex auf dem Laptop als Teil von [[laptop-setup]]. `systemctl --user status codex-pbar` prüft den Dienst; `systemctl --user disable --now codex-pbar` beendet ihn und deaktiviert den automatischen Start. Den Klon am Installationsort belassen oder nach einem Umzug `tools/install.py` erneut ausführen.

## Who receives its output
Giovanni liest das Desktopfenster. Codex kann bei einer Fehlersuche den lokalen Diagnosebefehl lesen. Sitzungsdaten werden nicht an GitHub gesendet.
