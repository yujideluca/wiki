---
id: phone
lang: pt-BR
source_hash: 182e1885980b
title: Celular do Giovanni (Motorola edge 50 fusion)
aliases: [celular]
---

## What it is
O celular Android do Giovanni, um Motorola edge 50 fusion: onde o [[quizapp]] é usado e o aparelho em que toda mudança de interface é testada.

## What it does
Roda o QuizApp estável e o beta lado a lado, recebe atualizações do [[release-feed]] e é controlado por adb na rodada de depuração depois de programar ([[skill-adb-android-control]]). Também roda o app do Claude ([[claude-app]]), que acessa o [[remote-assistant]].

## How it does it
Ligado ao notebook por USB (adb); usa a internet para atualizações e para este wiki.

## Where it sits in the pipeline
O fim do fluxo do QuizApp.

## Who receives its output
O Giovanni.
