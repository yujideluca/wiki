---
id: android-toolchain
lang: de
source_hash: c441b11b4ad2
title: Android-Werkzeugkette (env.sh)
---

## What it is
Die „Werkzeugkette“ (Toolchain) ist die Menge der Programme, die aus dem Quellcode von [[quizapp]] eine installierbare Android-App machen. Hier besteht sie aus dem [JDK 21](https://en.wikipedia.org/wiki/Java_Development_Kit) (Java Development Kit, dem Java-Compiler samt Laufzeit), [Gradle](https://gradle.org/) 9.8 (dem Build-Werkzeug, das Kompilieren und Tests ausführt) und dem Android SDK (Software Development Kit: die offiziellen Android-Bibliotheken und Kommandozeilenwerkzeuge). Alles liegt entpackt in `~/dev`, dazu ein kleines Skript, `~/dev/env.sh`, das der Shell sagt, wo sie alles findet.

## What it does
`source ~/dev/env.sh` setzt die Umgebungsvariablen `JAVA_HOME`, `ANDROID_HOME` und `ANDROID_SDK_ROOT` (sie sagen, wo Java und das SDK liegen) und erweitert `PATH` (die Liste der Ordner, in denen die Shell nach Programmen sucht) um die SDK-Kommandozeilenwerkzeuge, die Plattform-Werkzeuge (darunter [adb](https://developer.android.com/tools/adb), die Android Debug Bridge zur Verbindung mit einem Handy) und Gradle.

## How it does it
Alles ist ohne Administratorrechte installiert. Das Quality Gate ([[quizapp-quality-gate]]) lädt die Datei selbst, niemand muss daran denken. Ist sie nicht geladen, werden Befehle wie `adb` oder `gradle` schlicht „nicht gefunden“.

## Where it sits in the pipeline
Unter jedem QuizApp-Build und jedem adb-Befehl.

## Who receives its output
Das [[quizapp-quality-gate]], Gradle-Builds und die Skill [[skill-adb-android-control]].

## Notes
Die Datei ist ein einzulesendes Bash-Fragment mit `# shellcheck shell=bash`. Werte werden vor dem Export zugewiesen, damit `export` einen fehlgeschlagenen Befehl nicht verdeckt. Heimatverzeichnispfade stehen in Anführungszeichen. [[machine-bootstrap]] erfasst dieselbe Datei für die Wiederherstellung. Die Shell-Prüfung und ein Test mit Leerzeichen im Heimatverzeichnispfad bestanden am 2026-10-26.
