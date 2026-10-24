---
id: quizweb-conformance
lang: pt-BR
source_hash: d5986c028e3f
title: Vetores de conformidade (app = web)
---

## What it is
"Vetores de conformidade" são casos de teste calculados à mão que o [[quizapp]] e o [[quizweb]] precisam passar (`scheduler.json`, `daily_bar.json`). Como os dois apps são escritos em linguagens diferentes, os casos compartilhados garantem que as duas implementações não se afastem.

## What it does
Cada vetor é um histórico de entrada com o agendamento ou a barra de progresso esperados com exatidão, calculados à mão e não pelo código testado.

## How it does it
Os mesmos arquivos ficam nos dois repositórios. O passo 4 do [[quizapp-quality-gate]] falha se não forem idênticos byte a byte (verificado com `cmp`, um comando que compara dois arquivos).

## Where it sits in the pipeline
Entre as duas camadas de domínio: o [[spaced-repetition-scheduler]] e o [[quizweb-domain]].

## Who receives its output
As duas suítes de testes e o [[quizapp-quality-gate]].
