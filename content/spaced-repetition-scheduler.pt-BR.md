---
id: spaced-repetition-scheduler
lang: pt-BR
source_hash: 2edefc4be95c
title: SpacedRepetitionScheduler
aliases: [agendador, regras de espaçamento]
---

## What it is
O coração do [[quizapp]]: uma função pura `(progresso, nota, agora, configuração) → progresso` que decide quando uma carta volta. Uma variante do SM-2 com os parâmetros padrão do Anki.

## What it does
Leva a carta pelas fases NEW → LEARNING → REVIEW (RELEARNING depois de um erro). O primeiro acerto manda a carta para 3 dias; cada acerto seguinte multiplica o intervalo pela facilidade (3 → 8 → 20 → 50 → 125 dias). Um erro numa carta nova repete depois de 10 minutos, nunca antes (ADR-0007, as regras de espaçamento).

## How it does it
Nunca lê o relógio por conta própria e não tem variação aleatória, então é totalmente determinístico (ADR-0003). Facilidade inicial 2,5, mínima 1,3, bônus de fácil 1,3, fator de difícil 1,2 (`SchedulerConfig`). Garantido por `SpacingRulesTest`, `PeriodizationSimulationTest`, vetores de conformidade compartilhados com o [[quizweb-domain]] e pelo [[mutation-check]].

## Where it sits in the pipeline
Logo depois do [[answer-grader]] no fluxo de resposta; a saída é o novo `CardProgress` que o [[study-controller]] salva.

## Who receives its output
O [[study-controller]] (e por ele o [[progress-store]]).
