---
id: work-ask-language
lang: de
source_hash: 316d9a735700
title: Regel: nach der Programmiersprache fragen
---

## What it is
Das ist eine dauerhafte Regel von Giovanni (2026-10-22): Vor jedem Projekt, das Programmieren beinhaltet, muss Claude fragen, welche Programmiersprache(n) für jeden Teil verwendet werden sollen (Front End = was der Nutzer sieht, Back End = der Server dahinter, Werkzeuge), und nie allein eine wählen.

## What it does
Sie legt die Sprachwahl zu Beginn des Entwurfs in Giovannis Hände, nicht erst, wenn Code existiert. Die Regel entstand, als Front End (Elm) und Back End (Elixir) des Wikis erst benannt wurden, nachdem der Entwurf schon skizziert war.

## How it does it
Sie ist im Gedächtnis unter dem Key `work.ask-language` gespeichert und in den Abschnitt „how it gets made“ der Brainstorming-Skill ([[skill-brainstorming]]) geschrieben, also dorthin, wo die Entscheidung getroffen wird.

## Where it sits in the pipeline
Schritt 2 von [[new-project]]; angewandt von [[skill-brainstorming]].

## Who receives its output
[[claude-code]] und der [[remote-assistant]].
