---
id: quiz-backups
lang: pt-BR
source_hash: 5661c1f709be
title: quiz-backups (cópias no notebook)
---

## What it is
Cópias do progresso do próprio Giovanni no QuizApp guardadas no notebook em `~/dev/quiz-backups` (por exemplo `20261019-0847/progress.json` e arquivos de backup exportados).

## What it does
Permite desfazer um celular zerado ou uma versão arriscada: o progresso pode ser reposto.

## How it does it
Uma pasta com data e hora por cópia (puxada do celular por adb) mais `exported/` para arquivos feitos com o [[progress-backup]]; `LATEST` indica a mais recente.

## Where it sits in the pipeline
No fim do caminho de backup: [[progress-backup]] / adb → aqui.

## Who receives its output
O Giovanni ou o Claude, quando for preciso restaurar o progresso.
