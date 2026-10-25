---
id: wiki-frontend
lang: de
source_hash: 59b40e0006dd
title: Wiki-Front-End (Elm)
---

## What it is
Das Front End ist der Teil des Wikis, den man sieht und anklickt. Es ist in [Elm](https://elm-lang.org/) geschrieben (Giovannis Wahl), einer Sprache für Webseiten, die viele Arten von Fehlern gar nicht erst kompiliert, sodass Fehler abgefangen werden, bevor die Seite je läuft.

## What it does
Der Startbildschirm ist die Systemkarte ([[wiki-map-view]]) mit Suche und Vorschlägen ([[wiki-search]]), einem Projektfilter, einem Zeitleistenregler und einer Legende der Arten. Fährt man über einen Punkt, füllen sich vier Kästen mit seiner Beschreibung; ein Klick auf einen Punkt öffnet seinen Artikel ([[wiki-article-view]]). Ein Link „Glossar“ in der oberen Leiste führt zur Glossarseite, und Links zu anderen Websites öffnen sich in einem neuen Tab. Die Oberfläche ist auf Englisch, Deutsch oder brasilianischem Portugiesisch, im Browser gemerkt. Auf einem Handy (ein Fenster bis 760 Pixel Breite) füllt die Karte den ganzen Bildschirm mit einer pillenförmigen Suchleiste oben, ein Tipp auf einen Punkt öffnet eine Sprechblase, und Artikelseiten folgen dem Aufbau der mobilen Wikipedia; auf einem Desktop wird die Karte durch eine Linse gesehen und ihre Punkte sind elastisch (beides beschrieben in [[wiki-map-view]] und [[wiki-article-view]]).

## How it does it
Es ist eine `Browser.application` (ein Elm-Programm, das die ganze Seite und ihre Adresse steuert) mit den Routen `/` und `/p/<id>`. Es lädt `data/graph.json` einmal und jeden Artikel in der gewählten Sprache bei Bedarf; die Sprache wird über einen Port (Elms kontrollierte Tür zu JavaScript, in `boot.js`) in localStorage (dem kleinen Schlüssel-Wert-Speicher des Browsers) gehalten. Die Karte ist dunkel und filmisch (angelehnt an „Dark explorer“-Visualisierungen), die Artikel sind hell mit Serifenschrift, wie Wikipedia. Der Code ist in Module aufgeteilt: `Main` (Zustand und Nachrichten), `TopBar` (die obere Leiste und das Suchfeld, in einer Desktop- und einer Handy-Form), `MapView`, `MapSize`, `Layout`, `Filter`, `MapCamera` (die Karte ins Fenster einpassen, auf einen Punkt zentrieren, die Linse, die Startpunkte der Federn), `Lens` (das Fischauge) und `Motion` (die elastische Bewegung), `ArticleView`, `WikiText`, `Search`, `I18n` und `Data`. `index.html` markiert die Seite als nicht übersetzbar, weil die eigene Übersetzung von Chrome die Suchleiste verdecken und den Text überschreiben würde, den die App steuert. Getestet wird es mit elm-test (Anforderungen MP-1 bis MP-9, LG-2, MB-1 bis MB-8, LN-1 bis LN-4, DY-1 bis DY-6 und LY-1).

## Where it sits in the pipeline
Die Spitze des Wikis, nach der Anmeldung vom [[wiki-router]] ausgeliefert.

## Who receives its output
[[giovanni]], auf dem Laptop oder dem Handy.
