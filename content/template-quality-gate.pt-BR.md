---
id: template-quality-gate
lang: pt-BR
source_hash: cfef1c6bbef4
title: Portão de qualidade do modelo
---

## What it is
Um portão de qualidade (quality gate) é um script que decide se um projeto está "aprovado". Este é o esqueleto do `tools/quality_gate.sh` de cada projeto: a definição única de "aprovado", usada antes de um lançamento e pela CI (integração contínua, verificações automáticas a cada push). Ter uma só definição significa que as verificações no notebook e no GitHub nunca podem discordar.

## What it does
Tem três passos para cada projeto preencher: build e testes; rastreabilidade de requisitos, isto é, todo requisito tem um teste e todo teste aponta para um requisito ([[check-traceability]]); e funções de aptidão (fitness functions), verificações automáticas de que o design não se desviou. Também falha se o portão demorar mais de 1200 segundos, porque um portão lento acaba pulado, e um portão pulado não protege nada.

## How it does it
É um script [Bash](https://www.gnu.org/software/bash/) com `set -euo pipefail` (parar no primeiro erro), em que cada passo é um comando que termina com código diferente de zero (o número que um programa devolve para dizer que algo deu errado) em caso de falha. O workflow de CI (`.github/workflows/quality-gate.yml`) executa exatamente este script.

## Where it sits in the pipeline
Copiado para cada novo projeto ([[new-project]]).

## Who receives its output
O [[quizapp-quality-gate]] e o [[wiki-quality-gate]], que são suas versões preenchidas.
