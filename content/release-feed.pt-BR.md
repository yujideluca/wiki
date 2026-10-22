---
id: release-feed
lang: pt-BR
source_hash: a13c9c788bc7
title: german-quiz-releases (canal de atualização)
aliases: [repositório de versões]
---

## What it is
O repositório público `yujideluca/german-quiz-releases` no GitHub (clone local `~/dev/german-quiz-releases`), que guarda só o APK mais novo e seu manifesto `latest.json` (versionCode, versionName, sha256, commit).

## What it does
É o canal de atualização automática que o app lê. Dois branches: `main` = estável (o que os usuários recebem) e `bleeding-edge` = beta ([[release-channels]]).

## How it does it
Só o [[publish-apk]] escreve nele: compila, grava versionCode e SHA-256 e faz push.

## Where it sits in the pipeline
Entre o [[publish-apk]] no notebook e o [[update-client]] no celular.

## Who receives its output
O [[update-client]] em cada cópia instalada.
