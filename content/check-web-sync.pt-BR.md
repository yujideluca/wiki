---
id: check-web-sync
lang: pt-BR
source_hash: 33975fd54a76
title: check_web_sync.sh
aliases: [verificação de sincronia web]
---

## What it is
A verificação de que a versão web sempre corresponde à versão de usuário do app Android (ADR-0006).

## What it does
Sai com 2 e diz o que está atrasado quando: um arquivo de vocabulário ou de tradução difere entre o [[vocab-assets]] e o `vocab/` e `i18n/` da web; o conjunto de modos difere (ids do `GameMode` contra `MODES` no [[quizweb-domain]]); ou o clone web tem trabalho sem commit ou sem push.

## How it does it
Bash comparando arquivos em `~/dev/QuizApp` e `~/dev/QuizWeb`. A correção é levar a mudança para o QuizWeb, aumentar o `VERSION` no `sw.js`, rodar `npm test`, fazer commit e push.

## Where it sits in the pipeline
No fim do `promote` do [[publish-apk]].

## Who receives its output
O [[publish-apk]] e o Claude (o que levar para a web).
