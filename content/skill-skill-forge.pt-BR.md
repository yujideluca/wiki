---
id: skill-skill-forge
lang: pt-BR
source_hash: c1492845672e
title: Skill: skill-forge
---

## What it is
O fluxo completo para criar ou refazer uma skill para o Giovanni.

## What it does
Análise de requisitos, três versões concorrentes, testes, checagem de compatibilidade com as outras skills, depois validação e empacotamento pelo skill-creator. Edições pequenas numa skill pulam isso e usam só o skill-creator.

## How it does it
Um `SKILL.md` em `~/.claude/skills/skill-forge`; o Claude a carrega quando um pedido combina com a descrição dela.

## Where it sits in the pipeline
Como toda skill nova ou refeita é feita.

## Who receives its output
A pasta [[skills]] (e as cópias do app do Claude, [[claude-ai-skills]]).
