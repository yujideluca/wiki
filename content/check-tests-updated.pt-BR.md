---
id: check-tests-updated
lang: pt-BR
source_hash: 7a6a1315851f
title: check_tests_updated.sh
---

## What it is
`check_tests_updated.sh` é a verificação por trás da decisão ADR-0011 (uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). A regra: uma nova versão do [[quizapp]] só pode chegar aos usuários se sobreviveu a testes atualizados para o que ela muda. Senão, testes antigos poderiam passar enquanto o novo comportamento não é testado de forma alguma.

## What it does
Compara o commit prestes a ser publicado com o último lançamento estável. Se código ou conteúdo mudou mas nenhum teste mudou, recusa e sai com código 1.

## How it does it
Um script [Bash](https://www.gnu.org/software/bash/) sobre `git diff --name-only BASE HEAD` (a lista de arquivos que diferem entre dois pontos do histórico), que separa o código principal das pastas de teste.

## Where it sits in the pipeline
Executado pelo `promote` do [[publish-apk]], como parte do [[quizapp-release]].

## Who receives its output
O [[publish-apk]].
