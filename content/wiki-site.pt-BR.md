---
id: wiki-site
lang: pt-BR
source_hash: 50bf5e5e239c
title: site/ (wiki compilado)
---

## What it is
A pasta `site/` é o wiki compilado, pronto para ser exibido: `index.html`, `assets/` (o app Elm compilado `app.js`, `boot.js` e `style.css`) e `data/` (os arquivos de grafo e de páginas em [JSON](https://en.wikipedia.org/wiki/JSON), JavaScript Object Notation, um formato de dados em texto simples).

## What it does
É tudo o que o navegador precisa depois do login. O seu `index.html` diz ao navegador para não oferecer a tradução própria da página. Nada disso é enviado antes do login.

## How it does it
É gerado pelo [[wiki-build]] e não vai para o git (é derivado, então sempre pode ser regenerado). É servido do disco pelo [[wiki-router]], a partir da pasta indicada por `WIKI_SITE_DIR` (por padrão `~/dev/wiki/site`), então uma publicação aparece sem reiniciar o servidor.

## Where it sits in the pipeline
Entre o [[wiki-build]] e o [[wiki-router]].

## Who receives its output
O [[wiki-router]].
