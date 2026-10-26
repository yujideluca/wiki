---
id: wiki-site
lang: pt-BR
source_hash: 8ce12632852a
title: site/ (wiki compilado)
---

## What it is
A pasta `site/` é o wiki compilado, pronto para ser exibido: `index.html`, `assets/` (o app Elm compilado `app.js`, `boot.js` e `style.css`) e `data/` (os arquivos de grafo e de páginas em [JSON](https://en.wikipedia.org/wiki/JSON), JavaScript Object Notation, um formato de dados em texto simples).

## What it does
É tudo o que o navegador precisa depois do login. O seu `index.html` diz ao navegador para não oferecer a tradução própria da página. Nada disso é enviado antes do login.

## How it does it
É gerado pelo [[wiki-build]] e não vai para o git (é derivado, então sempre pode ser regenerado). É servido do disco pelo [[wiki-router]]. A pasta servida é definida por `WIKI_SITE_DIR`. Desde 26/10/2026 o serviço lê uma pasta de release, `~/.local/share/wiki/releases/<commit>`, escolhida por um drop-in do systemd (um arquivo pequeno que sobrescreve uma configuração do [[wiki-service]]). Assim, uma publicação só aparece no site depois que uma pasta de release é construída a partir do commit publicado e o drop-in aponta para ela; sem o drop-in volta a servir `~/dev/wiki/site`.

## Where it sits in the pipeline
Entre o [[wiki-build]] e o [[wiki-router]].

## Who receives its output
O [[wiki-router]].
