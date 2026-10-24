---
id: study-pipeline
lang: pt-BR
source_hash: efa4c9fdee50
title: StudyPipeline (montador da fila)
---

## What it is
Antes de cada sessão de estudo, o [[quizapp]] precisa decidir quais cartas perguntar e em que ordem. O StudyPipeline monta essa fila de cartas. Um pipeline aqui é uma cadeia de pequenos passos em que cada passo recebe o resultado do anterior.

## What it does
`buildQueue` é a cadeia `attachProgress → excludeUnavailable → selectLearningDue → selectReviewsDue → selectNewCards → interleave`. Em palavras: anexar o progresso salvo de cada carta; descartar cartas suspensas ou removidas; pegar primeiro as cartas em aprendizado cujo tempo de espera acabou; depois as revisões, as mais atrasadas primeiro, no máximo 100; depois as cartas novas (sem limite diário), intercaladas uma a cada 3 revisões.

## How it does it
É uma cadeia de pequenos passos puros, cada um testado separadamente (uma função é "pura" quando a mesma entrada sempre dá a mesma saída e nada mais muda).

## Where it sits in the pipeline
No início de cada sessão, entre as cartas ([[card-factory]]) com seu progresso salvo ([[progress-store]]) e a sessão em andamento ([[study-session]]).

## Who receives its output
O [[study-controller]], que entrega a fila à [[study-session]].
