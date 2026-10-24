---
id: skill-adb-android-control
lang: de
source_hash: a58d90469ff0
title: Skill: adb-android-control
---

## What it is
Die Skill „adb-android-control“ ist die Befehlsreferenz für die Arbeit mit Giovannis Handy (einem Motorola edge 50 fusion) über adb während der App-Entwicklung, etwa bei QuizApp. adb ist die Android Debug Bridge ([Dokumentation](https://developer.android.com/tools/adb)): ein Werkzeug, mit dem ein Computer ein Handy über ein Kabel steuern kann. Ihre Beschreibung sagt: für Android-Arbeit über adb während der App-Entwicklung verwenden: eine APK installieren (Android Package, die installierbare App-Datei), die App starten, tippen, wischen und tippen, um einen Ablauf durchzuspielen, einen Screenshot machen, logcat lesen (das Systemlog von Android, [Dokumentation](https://developer.android.com/tools/logcat)) nach Abstürzen, dumpsys (ein Statusauszug der Systemdienste) und Berechtigungen. Sie ist die Befehlsreferenz für den Debug-Durchgang nach dem Programmieren. Nicht für allgemeine Handyfragen, USB- oder Kubuntu-Probleme ([[skill-reparo-kubuntu]]) oder alles ohne adb. Sie ist aus der Open-Source-Skill hah23255/adb-android-control 2.0.1 (MIT-Lizenz) angepasst: nur die Befehlsreferenz und Abläufe; die Termux-Skripte, der Netzwerk-Portscanner, der Funkscanner und das Python-Paket wurden weggelassen, und ein Netzwerkscan darf aus dieser Skill nie ausgeführt werden.

## What it does
Sie lässt Claude eine App auf dem Handy bedienen und lesen, was passiert ist: der Debug-Durchgang der ersten Linie nach dem Programmieren von [[quizapp]]. Ihre Rolle ist „Domäne“; sie verweist auf die CLAUDE.md des Projekts (bei QuizApp legt `source ~/dev/env.sh` adb in den Pfad und beschreibt Build- und Installationsschritte), auf [[skill-verification-before-completion]] (was als Beleg zählt) und auf [[skill-reparo-kubuntu]] (USB- und Host-Probleme).

## How it does it
Eine `SKILL.md` in `~/.claude/skills/adb-android-control`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Teil des Entwicklungsprozesses in Claude Code, in jedem Projekt mit Android-App benutzt.

## Who receives its output
Das [[phone]]; die logcat-Ausgabe ([[study-debug-log]]) kommt zu Claude zurück.

## Steps
Die Skill ist eine Befehlsreferenz, nach Aufgaben gruppiert. Die Gruppen sind:
1. **Verbindung.** `adb devices` listet verbundene Geräte; `adb connect <ip>:<port>` und `adb disconnect` steuern drahtloses Debugging; `adb kill-server && adb start-server` startet den adb-Hintergrundprozess neu, wenn etwas hängt.
2. **App-Verwaltung.** `adb install -r app.apk` installiert (ersetzt), `-d` erlaubt ein Downgrade, `-g` gewährt alle Berechtigungen; `adb uninstall`, `adb shell pm clear <Paket>` (Daten der App löschen), `adb shell am force-stop <Paket>`, `pm list packages` (optional gefiltert), `pm path` und `adb pull`, um die APK zu extrahieren.
3. **Dateien.** `adb push` und `adb pull` kopieren Dateien; `adb shell ls`, `mkdir`, `rm` und `df -h` untersuchen den Speicher des Handys.
4. **Bildschirm.** `adb exec-out screencap -p > shot.png` macht einen Screenshot direkt auf den Laptop; `adb shell screenrecord` nimmt Video auf (bis 180 Sekunden).
5. **Eingabe.** `adb shell input tap X Y`, `input swipe X1 Y1 X2 Y2 ms`, `input text "..."` (Leerzeichen als `%s`) und `input keyevent KEYCODE_...` (Home 3, Back 4, Power 26, Enter 66 usw.).
6. **Activities und Intents.** `adb shell am start -n <Paket>/.Activity` startet einen Bildschirm; `am start -a android.intent.action.VIEW -d <url>` öffnet einen Link; `am broadcast` sendet eine Systemnachricht.
7. **Informationen.** `getprop` (Modell, Android-Version), `dumpsys battery|meminfo|cpuinfo|wifi`, `wm size`, `ps -A`, `top -n 1`.
8. **Logcat.** `adb logcat -c` leert das Log, `adb logcat -d` gibt es aus und endet, `-s TAG:*` filtert nach Tag, `"*:E"` zeigt nur Fehler, `--pid=$(adb shell pidof -s <Paket>)` zeigt eine App, `-b crash` zeigt Abstürze, `-v time` fügt Zeitstempel hinzu.
9. **Einstellungen und Netzwerk.** `adb shell settings get|put`, `svc wifi enable|disable`, `adb forward` und `adb reverse` (Portweiterleitung zwischen Laptop und Handy).
10. **Strom.** `adb reboot` (auch `recovery` und `bootloader`), `svc power stayon usb` hält den Bildschirm wach, solange verbunden.
11. **Fortgeschritten.** `uiautomator dump` schreibt die Struktur des Bildschirms als XML, `monkey -p <Paket> -v 500` sendet zufällige Ereignisse, `pm grant|revoke` ändert eine Berechtigung, `dumpsys package <Paket>` zeigt Berechtigungen.
12. **Fertige Abläufe.** App-Test-Automatisierung (installieren, starten, Screenshot, tippen, scrollen, End-Screenshot, Logs des App-Prozesses), Geräte-Gesundheitscheck (Modell, Android-Version, Akku, Speicher, Arbeitsspeicher, Prozesszahl), Massen-Screenshots im Intervall sowie Extraktion der APK und der Berechtigungen einer App.
13. **Fehlersuche.** Gerät nicht gefunden: adb-Server neu starten und Geräte auflisten. Gerät offline: trennen und neu verbinden. Zugriff verweigert: manche Operationen brauchen Root. Verbindung abgelehnt: das Gerät mit `adb pair <ip>:PORT CODE` neu koppeln.
