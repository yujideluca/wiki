---
id: deutsch-gespraech
title: Deutsch-Gespräch project (Claude app)
aliases: [deutsch-gespraech-state, German conversation]
kind: process
project: skills
status: active
fed_by: []
feeds: []
reviewed: 2026-10-22
---

## What it is
A Claude app project for German conversation practice whose memory is a Google Doc, `deutsch-gespraech-state`.

## What it does
At the first message of every chat in that project it loads the conversation state from the Doc; on "Ende" it saves the session there; on "Gedächtnis?" or "Vergiss …" it shows or deletes stored items.

## How it does it
The skill deutsch-gespraech-memory in the app ([[claude-ai-skills]]). Its session-start notice is not meant for Claude Code, which ignores it.

## Where it sits in the pipeline
Only in the [[claude-app]], next to [[skill-alemao-goethe-fsp]].

## Who receives its output
The Google Doc, and Giovanni in the next conversation.

## Steps
1. Giovanni opens a chat in the Deutsch-Gespräch project of the [[claude-app]].
2. The skill loads `deutsch-gespraech-state` from Google Docs.
3. They talk in German; corrections follow [[skill-alemao-goethe-fsp]].
4. "Ende" saves the session back to the Doc.
5. "Gedächtnis?" shows stored items, "Vergiss …" deletes one.
