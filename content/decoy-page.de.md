---
id: decoy-page
lang: de
source_hash: 241cfd2b7902
title: Attrappe
aliases: [Köder]
---

## What it is
Was jeder sieht, der nicht angemeldet ist: ein psychedelischer, animierter Graph aus erfundenen Wörtern und ein Knopf „Sign in with Google“ (Giovannis Entwurf).

## What it does
Zeigt leuchtende, farbwechselnde Knoten, die treiben, sich verbinden und auf die Maus reagieren, mit Kauderwelsch-Beschriftungen, die zufällig im Browser des Besuchers entstehen. Nichts Echtes steht auf der Seite.

## How it does it
Eine eigenständige HTML-Datei mit eingebettetem Canvas-JavaScript: keine externe Datei, kein Fetch. Tests prüfen, dass sie nichts von außen lädt, keine Anfragen stellt und keinen Seitentitel aus den Inhalten enthält (DC-1). Beachtet „Bewegung reduzieren“.

## Where it sits in the pipeline
Von [[wiki-router]] für jede Seite ohne Sitzung zurückgegeben.

## Who receives its output
Besucher ohne Sitzung (und Giovanni vor der Anmeldung).
