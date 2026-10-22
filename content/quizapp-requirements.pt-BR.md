---
id: quizapp-requirements
lang: pt-BR
source_hash: 1502c78509ba
title: Requisitos e rastreabilidade do QuizApp
aliases: [marcas REQ]
---

## What it is
O catálogo de todas as promessas testáveis do [[quizapp]], cada uma com um ID (SP-1 espaçamento, GR-1 avaliação, QU-1 fila, DG-* meta diária, QP-* banco de perguntas…), mais a estratégia de testes em `docs/TESTING.md` (ADR-0008, qualidade começando pelos requisitos).

## What it does
Diz o que precisa valer e em que nível é testado: unitário, integração, propriedade, conformidade entre plataformas, aceitação no aparelho, verificado por mutação. O `docs/TRACEABILITY.md` (gerado) liga cada requisito aos seus testes.

## How it does it
Um comportamento que o Giovanni descreve vira primeiro uma linha; depois um teste marcado `REQ <ID>`; depois código. O [[check-traceability]] falha quando um requisito não tem teste.

## Where it sits in the pipeline
O primeiro passo do [[quizapp-release]].

## Who receives its output
O [[check-traceability]] e quem escreve testes.
