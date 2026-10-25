---
id: user-space-tools
lang: de
source_hash: bb9c42943d4c
title: User-Space-Werkzeuge (~/.local)
---

## What it is
„User-Space“ heißt: in den eigenen Ordnern des Benutzers statt in Systemordnern installiert, sodass keine Administratorrechte nötig sind. Diese Seite behandelt die zusätzlichen Werkzeuge in `~/.local` auf Giovannis Laptop: [Node.js](https://nodejs.org/) 22 mit npm (JavaScript-Laufzeit und ihr Paketinstaller), [uv](https://docs.astral.sh/uv/) (ein schnelles Python-Paketwerkzeug), pyright (ein Python-Typprüfer), kotlin-lsp (ein Helfer, der Editoren Kotlin-Code erklärt), rclone (kopiert Dateien in Cloud-Speicher), eine eigene Kopie von tmux (ein Terminal, das ohne Fenster weiterläuft), shellcheck 0.11.0 (ein Prüfer für Shell-Skripte, benutzt von [[pipeline-check]]), [Elm](https://elm-lang.org/) 0.19.1 mit elm-test und elm-format sowie die Skripte `mem`, `tg-send`, `claude-assistant` und `wiki`.

## What it does
Sie geben Claude Code Language Server (Programme, die über das Language Server Protocol, LSP, Codefehler und Definitionen melden), Build-Werkzeuge und Helfer. Die Ausnahme ist [Elixir](https://elixir-lang.org/) 1.18 mit Erlang/OTP 27 (OTP ist die Open Telecom Platform, die Standardbibliotheken von Erlang): Diese hat Giovanni für das Wiki mit dem System-Paketmanager `apt` installiert.

## How it does it
Kleine Wrapper-Skripte im `PATH` (der Liste der Ordner, in denen nach Befehlen gesucht wird) in `~/.local/bin`. pyright liegt in `~/.local/share/pyright-pkg`, weil eine virtuelle Umgebung nicht möglich war, und kotlin-lsp in `~/.local/opt/kotlin-lsp`. Die genauen Pfade und Upgrade-Schritte stehen in [[claude-auto-memory]].

## Where it sits in the pipeline
Unter der Arbeit jedes Projekts.

## Who receives its output
[[claude-code]], [[claude-assistant]] und der Wiki-Build ([[wiki-build]]).
