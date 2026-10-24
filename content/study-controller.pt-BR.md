---
id: study-controller
lang: pt-BR
source_hash: 2c9ac1cbce0b
title: StudyController
---

## What it is
O `StudyController` é o ponto de entrada único (uma "fachada": uma porta de entrada simples diante de muitas partes) com que as telas do [[quizapp]] conversam. Ele liga armazenamento, relógio, fila de cartas e motor de sessão.

## What it does
Inicia sessões de estudo, registra cada resposta (nota → agendamento → salvar), informa a contagem de hoje para a [[daily-goal]] e cuida de suspender e remover cartas, zerar o progresso e importar e exportar um backup.

## How it does it
Chama o [[card-factory]] para as cartas, o [[study-pipeline]] para a fila, a [[study-session]] para a sessão em andamento, o [[answer-grader]] e o [[spaced-repetition-scheduler]] a cada resposta, e escreve pelo [[progress-store]] e pelo [[training-store]]. É testado de ponta a ponta, inclusive que o progresso sobrevive de uma sessão para a seguinte.

## Where it sits in the pipeline
O meio das camadas `ui → StudyController → domain/content/data`.

## Who receives its output
O [[study-view-model]], que transforma seus resultados no que a tela mostra.
