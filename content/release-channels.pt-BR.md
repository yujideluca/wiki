---
id: release-channels
lang: pt-BR
source_hash: 7fa797bc5567
title: Canais de versão: estável e beta
aliases: [beta]
---

## What it is
A regra de que nada chega ao jogador sem passar antes pelo app beta (ADR-0005), e de quando um beta pode ser promovido (ADR-0011).

## What it does
Duas variantes de build: `stable` (`dev.yuji.quiz`, "Deutsch B2", segue o `main` do [[release-feed]]) e `beta` (`dev.yuji.quiz.beta`, "Deutsch B2 beta", segue o `bleeding-edge`). Um beta fica apto quando sobrevive aos testes automáticos atualizados para o que ele muda; aí o Giovanni decide.

## How it does it
Garantido pelo [[publish-apk]] (`promote` roda o portão com [[mutation-check]] e [[check-tests-updated]]). As versões web esperam num branch `web-<versão>` do [[quizweb]] até a promoção.

## Where it sits in the pipeline
Rege o [[quizapp-release]].

## Who receives its output
O [[update-client]] (qual branch seguir).
