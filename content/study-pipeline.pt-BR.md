---
id: study-pipeline
lang: pt-BR
source_hash: f8d6f1dc37f0
title: StudyPipeline (montagem da fila)
---

## What it is
Monta a fila de cartas de uma sessão de estudo no [[quizapp]].

## What it does
`buildQueue` = `attachProgress → excludeUnavailable → selectLearningDue → selectReviewsDue → selectNewCards → interleave`. Cartas em aprendizado primeiro, quando a espera acaba; revisões das mais atrasadas para as menos, no máximo 100; cartas novas sem limite diário, uma a cada 3 revisões.

## How it does it
Uma cadeia de passos puros pequenos, testados um a um; cartas suspensas e removidas saem em `excludeUnavailable`.

## Where it sits in the pipeline
No início de cada sessão, entre as cartas ([[card-factory]]) com seu progresso salvo ([[progress-store]]) e a sessão em andamento ([[study-session]]).

## Who receives its output
O [[study-controller]], que entrega a fila ao [[study-session]].
