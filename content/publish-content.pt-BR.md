---
id: publish-content
lang: pt-BR
source_hash: 55f080e0d7e3
title: publish_content.sh
aliases: [publicar perguntas]
---

## What it is
Publica um banco de perguntas novo sem APK novo (ADR-0012).

## What it does
`publish_content.sh beta` confere o banco commitado e o coloca na pasta `content/` do [[release-feed]] no `bleeding-edge`, onde o app beta o encontra. `publish_content.sh promote` (decisão do Giovanni, como um APK) copia exatamente esse pacote para o `main`, para o app estável, e coloca os mesmos arquivos na versão web ([[quizweb]]).

## How it does it
Bash; a etapa web trabalha numa cópia temporária do `origin/main` do repositório web, para não atrapalhar uma versão web esperando num branch `web-<versão>`.

## Where it sits in the pipeline
O caminho só de conteúdo do [[quizapp-release]]: editar o TSV → [[build-vocab]] → commit → este script.

## Who receives its output
O [[release-feed]] (os dois branches) e o [[quizweb-content]].
