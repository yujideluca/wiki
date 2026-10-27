---
id: quizapp-release
lang: de
source_hash: 66c38a45b9c1
title: QuizApp-Release (Beta → stabil)
---

## What it is
Diese Seite beschreibt den Weg, den eine Änderung an [[quizapp]] von der Idee bis zu Giovannis Handy nimmt. Der Weg ist so gebaut, dass nichts unspezifiziert, ungetestet oder unerprobt beim Spieler ankommt.

## Flow
trigger t1: Giovanni nennt ein Verhalten, das die App haben soll | [[giovanni]]
step s1: Es wird eine Zeile in den Anforderungen | [[quizapp-requirements]]
step s2: Claude schreibt den mit der Anforderung markierten Test, dann den Code | [[quizapp-core]], [[quizapp-app]]
step s3: Fehlersuche: Tests, Installation am Handy, Ablauf durchspielen, Logcat lesen | [[phone]], [[skill-adb-android-control]]
step s4: Das Quality Gate besteht lokal; Push; die automatischen Prüfungen müssen bestehen | [[quizapp-quality-gate]], [[quizapp-ci]]
step s5: Eine Beta wird im Branch bleeding-edge des Release-Feeds veröffentlicht | [[publish-apk]], [[release-feed]]
step s6: Die Beta-App bietet das Update an; Giovanni probiert es aus | [[update-client]]
decide d1: Sagt Giovanni: freigeben?
step s7: Das Promote-Gate (Mutations- und Testprüfung) veröffentlicht die stabile App | [[mutation-check]], [[check-tests-updated]]
step s8: Der wartende QuizWeb-Port wird nach main gemergt | [[quizweb]]
trigger t2: Es kommen nur neue Fragen hinzu | [[question-pool-updater]]
step s9: Bearbeitet die Fragen-Dateien und führt build-vocab aus | [[build-vocab]]
step s10: Veröffentlicht Beta, dann Promote, sobald die automatische Pipeline besteht | [[publish-content]]
product p1: Die stabile App auf Giovannis Handy | [[quizapp]]
product p2: Die Version bleibt Beta und wartet
product p3: Neue Fragen ausgeliefert ohne neue App-Datei

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> s6
s6 -> d1
d1 -ja-> s7
d1 -nein-> p2
s7 -> s8
s7 -> p1
s8 -> p1
t2 -> s9
s9 -> s10
s10 -> p3

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
9. Nur neue Fragen brauchen keine APK: TSV-Dateien (tabulatorgetrennte Werte) bearbeiten, [[build-vocab]] ausführen, committen, dann [[publish-content]] `beta` und `promote`, sobald die automatische Pipeline (das Gate und der [[mutation-check]]) bestanden hat: Seit dem 25. Oktober 2026 deckt Giovannis Dauererlaubnis Aktualisierungen des Fragenpools ab, ein gesondertes Okay ist nicht nötig. App-Releases warten weiterhin auf Giovanni.
