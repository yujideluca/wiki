---
id: question-pack
lang: pt-BR
source_hash: b3d89d910ee5
title: Pacote de perguntas (ContentPack)
aliases: [banco de perguntas]
---

## What it is
O banco de perguntas do [[quizapp]] como um pacote versionado de sete arquivos (`vocab/*.json` e `i18n/*.json`), descrito por um manifesto, o `content.json` (ADR-0012, 22/10/2026).

## What it does
O manifesto diz o formato dos arquivos (`schema`, por ora 1 = `CONTENT_SCHEMA`), a versão do banco (`contentVersion`, sobe um sempre que algum arquivo muda) e o SHA-256 de cada arquivo. O `validateContentPack` só aceita um pacote quando todo arquivo está listado, bate com a soma de verificação, pode ser lido e todo modo continua com pelo menos uma pergunta; o `shouldDownloadContent` decide se vale baixar um pacote do canal.

## How it does it
Kotlin puro no [[quizapp-core]], testado pelo `ContentPackTest` e por cinco mutantes no [[mutation-check]] (requisitos QP-1..QP-4). O pacote embutido no APK é o `assets/content.json`, mantido pelo [[content-manifest]]. Um modo novo ou um campo novo nos arquivos não é mudança de banco: exige uma versão nova do app e um schema maior, que apps antigos ignoram.

## Where it sits in the pipeline
Entre o build do conteúdo ([[build-vocab]], [[content-manifest]]) e o [[question-pool-updater]] do app.

## Who receives its output
O [[question-pool-updater]], que o usa para verificar e instalar pacotes baixados.
