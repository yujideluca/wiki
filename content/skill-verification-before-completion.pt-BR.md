---
id: skill-verification-before-completion
lang: pt-BR
source_hash: fe762a95f051
title: Skill: verification-before-completion
---

## What it is
A regra de que a evidência vem antes de qualquer afirmação de que o trabalho está pronto, corrigido ou passando.

## What it does
Antes de dizer "pronto" ou fazer commit: rodar os comandos de verificação e ler a saída. Alimenta a linha "Verified by:" que fecha todo relatório ao Giovanni, que também diz o que não deu para conferir.

## How it does it
Um `SKILL.md` em `~/.claude/skills/verification-before-completion`; o Claude a carrega quando um pedido combina com a descrição dela.

## Where it sits in the pipeline
Parte do processo de desenvolvimento no Claude Code, usada em todo projeto.

## Who receives its output
O Giovanni (o relatório) e o commit.
