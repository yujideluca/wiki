---
id: signing-key
lang: pt-BR
source_hash: 45f64ed11d94
title: Chave de assinatura do QuizApp
---

## What it is
O Android só instala a atualização de um app se ela for assinada com a mesma chave criptográfica da versão instalada. O QuizApp tem sua própria chave de assinatura, guardada fora do repositório em `~/.android`: o keystore (o arquivo da chave) e um arquivo de propriedades com as credenciais. O conteúdo nunca é escrito em outro lugar.

## What it does
Assina os builds de depuração e de lançamento, de modo que as atualizações se instalam umas sobre as outras e o progresso sobrevive; estável e beta podem ser instalados lado a lado.

## How it does it
O build do Gradle lê o arquivo de propriedades. Se o arquivo não existir, recorre à chave de depuração padrão, que serve para testes mas não corresponderia ao app real.

## Where it sits in the pipeline
Usada pelo [[publish-apk]] e por todo build local.

## Who receives its output
O [[publish-apk]].
