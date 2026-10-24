---
id: activity-calendar
lang: pt-BR
source_hash: f2516fd8fc66
title: Calendário de sequência
---

## What it is
O calendário de sequência é o calendário mensal compacto no alto da tela inicial do [[quizapp]]. Mostra em quais dias o Giovanni estudou. Uma "sequência" (streak) é o número de dias seguidos em que algo foi feito.

## What it does
Um dia com pelo menos uma resposta conta como estudado. O calendário mostra a sequência atual (um hoje vazio não quebra uma sequência que vinha até ontem), a maior sequência e os dias estudados neste mês. Cada dia estudado é colorido de amarelo-claro a laranja e laranja-avermelhado a partir de 100 respostas (`HeatColor`).

## How it does it
A lógica é código puro em `ActivityCalendar.kt`, trabalhando sobre o histórico do [[training-store]]; o desenho é feito por `ui/CalendarCard.kt`. Há setas para o mês anterior e o seguinte, a semana começa na segunda-feira e meses futuros não podem ser exibidos.

## Where it sits in the pipeline
Lê o [[training-store]]; exibido pelo [[study-view-model]] na tela inicial.

## Who receives its output
O [[study-view-model]].
