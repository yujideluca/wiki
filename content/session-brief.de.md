---
id: session-brief
lang: de
source_hash: 6a4031cc027c
title: Session-Brief (Gedächtnis beim Chat-Start)
---

## What it is
Der Session-Brief ist der Textblock, den ein [[claude-code]]-Chat als Erstes sieht. Er beginnt mit „Memory (workflow-memory)…“ und hat vier Teile: die wenigen Regeln, die immer gelten, vollständig ausgegeben (jede mit einem kurzen `#code`, damit man auf sie verweisen kann); ein Index aller übrigen Regeln, gruppiert nach der Art von Aufgabe, für die sie wichtig sind (ein Tag, etwa `deploy` oder `git`), mit der Zahl der Regeln und einem einzeiligen „use when“; die offenen Punkte; und wie man eine neue Vorliebe festhält, Verwendetes meldet und Rückmeldung gibt.

## What it does
Er legt die Standardwerte der Sitzung fest. Er erlaubt von sich aus nie etwas: Die Rangfolge lautet zuerst die aktuelle Anweisung, dann die Regeldatei des Repositorys, dann das Projektgedächtnis, dann das allgemeine Profil. Anders gesagt: Was Giovanni jetzt sagt, schlägt immer, was das Gedächtnis sagt.

## How it does it
Der [[hook-session-start]] gibt ihn aus. Die `always`-Regeln und der Index stammen aus den Tags in `mem/tags.toml` (der Liste bekannter Tags, jeweils mit ihrer „use when“-Zeile); die offenen Punkte folgen den Regeln von [[mem-pendency]]. Der Teil vor den offenen Punkten bleibt unter 1.900 Zeichen, weil das Programm, das den Hook ausführt, einem Chat nur die ersten 2 KB der Hook-Ausgabe zeigt; ein Test schlägt fehl, wenn das echte Gedächtnis ihn länger macht. Vor einer Aufgabe einer der aufgeführten Arten führt Claude [[mem-rules]] mit dem Tag aus, um den vollen Wortlaut dieser Regeln zu lesen. Ist das Herunterladen des neuesten Gedächtnisses gescheitert, steht im Brief „memory may be stale“. Nach `/clear` oder einer Verdichtung ist der Brief derselbe, weil er ohnehin kurz ist. Regeln, die nur Codex betreffen, haben den Geltungsbereich `instance:codex` und erscheinen nicht im Brief von Claude Code.

## Where it sits in the pipeline
Er ist die erste Eingabe jeder Claude-Code-Sitzung ([[chat-start]]).

## Who receives its output
[[claude-code]] und der [[remote-assistant]].
