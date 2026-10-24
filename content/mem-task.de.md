---
id: mem-task
lang: de
source_hash: bbabc7f00743
title: mem task (offene Punkte)
---

## What it is
Ein „offener Punkt“ ist ein unerledigtes Ziel oder ein bekanntes Problem, das Giovanni nicht vergessen soll. `mem task --check WIE [--category C] "Text"` ist der Befehl (CLI, Kommandozeilenschnittstelle), der einen solchen Punkt festhält, damit er sichtbar bleibt, bis er erledigt ist.

## What it does
Er erzeugt ein `task`-Ereignis der Form `was offen ist | check: wie man prüft, dass es noch gilt`. Der Punkt wird zu Beginn jedes Chats gezeigt, bis Giovanni entscheidet: erledigt (`mem done`), geparkt (`mem archive`, zurückgeholt mit `mem reopen`) oder gelöscht (`mem forget`). Die Regeln für offene Punkte stehen bei [[mem-pendency]].

## How it does it
Der Befehl lehnt eine Aufgabe ohne Prüfung ab, denn ein nicht prüfbarer Punkt wird zur veralteten Erinnerung. Bevor Claude Giovanni an einen Punkt erinnert, führt es dessen Prüfung aus; gilt er nicht mehr, schließt Claude ihn, statt ihn zu erwähnen.

## Where it sits in the pipeline
Wird am Ende einer Sitzung für alles erzeugt, was noch offen ist.

## Who receives its output
[[events-log]] und dann der [[session-brief]] jedes Chats.
