---
id: quizweb-conformance
lang: pt-BR
source_hash: 32a77a64233c
title: Vetores de conformidade (app = web)
aliases: [vetores compartilhados]
---

## What it is
Casos de teste calculados à mão (`scheduler.json`, `daily_bar.json`) que o [[quizapp]] e o [[quizweb]] precisam passar, para as duas implementações não se afastarem.

## What it does
Cada vetor é um histórico de entrada com o agendamento ou a barra de progresso exatamente esperados.

## How it does it
Os mesmos arquivos ficam nos dois repositórios; o passo 4 do [[quizapp-quality-gate]] falha se não forem idênticos byte a byte (`cmp`).

## Where it sits in the pipeline
Entre as duas camadas de domínio: o [[spaced-repetition-scheduler]] e o [[quizweb-domain]].

## Who receives its output
As duas suítes de testes e o [[quizapp-quality-gate]].
