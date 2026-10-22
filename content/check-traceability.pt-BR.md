---
id: check-traceability
lang: pt-BR
source_hash: 5e813c9bc841
title: check_traceability.py
aliases: [portão de rastreabilidade]
---

## What it is
O portão de rastreabilidade de requisitos comum a todos os projetos: todo requisito tem um teste, e toda marca de teste cita um requisito real.

## What it does
Lê os IDs do `docs/REQUIREMENTS.md`, junta as marcas `REQ <ID>` das pastas de teste, falha se um requisito não tem teste marcado ou se uma marca é desconhecida, e escreve o `docs/TRACEABILITY.md` (requisito → arquivos de teste).

## How it does it
Biblioteca padrão do Python; cada projeto define seus `TEST_DIRS` e extensões (QuizApp: Kotlin e JS; o wiki: Elixir e Elm).

## Where it sits in the pipeline
O passo 2 de todo portão de qualidade.

## Who receives its output
O [[template-quality-gate]], o [[quizapp-quality-gate]] e o [[wiki-quality-gate]].
