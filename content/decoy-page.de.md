---
id: decoy-page
lang: de
source_hash: fe345081af28
title: Köder-Seite (Decoy)
---

## What it is
Ein Köder (Decoy) ist etwas, das echt aussieht, aber das Echte verbirgt. Die Köder-Seite sieht jeder, der nicht angemeldet ist und die Adresse des Wikis öffnet: ein animierter, psychedelischer Graph aus erfundenen Wörtern und ein Knopf „Mit Google anmelden“ (Giovannis Entwurf). Sie soll sicherstellen, dass ein Fremder, der die Adresse findet, nichts darüber erfährt, was das Wiki enthält.

## What it does
Sie zeigt leuchtende, farbwechselnde Knoten, die treiben, sich verbinden und auf die Maus reagieren, beschriftet mit Kauderwelsch, das zufällig im Browser des Besuchers erzeugt wird. Nichts Echtes steht auf der Seite.

## How it does it
Sie ist eine einzige in sich geschlossene [HTML](https://en.wikipedia.org/wiki/HTML)-Datei (HyperText Markup Language, die Sprache der Webseiten) mit eingebettetem JavaScript, das auf eine Canvas zeichnet: keine externe Datei und keine Netzwerkanfrage. Tests prüfen, dass sie nichts von außen lädt, keine Anfragen stellt und keinen Seitentitel aus dem Inhalt enthält (Anforderung DC-1). Sie beachtet die Browsereinstellung „Bewegung reduzieren“.

## Where it sits in the pipeline
Vom [[wiki-router]] für jede Seitenanfrage ohne gültige Sitzung zurückgegeben.

## Who receives its output
Besucher ohne Sitzung (und Giovanni, vor der Anmeldung).
