---
id: checks-pipeline-check
lang: pt-BR
source_hash: 5a8c20d8da09
title: pipeline-check: verificadores e regras
---

## What it is
Estas são as verificações que guardam o próprio [[pipeline-check]], o programa em Rust que mede todos os outros projetos (repositório próprio, `yujideluca/pipeline-check`). O programa não pode contar com uma cópia fixada de si mesmo e por isso tem a ligação mais enxuta.

## What it does
O gate tem três passos: (1) `cargo test`, com arquivos de teste para execuções de ponta a ponta, o modo pre-push, ShellCheck, rastreabilidade e um conjunto de caça a bugs; (2) rastreabilidade de requisitos rodando o seu próprio `--traceability` sobre `src` e `tests` (os requisitos PC) com a matriz commitada; (3) uma verificação de mutação feita à mão: `mutants.py` planta falhas e o gate falha se alguma sobreviver. Seus princípios: o programa mede e um skill julga (ADR-0002, registro de decisão de arquitetura), e uma ferramenta usada por mais de um projeto vive uma vez e é consumida por versão fixada (ADR-0003).

## How it does it
O job de CI (integração contínua) `gate` roda `tools/quality_gate.sh` diretamente (no máximo 30 minutos). Seu `pipeline-check.toml` não define limites de fitness, seção GitHub nem guarda de pre-push; tem as seções de rastreabilidade e de ShellCheck. Três ADRs estão em seu `docs/adr`.

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
