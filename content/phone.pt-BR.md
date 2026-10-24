---
id: phone
lang: pt-BR
source_hash: a983b71161d9
title: Celular do Giovanni (Motorola edge 50 fusion)
---

## What it is
Este é o celular Android do Giovanni, um Motorola edge 50 fusion. É onde o [[quizapp]] é usado e o aparelho em que toda mudança nas telas do app é testada.

## What it does
Roda a versão estável e a versão beta do QuizApp lado a lado, recebe atualizações do [[release-feed]] e é controlado por adb (a Android Debug Bridge, uma ferramenta que permite a um computador controlar um celular) durante a verificação de depuração depois de programar ([[skill-adb-android-control]]). Também roda o [[claude-app]], que alcança o [[remote-assistant]].

## How it does it
Está ligado ao notebook por cabo USB (para o adb) e acessa a internet para atualizações e para este wiki.

## Where it sits in the pipeline
O fim do pipeline do QuizApp: o ponto em que o que foi construído finalmente é usado.

## Who receives its output
O Giovanni.
