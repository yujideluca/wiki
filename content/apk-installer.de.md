---
id: apk-installer
lang: de
source_hash: 70f8d5b3eedf
title: ApkInstaller
---

## What it is
Der `ApkInstaller` ist ein dünner Android-Adapter (ein kleines Codestück, das die App mit einem Teil von Android verbindet). Er öffnet den System-Installer von Android für eine APK (Android Package, die installierbare App-Datei), die heruntergeladen und geprüft wurde.

## What it does
Er übergibt die Datei an den Paketinstaller von Android. Giovannis Fortschritt übersteht das Update, weil die neue APK mit demselben Schlüssel signiert ist wie die alte ([[signing-key]]); Android akzeptiert ein Update nur, wenn es mit demselben Schlüssel signiert ist.

## How it does it
Er wird erst aufgerufen, nachdem der [[update-client]] den SHA-256 der Datei geprüft hat (SHA-256, Secure Hash Algorithm 256, ein Fingerabdruck des Dateiinhalts), sodass ein beschädigter oder manipulierter Download nie zur Installation angeboten wird.

## Where it sits in the pipeline
Der letzte Schritt eines Updates in der App.

## Who receives its output
Android auf dem [[phone]].
