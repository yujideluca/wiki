---
id: mutation-check
lang: pt-BR
source_hash: cb8c15193642
title: Verificação de mutação
---

## What it is
O teste de mutação ([mutation testing](https://en.wikipedia.org/wiki/Mutation_testing)) pergunta: "se eu quebrar o programa de propósito, algum teste percebe?" O `mutation_check.py` planta falhas de propósito e exige que um teste falhe para cada uma. Se uma falha plantada ("mutante") passa despercebida, os testes não protegem de verdade aquela regra.

## What it does
Cada mutante muda uma constante, comparação ou condição no agendador, avaliador, pipeline de estudo, sessão, meta diária, verificação de atualização, armazenamentos de progresso e de treino, controlador de estudo ou carregador e armazenamento do conjunto de perguntas do [[quizapp]] ([[question-pack]]), ou no gêmeo web. Um mutante sobrevivente significa que um requisito não está realmente protegido. Os arquivos-fonte são sempre restaurados depois.

## How it does it
Um script [Python](https://www.python.org/) que executa a suíte de testes correspondente a cada mutante (`--web-only` e `--app-only` o limitam a um lado). É lento, então roda no `promote` e toda segunda-feira na CI (integração contínua, verificações automáticas no GitHub), não a cada push.

## Where it sits in the pipeline
Dentro do [[quizapp-quality-gate]] quando chamado com `--mutation`, o que o `promote` do [[publish-apk]] faz.

## Who receives its output
O [[quizapp-quality-gate]].
