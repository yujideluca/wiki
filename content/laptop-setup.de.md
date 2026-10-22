---
id: laptop-setup
lang: de
source_hash: afc723b9ba7d
title: Laptop-Einrichtung
---

## What it is
Alles, was auf dem Laptop ([[acer-nitro]]) installiert und eingerichtet ist, damit die Claude-Instanzen arbeiten können: Einstellungen und Hooks von Claude Code, der ständige Assistent, Werkzeuge im Benutzerbereich, die Android-Werkzeugkette und Fernzugriff.

## What it does
Stellt den Boden für alle Projekte: [[claude-code-settings]] und [[global-claude-md]], den Dienst [[claude-assistant]], die Statuszeile [[pbar]], den Telegram-Sender [[tg-send]], die Android-Bauwerkzeuge ([[android-toolchain]]), die Zusatzwerkzeuge in `~/.local` ([[user-space-tools]]), [[tailscale]] und die SSH-Einrichtung ([[remote-terminal]]).

## How it does it
Die meisten Installationen liegen im Benutzerbereich (ohne sudo) unter `~/.local` und `~/dev`; Schritte mit sudo übernimmt Giovanni. Dauerhafte Fakten zur Einrichtung stehen in [[claude-auto-memory]] und [[workflow-memory]].

## Where it sits in the pipeline
Unter allen Projekten: QuizApp baut mit ihrer Werkzeugkette, das Wiki läuft als ihr Dienst, der Assistent lebt in ihrem systemd.

## Who receives its output
[[claude-code]], [[remote-assistant]] und jedes Projekt in `~/dev`.
