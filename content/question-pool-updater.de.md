---
id: question-pool-updater
lang: de
source_hash: 00d51f3bc0c9
title: Aktualisierer des Fragenbestands (ContentStore, ContentUpdater)
---

## What it is
Der Teil von [[quizapp-app]], der neuere Fragenpakete herunterlädt und entscheidet, welches Paket die App nutzt.

## What it does
Bei jeder Update-Prüfung (App im Vordergrund, höchstens alle 30 s) liest er `content/content.json` aus dem eigenen Feed-Branch (Beta: `bleeding-edge`, stabil: `main`), lädt ein Paket nur, wenn dessen Schema das der App ist und die Version höher als die des genutzten Pakets, und installiert es nur, wenn die Prüfung von [[question-pack]] besteht. Beim Start nutzt er das heruntergeladene Paket nur, solange es neuer ist als das eingebaute; ein veraltetes oder unlesbares wird gelöscht. Der Stapel wird auf dem Startbildschirm oder in den Einstellungen sofort getauscht, während einer Lernsitzung erst bei der Rückkehr zum Start; ein Fenster sagt, wie viele Fragen hinzukamen, und die Einstellungen zeigen Version und Herkunft des Bestands.

## How it does it
`ContentUpdater` holt über [[update-client]] (GitHub-Contents-API); `ContentStore` schreibt nach `files/content/staging` und benennt das in `files/content/current` um, sodass eine unterbrochene Installation nie ein halbes Paket hinterlässt. `ui/QuestionPool.kt` übernimmt Tausch und Fenster. Der Fortschritt bleibt unberührt, weil Karten-IDs aus dem Inhalt kommen. Ein fehlgeschlagener, abgelehnter oder Offline-Download bleibt still und ändert nichts. Getestet von `ContentUpdaterTest`. Debug-Builds können per `adb reverse` einen lokalen Feed lesen (eine nur für Debug geltende Netzkonfiguration erlaubt HTTP zu 127.0.0.1).

## Where it sits in the pipeline
Zwischen [[release-feed]] und den Bildschirmen ([[study-view-model]]).

## Who receives its output
[[study-view-model]] (der neue Stapel und das Fenster).
