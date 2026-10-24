---
id: check-web-sync
lang: pt-BR
source_hash: 1178303a41ce
title: check_web_sync.sh
---

## What it is
`check_web_sync.sh` verifica que a versão web ([[quizweb]]) sempre corresponde à versão do usuário (estável) do app Android (decisão ADR-0006; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). Sem ela, os dois "gêmeos" poderiam se afastar aos poucos.

## What it does
Sai com código 2 e diz o que está atrasado quando: um arquivo de vocabulário ou de tradução difere entre o [[vocab-assets]] e as pastas `vocab/` e `i18n/` da web; o conjunto de modos difere (os ids de armazenamento do `GameMode` contra `MODES` em [[quizweb-domain]]); ou o clone da web tem trabalho não commitado ou não enviado.

## How it does it
Um script [Bash](https://www.gnu.org/software/bash/) que compara arquivos em `~/dev/QuizApp` e `~/dev/QuizWeb`. A correção é portar a mudança para o QuizWeb, aumentar o `VERSION` em `sw.js` (veja [[quizweb-service-worker]]), executar `npm test`, commitar e fazer push.

## Where it sits in the pipeline
No fim do `promote` do [[publish-apk]].

## Who receives its output
O [[publish-apk]] e o Claude (que fica sabendo o que portar).
