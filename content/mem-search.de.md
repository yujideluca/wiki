---
id: mem-search
lang: de
source_hash: 6da23209627f
title: mem search
aliases: [Gedächtnissuche]
---

## What it is
Volltextsuche über alle Gedächtniseinträge, auch solche, die für das Briefing zu kalt sind, und geparkte offene Punkte.

## What it does
`mem search "Wörter"` gibt passende Einträge mit ihren #Codes aus.

## How it does it
Ein abgeleiteter SQLite-FTS5-Index, bei jedem Aufruf aus dem Protokoll neu gebaut und nie committet; Vektoren ließen sich später ergänzen, ohne das Protokoll anzufassen.

## Where it sits in the pipeline
Genutzt, wenn das Briefing sagt „N weitere Einträge passten nicht“.

## Who receives its output
Die Claude-Instanz, die gesucht hat.
