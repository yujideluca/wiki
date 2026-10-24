---
id: publish-apk
lang: pt-BR
source_hash: bb877313e92a
title: publish_apk.sh
---

## What it is
`publish_apk.sh` é o script de lançamento do [[quizapp]]. Constrói um APK de lançamento assinado (Android Package, o arquivo instalável do app) e o publica no [[release-feed]].

## What it does
Executa primeiro o [[quizapp-quality-gate]]. Depois publica um beta no branch `bleeding-edge`. O comando `publish_apk.sh promote` leva um beta ao branch estável `main`, depois de o portão com verificação de mutação e o [[check-tests-updated]] terem passado (decisão ADR-0011; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). Promover é decisão do Giovanni, sem tempo mínimo em beta.

## How it does it
Um build de lançamento do Gradle assinado com a [[signing-key]]. Escreve o versionCode e a impressão digital SHA-256 (Secure Hash Algorithm 256) no `latest.json` e faz push do repositório do feed.

## Where it sits in the pipeline
O último passo do [[quizapp-release]].

## Who receives its output
O [[release-feed]].
