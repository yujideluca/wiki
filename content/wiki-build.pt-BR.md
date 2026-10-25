---
id: wiki-build
lang: pt-BR
source_hash: 61aa08453346
title: wiki build (conteúdo → dados)
---

## What it is
`wiki build` transforma o conteúdo nos dados que o front end em Elm lê (módulo Elixir `Wiki.Content.Build`) e depois compila o front end. Pense nele como o passo que prepara o wiki para ser exibido.

## What it does
Escreve `site/data/graph.json` (os nós com seu texto nos três idiomas, as arestas `feeds`, as arestas `mentions` tiradas dos links e os tipos) e um arquivo `site/data/pages/<id>.<lang>.json` por página e idioma (seções, campos da caixa de informações, histórico). Uma página do tipo reference (o glossário) pode apontar para qualquer página sem desenhar arestas no mapa. Preenche `since` a partir do primeiro commit git das fontes de uma página, marca páginas sem fontes (coisas que vivem fora do notebook) como "pode estar desatualizada" 30 dias após o horário de revisão, depois executa `elm make --optimize` e copia os arquivos estáticos.

## How it does it
Usa chamadas git somente de leitura para datas e histórico e escreve [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, um formato de dados em texto simples) com o módulo `JSON` embutido no Elixir 1.18.

## Where it sits in the pipeline
O segundo passo de `wiki publish`, depois do [[wiki-check]].

## Who receives its output
O [[wiki-site]].
