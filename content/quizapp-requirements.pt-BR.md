---
id: quizapp-requirements
lang: pt-BR
source_hash: f4adfd238bb2
title: Requisitos e rastreabilidade do QuizApp
---

## What it is
Um requisito é uma promessa testável do programa, por exemplo "uma resposta errada em uma carta nova volta após 10 minutos". Este catálogo lista toda promessa testável do [[quizapp]], cada uma com um ID (SP-1 espaçamento, GR-1 avaliação, QU-1 fila, DG-* meta diária, QP-* conjunto de perguntas e assim por diante), junto com a estratégia de testes em `docs/TESTING.md` (decisão ADR-0008, "requisitos primeiro"; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão).

## What it does
Diz o que deve valer e em que nível cada promessa é testada: unitário (uma peça), integração (peças juntas), propriedade (muitas entradas aleatórias), conformidade entre plataformas (app e web concordam), aceitação em um aparelho e verificação de mutação. O arquivo gerado `docs/TRACEABILITY.md` liga cada requisito aos seus testes.

## How it does it
Um comportamento declarado pelo Giovanni vira primeiro uma linha; depois se escreve um teste etiquetado `REQ <ID>`; depois o código. A verificação [[check-traceability]] falha quando um requisito não tem teste.

## Where it sits in the pipeline
O primeiro passo do [[quizapp-release]].

## Who receives its output
O [[check-traceability]] e todo autor de teste.
