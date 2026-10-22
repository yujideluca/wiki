---
id: wiki-build
lang: pt-BR
source_hash: 095b1a19c418
title: wiki build (conteúdo → dados)
---

## What it is
Transforma o conteúdo nos dados que o front-end em Elm lê (módulo Elixir `Wiki.Content.Build`) e depois compila o front-end.

## What it does
Grava `site/data/graph.json` (nós com o texto nos três idiomas, arestas `feeds` e arestas `mentions` vindas dos links, tipos) e um `site/data/pages/<id>.<idioma>.json` por página e idioma (seções, campos da caixa de informações, histórico). Preenche o `since` com o primeiro commit das fontes da página, marca como "pode estar desatualizada" a página de coisa fora do notebook 30 dias depois da revisão, roda `elm make --optimize` e copia os arquivos estáticos.

## How it does it
Chamadas ao git só de leitura para datas e histórico; JSON pelo módulo `JSON` embutido no Elixir 1.18.

## Where it sits in the pipeline
O segundo passo do `wiki publish`, depois do [[wiki-check]].

## Who receives its output
O [[wiki-site]].
