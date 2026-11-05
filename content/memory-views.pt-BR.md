---
id: memory-views
lang: pt-BR
source_hash: fa3c669cc5eb
title: views/ (BRIEF, PREFERENCES, REVIEW)
---

## What it is
A pasta `views/` contém os resumos legíveis do [[workflow-memory]]. Eles são gerados, nunca escritos à mão: `BRIEF.md` (o que as conversas no [[claude-app]] leem), `rules/TAG.md` (um arquivo por tipo de tarefa, com o texto completo de suas regras), `PREFERENCES.md` (todas as preferências em vigor) e `REVIEW.md` (a única lista que precisa da atenção do Giovanni). Existem para leitores que não conseguem rodar o comando [[mem]].

## What it does
O BRIEF traz as regras que sempre valem, um índice dos tipos de tarefa (tags), as pendências e, no fim, instruções de como uma conversa registra uma correção. Uma conversa prestes a fazer uma tarefa de um tipo busca o `rules/TAG.md` dessa tag, do mesmo jeito que o comando [[mem-rules]] atende o Claude Code. O REVIEW lista tudo o que precisa de decisão humana: conflitos entre escritores, entradas marcadas como erradas, arquivos em quarentena, propostas do harvester automático e avisos (por exemplo uma regra sem tag).

## How it does it
Os arquivos são reconstruídos por `mem build` e pelo [[mem-action]] a cada push e uma vez por dia. A integração contínua (CI, verificações automáticas a cada push) falha se alguém editou uma visão à mão, usando `build --check`, que reconstrói e compara.

## Where it sits in the pipeline
O lado de saída da memória.

## Who receives its output
O [[claude-app]] (BRIEF, pelo conector do GitHub) e o [[giovanni]] (REVIEW).
