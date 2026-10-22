---
id: mem-github-connector
lang: de
source_hash: 4d554d53348a
title: Gedächtnis aus der Claude-App schreiben
aliases: [GitHub-Connector]
---

## What it is
Wie die [[claude-app]], die `mem` nicht ausführen kann, das gemeinsame Gedächtnis trotzdem liest und schreibt.

## What it does
Liest zu Beginn jedes Chats `views/BRIEF.md` und hält eine Korrektur fest, indem sie eine neue Ereignisdatei anlegt.

## How it does it
Über den GitHub-Connector (seine Werkzeuge sind in der App zurückgestellt und müssen beim Namen geladen werden), nach der Anleitung am Ende von BRIEF.md. Auf der Handy-App getestet (normale und Projekt-Chats).

## Where it sits in the pipeline
Die Seite der Claude-App von [[workflow-memory]].

## Who receives its output
[[events-log]].

## Steps
1. Der Chat beginnt; der Verweis in den claude.ai-Einstellungen ([[claude-ai-settings-pointer]]) sagt ihm, die GitHub-Werkzeuge zu laden.
2. Er liest `views/BRIEF.md` aus `yujideluca/workflow-memory` (Branch main) — [[memory-views]].
3. Giovanni gibt eine Korrektur; der Chat legt eine Ereignisdatei in `events/` an, im Format der Anleitung ([[events-log]]).
4. Der Push löst [[mem-action]] aus, die die Datei prüft ([[mem-validator]]) und [[memory-views]] neu baut.
5. Die nächste Claude-Code-Sitzung holt sie in ihr Briefing ([[hook-session-start]]).
