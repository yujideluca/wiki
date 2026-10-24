---
id: study-debug-log
lang: pt-BR
source_hash: 1d7eb4fd1b00
title: DebugFlags e StudyLog
---

## What it is
É o diagnóstico embutido do QuizApp: uma chave geral (`DebugFlags`) e canais de log tipados (`StudyLog`: CONTENT, PIPELINE, SCHEDULER, SESSION, STORAGE e UI para a interface de usuário). Um log é um registro corrente do que o programa fez, escrito para que um desenvolvedor descubra o que deu errado.

## What it does
Builds de depuração ligam tudo, builds de lançamento desligam tudo. Nos builds de depuração, uma sobreposição sob cada pergunta mostra o id da carta, a nota, o tempo de resposta, a mudança de fase, a facilidade, o intervalo, os lapsos e a hora de vencimento.

## How it does it
As chamadas de log são "preguiçosas": o texto só é montado se o canal estiver ligado, então canais desligados não custam nada. O `AndroidStudyLog` escreve as mensagens no logcat, o log do sistema do Android, que pode ser lido do notebook com o adb (Android Debug Bridge).

## Where it sits in the pipeline
Usado por todas as camadas do [[quizapp-core]]; lido durante a verificação de depuração depois de programar.

## Who receives its output
O logcat, lido com [[skill-adb-android-control]].
