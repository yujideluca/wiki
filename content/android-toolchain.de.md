---
id: android-toolchain
lang: de
source_hash: cafc764f3c8f
title: Android-Werkzeugkette (env.sh)
---

## What it is
Die „Werkzeugkette“ (Toolchain) ist die Menge der Programme, die aus dem Quellcode von [[quizapp]] eine installierbare Android-App machen. Hier besteht sie aus dem [JDK 21](https://en.wikipedia.org/wiki/Java_Development_Kit) (Java Development Kit, dem Java-Compiler samt Laufzeit), [Gradle](https://gradle.org/) 9.8 (dem Build-Werkzeug, das Kompilieren und Tests ausführt) und dem Android SDK (Software Development Kit: die offiziellen Android-Bibliotheken und Kommandozeilenwerkzeuge). Alles liegt entpackt in `~/dev`, dazu ein kleines Skript, `~/dev/env.sh`, das der Shell sagt, wo sie alles findet.

## Architecture
### Kontext
person g: Giovanni — lädt es beim Bauen von Hand | [[giovanni]]
system t: Android-Werkzeugkette — Java, Gradle und die Android-Werkzeuge in ~/dev
external q: QuizApp-Quality-Gate — lädt es von selbst | [[quizapp-quality-gate]]
external a: QuizApp — der Quellcode, den es in eine App verwandelt | [[quizapp]]
external p: Das Handy — erreicht mit adb | [[phone]]

g -lädt env.sh von-> t
q -lädt-> t
t -baut die App aus-> a
t -spricht mit-> p

### Container
person g: Giovanni oder das Quality Gate
container en: env.sh — setzt die Variablen und den Suchpfad
container jd: Java Development Kit 21 — Java-Compiler und Laufzeit
container gr: Gradle 9.8 — führt Kompilier- und Testschritte aus
container sd: Android-Software-Development-Kit — Bibliotheken und Kommandozeilenwerkzeuge
container ad: adb — die Android Debug Bridge
external p: Das Handy | [[phone]]

g -lädt-> en
en -zeigt auf-> jd
en -fügt zum Suchpfad hinzu-> gr
en -zeigt auf-> sd
en -fügt zum Suchpfad hinzu-> ad
ad -spricht mit-> p

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
