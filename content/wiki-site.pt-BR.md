---
id: wiki-site
lang: pt-BR
source_hash: 2c57f1f81e0e
title: site/ (wiki gerado)
---

## What it is
A saída gerada: `index.html`, `assets/` (o app Elm compilado `app.js`, `boot.js`, `style.css`) e `data/` (JSON do grafo e das páginas).

## What it does
Tudo o que o navegador precisa depois do login; nada disso é enviado antes do login.

## How it does it
Gerado pelo [[wiki-build]], não vai para o commit (é derivado); servido do disco pelo [[wiki-router]], então uma publicação aparece sem reiniciar o servidor.

## Where it sits in the pipeline
Entre o [[wiki-build]] e o [[wiki-router]].

## Who receives its output
O [[wiki-router]].
