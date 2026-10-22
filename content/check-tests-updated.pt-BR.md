---
id: check-tests-updated
lang: pt-BR
source_hash: 8d4861f789e2
title: check_tests_updated.sh
---

## What it is
A verificação por trás do ADR-0011: uma versão nova só chega aos usuários se sobreviveu a testes atualizados para o que ela muda.

## What it does
Compara o commit a publicar com a última versão estável: se código ou conteúdo mudou e nenhum teste mudou, recusa (sai com 1).

## How it does it
Bash sobre `git diff --name-only BASE HEAD`, separando o código principal das pastas de teste.

## Where it sits in the pipeline
Rodado pelo `promote` do [[publish-apk]], parte do [[quizapp-release]].

## Who receives its output
O [[publish-apk]].
