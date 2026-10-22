---
id: signing-key
lang: de
source_hash: ce8b1d83d5cd
title: Signaturschlüssel von QuizApp
aliases: [Release-Keystore]
---

## What it is
Der eigene Android-Signaturschlüssel des Projekts, außerhalb des Repos in `~/.android` (Keystore und eine Properties-Datei mit den Zugangsdaten). Sein Inhalt wird nirgendwo anders hingeschrieben.

## What it does
Signiert Debug- und Release-Builds, damit Updates übereinander installieren und der Fortschritt bleibt; stabil und Beta lassen sich nebeneinander installieren.

## How it does it
Der Gradle-Build liest die Properties-Datei; fehlt sie, nimmt er den Standard-Debugschlüssel.

## Where it sits in the pipeline
Genutzt von [[publish-apk]] und jedem lokalen Build.

## Who receives its output
[[publish-apk]].
