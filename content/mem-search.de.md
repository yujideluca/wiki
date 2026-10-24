---
id: mem-search
lang: de
source_hash: cde7d3c800f8
title: mem search
---

## What it is
`mem search` ist eine Volltextsuche über jeden Gedächtniseintrag, auch über solche, die zu alt für den Brief sind, und über geparkte offene Punkte. Man nutzt sie, wenn im Brief steht „N more entries did not fit“.

## What it does
`mem search "Wörter"` gibt die passenden Einträge samt ihrem `#code` aus.

## How it does it
Sie baut bei jedem Aufruf aus dem Protokoll einen temporären Index mit SQLite FTS5 auf ([SQLite](https://www.sqlite.org/) ist eine kleine Datenbank-Engine; FTS5 ist ihre Volltextsuche) und speichert ihn nie im Repository. Bei Bedarf ließe sich später eine „Vektor“-Suche (nach Bedeutung) ergänzen, ohne das Protokoll anzutasten.

## Where it sits in the pipeline
Wird genutzt, wenn der kurze Brief nicht enthält, was gebraucht wird.

## Who receives its output
Die Claude-Instanz, die gesucht hat.
