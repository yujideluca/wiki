---
id: mutation-check
lang: pt-BR
source_hash: a0ef30ec4740
title: Teste de mutação
aliases: [mutantes]
---

## What it is
Uma verificação de que os testes protegem de verdade as regras: ela planta defeitos de propósito e exige que algum teste falhe para cada um.

## What it does
Cada mutante muda uma constante, comparação ou condição no agendador, avaliador, fila, sessão, armazenamento ou no gêmeo web; um mutante sobrevivente significa que um requisito não está realmente protegido. Os arquivos originais são sempre restaurados.

## How it does it
Python; roda a suíte de testes correspondente para cada mutante (`--web-only`, `--app-only`). É lento, então roda no `promote` e toda segunda-feira na CI, não a cada push.

## Where it sits in the pipeline
Dentro do [[quizapp-quality-gate]] quando chamado com `--mutation`, como faz o `promote` do [[publish-apk]].

## Who receives its output
O [[quizapp-quality-gate]].
