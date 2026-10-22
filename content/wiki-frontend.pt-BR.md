---
id: wiki-frontend
lang: pt-BR
source_hash: 5689d2a9ebcf
title: Front-end do wiki (Elm)
---

## What it is
A parte do wiki que você vê e clica, escrita em Elm (escolha do Giovanni): uma linguagem para páginas web que se recusa a compilar muitos tipos de erro.

## What it does
O início é o mapa do sistema ([[wiki-map-view]]) com busca e autocompletar ([[wiki-search]]), filtro por projeto, linha do tempo e legenda dos tipos; passar o mouse num ponto preenche quatro caixas; clicar abre o artigo ([[wiki-article-view]]). Interface em inglês, alemão ou português do Brasil, lembrada pelo navegador.

## How it does it
`Browser.application` com as rotas `/` e `/p/<id>`; carrega o `data/graph.json` uma vez e cada artigo no idioma escolhido quando preciso; o idioma fica no localStorage por uma porta (`boot.js`). Mapa escuro e cinematográfico (o explorador de Dark) e artigos claros com fonte serifada (Wikipédia). Testado com elm-test (MP-1…MP-4, LG-2).

## Where it sits in the pipeline
O topo do wiki, servido pelo [[wiki-router]] depois do login.

## Who receives its output
O [[giovanni]], no notebook ou no celular.
