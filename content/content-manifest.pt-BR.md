---
id: content-manifest
lang: pt-BR
source_hash: 04934e577615
title: content_manifest.py
---

## What it is
O script que mantém o manifesto do banco de perguntas, `app/src/main/assets/content.json`, em dia com os arquivos do banco.

## What it does
Grava o SHA-256 de cada arquivo do banco e aumenta o `contentVersion` em um só se algum arquivo mudou. `--check` sai com 1 quando o manifesto não bate com os arquivos.

## How it does it
Biblioteca padrão do Python; `SCHEMA = 1` precisa ser igual ao `CONTENT_SCHEMA` do [[question-pack]] (aumentar os dois juntos quando o formato mudar). Rodado pelo [[build-vocab]]; o `--check` roda no [[quizapp-quality-gate]].

## Where it sits in the pipeline
Logo depois do [[build-vocab]] no fluxo de conteúdo.

## Who receives its output
O [[question-pack]] (o manifesto embutido) e o [[quizapp-quality-gate]].
