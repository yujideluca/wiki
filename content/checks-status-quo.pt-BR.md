---
id: checks-status-quo
lang: pt-BR
source_hash: 4b5f386286df
title: status-quo: verificadores e regras
---

## What it is
Estes são os verificadores do repositório `status-quo` (veja [[status-quo-design]] e [[status-quo-layout]]), um workspace em Rust iniciado a partir do [[project-template]]. No momento da escrita não tinha commits, então suas verificações são em parte os espaços de preenchimento ainda vazios do modelo.

## What it does
O gate ainda traz o passo do modelo `echo "TODO: build and run the test suite"`, então nenhum teste roda ainda; o passo de rastreabilidade e o de fitness são reais. Tem 25 requisitos (grupo SQ) em `docs/REQUIREMENTS.md`. Seu `pipeline-check.toml` ainda chama o projeto de `<project name>` e define apenas o teto de duração do gate (1200 segundos). No seu `CLAUDE.md`, o princípio 2 (a

## How it does it
lógica

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
