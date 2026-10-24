---
id: progress-backup
lang: pt-BR
source_hash: 772f585f0b80
title: Backup de progresso
---

## What it is
Configurações > Backup no [[quizapp]] exporta o progresso de estudo do Giovanni como um único arquivo [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, um formato de dados em texto simples) e pode restaurá-lo (decisão ADR-0010; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). É a rede de segurança contra um reset do celular ou um lançamento arriscado.

## What it does
Exporta e importa a versão do formato, o estado de cada carta, o histórico de respostas, a meta diária e o tema. Uma importação substitui o progresso atual em uma única gravação, então ou funciona por completo ou não funciona.

## How it does it
O código que converte o progresso para o arquivo e de volta (o codec) fica no [[quizapp-core]]. Os arquivos passam pelo seletor de documentos do Android (`CreateDocument` e `OpenDocument`), de modo que o usuário escolhe o armazenamento do celular ou o Google Drive e o app não precisa de permissão de armazenamento.

## Where it sits in the pipeline
Lê o [[progress-store]] e o [[training-store]]; seus arquivos acabam no celular, no Google Drive ou em [[quiz-backups]].

## Who receives its output
O Giovanni (o arquivo) e o [[quiz-backups]] no notebook.
