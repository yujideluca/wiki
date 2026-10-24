---
id: remote-assistant
lang: de
source_hash: 41f62f766233
title: Remote-Assistent
---

## What it is
Der Remote-Assistent ist eine Claude-Code-Sitzung, die ständig auf dem Laptop läuft und die [[giovanni]] über die Funktion Remote Control aus der Claude-App auf dem Handy erreichen kann. In der App erscheint sie als `yuji-nitro-assistant`. Man kann sie sich als zweite Tür in denselben Laptop vorstellen: dasselbe Claude, dieselben Repositories, aber von überall erreichbar.

## What it does
Er erledigt kurze Aufgaben auf dem Laptop, während Giovanni nicht davorsitzt. Er folgt denselben Regeln wie [[claude-code]] und schreibt unter dem Instanznamen `assistant` ins gemeinsame Gedächtnis, damit dieses erkennen kann, wer was geschrieben hat.

## How it does it
Der Dienst [[claude-assistant]] hält ihn am Leben: Eine tmux-Sitzung (ein Terminal, das ohne Fenster weiterläuft) führt in einer Neustart-Schleife `claude remote-control` aus dem Ordner `~/assistant` aus. Dieser Ordner hat eine eigene CLAUDE.md (eine Textdatei mit dauerhaften Anweisungen, die Claude Code beim Start liest), die kurze, auf dem Handy gut lesbare Antworten verlangt. Seinen Berechtigungsmodus (wie viel Claude ohne Nachfrage tun darf) hat Giovanni persönlich festgelegt.

## Where it sits in the pipeline
Er ist ein zweiter Eingang in denselben Laptop und dieselben Projekt-Repositories wie Claude Code; der Unterschied liegt nur darin, wie Giovanni zu ihm kommt.

## Who receives its output
Dieselben Empfänger wie bei [[claude-code]]: die Projekt-Repositories und das Gedächtnisprotokoll [[events-log]] (Einträge tragen die Markierung `MEM_INSTANCE=assistant`).
