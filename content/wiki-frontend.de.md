---
id: wiki-frontend
lang: de
source_hash: 5f9a770d29aa
title: Wiki-Front-End (Elm)
---

## What it is
Das Front End ist der Teil des Wikis, den man sieht und anklickt. Es ist in [Elm](https://elm-lang.org/) geschrieben (Giovannis Wahl), einer Sprache für Webseiten, die viele Arten von Fehlern gar nicht erst kompiliert, sodass Fehler abgefangen werden, bevor die Seite je läuft.

## What it does
Der Startbildschirm ist die Systemkarte ([[wiki-map-view]]) mit Suche und Vorschlägen ([[wiki-search]]), einem Projektfilter, einem Zeitleistenregler und einer Legende der Arten. Fährt man über einen Punkt, füllen sich vier Kästen mit seiner Beschreibung; ein Klick auf einen Punkt öffnet seinen Artikel ([[wiki-article-view]]). Ein Link „Glossar“ in der oberen Leiste führt zur Glossarseite, und Links zu anderen Websites öffnen sich in einem neuen Tab. Die Oberfläche ist auf Englisch, Deutsch oder brasilianischem Portugiesisch, im Browser gemerkt.

## How it does it
Es ist eine `Browser.application` (ein Elm-Programm, das die ganze Seite und ihre Adresse steuert) mit den Routen `/` und `/p/<id>`. Es lädt `data/graph.json` einmal und jeden Artikel in der gewählten Sprache bei Bedarf; die Sprache wird über einen Port (Elms kontrollierte Tür zu JavaScript, in `boot.js`) in localStorage (dem kleinen Schlüssel-Wert-Speicher des Browsers) gehalten. Die Karte ist dunkel und filmisch (angelehnt an „Dark explorer“-Visualisierungen), die Artikel sind hell mit Serifenschrift, wie Wikipedia. Getestet wird es mit elm-test (Anforderungen MP-1 bis MP-9 und LG-2).

## Where it sits in the pipeline
Die Spitze des Wikis, nach der Anmeldung vom [[wiki-router]] ausgeliefert.

## Who receives its output
[[giovanni]], auf dem Laptop oder dem Handy.
