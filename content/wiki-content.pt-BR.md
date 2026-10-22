---
id: wiki-content
lang: pt-BR
source_hash: 476989c4168a
title: Conteúdo do wiki (páginas Markdown)
aliases: [páginas]
---

## What it is
A fonte de verdade deste wiki: um arquivo Markdown por conceito em `content/` (inglês), com as traduções `<id>.de.md` e `<id>.pt-BR.md`, e o `_kinds.json`, a lista aberta de tipos e suas cores.

## What it does
Cada página tem um cabeçalho (`id, title, aliases, kind, project, status, location, fed_by, feeds, sources, memory, since, until, reviewed`) e seções fixas: O que é, O que faz, Como faz, Onde fica no fluxo, Quem recebe o que produz, mais Passos (páginas de processo), Funções e Observações, opcionais.

## How it does it
Os links seguem o estilo do Obsidian `[[id]]`; `fed_by`/`feeds` são as arestas do fluxo e precisam bater nos dois sentidos. As `sources` são `repo:caminho`, para uma mudança no código marcar a página como desatualizada. As traduções guardam um hash do texto em inglês de onde vieram. As páginas dizem o que existe; as regras ficam na memória e são ligadas pelo #código.

## Where it sits in the pipeline
Escrito pelo [[claude-code]] no fim de cada tarefa ([[end-of-task]]); verificado pelo [[wiki-check]]; transformado em dados pelo [[wiki-build]].

## Who receives its output
O [[wiki-check]] e o [[wiki-build]].
