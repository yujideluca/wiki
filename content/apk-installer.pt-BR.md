---
id: apk-installer
lang: pt-BR
source_hash: 33698f81c022
title: ApkInstaller
aliases: [instalador]
---

## What it is
O adaptador Android simples que abre o instalador do sistema para um APK baixado e verificado.

## What it does
Entrega o arquivo ao instalador de pacotes do Android; o progresso sobrevive porque o APK novo é assinado com a mesma chave ([[signing-key]]).

## How it does it
Só é chamado depois que o [[update-client]] conferiu o SHA-256.

## Where it sits in the pipeline
O último passo de uma atualização no app.

## Who receives its output
O Android no [[phone]].
