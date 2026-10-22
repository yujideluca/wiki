---
id: progress-store
lang: pt-BR
source_hash: 3effa5327449
title: ProgressStore (progress.json)
---

## What it is
Onde o [[quizapp]] guarda o estado de agendamento de cada carta (`CardProgress`: fase, passo, facilidade, intervalo, vencimento, erros, suspensão/remoção): um arquivo JSON no celular.

## What it does
Salva depois de cada resposta e carrega na abertura. Um arquivo corrompido é registrado no canal STORAGE e tratado como vazio, em vez de travar o app.

## How it does it
O `FileProgressStore` reescreve o arquivo de forma atômica (arquivo temporário + renomear), então uma queda nunca o deixa pela metade. Fica atrás da interface `ProgressStore`; os testes usam `InMemoryProgressStore`; `replaceAll` aplica a importação de um backup numa só gravação.

## Where it sits in the pipeline
Abaixo do [[study-controller]]: gravado depois do [[spaced-repetition-scheduler]], lido pelo [[study-pipeline]].

## Who receives its output
O [[study-pipeline]] (próxima sessão) e o [[progress-backup]] (exportação).
