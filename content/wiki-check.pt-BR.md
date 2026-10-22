---
id: wiki-check
lang: pt-BR
source_hash: 0579d5281e8e
title: wiki check (regras do conteúdo)
---

## What it is
Todas as regras que uma página precisa seguir antes de ser publicada (módulo Elixir `Wiki.Content.Check`).

## What it does
Campos do cabeçalho e tipos válidos; as cinco seções presentes e não vazias; todo `[[link]]`, `fed_by` e `feeds` aponta para algo; `fed_by`/`feeds` simétricos; nenhuma página órfã (exceto atores e coisas externas); verificação de privacidade (chaves, tokens, senhas, telefones, e-mails que não sejam o do Giovanni); promoção (uma função listada numa página e citada por outras duas precisa de página própria); uma página sem fontes precisa de data de revisão; as traduções em alemão e português existem e batem com o inglês atual. `--local` também confere se as fontes e as referências de memória existem.

## How it does it
Funções puras sobre o conteúdo carregado; devolve uma lista ordenada de `arquivo: problema`. A CI roda sem `--local` porque o GitHub não enxerga os outros repositórios privados.

## Where it sits in the pipeline
O primeiro passo do `wiki publish` e parte do [[wiki-quality-gate]].

## Who receives its output
O [[wiki-cli]] (o publish recusa a qualquer problema).
