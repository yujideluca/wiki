---
id: apk-installer
lang: pt-BR
source_hash: 70f8d5b3eedf
title: ApkInstaller
---

## What it is
O `ApkInstaller` é um adaptador Android fino (um pequeno pedaço de código que liga o app a uma parte do Android). Abre o instalador do sistema do Android para um APK (Android Package, o arquivo instalável do app) que foi baixado e verificado.

## What it does
Entrega o arquivo ao instalador de pacotes do Android. O progresso do Giovanni sobrevive à atualização porque o novo APK é assinado com a mesma chave do antigo ([[signing-key]]); o Android só aceita uma atualização assinada pela mesma chave.

## How it does it
É chamado somente depois de o [[update-client]] ter verificado o SHA-256 do arquivo (SHA-256, Secure Hash Algorithm 256, uma impressão digital do conteúdo do arquivo), então um download danificado ou adulterado nunca é oferecido para instalação.

## Where it sits in the pipeline
O último passo de uma atualização dentro do app.

## Who receives its output
O Android no [[phone]].
