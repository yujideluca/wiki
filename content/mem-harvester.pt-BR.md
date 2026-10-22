---
id: mem-harvester
lang: pt-BR
source_hash: 70527e6145e4
title: Coletor de preferências (harvest.py)
aliases: [coletor]
---

## What it is
Recolhe preferências das palavras do próprio Giovanni nas mensagens, para uma regra dita uma vez não se perder.

## What it does
Só conta o texto da mensagem do usuário (nunca saída de ferramenta nem texto do Claude), em inglês e português, só frases que estabelecem uma regra e citam uma ação. O escopo padrão é o projeto; um hábito visto em dois projetos, ou dito "em todos os meus projetos", vira global (`promote`).

## How it does it
Ids de evento determinísticos, então uma chamada repetida do hook grava o mesmo arquivo. Uma entrada coletada nunca sobrescreve uma com `owner: user`; vira uma proposta no REVIEW.

## Where it sits in the pipeline
Chamado pelo [[hook-prompt]] a cada mensagem que o Giovanni manda ao Claude Code.

## Who receives its output
O [[events-log]].
