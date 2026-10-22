---
id: study-debug-log
lang: pt-BR
source_hash: 00a1619e3c3b
title: DebugFlags e StudyLog
aliases: [sobreposição de depuração]
---

## What it is
O diagnóstico do QuizApp: um interruptor (`DebugFlags`) e canais de log tipados (`StudyLog`: CONTENT, PIPELINE, SCHEDULER, SESSION, STORAGE, UI).

## What it does
Builds de depuração ligam tudo, builds de release nada. Uma sobreposição de depuração abaixo de cada pergunta mostra id da carta, nota, tempo de resposta, mudança de fase, facilidade, intervalo, erros e vencimento.

## How it does it
As funções de log só são avaliadas quando necessário, então canais desligados não custam nada; o `AndroidStudyLog` escreve no logcat.

## Where it sits in the pipeline
Usado por todas as camadas do [[quizapp-core]]; lido na rodada de depuração depois de programar.

## Who receives its output
O logcat, lido com a [[skill-adb-android-control]].
