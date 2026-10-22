---
id: apk-installer
lang: de
source_hash: 33698f81c022
title: ApkInstaller
aliases: [Installer]
---

## What it is
Der dünne Android-Adapter, der den Systeminstaller für eine heruntergeladene, geprüfte APK öffnet.

## What it does
Übergibt die Datei an den Paketinstaller von Android; der Fortschritt bleibt erhalten, weil die neue APK mit demselben Schlüssel signiert ist ([[signing-key]]).

## How it does it
Wird erst aufgerufen, nachdem [[update-client]] die SHA-256 geprüft hat.

## Where it sits in the pipeline
Der letzte Schritt eines Updates in der App.

## Who receives its output
Android auf dem [[phone]].
