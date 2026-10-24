---
id: release-channels
lang: pt-BR
source_hash: bd9b881c526c
title: Canais de lançamento: estável e beta
---

## What it is
Um "canal de lançamento" é um fluxo separado de versões que as pessoas podem seguir. Esta página descreve a regra de que nada chega ao jogador sem passar primeiro pelo app beta (decisão ADR-0005) e quando um beta pode ser promovido (decisão ADR-0011). Uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão.

## What it does
Há dois sabores de build. O `stable` (pacote `dev.yuji.quiz`, exibido como "Deutsch B2") segue o branch `main` do [[release-feed]]; o `beta` (pacote `dev.yuji.quiz.beta`, exibido como "Deutsch B2 beta") segue o branch `bleeding-edge`. Como os pacotes são diferentes, os dois podem ser instalados ao mesmo tempo no celular. Um beta torna-se elegível para promoção depois de sobreviver aos testes automatizados atualizados para o que ele muda; depois disso o Giovanni decide.

## How it does it
É aplicado pelo [[publish-apk]]: seu `promote` executa o portão com [[mutation-check]] e [[check-tests-updated]]. Portabilidades web esperam em um branch `web-<versão>` do [[quizweb]] até a promoção.

## Where it sits in the pipeline
Rege o [[quizapp-release]].

## Who receives its output
O [[update-client]], que fica sabendo qual branch seguir.
