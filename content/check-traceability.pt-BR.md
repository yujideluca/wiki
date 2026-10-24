---
id: check-traceability
lang: pt-BR
source_hash: 6c2600619e7c
title: pipeline-check --traceability
aliases: [portão de rastreabilidade, check_traceability.py]
---

## What it is
A verificação de rastreabilidade de requisitos comum a todos os projetos: todo requisito tem um teste, e toda marca de teste cita um requisito real.

## What it does
Lê os IDs do `docs/REQUIREMENTS.md`, junta as marcas `REQ <ID>` das pastas de teste, falha se um requisito não tem teste marcado ou se uma marca é desconhecida, e escreve o `docs/TRACEABILITY.md` (requisito → arquivos de teste).

## How it does it
Um subcomando do programa [[pipeline-check]] (Rust, `--traceability`, desde a v0.3.0) que cada projeto executa pelo seu `tools/pipeline-check.sh` com versão fixada; ele substituiu o `check_traceability.py` que era copiado em cada repositório. Cada projeto lista as pastas de teste, as extensões e um rótulo opcional numa seção `[traceability]` do `pipeline-check.toml` (QuizApp: Kotlin e JS, com os testes do gêmeo web rotulados `web`; o wiki: Elixir e Elm).

## Where it sits in the pipeline
O passo 2 de todo portão de qualidade.

## Who receives its output
O [[template-quality-gate]], o [[quizapp-quality-gate]] e o [[wiki-quality-gate]].
