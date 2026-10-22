---
id: skill-bias-risk-triage
lang: pt-BR
source_hash: 2fe25bf6ee86
title: Skill: bias-risk-triage
---

## What it is
Uma checagem silenciosa antes de responder perguntas factuais curtas.

## What it does
Procura viés, mitos, conspiração, informação desatualizada ou alto risco e define a profundidade da verificação (níveis T0–T3). Define só a profundidade mínima, nunca o formato; skills de domínio como a [[skill-consulta-clinica]] mantêm o formato delas.

## How it does it
Um `SKILL.md` em `~/.claude/skills/bias-risk-triage`; o Claude a carrega quando um pedido combina com a descrição dela.

## Where it sits in the pipeline
Antes de respostas factuais curtas, em qualquer conversa.

## Who receives its output
A resposta que vem depois (a profundidade dela).
