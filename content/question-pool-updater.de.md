---
id: question-pool-updater
lang: de
source_hash: 54ee99ea9be7
title: Fragenpool-Updater (ContentStore, ContentUpdater)
---

## What it is
Das ist der Teil des Moduls [[quizapp-app]], der neuere Fragenpakete herunterlädt und entscheidet, welches Paket die App benutzt. Im Code besteht er aus `ContentUpdater`, `ContentStore` und `QuestionPool`.

## What it does
Bei jeder Update-Prüfung (wenn die App in den Vordergrund kommt, höchstens alle 30 Sekunden) liest er `content/content.json` aus dem eigenen Zweig des Feeds (Beta: `bleeding-edge`, stabil: `main`). Er lädt ein Paket nur herunter, wenn dessen Schema das ist, das die App versteht, und seine Version höher ist als die des benutzten Pakets, und installiert es nur, wenn die Validierung des [[question-pack]] besteht. Beim Start nutzt er das heruntergeladene Paket nur, solange es neuer ist als das eingebaute; ein veraltetes oder unlesbares wird gelöscht. Das Deck wird auf dem Startbildschirm oder in den Einstellungen sofort getauscht, während einer Lernsitzung erst, wenn der Spieler zum Start zurückkehrt. Ein Popup sagt, wie viele Fragen hinzukamen, und die Einstellungen zeigen die Poolversion und woher sie stammt.

## How it does it
`ContentUpdater` holt über den [[update-client]] (die GitHub-Contents-API, Application Programming Interface: eine Webschnittstelle zum Lesen von Repository-Dateien). `ContentStore` schreibt in `files/content/staging` und benennt diesen Ordner dann in `files/content/current` um, sodass eine unterbrochene Installation nie ein halbes Paket hinterlässt. `ui/QuestionPool.kt` führt den Tausch aus und zeigt das Popup. Der Fortschritt bleibt unberührt, weil die Karten-IDs aus dem Inhalt stammen. Ein fehlgeschlagener, abgelehnter oder offline erfolgter Download bleibt still und ändert nichts. Getestet wird er durch `ContentUpdaterTest`. Debug-Builds können einen lokalen Feed über `adb reverse` lesen (Portweiterleitung vom Handy zum Laptop; eine nur für Debug geltende Netzwerkeinstellung erlaubt einfaches HTTP zu 127.0.0.1).

## Where it sits in the pipeline
Zwischen dem [[release-feed]] und den Bildschirmen ([[study-view-model]]).

## Who receives its output
Das [[study-view-model]] (das neue Deck und das Popup).
