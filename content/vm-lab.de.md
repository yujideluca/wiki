---
id: vm-lab
lang: de
source_hash: b693c9a61448
title: vm-lab (Testrechner für Windows)
---

## What it is
`vm-lab` ist ein kleiner Befehl, `vmlab`, der auf dem [[acer-nitro]] wegwerfbare Windows-Rechner bereithält, damit Software auf einem echten Windows ausprobiert werden kann, ohne einen zweiten Computer zu besitzen. Eine virtuelle Maschine (VM) ist ein ganzer Computer, den ein Programm simuliert; hier ist die Simulation [QEMU](https://www.qemu.org/) mit KVM, der Linux-Funktion, die sie fast so schnell wie echte Hardware macht. Administratorrechte sind nicht nötig. Entstanden ist es, damit [[status-quo]] unter Windows 10 und Windows 11 gebaut und getestet werden kann, aber jeder Test, der ein sauberes Windows braucht, kann es nutzen: ein Installationsprogramm, ein Programm, ein Browser.

## What it does
`vmlab fetch` lädt das kostenlose Evaluierungs-Abbild (ISO) von Microsoft für Windows 10 Enterprise LTSC 2021 oder Windows 11 Enterprise 24H2 herunter. `vmlab create` installiert es ohne Mausklicks: Eine kleine zusätzliche Disc trägt eine Antwortdatei (`autounattend.xml`), die Windows Setup sagt, wie die Platte aufgeteilt wird, welche Sprache gilt und dass ein lokaler Administrator namens `lab` angelegt wird; ein Skript beim ersten Anmelden (`lab-setup.ps1`) schaltet dann den SSH-Server (Secure Shell, eine Möglichkeit, Befehle von außen auszuführen) ein, hinterlegt den Lab-Schlüssel und schaltet den Ruhezustand ab. Windows 11 verweigert normalerweise einen Rechner ohne Sicherheitschip, daher schaltet die Antwortdatei diese Prüfungen ab; die VM hat keinen. `vmlab provision NAME rust` installiert den Rust-Compiler und Microsofts C++-Build-Werkzeuge in der VM. `vmlab start`, `stop`, `ssh`, `ps` (PowerShell-Code genau wie geschrieben ausführen), `push`, `pull`, `sync` (einen Quellordner hineinkopieren, ohne seinen Build-Ordner anzutasten), `shot` (Bildschirmfoto der VM), `reset`, `seal`, `status` und `destroy` erledigen den Rest. Der Gast erreicht das Internet über QEMUs privates Netz und ist nur von diesem Laptop aus erreichbar (SSH auf Port 2210 für Windows 10, 2211 für Windows 11).

## How it does it
Es ist eine einzelne Python-3-Datei ohne zusätzliche Pakete. Alles, was sie erzeugt, liegt in `~/.local/share/vm-lab`: die heruntergeladenen Abbilder, ein Ordner pro VM mit Platte und UEFI-Einstellungen sowie ein SSH-Schlüssel nur für diesen Zweck. Nach der Installation einer VM wird ihre Platte **versiegelt** (`base.qcow2`, nie wieder beschrieben). `start` startet eine zweite, dünne Platte (`work.qcow2`), die nur die Änderungen aufzeichnet, sodass ein Test das saubere Abbild nicht beschädigen kann: `reset` löscht die dünne Platte, `seal` führt sie in die saubere zusammen (nach dem Installieren von Werkzeugen). Windows bringt Treiber für die virtuelle Platte (NVMe) und die Netzkarte (Intel e1000e) mit, daher braucht es keine Treiber-Disc. Der Bildschirm liegt im Speicher, und `shot` lässt QEMU ihn als Bild speichern. Jede VM bekommt 6 GB Speicher (`VMLAB_MEM` ändert das); auf diesem Laptop mit 23 GB läuft immer nur eine.

## Where it sits in the pipeline
Es ist ein Werkzeug des [[acer-nitro]], das der Windows-Teil von [[status-quo]] nutzt (Anforderung SQ-36): Das Projekt wird mit `sync` in die VM kopiert, dort mit `cargo` gebaut und seine Tests laufen; Fehler, die nur Windows zeigt, werden im Code behoben. Beispiele, die so gefunden wurden: Das Speichern einer Datei schlug fehl, weil Windows einen Ordner nicht wie eine Datei leeren kann, eine neu angelegte Datei behielt ihre alte Erstellungszeit, sodass eine Log-Rotation übersehen wurde, und das Installationsprogramm lehnte seinen eigenen Eintrag ab.

## Who receives its output
Giovanni und Claude lesen die Testprotokolle und Bildschirmfotos; die Ergebnisse prägen die Windows-Unterstützung von [[status-quo]].

## Notes
Die Abbilder sind Microsofts Evaluierungsversionen (90 Tage). Das Windows-10-Abbild zeigt auf dem Desktop „license expired“ wegen des in diesem Build eingebrannten Datums; `vmlab create --force` erzeugt ein frisches. Die VM hat keine Grafikkarte, daher kann das Windows-Programm dort sein Fenster nicht öffnen, solange kein Software-OpenGL-Treiber (Mesa) hinzugefügt wird; das geschah am 2026-11-06 nicht, weil das Installieren heruntergeladener Treiberdateien in die VM Giovannis Zustimmung braucht. Windows 11 wurde am selben Tag installiert und die Rust-Einrichtung gestartet.
