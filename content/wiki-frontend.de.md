---
id: wiki-frontend
lang: de
source_hash: 99292891e9d1
title: Wiki-Front-End (Elm)
---

## What it is
Das Front End ist der Teil des Wikis, den man sieht und anklickt. Es ist in [Elm](https://elm-lang.org/) geschrieben (Giovannis Wahl), einer Sprache für Webseiten, die viele Arten von Fehlern gar nicht erst kompiliert, sodass Fehler abgefangen werden, bevor die Seite je läuft.

## Architecture
### Kontext
person g: Giovanni — durchstöbert die Karte und die Artikel | [[giovanni]]
system f: Wiki-Frontend — der Teil, den man sieht und anklickt
external s: Wiki-Server — schickt die Datendateien | [[wiki-server]]
external b: Browser-Speicher — merkt sich die Sprache

g -benutzt-> f
s -schickt Datendateien an-> f
f -merkt sich die Sprache in-> b

### Container
person g: Giovanni | [[giovanni]]
container ma: Main — Zustand, Nachrichten und Routen
container mp: Karte — die Punkte, die Linse und der Filter | [[wiki-map-view]]
container ar: Artikel — die Seite mit Infobox und Abschnitten | [[wiki-article-view]]
container fl: Flussdiagramm — zeichnet Flussdiagramme und C4-Diagramme | [[wiki-flow-view]]
container sr: Suche — ordnet Vorschläge | [[wiki-search]]
container bo: boot.js — die einzige Tür zu JavaScript
store da: Datendateien — der Graph und eine Datei pro Seite und Sprache | [[wiki-site]]
store ls: Browser-Speicher — die gewählte Sprache

g -benutzt-> ma
ma -zeigt-> mp
ma -zeigt-> ar
ma -fragt-> sr
ar -zeichnet Diagramme mit-> fl
ma -lädt-> da
ma -spricht mit JavaScript über-> bo
bo -schreibt die Sprache in-> ls

## What it does
Der Startbildschirm ist die Systemkarte ([[wiki-map-view]]) mit Suche und Vorschlägen ([[wiki-search]]), einem Projektfilter, einem Zeitleistenregler und einer Legende der Arten. Fährt man über einen Punkt, füllen sich vier Kästen mit seiner Beschreibung; ein Klick auf einen Punkt öffnet seinen Artikel ([[wiki-article-view]]). Ein Link „Glossar“ in der oberen Leiste führt zur Glossarseite, und Links zu anderen Websites öffnen sich in einem neuen Tab. Die Oberfläche ist auf Englisch, Deutsch oder brasilianischem Portugiesisch, im Browser gemerkt. Auf einem Handy (ein Fenster bis 760 Pixel Breite) füllt die Karte den ganzen Bildschirm mit einer pillenförmigen Suchleiste oben, ein Tipp auf einen Punkt öffnet eine Sprechblase, und Artikelseiten folgen dem Aufbau der mobilen Wikipedia; auf einem Desktop wird die Karte durch eine Linse gesehen und ihre Punkte sind elastisch (beides beschrieben in [[wiki-map-view]] und [[wiki-article-view]]).

## How it does it
Es ist eine `Browser.application` (ein Elm-Programm, das die ganze Seite und ihre Adresse steuert) mit den Routen `/` und `/p/<id>`. Es lädt `data/graph.json` einmal und jeden Artikel in der gewählten Sprache bei Bedarf; die Sprache wird über einen Port (Elms kontrollierte Tür zu JavaScript, in `boot.js`) in localStorage (dem kleinen Schlüssel-Wert-Speicher des Browsers) gehalten. Die Karte ist dunkel und filmisch (angelehnt an „Dark explorer“-Visualisierungen), die Artikel sind hell mit Serifenschrift, wie Wikipedia. Der Code ist in Module aufgeteilt: `Main` (Zustand und Nachrichten), `TopBar` (die obere Leiste und das Suchfeld, in einer Desktop- und einer Handy-Form), `MapView`, `MapSize`, `Layout`, `Filter`, `MapCamera` (die Karte ins Fenster einpassen, auf einen Punkt zentrieren, die Linse, die Startpunkte der Federn), `Touch` (ein Finger verschiebt, zwei Finger zoomen), `Lens` (die Globuslinse) und `Motion` (die elastische Bewegung), `ArticleView`, `WikiText`, `Search`, `I18n` und `Data`. `index.html` markiert die Seite als nicht übersetzbar, weil die eigene Übersetzung von Chrome die Suchleiste verdecken und den Text überschreiben würde, den die App steuert. Getestet wird es mit elm-test (Anforderungen MP-1 bis MP-9, LG-2, MB-1 bis MB-8, LN-1 bis LN-4, DY-1 bis DY-6, LY-1 und TC-1 bis TC-3). Seiten mit einem Flussdiagramm werden von [[wiki-flow-view]] gezeichnet.

## Where it sits in the pipeline
Die Spitze des Wikis, nach der Anmeldung vom [[wiki-router]] ausgeliefert.

## Who receives its output
[[giovanni]], auf dem Laptop oder dem Handy.


Verbundene Seiten in der Artikel-Infobox erscheinen als alphabetische Liste mit vollständigen Titeln, farbigen Artmarkierungen und Seitenlinks. Titel werden umgebrochen, damit Seiten mit vielen Verbindungen lesbar bleiben.
