---
id: update-client
lang: de
source_hash: 2dd2dc905f0b
title: UpdateClient (Update in der App)
aliases: [Update-Prüfung]
---

## What it is
Wie [[quizapp]] sich ohne App-Store selbst aktualisiert (ADR-0004).

## What it does
Jedes Mal, wenn die App in den Vordergrund kommt (höchstens alle 30 s), liest sie `latest.json` aus [[release-feed]]; ein höherer versionCode öffnet ein Fenster auf dem Startbildschirm (nie während einer Sitzung). „Aktualisieren“ lädt die APK, prüft ihre SHA-256 und gibt sie an [[apk-installer]]. Dieselbe Prüfung fragt auch [[question-pool-updater]] nach einem neueren Fragenpaket.

## How it does it
Liest über die GitHub-Contents-API (`Accept: application/vnd.github.raw+json`), weil raw.githubusercontent.com 5 Minuten zwischenspeicherte; ein 403 wird als Stundenlimit gemeldet (60 Anfragen pro IP). Die Beta-Variante folgt dem Branch `bleeding-edge`, stable folgt `main` ([[release-channels]]).

## Where it sits in the pipeline
Zwischen [[release-feed]] auf GitHub und [[apk-installer]] auf dem Handy.

## Who receives its output
[[apk-installer]].
