---
id: publish-apk
lang: pt-BR
source_hash: eaf1591f7392
title: publish_apk.sh
---

## What it is
O script de publicação do [[quizapp]]: compila um APK de release assinado e publica no [[release-feed]].

## What it does
Roda primeiro o [[quizapp-quality-gate]]; publica um beta no `bleeding-edge`; `publish_apk.sh promote` leva um beta para o estável `main` depois que o portão com teste de mutação e o [[check-tests-updated]] passam (ADR-0011). Promover é decisão do Giovanni, sem tempo mínimo em beta.

## How it does it
Build de release do Gradle assinado com a [[signing-key]]; grava versionCode e SHA-256 no `latest.json` e faz push do repositório do canal.

## Where it sits in the pipeline
O último passo do [[quizapp-release]].

## Who receives its output
O [[release-feed]].
