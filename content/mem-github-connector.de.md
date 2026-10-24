---
id: mem-github-connector
lang: de
source_hash: 4442edf5d172
title: Gedächtnis aus der Claude-App schreiben
---

## What it is
Die [[claude-app]] kann keine Programme ausführen und deshalb den Befehl `mem` nicht benutzen. Diese Seite erklärt, wie sie trotzdem das gemeinsame Gedächtnis liest und schreibt: über den GitHub-Connector, eine Erweiterung, die der App Werkzeuge zum Lesen und Schreiben von Dateien in GitHub-Repositories gibt.

## What it does
Zu Beginn jedes Chats liest sie `views/BRIEF.md`; korrigiert Giovanni sie, hält sie die Korrektur fest, indem sie eine neue Ereignisdatei anlegt.

## How it does it
Ihre GitHub-Werkzeuge sind in der App „deferred“ (zurückgestellt), das heißt, sie müssen mit ihrem Namen geladen werden, bevor man sie benutzen kann; der Zeigertext in den App-Einstellungen ([[claude-ai-settings-pointer]]) weist sie dazu an. Danach folgt sie der Anleitung am Ende von BRIEF.md. Das wurde in der Handy-App getestet, in normalen Chats und in Projekt-Chats.

## Where it sits in the pipeline
Die Seite der Claude-App an [[workflow-memory]].

## Who receives its output
[[events-log]].

## Steps
1. Der Chat beginnt; der Zeiger in den claude.ai-Einstellungen ([[claude-ai-settings-pointer]]) weist ihn an, die GitHub-Werkzeuge zu laden.
2. Er liest `views/BRIEF.md` von `yujideluca/workflow-memory` (Zweig main) — siehe [[memory-views]].
3. Giovanni gibt eine Korrektur; der Chat legt eine Ereignisdatei in `events/` an, im Format, das am Ende des Briefs beschrieben ist ([[events-log]]).
4. Der Push löst [[mem-action]] aus, das die Datei validiert ([[mem-validator]]) und [[memory-views]] neu erzeugt.
5. Die nächste Claude-Code-Sitzung lädt es herunter und zeigt es in ihrem Brief ([[hook-session-start]]).
