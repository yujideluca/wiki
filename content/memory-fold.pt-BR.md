---
id: memory-fold
lang: pt-BR
source_hash: 64bb824fbf4e
title: A dobra (core.py)
---

## What it is
"A dobra" (fold) é a função única no coração do [[workflow-memory]]: ela pega o registro inteiro de eventos e o "dobra" no estado atual (como dobrar uma lista longa em um único resultado). Em termos de programação, é uma [função pura](https://en.wikipedia.org/wiki/Pure_function): a mesma entrada sempre dá a mesma saída e nada mais é alterado. Fica em `mem/core.py`.

## What it does
Para cada assunto (escopo mais key) vale a decisão mais recente; a mesma decisão repetida soma evidência; uma negação conta como mudança; `forget` e `done` encerram seu alvo; o feedback muda o destaque de uma entrada (`wrong` a tira do brief e a lista para o Giovanni revisar). Um evento do [[mem-harvester]] automático nunca sobrescreve as palavras do próprio Giovanni. Se dois escritores dão à mesma key textos diferentes em 24 horas, o resultado é um conflito que o Giovanni vê, não uma mescla silenciosa. Depois classifica as entradas para o brief: preferências nunca desbotam; os outros tipos desbotam com uma meia-vida (o tempo após o qual o peso cai pela metade): 180 dias para decisões e fatos, 7 dias para notas, esticada por cada uso informado ([[mem-use]]).

## How it does it
O resultado não depende da ordem em que os eventos chegam e é [idempotente](https://en.wikipedia.org/wiki/Idempotence) (aplicar um duplicado não muda nada); as duas propriedades são testadas. Os eventos são ordenados por hora e depois id, e duplicados contam uma vez. A função `brief()` encaixa as entradas em um orçamento de 2.900 caracteres (`BRIEF_BUDGET`); com cerca de 1.100 caracteres de texto fixo de instruções, o resumo inteiro tem cerca de 4.000 caracteres, que são 2,5 % da primeira rodada mediana medida em 2026-10-19 (44.860 tokens); os números foram calibrados com `scripts/calibrate.py`. Preferências são fixadas, então o orçamento nunca as descarta; ele limita só decisões, fatos e notas. `brief()` também pode encurtar cada regra a um tamanho dado (usado depois de `/clear`), e uma entrada com escopo `instance:X` é mostrada só à ferramenta chamada X.

## Where it sits in the pipeline
Entre o [[events-log]] e tudo o que mostra memória.

## Who receives its output
O [[session-brief]] (via [[hook-session-start]]) e o [[memory-views]] (via [[mem-action]]).
