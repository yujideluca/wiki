---
id: signing-key
lang: de
source_hash: 45f64ed11d94
title: QuizApp-Signaturschlüssel
---

## What it is
Android installiert ein App-Update nur, wenn es mit demselben kryptografischen Schlüssel signiert ist wie die installierte Version. QuizApp hat einen eigenen Signaturschlüssel, der außerhalb des Repositorys in `~/.android` liegt: der Keystore (die Schlüsseldatei) und eine Properties-Datei mit seinen Zugangsdaten. Der Inhalt wird nie anderswo hingeschrieben.

## What it does
Er signiert Debug- und Release-Builds, sodass sich Updates übereinander installieren lassen und der Fortschritt erhalten bleibt; stabil und Beta lassen sich nebeneinander installieren.

## How it does it
Der Gradle-Build liest die Properties-Datei. Fehlt die Datei, fällt er auf den Standard-Debug-Schlüssel zurück, der für Tests in Ordnung ist, aber nicht zur echten App passen würde.

## Where it sits in the pipeline
Benutzt von [[publish-apk]] und von jedem lokalen Build.

## Who receives its output
[[publish-apk]].
