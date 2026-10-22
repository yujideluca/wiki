---
id: mem-search
lang: pt-BR
source_hash: 6da23209627f
title: mem search
aliases: [busca na memória]
---

## What it is
Busca de texto completo em todas as entradas da memória, inclusive as frias demais para aparecer no resumo e os itens estacionados.

## What it does
`mem search "palavras"` imprime as entradas encontradas com seus #códigos.

## How it does it
Um índice SQLite FTS5 derivado, refeito a partir do registro a cada chamada e nunca commitado; vetores poderiam ser acrescentados depois sem mexer no registro.

## Where it sits in the pipeline
Usado quando o resumo diz "N entradas a mais não couberam".

## Who receives its output
A instância do Claude que buscou.
