---
id: skill-reparo-kubuntu
lang: de
source_hash: efb7759868da
title: Skill: reparo-kubuntu (Laptop-Reparatur)
---

## What it is
Die Skill „reparo-kubuntu“ („Kubuntu-Reparatur“) diagnostiziert und behebt Probleme von Giovannis Laptop (ein Acer Nitro mit Kubuntu 24.04, der Plasma-5.27-Oberfläche, dem Anzeigesystem X11 und einer Nvidia-Grafikkarte) und macht die Reparaturen neustartfest. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt genau das. Ihre Rolle ist „Domäne“: Sie besitzt den Diagnose- und Reparaturablauf auf seinem Linux; sie verweist auf [[skill-browser-automacao-segura]], falls ein Browser benutzt wird; und sie beachtet die Sprache der Nachricht und die Tiefe-Flags `!!`, `***` und `...`. Die Fassung für Claude Code wird nur dort bearbeitet; die Claude-App behält ihre eigene Fassung ([[claude-ai-skills]]).

## What it does
Sie deckt Probleme mit Anzeige, Treibern, Ton, Netzwerk, Desktop und Start ab, Schritt für Schritt, wobei Befehle, die Administratorrechte brauchen (`sudo`), Giovanni zum Ausführen mit dem Präfix `!` übergeben werden. Ihre Methode stammt aus Googles „Effective Troubleshooting“ ([SRE-Buch](https://sre.google/sre-book/effective-troubleshooting/); SRE ist Site Reliability Engineering) und dem siebenstufigen Troubleshooting von Ubuntu: stabilisieren und Beweise sichern → untersuchen → nach Wahrscheinlichkeit geordnete Hypothesen → eine Änderung nach der anderen → beheben → nach einem Neustart erneut testen → dokumentieren. Die Fallen sind, einem irrelevanten Symptom nachzujagen, eine unsichere Änderung während des Tests und die Annahme, die alte Ursache sei zurückgekehrt.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/reparo-kubuntu`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Wartung des Laptops selbst.

## Who receives its output
Der [[acer-nitro]].

## Steps
0. **Format.** Zuerst die Schlussfolgerung: die Haupthypothese plus der nächste Schritt. Mit `!!`: bis zu 5 Zeilen (Hypothese, 1 Test, 1 Reparatur, wie man prüft). Jede Antwort, die eine Reparatur vorschlägt, endet mit **Prüfen** (was nach dem Neustart zu kontrollieren ist) und **Rückgängig** (wie man zurückdreht).
1. **Stabilisieren und sammeln, ohne etwas zu ändern.** Claude Code läuft auf dem Laptop selbst, also die Befehle selbst ausführen, ohne Giovanni etwas einfügen zu lassen. Ein Block sammelt Systemversion, Kernel, Plasma-Version, Sitzungstyp, Nvidia-Treiberversion, die Warnungen und Fehler des Benutzer- und Systemjournals dieses Starts, aktuelle Absturzabbilder und die jüngste Verlaufsliste des Paketmanagers und speichert sie in `~/diag_<Datum>_<Uhrzeit>.txt`. Befehle mit `sudo` fragen nach einem Passwort: Giovanni die Zeile zum Ausführen mit `! sudo ...` geben. Nur fragen, was das Log nicht beantwortet: was sich geändert hat (Update, Konfiguration, Theme) und ob es reproduzierbar ist.
2. **Symptom → erste Hypothese → sicherer Test** (aus seiner Geschichte). Schwarzer Bildschirm, kein Panel oder Absturz von plasmashell oder krunner → Absturz von plasmashell (ein Fehler der Schriftbibliothek oder ein fehlendes Theme) → `coredumpctl info plasmashell`, `systemctl --user restart plasma-plasmashell`. Absturz in libfontconfig → beschädigter Schriftcache oder schlecht passende Webschrift → `fc-cache -r -v`, `fc-match sans`. Akzentuierte Großbuchstaben oder seltsame Tastatur → die Eingabemethode Fcitx plus Layout und Modell (`pc104alt`, `br`) → `fcitx5-diagnose`, `setxkbmap -query`. Touchpad ohne Konfiguration → Modul oder Treiber (libinput gegenüber synaptics, ein XCTECH-Empfänger) → `xinput list`, `journalctl -k | grep -i touch`. Langsamer Start → `NetworkManager-wait-online` oder fstab → `systemd-analyze blame | head`, `systemd-analyze critical-chain`. Flackern → Nvidia-Treiber gegenüber Kernel → `ubuntu-drivers devices`, `dkms status`.
3. **Sicher ändern.** Eine Änderung nach der anderen und sagen, was sie beweist. Vor dem Bearbeiten ein datiertes Backup machen (`cp -a`). Nie `rm -rf` in `~/.config` oder `/etc`: stattdessen in einen Quarantäneordner verschieben. Vor Eingriffen in Treiber oder Kernel einen Snapshot (Timeshift) machen, falls verfügbar. `sudo`-Befehle in einer Zeile erklären und ihn mit `! sudo ...` ausführen lassen; ohne sudo selbst ausführen und die relevante Ausgabe zeigen.
4. **Dauerhaft machen (seine Priorität).** Eine Reparatur wird zu einem Skript `~/fixes/<Name>.sh` (idempotent, mit abschließender Prüfung). Muss sie in jeder Sitzung laufen, eine systemd-Benutzereinheit `~/.config/systemd/user/<Name>.service` anlegen (`Type=oneshot`, `After=graphical-session.target` und, falls sie Plasma berührt, `After=plasma-plasmashell.service`, `ExecStart=%h/fixes/<Name>.sh`, `WantedBy=graphical-session.target`) und mit `systemctl --user enable <Name>` aktivieren. Eine Plasma-Umgebungsvariable kommt nach `~/.config/plasma-workspace/env/`.
5. **Erneut testen und festhalten.** Neu starten, den Block aus Schritt 1 erneut ausführen und mit dem vorigen vergleichen. Ursache, Reparatur und Rückgängigmachen in `~/fixes/LEIAME.md` festhalten.
