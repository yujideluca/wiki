---
id: session-brief
lang: de
source_hash: eb21f1167079
title: Session-Brief (Gedächtnis beim Chat-Start)
---

## What it is
Der Session-Brief ist der Textblock, den ein [[claude-code]]-Chat als Erstes sieht. Er beginnt mit „Memory (workflow-memory)…“ und listet Giovannis dauerhafte Vorlieben (jede mit einem kurzen `#code` versehen, damit man auf sie verweisen kann), die offenen Punkte und wie man eine neue Vorliebe festhält, Verwendetes meldet und Rückmeldung gibt.

## What it does
Er legt die Standardwerte der Sitzung fest. Er erlaubt von sich aus nie etwas: Die Rangfolge lautet zuerst die aktuelle Anweisung, dann die Regeldatei des Repositorys, dann das Projektgedächtnis, dann das allgemeine Profil. Anders gesagt: Was Giovanni jetzt sagt, schlägt immer, was das Gedächtnis sagt.

## How it does it
Der [[hook-session-start]] gibt ihn aus, anhand der Rangfolge aus [[memory-fold]] und der Regeln für offene Punkte aus [[mem-pendency]], jeweils innerhalb eines Größenbudgets, damit der Brief kurz bleibt. Ist das Herunterladen des neuesten Gedächtnisses gescheitert, steht im Brief „memory may be stale“.

## Where it sits in the pipeline
Er ist die erste Eingabe jeder Claude-Code-Sitzung ([[chat-start]]).

## Who receives its output
[[claude-code]] und der [[remote-assistant]].
