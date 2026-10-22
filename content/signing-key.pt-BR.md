---
id: signing-key
lang: pt-BR
source_hash: ce8b1d83d5cd
title: Chave de assinatura do QuizApp
aliases: [keystore de release]
---

## What it is
A chave de assinatura Android própria do projeto, guardada fora do repositório em `~/.android` (o keystore e um arquivo de propriedades com as credenciais). O conteúdo nunca é escrito em outro lugar.

## What it does
Assina os builds de depuração e de release, para as atualizações instalarem por cima e o progresso sobreviver; estável e beta podem ser instalados lado a lado.

## How it does it
O build do Gradle lê o arquivo de propriedades; se ele faltar, usa a chave de depuração padrão.

## Where it sits in the pipeline
Usada pelo [[publish-apk]] e por todo build local.

## Who receives its output
O [[publish-apk]].
