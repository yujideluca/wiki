---
id: quizapp-adrs
lang: pt-BR
source_hash: 96fc6f7fa125
title: ADRs do QuizApp
---

## What it is
Uma ADR (architecture decision record) é uma nota curta sobre uma decisão importante: o contexto, a decisão, as alternativas consideradas e as consequências. Estas são as ADRs do [[quizapp]], na pasta `docs/adr/`, um arquivo por decisão estrutural.

## What it does
Registram: 0001 registrar decisões · 0002 Kotlin + Compose · 0003 agendador puro e determinístico · 0004 feed de atualização · 0005 canais de lançamento · 0006 gêmeo web · 0007 regras de espaçamento · 0008 garantia de qualidade com requisitos primeiro · 0009 módulo core puro · 0010 backup de progresso · 0011 promover após testes atualizados · 0012 conjunto de perguntas baixável ([[question-pack]]) · 0013 um programa mede e uma skill julga ([[maintenance-pipeline]]).

## How it does it
Usam o formato MADR (Markdown Architectural Decision Records, em forma reduzida), a partir de `docs/adr/0000-template.md`. Uma mudança estrutural recebe sua ADR no mesmo commit da mudança, de modo que o motivo nunca se separa do código.

## Where it sits in the pipeline
Ao lado do [[quizapp-design-doc]]; o padrão vem do [[project-template]].

## Who receives its output
O Claude e o Giovanni, sempre que uma decisão é questionada.
