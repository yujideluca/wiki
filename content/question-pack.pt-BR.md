---
id: question-pack
lang: pt-BR
source_hash: 68faee0e03dc
title: Pacote de perguntas (ContentPack)
---

## What it is
O pacote de perguntas (nome de código `ContentPack`) é o conjunto de perguntas do [[quizapp]] visto como um pacote versionado: sete arquivos (`vocab/*.json` e `i18n/*.json`) descritos por um manifesto, `content.json` (decisão ADR-0012, 2026-10-22; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). Por ser um pacote, pode ser trocado sem lançar um novo app.

## What it does
O manifesto informa o formato dos arquivos (`schema`, hoje 1, igual a `CONTENT_SCHEMA`), a versão do conjunto (`contentVersion`, que sobe em um sempre que qualquer arquivo muda) e o SHA-256 de cada arquivo (SHA-256, Secure Hash Algorithm 256, uma impressão digital do conteúdo do arquivo). A função `validateContentPack` só aceita um pacote quando todo arquivo está listado, corresponde à sua impressão digital e pode ser interpretado, e cada modo ainda tem pelo menos uma pergunta. `shouldDownloadContent` decide se um pacote encontrado no feed vale a pena ser baixado.

## How it does it
É Kotlin puro no [[quizapp-core]], testado pelo `ContentPackTest` e por cinco mutantes no [[mutation-check]] (requisitos QP-1 a QP-4). O pacote embutido no app é `assets/content.json`, mantido pelo [[content-manifest]]. Um novo modo ou um campo novo nos arquivos não é uma mudança de conjunto: exige um lançamento do app e um esquema mais alto, que apps antigos ignoram.

## Where it sits in the pipeline
Entre a construção do conteúdo ([[build-vocab]], [[content-manifest]]) e o [[question-pool-updater]] do app.

## Who receives its output
O [[question-pool-updater]], que o usa para verificar e instalar pacotes baixados.
