---
id: daily-goal
lang: pt-BR
source_hash: 6ee10e16e92e
title: Meta diária
---

## What it is
Uma meta só motivacional: responder N perguntas hoje (controle deslizante nas Configurações, de 10 a 100 de 10 em 10, padrão 20).

## What it does
Toda resposta em qualquer quiz conta para uma contagem única por dia local; a tela inicial mostra `respondidas / meta` numa barra entre 0 e 1. Atingir a meta só muda a exibição ("Meta diária atingida ✓"); nada impede de continuar.

## How it does it
A contagem de hoje é a entrada de hoje no [[training-store]]; a `MainActivity` atualiza a tela inicial sempre que o app volta ao primeiro plano, o que corrigiu uma barra desatualizada depois da meia-noite (20/10/2026, requisitos DG-2..DG-5, verificados por testes de propriedade e vetores compartilhados com o [[quizweb]]).

## Where it sits in the pipeline
Lida do [[training-store]], exibida pelo [[study-view-model]].

## Who receives its output
O [[study-view-model]] (cartão inicial e cabeçalho do estudo).
