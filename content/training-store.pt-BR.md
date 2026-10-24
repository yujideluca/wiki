---
id: training-store
lang: pt-BR
source_hash: 8473e3cc6421
title: TrainingStore (histórico de respostas)
---

## What it is
O `TrainingStore` guarda quantas perguntas o Giovanni respondeu em cada dia do calendário local, junto com a configuração da meta diária. É a base de dados do calendário de sequência e da barra de progresso diário.

## What it does
Guarda o `AnswerHistory` (um mapa de número do dia para contagem, salvo como texto no formato `day:count;...` nas preferências do Android chamadas `training`) e a meta (10 a 100). Não é tocado pela ação "Zerar todo o progresso", de modo que o histórico de esforço sobrevive a um reinício.

## How it does it
Usa SharedPreferences do Android (um pequeno armazenamento chave-valor embutido no Android, veja [a documentação](https://developer.android.com/training/data-storage/shared-preferences)). Instalações antigas migram sua contagem única de um dia para o histórico.

## Where it sits in the pipeline
Escrito pelo [[study-controller]] depois de cada resposta em qualquer modo.

## Who receives its output
A [[daily-goal]] (a barra de hoje), o [[activity-calendar]] (sequências) e o [[progress-backup]].
