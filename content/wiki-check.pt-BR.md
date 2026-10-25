---
id: wiki-check
lang: pt-BR
source_hash: 097283d94376
title: wiki check (regras de conteúdo)
---

## What it is
`wiki check` executa toda regra que uma página deve seguir antes de poder ser publicada. No código é o módulo Elixir `Wiki.Content.Check`.

## What it does
Verifica que: campos do cabeçalho e tipos são válidos; as cinco seções obrigatórias estão presentes e não vazias; todo `[[link]]`, `fed_by` e `feeds` aponta para uma página real; `fed_by` e `feeds` concordam nos dois sentidos; não há páginas órfãs (páginas para as quais nada aponta), exceto atores e coisas externas; a verificação de privacidade não encontra chaves, tokens, senhas, telefones nem e-mails que não sejam os do Giovanni (os padrões são o arquivo `privacy-patterns.tsv` do workflow-memory, copiado para `server/priv/` e comparado pelo portão); uma função listada em uma página e citada por outras duas ganha página própria (a regra de promoção); toda página tem um horário de revisão, uma data ou data com minuto em UTC (tempo universal coordenado, o mesmo horário em qualquer lugar) que não está no futuro e com o qual o [[wiki-stale]] compara as fontes; uma página de skill tem uma seção Steps com a definição da própria skill; o primeiro uso de cada sigla listada vem com o nome completo; e as traduções em alemão e português existem e correspondem ao inglês atual. Com `--local` verifica também que as fontes e as entradas de memória existem.

## How it does it
É formado por funções puras sobre o conteúdo carregado e devolve uma lista ordenada de linhas no formato `arquivo: problema`. A integração contínua (CI, verificações automáticas no GitHub) o executa sem `--local`, porque o GitHub não enxerga os outros repositórios privados do Giovanni.

## Where it sits in the pipeline
O primeiro passo de `wiki publish` e parte do [[wiki-quality-gate]].

## Who receives its output
A [[wiki-cli]] (a publicação recusa diante de qualquer problema).
