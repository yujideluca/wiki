---
id: claude-app
lang: de
source_hash: 09d495292e04
title: Claude-App (claude.ai)
---

## What it is
Claude in der App und auf claude.ai (Handy, Browser, Projekte). Sie erreicht den Laptop nicht.

## What it does
Gespräche, Texte und Lernen: Deutschübungen ([[skill-alemao-goethe-fsp]]), klinische Fragen ([[skill-consulta-clinica]]), Bewerbungen in Deutschland ([[skill-candidatura-alemanha]]).

## How it does it
Ein in die claude.ai-Einstellungen eingefügter Verweis ([[claude-ai-settings-pointer]]) lässt jeden Chat `views/BRIEF.md` aus [[workflow-memory]] über den GitHub-Connector lesen; Korrekturen hält sie fest, indem sie eine Ereignisdatei anlegt ([[mem-github-connector]]). Ihre Skills sind die claude.ai-Kopien in [[claude-ai-skills]].

## Where it sits in the pipeline
Außerhalb des Laptops. Ihre einzige gemeinsame Schnittstelle mit den anderen Instanzen ist [[workflow-memory]] (ADR-0003).

## Who receives its output
[[events-log]], über den GitHub-Connector.
