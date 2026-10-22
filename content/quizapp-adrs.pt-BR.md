---
id: quizapp-adrs
lang: pt-BR
source_hash: 235745b75611
title: ADRs do QuizApp
aliases: [registros de decisão de arquitetura]
---

## What it is
Os registros de decisão de arquitetura do [[quizapp]] (`docs/adr/`): um arquivo curto por decisão estrutural, com contexto, decisão, alternativas e consequências.

## What it does
0001 registrar decisões · 0002 Kotlin + Compose · 0003 agendador puro e determinístico · 0004 canal de atualização · 0005 canais de versão · 0006 gêmeo web · 0007 regras de espaçamento · 0008 qualidade começando pelos requisitos · 0009 módulo core puro · 0010 backup do progresso · 0011 promover depois de testes atualizados.

## How it does it
Formato MADR (enxuto), a partir de `docs/adr/0000-template.md`; uma mudança estrutural ganha seu ADR no mesmo commit.

## Where it sits in the pipeline
Ao lado do [[quizapp-design-doc]]; o padrão vem do [[project-template]].

## Who receives its output
O Claude e o Giovanni, quando uma decisão é questionada.
