---
id: activity-calendar
lang: pt-BR
source_hash: bc3abc227a7e
title: Calendário de sequência
aliases: [sequência]
---

## What it is
O calendário mensal compacto no topo da tela inicial, que mostra em que dias o Giovanni treinou.

## What it does
Um dia com pelo menos uma resposta conta como treinado. Mostra a sequência atual (um hoje vazio não quebra uma sequência que vinha até ontem), a maior sequência e os dias do mês; cada dia treinado é colorido de amarelo-claro → laranja → laranja-avermelhado a partir de 100 respostas (`HeatColor`).

## How it does it
Lógica pura em `ActivityCalendar.kt` sobre o histórico do [[training-store]]; desenhado por `ui/CalendarCard.kt`. Setas de mês anterior/seguinte, segunda-feira primeiro, sem meses futuros.

## Where it sits in the pipeline
Lê o [[training-store]] e é exibido pelo [[study-view-model]] na tela inicial.

## Who receives its output
O [[study-view-model]].
