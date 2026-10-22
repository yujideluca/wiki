---
id: remote-assistant
lang: de
source_hash: e01b95e3fdf4
title: Fernassistent
---

## What it is
Eine Claude-Code-Sitzung, die ständig auf dem Laptop läuft und die [[giovanni]] über die Claude-App auf dem Handy erreicht (Remote Control). In der App heißt sie `yuji-nitro-assistant`.

## What it does
Kurze Aufgaben auf dem Laptop, wenn Giovanni unterwegs ist: dieselben Regeln wie [[claude-code]], schreibt ins Gedächtnis als Instanz `assistant`.

## How it does it
Der Dienst [[claude-assistant]] hält sie am Leben: Eine tmux-Sitzung startet `claude remote-control` in einer Neustart-Schleife im Ordner `~/assistant`, dessen eigene CLAUDE.md kurze, handyfreundliche Antworten verlangt. Den Berechtigungsmodus hat Giovanni selbst gesetzt.

## Where it sits in the pipeline
Eine zweite Tür zum selben Laptop und zu denselben Repos wie Claude Code.

## Who receives its output
Wie [[claude-code]]: Repos und [[events-log]] (mit `MEM_INSTANCE=assistant`).
