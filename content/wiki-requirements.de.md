---
id: wiki-requirements
lang: de
source_hash: bcd517aa3b32
title: Wiki-Anforderungen
---

## What it is
Eine Anforderung ist ein prüfbares Versprechen der Software. Diese Seite beschreibt die eigene Liste von Versprechen des Wikis (`docs/REQUIREMENTS.md`), jedes mit einer ID aus einer Zwei-Buchstaben-Familie und einer Nummer: AU (das Anmelde-Tor), DC (der Köder), CO (Inhaltsregeln), LG (Sprachen), BU (der Build), UP (die Aktualisierungskette), ST (die Veraltung von Seiten), MP (die Karte und die Seiten), MB (die Handy-Version), LN (die Linse auf der Karte), AR (wie ein Artikel gezeichnet wird) DY (die elastischen Punkte) LY (die Berechnung des Layouts) und TC (Berührung auf der Karte).

## What it does
Jede Zeile muss mindestens einen mit `REQ <ID>` getaggten Test haben; die erzeugte Datei `docs/TRACEABILITY.md` ordnet jede Anforderung ihren Tests zu.

## How it does it
Die Zeilen sind aus Giovannis Aussagen (Quelle G) und aus dem genehmigten Entwurf (Quelle D) geschrieben. Die Prüfung [[check-traceability]] erzwingt, dass jedes Versprechen einen Test hat und jedes Tag ein echtes Versprechen nennt.

## Where it sits in the pipeline
Neben dem Entwurfsdokument `docs/2026-10-22-wiki-design.md`.

## Who receives its output
[[check-traceability]] und das [[wiki-quality-gate]].
