---
id: publish-content
lang: pt-BR
source_hash: 78163a96bc6d
title: publish_content.sh
aliases: [publicar perguntas]
---

## What it is
Publica um banco de perguntas novo sem APK novo (ADR-0012).

## What it does
`publish_content.sh beta` confere o banco commitado e o coloca na pasta `content/` do [[release-feed]] no `bleeding-edge`, onde o app beta o encontra. `publish_content.sh promote` (decisão do Giovanni, como um APK) copia exatamente esse pacote para o `main`, para o app estável, e coloca os mesmos arquivos na versão web ([[quizweb]]).

## How it does it
Bash; a etapa web trabalha numa cópia temporária do `origin/main` do repositório web, para não atrapalhar uma versão web esperando num branch `web-<versão>`. `beta` roda antes os testes do core (as mesmas verificações que o app faz num download) e recusa uma versão do banco que já está em `bleeding-edge`; `promote` recusa se `bleeding-edge` não tiver um banco mais novo que `main`. Com `FEED_DIR` (e `WEB_DIR`) ele escreve numa cópia de teste (sandbox); junto com um build de debug que lê um feed local (`-PfeedUrl`), dá para testar um banco no celular sem publicá-lo.

## Where it sits in the pipeline
O caminho só de conteúdo do [[quizapp-release]]: editar o TSV → [[build-vocab]] → commit → este script.

## Who receives its output
O [[release-feed]] (os dois branches) e o [[quizweb-content]].
