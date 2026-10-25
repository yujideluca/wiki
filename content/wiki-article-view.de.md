---
id: wiki-article-view
lang: de
source_hash: d646d9738ac7
title: Artikelansicht
---

## What it is
Die Artikelansicht ist die vollständige Seite eines Konzepts, gestaltet wie Wikipedia (Option A der Entwurfsskizzen).

## What it does
Sie zeigt Titel und Art, den Einleitungsabsatz, eine Infobox (Art, Projekt, Status, Ort, Daten seit und bis, Quellen, Gedächtniseinträge) mit dem Pipeline-Streifen (was es speist → es → wer seine Ausgabe erhält) und eine kleine Karte der verbundenen Seiten, dann die Abschnitte mit übersetzten Überschriften und den Verlauf der Seite aus Git. Eine Ablaufseite (eine mit Abschnitt Steps, etwa eine Skill oder ein Verfahren) bekommt außerdem ein Schritt-für-Schritt-Diagramm: nummerierte Punkte, der aktuelle Schritt leuchtet, sein Text und die beteiligten Seiten, mit den Knöpfen Zurück und Weiter.

Der Ring um den hervorgehobenen Schritt (sein Leuchten und sein leichtes Wachsen) bleibt durch Abstand um die Punktereihe vollständig sichtbar.

Auf einem Handy (Fenster bis 760 Pixel Breite) folgt die Seite dem Aufbau der mobilen Wikipedia: oben eine Leiste mit Pfeil zurück zur Karte, Menüknopf und Suchfeld; dann Titel, Einleitungsabsatz und Infobox in einer Spalte; jeder andere Abschnitt beginnt geschlossen und öffnet sich beim Antippen seiner Überschrift.

## How it does it
Der Markdown-Text wird mit elm-markdown dargestellt, nachdem die `[[id]]`-Links in `/p/<id>` umgeschrieben wurden (Anforderung MP-3); Links zu anderen Websites öffnen sich in einem neuen Tab (MP-8). Sie zeigt einen Hinweis, wenn eine Seite noch keine Übersetzung hat oder veraltet sein kann.

## Where it sits in the pipeline
Im [[wiki-frontend]], unter `/p/<id>`.

## Who receives its output
Das [[wiki-frontend]].
