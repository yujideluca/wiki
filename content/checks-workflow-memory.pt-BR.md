---
id: checks-workflow-memory
lang: pt-BR
source_hash: 3932c2c4cf41
title: workflow-memory: verificadores e regras
---

## What it is
Estes são os verificadores do [[workflow-memory]], a memória compartilhada dos assistentes do Giovanni. Ele guarda eventos (registros de que algo foi decidido ou aprendido) como arquivos e deriva visões a partir deles.

## What it does
O gate tem dois passos: os testes unitários (`python3 -m unittest discover`, sete arquivos de teste) e `pipeline-check --measure-only`. Limites: nenhum arquivo Python com mais de 400 linhas em `mem`, `bin` e `scripts`, o gate com no máximo 300 segundos. As regras de conteúdo estão no código: todo evento novo passa pelo validador em `mem/validate.py`, que confere o esquema, corrige carimbos de tempo no futuro e aplica os padrões de privacidade compartilhados; um evento que falha é movido para `quarantine/` com uma nota `.reason` ([[mem-validator]]). A invariante um `tests/test_tags.py` verifica as tags das regras, inclusive que a saída de início da memória real fica abaixo de 1.900 caracteres e que nenhuma regra escrita pelo Giovanni fica sem tag.

## How it does it
arquivo

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
