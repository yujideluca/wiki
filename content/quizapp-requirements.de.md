---
id: quizapp-requirements
lang: de
source_hash: f4adfd238bb2
title: QuizApp-Anforderungen und Rückverfolgbarkeit
---

## What it is
Eine Anforderung ist ein prüfbares Versprechen des Programms, zum Beispiel „eine falsche Antwort auf eine neue Karte kommt nach 10 Minuten wieder“. Dieser Katalog listet jedes prüfbare Versprechen von [[quizapp]], jedes mit einer ID (SP-1 Abstände, GR-1 Bewertung, QU-1 Warteschlange, DG-* Tagesziel, QP-* Fragenpool usw.), zusammen mit der Teststrategie in `docs/TESTING.md` (Entscheidung ADR-0008, „Anforderungen zuerst“; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält).

## What it does
Er sagt, was gelten muss und auf welcher Ebene jedes Versprechen getestet wird: Unit (ein Teil), Integration (Teile zusammen), Property (viele zufällige Eingaben), plattformübergreifende Konformität (App und Web stimmen überein), Abnahme auf einem Gerät und mutationsgeprüft. Die erzeugte Datei `docs/TRACEABILITY.md` ordnet jede Anforderung ihren Tests zu.

## How it does it
Ein von Giovanni genanntes Verhalten wird zuerst zu einer Zeile; dann wird ein mit `REQ <ID>` getaggter Test geschrieben; dann der Code. Die Prüfung [[check-traceability]] schlägt fehl, wenn eine Anforderung keinen Test hat.

## Where it sits in the pipeline
Der erste Schritt des [[quizapp-release]].

## Who receives its output
[[check-traceability]] und jeder Testautor.
