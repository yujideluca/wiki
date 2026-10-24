---
id: daily-goal
lang: pt-BR
source_hash: 42007fd5f9d7
title: Meta diária
---

## What it is
A meta diária é um alvo puramente motivacional: "responda N perguntas hoje". O N é definido com um controle deslizante nas Configurações, de 10 a 100 em passos de 10 (padrão 20).

## What it does
Cada resposta em qualquer quiz conta para uma contagem compartilhada por dia local. A tela inicial mostra `respondidas / meta` como uma barra de progresso mantida entre 0 e 1. Alcançar a meta só muda a tela ("Meta diária atingida ✓"); nada impede o jogador de continuar.

## How it does it
A contagem de hoje é a entrada de hoje no [[training-store]]. A `MainActivity` atualiza a tela inicial toda vez que o app é retomado, o que corrigiu uma barra que ficava desatualizada depois da meia-noite (2026-10-20; requisitos DG-2 a DG-5, verificados por testes de propriedade, que tentam muitas entradas aleatórias, e por vetores de teste compartilhados com o [[quizweb]]).

## Where it sits in the pipeline
Lida do [[training-store]], mostrada pelo [[study-view-model]].

## Who receives its output
O [[study-view-model]] (o cartão inicial e o cabeçalho do estudo).
