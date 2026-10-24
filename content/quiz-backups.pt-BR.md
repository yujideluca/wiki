---
id: quiz-backups
lang: pt-BR
source_hash: e59de2ecbef0
title: quiz-backups (cópias no notebook)
---

## What it is
São cópias do próprio progresso do Giovanni no QuizApp, guardadas no notebook em `~/dev/quiz-backups` (por exemplo `20261019-0847/progress.json` e arquivos de backup exportados).

## What it does
Permitem desfazer um reset do celular ou um lançamento arriscado: o progresso pode ser recolocado.

## How it does it
Cada cópia é uma pasta com data e hora no nome (puxada do celular pelo adb, a Android Debug Bridge), mais uma pasta `exported/` para arquivos feitos pela função [[progress-backup]]. O arquivo `LATEST` indica a cópia mais recente.

## Where it sits in the pipeline
No fim do caminho de backup: [[progress-backup]] ou adb → aqui.

## Who receives its output
O Giovanni ou o Claude, quando for preciso restaurar o progresso.
