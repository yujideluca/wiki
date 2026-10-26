---
id: acer-nitro
lang: de
source_hash: 0dddfd229fee
title: Der Laptop (Acer Nitro, yuji-nitro)
---

## What it is
Das ist Giovannis Laptop: ein Acer Nitro mit Nvidia-Grafikkarte, auf dem [Kubuntu](https://kubuntu.org/) läuft (eine Variante des Betriebssystems [Linux](https://en.wikipedia.org/wiki/Linux) mit der Desktopoberfläche KDE Plasma). Im Netzwerk heißt er `yuji-nitro`. Fast alles in diesem Wiki liegt auf ihm: die Projektordner in `~/dev` (`~` steht für Giovannis Home-Ordner), die Claude-Programme und der Webserver dieses Wikis.

## What it does
Er ist die Maschine, auf der gearbeitet wird. Auf ihm laufen [[claude-code]] (der KI-Assistent, der den Code schreibt), der dauerhaft laufende [[claude-assistant]], die Builds und Tests aller Projekte und der Server dieses Wikis ([[wiki-service]]). Ist der Laptop aus oder im Ruhezustand, läuft nichts davon, und das Wiki ist dann nicht erreichbar.

## How it does it
Für das Benutzerkonto ist „Linger“ eingeschaltet. Normalerweise enden die Hintergrundprogramme eines Benutzers, wenn er sich abmeldet; mit Linger laufen sie weiter, auch wenn niemand angemeldet ist. Dadurch starten die obigen Dienste schon beim Hochfahren. Probleme am Laptop selbst (Bildschirm, Treiber, Ton, Netzwerk) werden mit der Skill [[skill-reparo-kubuntu]] behandelt; jede Reparatur wird dauerhaft gemacht, damit sie einen Neustart übersteht. Der Desktop läuft unter [Wayland](https://wayland.freedesktop.org/) (dem System, das die Fenster auf den Bildschirm zeichnet) mit Plasma 6 und vier virtuellen Desktops (getrennten Arbeitsflächen). Win+1…4 wechseln zu einem Desktop, Win+Umschalt+1…4 schicken das aktive Fenster dorthin. Bei Giovannis brasilianischem Tastaturlayout müssen die zweiten Kürzel als Win+!, Win+@, Win+# und Win+$ gespeichert sein, weil Umschalt+1…4 diese Zeichen tippt; sie liegen in KDEs Datei `~/.config/kglobalshortcutsrc`.

## Where it sits in the pipeline
Die „Pipeline“ ist in diesem Wiki die Kette von Schritten, durch die Arbeit läuft. Der Laptop ist das Erdgeschoss unter allem: Das Projekt [[laptop-setup]] beschreibt, was auf ihm installiert ist, und alles andere läuft darauf. Das Werkzeug [[machine-bootstrap]] hält die Einrichtung dieses Laptops fest, damit sie nach einer Neuinstallation wiederhergestellt werden kann.

## Who receives its output
Jede lokal laufende Claude-Instanz (siehe [[claude-code]] und [[remote-assistant]]) und jedes Projekt, das auf ihm gebaut wird.
