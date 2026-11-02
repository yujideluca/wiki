---
id: checks-codex-skills
lang: pt-BR
source_hash: da0b91ce2243
title: codex-skills: verificadores e regras
---

## What it is
Estes são os verificadores do [[codex-skills]], o repositório que guarda os skills usados pelo Codex, com suas fontes e um manifesto. Sua ferramenta `skillsctl` os valida e instala ([[codex-skillsctl]]).

## What it does
O gate roda: `skillsctl.py check` (valida o manifesto e as impressões digitais dos arquivos dos skills; o hash é calculado sobre nomes e bytes e nunca segue links simbólicos); os testes unitários em `tests/test_skillsctl.py`; uma verificação de mutação (`tools/mutation_check.py`); rastreabilidade de requisitos (os requisitos CS); e os limites de fitness. A regra por trás (ADR-0002, registro de decisão de arquitetura): adaptações de responsabilidade do Codex nunca atualizam as fontes do Claude.

## How it does it
A CI (integração contínua) roda `pipeline-check --mode ci` (no máximo 60 minutos). O `pipeline-check.toml` é o do modelo: sem seção GitHub, então a proteção de branch não é lida. Existem três ADRs.

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
