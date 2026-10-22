---
id: training-store
lang: pt-BR
source_hash: 63938cac2f64
title: TrainingStore (histórico de respostas)
---

## What it is
Guarda quantas perguntas o Giovanni respondeu em cada dia do calendário local, e a configuração da meta diária.

## What it does
Armazena o `AnswerHistory` (dia → respostas, salvo como `day:count;...` nas preferências `training`) e a meta (10–100). Não é afetado por "Zerar todo o progresso".

## How it does it
SharedPreferences do Android; instalações antigas migram a contagem única do dia para o histórico.

## Where it sits in the pipeline
Gravado pelo [[study-controller]] depois de cada resposta, em qualquer modo.

## Who receives its output
A [[daily-goal]] (barra do dia), o [[activity-calendar]] (sequências) e o [[progress-backup]].
