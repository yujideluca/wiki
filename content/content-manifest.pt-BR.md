---
id: content-manifest
lang: pt-BR
source_hash: 0cfc9ba99ce3
title: content_manifest.py
---

## What it is
`content_manifest.py` é o script que mantém o manifesto do conjunto de perguntas, `app/src/main/assets/content.json`, em dia com os arquivos do conjunto. Um manifesto é uma lista que descreve os arquivos de um pacote e como verificá-los.

## What it does
Escreve o SHA-256 de cada arquivo do conjunto (SHA-256, Secure Hash Algorithm 256, gera uma impressão digital curta do conteúdo de um arquivo; se um byte muda, a impressão muda por completo, veja [SHA-2](https://en.wikipedia.org/wiki/SHA-2)) e aumenta `contentVersion` em um somente se algum arquivo realmente mudou. A opção `--check` sai com código 1 quando o manifesto não corresponde aos arquivos.

## How it does it
[Python](https://www.python.org/) usando só a biblioteca padrão. Seu `SCHEMA = 1` deve ser igual a `CONTENT_SCHEMA` no [[question-pack]] (os dois sobem juntos quando o formato dos arquivos muda). É executado pelo [[build-vocab]]; o modo `--check` roda no [[quizapp-quality-gate]].

## Where it sits in the pipeline
Logo depois do [[build-vocab]] no pipeline de conteúdo.

## Who receives its output
O [[question-pack]] (o manifesto embutido no app) e o [[quizapp-quality-gate]].
