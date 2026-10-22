---
id: update-client
lang: pt-BR
source_hash: 6a8e54fd84d8
title: UpdateClient (atualização no app)
aliases: [verificação de atualização]
---

## What it is
Como o [[quizapp]] se atualiza sem loja de apps (ADR-0004).

## What it does
Toda vez que o app volta ao primeiro plano (no máximo a cada 30 s) ele lê o `latest.json` do [[release-feed]]; um versionCode maior abre um aviso na tela inicial (nunca durante uma sessão). Atualizar baixa o APK, confere o SHA-256 e entrega ao [[apk-installer]].

## How it does it
Lê pela API de conteúdo do GitHub (`Accept: application/vnd.github.raw+json`), porque o raw.githubusercontent.com guardava cache por 5 minutos; um 403 é informado como o limite por hora (60 pedidos por IP). A variante beta segue o branch `bleeding-edge` e a stable segue o `main` ([[release-channels]]).

## Where it sits in the pipeline
Entre o [[release-feed]] no GitHub e o [[apk-installer]] no celular.

## Who receives its output
O [[apk-installer]].
