---
id: release-channels
lang: de
source_hash: bd9b881c526c
title: Release-Kanäle: stabil und Beta
---

## What it is
Ein „Release-Kanal“ ist ein eigener Strom von Versionen, dem man folgen kann. Diese Seite beschreibt die Regel, dass nichts den Spieler erreicht, ohne zuerst durch die Beta-App zu gehen (Entscheidung ADR-0005), und wann eine Beta befördert werden darf (Entscheidung ADR-0011). Ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält.

## What it does
Es gibt zwei Build-Varianten. `stable` (Paket `dev.yuji.quiz`, angezeigt als „Deutsch B2“) folgt dem Zweig `main` des [[release-feed]]; `beta` (Paket `dev.yuji.quiz.beta`, angezeigt als „Deutsch B2 beta“) folgt dem Zweig `bleeding-edge`. Weil die Pakete verschieden sind, lassen sich beide gleichzeitig auf dem Handy installieren. Eine Beta wird beförderungsfähig, sobald sie die automatisierten Tests überstanden hat, die für das Geänderte aktualisiert wurden; danach entscheidet Giovanni.

## How it does it
Durchgesetzt wird es von [[publish-apk]]: Sein `promote` führt das Gate mit [[mutation-check]] und [[check-tests-updated]] aus. Web-Ports warten auf einem Zweig `web-<version>` von [[quizweb]] bis zur Beförderung.

## Where it sits in the pipeline
Es regelt den [[quizapp-release]].

## Who receives its output
Der [[update-client]], der erfährt, welchem Zweig er folgen soll.
