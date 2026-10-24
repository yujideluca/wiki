---
id: mem-search
lang: pt-BR
source_hash: cde7d3c800f8
title: mem search
---

## What it is
`mem search` é uma busca em texto completo sobre todas as entradas da memória, inclusive as antigas demais para aparecer no brief e as pendências guardadas. Use quando o brief disser "N more entries did not fit".

## What it does
`mem search "palavras"` imprime as entradas correspondentes junto com seu `#code`.

## How it does it
Monta um índice temporário com SQLite FTS5 a partir do registro a cada chamada ([SQLite](https://www.sqlite.org/) é um pequeno mecanismo de banco de dados; FTS5 é sua busca em texto completo) e nunca o guarda no repositório. Se desejado, uma busca "vetorial" (por significado) poderia ser acrescentada depois sem mexer no registro.

## Where it sits in the pipeline
Usado quando o brief curto não contém o que é preciso.

## Who receives its output
A instância do Claude que fez a busca.
