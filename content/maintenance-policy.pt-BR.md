---
id: maintenance-policy
lang: pt-BR
source_hash: 5147c4e3a428
title: Política de manutenção (dívida técnica)
aliases: [política de dívida]
---

## What it is
Como cada projeto se mantém saudável enquanto muda: tipos de manutenção da ISO/IEC/IEEE 14764, leis de Lehman, funções de aptidão e métricas de entrega DORA (`docs/MAINTENANCE.md`).

## What it does
Dívida técnica (tudo o que funciona hoje mas torna a próxima mudança mais lenta ou arriscada) vira uma Issue no GitHub com rótulo `debt` e prioridade P1–P3; funcionalidades novas usam `idea`. Mais ou menos uma sessão de trabalho em cinco vai para dívida ou prevenção: quando as últimas quatro foram só funcionalidades, o Claude avisa e propõe a dívida mais importante, e o Giovanni decide.

## How it does it
Uma limitação encontrada no trabalho vira issue na mesma sessão; a revisão mensal confere a lista.

## Where it sits in the pipeline
Parte do modelo, copiada para cada projeto.

## Who receives its output
A [[monthly-architecture-review]] e toda sessão do Claude (pelo CLAUDE.md de cada projeto).
