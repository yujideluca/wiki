---
id: progress-backup
lang: pt-BR
source_hash: f138e16fe7ce
title: Backup do progresso
aliases: [backup]
---

## What it is
Configurações > Backup no [[quizapp]]: um arquivo JSON com tudo o que é preciso para restaurar o progresso do Giovanni (ADR-0010).

## What it does
Exporta e importa: versão do formato, estado das cartas, histórico de respostas, meta diária e tema. A importação substitui o progresso atual numa só gravação.

## How it does it
O codec fica no [[quizapp-core]]; os arquivos passam pelo seletor de documentos do Android (`CreateDocument` / `OpenDocument`), então o usuário escolhe o armazenamento do celular ou o Google Drive e o app não precisa de permissão de armazenamento.

## Where it sits in the pipeline
Lê o [[progress-store]] e o [[training-store]]; os arquivos vão para o celular, para o Google Drive ou para o [[quiz-backups]].

## Who receives its output
O Giovanni (o arquivo) e o [[quiz-backups]] no notebook.
