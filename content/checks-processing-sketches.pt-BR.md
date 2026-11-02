---
id: checks-processing-sketches
lang: pt-BR
source_hash: d9932bb76a73
title: processing-sketches: verificadores e regras
---

## What it is
Estes são os verificadores do [[processing-sketches]], uma pasta de desenhos escritos para o ambiente Processing ([[drachenkurve]] e [[drachenfraktal]]). É o menor projeto.

## What it does
O gate faz duas coisas: toda pasta de sketch `nome/` deve conter `nome/nome.pde` (o arquivo que o Processing espera), e nenhum arquivo sob uma pasta `build/` pode ser rastreado pelo git. Limites: o gate com no máximo 300 segundos. Não há suíte de testes, lista de requisitos nem verificação de mutação.

## How it does it
A CI (integração contínua) roda `pipeline-check --mode ci` (no máximo 20 minutos); `pipeline-check.toml` nomeia o repositório e o job obrigatório `gate`, e a wiki registra a proteção como ativa ([[maintenance-pipeline]]).

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
