---
id: memory-views
lang: pt-BR
source_hash: 7e1ec6a36a63
title: views/ (BRIEF, PREFERENCES, REVIEW)
---

## What it is
Os arquivos gerados e somente leitura do [[workflow-memory]]: `BRIEF.md` (o que as conversas do app do Claude leem), `PREFERENCES.md`, `REVIEW.md` (a única lista que precisa do Giovanni).

## What it does
O BRIEF tem as entradas ordenadas, os itens em aberto e, no fim, como uma conversa registra uma correção. O REVIEW lista conflitos, entradas marcadas como erradas, arquivos em quarentena, propostas do coletor e avisos.

## How it does it
Nunca editados à mão: refeitos pelo `mem build` e pela [[mem-action]] a cada push e diariamente; a CI falha se uma view foi editada (`build --check`).

## Where it sits in the pipeline
O lado de saída da memória, para quem não pode rodar o `mem`.

## Who receives its output
O [[claude-app]] (BRIEF pelo conector do GitHub) e o [[giovanni]] (REVIEW).
