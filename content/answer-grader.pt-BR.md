---
id: answer-grader
lang: pt-BR
source_hash: 797aab00faa1
title: AnswerGrader
aliases: [avaliador]
---

## What it is
Transforma uma resposta de múltipla escolha numa nota do Anki, porque um quiz não pode pedir ao jogador que se avalie.

## What it does
Errou → AGAIN. Numa carta já em REVIEW: acertou em 10 s ou mais → HARD, acertou em até 2,5 s → EASY. Fora isso, GOOD. HARD e EASY nunca são dados a cartas ainda em (re)aprendizado, para um chute de sorte (uma em três) não pular o aprendizado e um acerto lento ali sempre passar (requisito GR-1).

## How it does it
Uma função pura de acerto, tempo de resposta e fase; limites em `GraderConfig`.

## Where it sits in the pipeline
Primeiro passo depois que o jogador responde, antes do [[spaced-repetition-scheduler]].

## Who receives its output
O [[spaced-repetition-scheduler]].
