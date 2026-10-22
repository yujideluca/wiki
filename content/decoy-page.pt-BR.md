---
id: decoy-page
lang: pt-BR
source_hash: 241cfd2b7902
title: Página isca
aliases: [isca]
---

## What it is
O que qualquer pessoa sem login vê: um grafo psicodélico e animado de palavras inventadas e um botão "Sign in with Google" (desenho do Giovanni).

## What it does
Mostra nós brilhantes que mudam de cor, flutuam e se ligam, reagindo ao mouse, com rótulos sem sentido gerados ao acaso no navegador de quem visita. Nada real está na página.

## How it does it
Um único arquivo HTML autossuficiente com JavaScript de canvas embutido: nenhum arquivo externo, nenhum fetch. Os testes conferem que ele não carrega nada de fora, não faz requisições e não contém nenhum título de página do conteúdo (DC-1). Respeita "reduzir movimento".

## Where it sits in the pipeline
Devolvida pelo [[wiki-router]] para toda página sem sessão.

## Who receives its output
Visitantes sem sessão (e o Giovanni antes de entrar).
