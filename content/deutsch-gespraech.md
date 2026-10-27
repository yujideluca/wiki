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
Deutsch-Gespräch ("German conversation") is a project inside the [[claude-app]] for practising spoken German. Because the app has no memory between chats, this project keeps its memory in a Google Doc called `deutsch-gespraech-state`.

## Flow
trigger t1: Giovanni opens a chat in the Deutsch-Gespräch project | [[claude-app]]
step s1: The skill loads deutsch-gespraech-state from Google Docs | [[skill-deutsch-gespraech-memory]]
step s2: They talk in German; corrections follow the exam-training skill | [[skill-alemao-goethe-fsp]]
decide d1: What does Giovanni type?
step s3: Saves the session back to the Doc
step s4: Shows the stored items
step s5: Deletes the named item
product p1: An updated state in the Google Doc, ready for the next conversation
product p2: The list of stored items on screen

t1 -> s1
s1 -> s2
s2 -> d1
d1 -Ende-> s3
d1 -Gedächtnis?-> s4
d1 -Vergiss …-> s5
s3 -> p1
s5 -> p1
s4 -> p2

## What it does
At the first message of every chat in that project, the state is loaded from the Doc. When Giovanni writes "Ende" (end), the session is saved there. "Gedächtnis?" shows what is stored, and "Vergiss …" deletes an item.

## How it does it
It is done by the skill deutsch-gespraech-memory in the app ([[claude-ai-skills]]). That skill shows a notice at the start of chats, which is not meant for [[claude-code]]; Claude Code ignores it.

## Where it sits in the pipeline
Only in the [[claude-app]], next to [[skill-alemao-goethe-fsp]].

## Who receives its output
The Google Doc, and Giovanni in the next conversation.

## Steps
1. Giovanni opens a chat in the Deutsch-Gespräch project of the [[claude-app]].
2. The skill loads `deutsch-gespraech-state` from Google Docs.
3. They talk in German; corrections follow [[skill-alemao-goethe-fsp]].
4. "Ende" saves the session back to the Doc.
5. "Gedächtnis?" shows the stored items, "Vergiss …" deletes one.
