---
id: fitness-check
lang: pt-BR
source_hash: ce82cafe66ed
title: Funções de aptidão
aliases: [verificações de arquitetura]
---

## What it is
Verificações automáticas de que a arquitetura não se desviou ("funções de aptidão", da arquitetura evolutiva; ADR-0009).

## What it does
1. O módulo `:core` continua Kotlin puro (sem plugin nem dependência Android). 2. Nenhum arquivo Kotlin passa de 400 linhas. 3. Com `--apk`, o APK de release fica abaixo de 3 MB.

## How it does it
Python; um limite só sobe de propósito, no mesmo commit que um ADR ou uma linha do registro de decisões explicando por quê.

## Where it sits in the pipeline
Passo 7 do [[quizapp-quality-gate]]; revisado na [[monthly-architecture-review]].

## Who receives its output
O [[quizapp-quality-gate]].
