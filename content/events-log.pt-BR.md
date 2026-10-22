---
id: events-log
lang: pt-BR
source_hash: a0bce5147cc8
title: events/ (o registro da memória)
aliases: [arquivos de evento]
---

## What it is
A própria memória: um arquivo Markdown por evento em `events/AAAA/MM/`, com nome `<hora>-<instância>-<6 caracteres>.md` (o nome é o id; o último pedaço é o #código mostrado no resumo).

## What it does
Guarda toda preferência, fato, decisão, tarefa, nota e evento de controle (feedback, claim, done, forget, use, archive, reopen, rescope). Os arquivos nunca são editados nem apagados, então quem escreve nunca entra em conflito (ADR-0002).

## How it does it
Um cabeçalho (`type`, `scope`, `key`, `owner`, `instance`, `ts`, opcionais `supersedes`, `target`, `signal`, `category`) e uma ou duas frases. O job de CI `append-only` rejeita edições; arquivos inválidos vão para `quarantine/` pelo [[mem-validator]].

## Where it sits in the pipeline
Escrito pelo [[mem]] (notebook) e pelo [[mem-github-connector]] (app do Claude); lido pelo [[memory-fold]].

## Who receives its output
O [[memory-fold]] e a [[mem-action]].
