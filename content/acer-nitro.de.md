---
id: acer-nitro
lang: de
source_hash: a874eb0a418e
title: Der Laptop (Acer Nitro, yuji-nitro)
---

## What it is
Das ist Giovannis Laptop: ein Acer Nitro mit Nvidia-Grafikkarte, auf dem [Kubuntu](https://kubuntu.org/) läuft (eine Variante des Betriebssystems [Linux](https://en.wikipedia.org/wiki/Linux) mit der Desktopoberfläche KDE Plasma). Im Netzwerk heißt er `yuji-nitro`. Fast alles in diesem Wiki liegt auf ihm: die Projektordner in `~/dev` (`~` steht für Giovannis Home-Ordner), die Claude-Programme und der Webserver dieses Wikis.

Geprüft am 2026-11-05: Das System ist Ubuntu 26.04.1 LTS mit Kernel 7.0.0-38-generic, und der Desktop ist KDE Plasma 6.6.6 in einer Wayland-Sitzung.

## What it does
Er ist die Maschine, auf der gearbeitet wird. Auf ihm laufen [[claude-code]] (der KI-Assistent, der den Code schreibt), der dauerhaft laufende [[claude-assistant]], die Builds und Tests aller Projekte und der Server dieses Wikis ([[wiki-service]]). Ist der Laptop aus oder im Ruhezustand, läuft nichts davon, und das Wiki ist dann nicht erreichbar.

## How it does it
Für das Benutzerkonto ist „Linger“ eingeschaltet. Normalerweise enden die Hintergrundprogramme eines Benutzers, wenn er sich abmeldet; mit Linger laufen sie weiter, auch wenn niemand angemeldet ist. Dadurch starten die obigen Dienste schon beim Hochfahren. Probleme am Laptop selbst (Bildschirm, Treiber, Ton, Netzwerk) werden mit der Skill [[skill-reparo-kubuntu]] behandelt; jede Reparatur wird dauerhaft gemacht, damit sie einen Neustart übersteht. Der Desktop läuft unter [Wayland](https://wayland.freedesktop.org/) (dem System, das die Fenster auf den Bildschirm zeichnet) mit Plasma 6 und vier virtuellen Desktops (getrennten Arbeitsflächen). Win+1…4 wechseln zu einem Desktop, Win+Umschalt+1…4 schicken das aktive Fenster dorthin. Bei Giovannis brasilianischem Tastaturlayout müssen die zweiten Kürzel als Win+!, Win+@, Win+# und Win+$ gespeichert sein, weil Umschalt+1…4 diese Zeichen tippt; sie liegen in KDEs Datei `~/.config/kglobalshortcutsrc`.

Der Laptop hat 23 GB RAM (den schnellen Arbeitsspeicher) und zwei SSDs (Solid-State-Drives): Die Haupt-SSD enthält das System und `~/dev`; eine zweite mit 512 GB ist nur vorübergehend eingehängt (kein Eintrag in `/etc/fstab`, der Liste der beim Start eingehängten Laufwerke). `/tmp` ist ein „tmpfs“, ein Ordner im RAM mit etwa 11,6 GB Obergrenze; Claudes Scratch-Dateien dort belegen also Speicher, und der Auftrag [[claude-scratch-review]] verschiebt oder löscht alte. Seit 2026-11-05 ist der Swap (Plattenplatz als Überlaufspeicher) eine einzelne Datei, `/swapfile`, mit 30 GB auf der Haupt-SSD, mit Swappiness 30 (wie bereitwillig das System ungenutzten Speicher auslagert; der Standard ist 60). Sie ersetzte eine volle 512-MB-Datei. Das Skript für die Änderung ist `~/setup-swap-30g.sh` und braucht `sudo`.

## Where it sits in the pipeline
Die „Pipeline“ ist in diesem Wiki die Kette von Schritten, durch die Arbeit läuft. Der Laptop ist das Erdgeschoss unter allem: Das Projekt [[laptop-setup]] beschreibt, was auf ihm installiert ist, und alles andere läuft darauf. Das Werkzeug [[machine-bootstrap]] hält die Einrichtung dieses Laptops fest, damit sie nach einer Neuinstallation wiederhergestellt werden kann.

## Who receives its output
Jede lokal laufende Claude-Instanz (siehe [[claude-code]] und [[remote-assistant]]) und jedes Projekt, das auf ihm gebaut wird.
