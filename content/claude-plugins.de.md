---
id: claude-plugins
lang: de
source_hash: de14de0622c6
title: Claude-Code-Plugins
---

## What it is
Ein Plugin ist ein Zusatzpaket für Claude Code, das zusätzliche Fähigkeiten mitbringt ([Dokumentation zu Plugins](https://docs.claude.com/en/docs/claude-code/plugins)). Diese Seite listet die auf dem Laptop installierten Plugins auf und sagt, welche eingeschaltet sind.

## What it does
- pyright-lsp und kotlin-lsp geben Claude „Code-Intelligenz“ für die Sprachen Python und Kotlin (LSP ist das Language Server Protocol, ein Standard, mit dem ein Editor oder Assistent ein Sprachwerkzeug nach Fehlern und Definitionen fragen kann).
- session-report erstellt einen Nutzungsbericht vergangener Sitzungen.
- claude-md-management hilft, CLAUDE.md-Dateien (Anweisungsdateien) in Ordnung zu halten.
- security-guidance warnt vor riskantem Code.
- feature-dev und pr-review-toolkit liefern Review- und Planungs-Agenten (Hilfsassistenten für eine bestimmte Aufgabe).
- claude-code-setup empfiehlt Automatisierungen.
- android-test-pilot analysiert Android-Apps und führt Tests auf dem Gerät aus; es stammt aus dem Marketplace `panicgit/android-test-pilot`.

## How it does it
Sie sind unter `~/.claude/plugins` installiert (die Liste steht in `installed_plugins.json`) und in [[claude-code-settings]] ein- oder ausgeschaltet. Eingeschaltet: pyright-lsp, kotlin-lsp, security-guidance und android-test-pilot. Installiert, aber ausgeschaltet: session-report, claude-md-management, feature-dev, pr-review-toolkit und claude-code-setup.

## Where it sits in the pipeline
In jeder Claude-Code-Sitzung.

## Who receives its output
[[claude-code]].
