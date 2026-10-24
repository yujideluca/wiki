---
id: update-client
lang: de
source_hash: 68a326627fee
title: UpdateClient (Update in der App)
---

## What it is
Der `UpdateClient` ist die Art, wie sich [[quizapp]] ohne App-Store selbst aktualisiert (Entscheidung ADR-0004; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält).

## What it does
Jedes Mal, wenn die App in den Vordergrund kommt (höchstens einmal pro 30 Sekunden; wurde die Uhr des Telefons zurückgestellt, sodass „jetzt“ vor der letzten Prüfung liegt, läuft die Prüfung trotzdem, statt zu warten, bis die Uhr aufgeholt hat), liest er `latest.json` aus dem [[release-feed]]. Ein höherer `versionCode` öffnet ein Popup auf dem Startbildschirm (nie während einer Lernsitzung). Ein Tipp auf „Update“ lädt die APK herunter (Android Package, die installierbare App-Datei), prüft ihren SHA-256-Fingerabdruck (Secure Hash Algorithm 256) und übergibt sie dem [[apk-installer]]. Dieselbe Prüfung fragt auch den [[question-pool-updater]] nach einem neueren Fragenpaket.

## How it does it
Er liest über die GitHub-Contents-API (Application Programming Interface: eine Webschnittstelle zum Lesen von Repository-Dateien) mit dem Header `Accept: application/vnd.github.raw+json`, weil die Adresse `raw.githubusercontent.com` Dateien 5 Minuten zwischenspeicherte. Ein Fehler 403 wird als stündliches Limit gemeldet (60 Anfragen pro IP-Adresse). Die Beta-Variante folgt dem Zweig `bleeding-edge`, die stabile folgt `main` ([[release-channels]]).

## Where it sits in the pipeline
Zwischen dem [[release-feed]] auf GitHub und dem [[apk-installer]] auf dem Handy.

## Who receives its output
Der [[apk-installer]].
