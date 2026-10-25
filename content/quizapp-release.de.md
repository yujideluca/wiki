---
id: quizapp-release
lang: de
source_hash: d521404b4214
title: QuizApp-Release (Beta → stabil)
---

## What it is
Diese Seite beschreibt den Weg, den eine Änderung an [[quizapp]] von der Idee bis zu Giovannis Handy nimmt. Der Weg ist so gebaut, dass nichts unspezifiziert, ungetestet oder unerprobt beim Spieler ankommt.

## What it does
Er stellt sicher, dass jede Änderung spezifiziert, getestet, in einer Beta-Version ausprobiert und nur auf Giovannis Ansage in die stabile Version befördert wird.

## How it does it
Zuerst kommt die Anforderung ([[quizapp-requirements]]), dann der Test, dann der Code; das Quality Gate entscheidet; die Beta-Version kommt vor der stabilen ([[release-channels]]).

## Where it sits in the pipeline
Er umfasst [[quizapp-requirements]], [[quizapp-quality-gate]], [[publish-apk]], [[release-feed]] und [[update-client]].

## Who receives its output
Giovanni, auf dem [[phone]].

## Steps
1. Giovanni nennt ein Verhalten; es wird eine Zeile in [[quizapp-requirements]].
2. Claude schreibt den mit `REQ <ID>` getaggten Test, dann den Code, in [[quizapp-core]] oder [[quizapp-app]].
3. Der Debug-Durchgang der ersten Linie: Tests, Installation auf dem [[phone]], den Ablauf durchspielen, logcat lesen ([[skill-adb-android-control]]).
4. Das [[quizapp-quality-gate]] besteht lokal; Push; [[quizapp-ci]] muss grün sein.
5. [[publish-apk]] veröffentlicht eine Beta auf dem Zweig `bleeding-edge` des [[release-feed]] (eine APK, Android Package, ist die installierbare App-Datei).
6. Der [[update-client]] der Beta-App bietet das Update an; Giovanni probiert es aus.
7. `publish_apk.sh promote` (das Gate mit [[mutation-check]] und [[check-tests-updated]]) veröffentlicht die stabile App auf `main`, wenn Giovanni es entscheidet, und nur, wenn `bleeding-edge` genau diesen Commit enthält.
8. Der [[quizweb]]-Port, der auf dem Zweig `web-<version>` wartet, wird nach `main` gemergt.
9. Nur neue Fragen brauchen keine APK: TSV-Dateien (tabulatorgetrennte Werte) bearbeiten, [[build-vocab]] ausführen, committen, dann [[publish-content]] `beta` und, wenn Giovanni es sagt, `promote`.
