---
id: progress-store
lang: pt-BR
source_hash: 56b13d56398d
title: ProgressStore (progress.json)
---

## What it is
É onde o [[quizapp]] guarda o estado de agendamento de cada carta (`CardProgress`: fase, passo, facilidade, intervalo, vencimento, lapsos e se a carta está suspensa ou removida). É um único arquivo [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, um formato de dados em texto simples), `progress.json`, no celular.

## What it does
Salva após cada resposta e carrega ao iniciar. Se o arquivo estiver corrompido, o problema é registrado no canal STORAGE e o arquivo é tratado como vazio, em vez de derrubar o app.

## How it does it
O `FileProgressStore` reescreve o arquivo de forma atômica: primeiro escreve um arquivo temporário e depois o renomeia, de modo que uma queda nunca deixa um arquivo pela metade. Fica atrás da interface `ProgressStore` (uma promessa do que um armazenamento deve saber fazer), então os testes usam um simples `InMemoryProgressStore`; `replaceAll` aplica a importação de um backup em uma única gravação.

## Where it sits in the pipeline
Sob o [[study-controller]]: escrito depois do [[spaced-repetition-scheduler]], lido pelo [[study-pipeline]].

## Who receives its output
O [[study-pipeline]] (próxima sessão) e o [[progress-backup]] (exportação).
