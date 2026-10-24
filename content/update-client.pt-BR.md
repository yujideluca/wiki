---
id: update-client
lang: pt-BR
source_hash: 68a326627fee
title: UpdateClient (atualização dentro do app)
---

## What it is
O `UpdateClient` é como o [[quizapp]] se atualiza sem loja de aplicativos (decisão ADR-0004; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão).

## What it does
Toda vez que o app vai para o primeiro plano (no máximo uma vez a cada 30 segundos; se o relógio do telefone foi atrasado, de modo que "agora" fica antes da última verificação, a verificação roda mesmo assim em vez de esperar o relógio alcançar), lê o `latest.json` do [[release-feed]]. Um `versionCode` mais alto abre um popup na tela inicial (nunca durante uma sessão de estudo). Tocar em "Atualizar" baixa o APK (Android Package, o arquivo instalável do app), verifica sua impressão digital SHA-256 (Secure Hash Algorithm 256) e o entrega ao [[apk-installer]]. A mesma verificação também pede ao [[question-pool-updater]] um pacote de perguntas mais novo.

## How it does it
Lê pela API de conteúdo do GitHub (application programming interface: uma interface web para ler arquivos de repositório) com o cabeçalho `Accept: application/vnd.github.raw+json`, porque o endereço `raw.githubusercontent.com` mantinha arquivos em cache por 5 minutos. Um erro 403 é informado como o limite por hora (60 requisições por endereço IP). O sabor beta segue o branch `bleeding-edge`, o estável segue o `main` ([[release-channels]]).

## Where it sits in the pipeline
Entre o [[release-feed]] no GitHub e o [[apk-installer]] no celular.

## Who receives its output
O [[apk-installer]].
