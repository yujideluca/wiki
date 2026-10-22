---
id: study-controller
lang: pt-BR
source_hash: 72fccc743498
title: StudyController
aliases: [fachada do controlador]
---

## What it is
A única fachada com que a interface do [[quizapp]] conversa: liga armazenamento, relógio, fila e motor.

## What it does
Inicia sessões, registra cada resposta (avaliar → agendar → salvar), informa a contagem do dia para a [[daily-goal]] e cuida de suspender/remover, zerar e importar/exportar o backup.

## How it does it
Chama o [[card-factory]] para as cartas, o [[study-pipeline]] para a fila, o [[study-session]] para a sessão em andamento, o [[answer-grader]] e o [[spaced-repetition-scheduler]] a cada resposta, e grava pelo [[progress-store]] e pelo [[training-store]]. Testado de ponta a ponta, inclusive a persistência entre sessões.

## Where it sits in the pipeline
O meio de `ui → StudyController → domain/content/data`.

## Who receives its output
O [[study-view-model]], que transforma os resultados em estado de tela.
