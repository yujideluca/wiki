---
id: quizapp-release
lang: de
source_hash: 31e1fe43f277
title: QuizApp-Release (Beta → stabil)
aliases: [Release-Ablauf]
---

## What it is
Der Weg, den eine Änderung an [[quizapp]] von der Idee bis auf Giovannis Handy nimmt.

## What it does
Stellt sicher, dass jede Änderung spezifiziert, getestet, in der Beta ausprobiert und nur auf Giovannis Wort freigegeben wird.

## How it does it
Erst die Anforderung ([[quizapp-requirements]]), dann der Test, dann der Code; das Tor entscheidet; Beta vor stabil ([[release-channels]]).

## Where it sits in the pipeline
Umfasst [[quizapp-requirements]], [[quizapp-quality-gate]], [[publish-apk]], [[release-feed]], [[update-client]].

## Who receives its output
Giovanni, auf dem [[phone]].

## Steps
1. Giovanni beschreibt ein Verhalten; es wird eine Zeile in [[quizapp-requirements]].
2. Claude schreibt den mit `REQ <ID>` markierten Test, dann den Code, in [[quizapp-core]] oder [[quizapp-app]].
3. Der erste Debug-Durchgang: Tests, Installation auf dem [[phone]], Ablauf durchspielen, logcat lesen ([[skill-adb-android-control]]).
4. [[quizapp-quality-gate]] besteht lokal; Push; [[quizapp-ci]] muss grün sein.
5. [[publish-apk]] veröffentlicht eine Beta im Branch `bleeding-edge` von [[release-feed]].
6. Der [[update-client]] der Beta-App bietet das Update an; Giovanni probiert es aus.
7. `publish_apk.sh promote` (Tor mit [[mutation-check]] und [[check-tests-updated]]) hebt sie nach stabil `main`, wenn Giovanni entscheidet.
8. Die auf `web-<version>` wartende Portierung von [[quizweb]] wird in `main` gemergt.
