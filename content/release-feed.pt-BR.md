---
id: release-feed
lang: pt-BR
source_hash: 1e0d55392911
title: german-quiz-releases (feed de atualização)
---

## What it is
O "feed de atualização" é o repositório público do GitHub `yujideluca/german-quiz-releases` (clone local `~/dev/german-quiz-releases`). Guarda apenas o APK mais novo (Android Package, o arquivo instalável do app) e seu arquivo de descrição `latest.json` (versionCode, versionName, impressão digital sha256, commit). Desde 2026-10-22 tem também uma pasta `content/` com o [[question-pack]] mais novo.

## What it does
É o que os apps leem ao verificar atualizações. Há dois branches: `main` é o canal estável (o que os usuários recebem) e `bleeding-edge` é o canal beta ([[release-channels]]).

## How it does it
É escrito apenas pelo [[publish-apk]] (o APK) e pelo [[publish-content]] (o pacote de perguntas), então nada mais pode mudar o que os apps baixam.

## Where it sits in the pipeline
Entre o [[publish-apk]] no notebook e o [[update-client]] no celular.

## Who receives its output
O [[update-client]] em cada cópia instalada e o [[question-pool-updater]].
