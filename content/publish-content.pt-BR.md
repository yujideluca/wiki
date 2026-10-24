---
id: publish-content
lang: pt-BR
source_hash: ea321bd2e361
title: publish_content.sh
---

## What it is
`publish_content.sh` publica um novo conjunto de perguntas sem construir um novo APK (Android Package, o arquivo instalável do app). Isso é possível graças à decisão ADR-0012 (uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão).

## What it does
`publish_content.sh beta` verifica o conjunto commitado e o coloca na pasta `content/` do [[release-feed]], no branch `bleeding-edge`, onde o app beta o encontra. `publish_content.sh promote` (decisão do Giovanni, como para um APK) copia exatamente esse pacote para o branch `main` para o app estável e coloca os mesmos arquivos na versão web ([[quizweb]]).

## How it does it
[Bash](https://www.gnu.org/software/bash/). A etapa web trabalha em um worktree temporário (uma segunda cópia em checkout) do `origin/main` do repositório web, então uma portabilidade web que espera em um branch `web-<versão>` não é perturbada.

## Where it sits in the pipeline
O caminho só de conteúdo do [[quizapp-release]]: editar os arquivos TSV (valores separados por tabulação) → [[build-vocab]] → commit → este script.

## Who receives its output
O [[release-feed]] (os dois branches) e o [[quizweb-content]].
