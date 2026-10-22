---
id: skill-browser-automacao-segura
lang: pt-BR
source_hash: 06b05fc87539
title: Skill: browser-automacao-segura (safe browser automation)
---

## What it is
As regras de segurança para qualquer ação num navegador (o navegador do app ou o Claude in Chrome), principalmente ações em lote, remoções, edições em massa e scripts em páginas. Escrita em português.

## What it does
Evita diálogos que travam a sessão, laços e erros destrutivos; pergunta antes de qualquer coisa irreversível.

## How it does it
Um `SKILL.md` em `~/.claude/skills/browser-automacao-segura`; o Claude a carrega quando um pedido combina com a descrição dela.

## Where it sits in the pipeline
Antes e durante qualquer automação de navegador.

## Who receives its output
A sessão do navegador; a [[skill-click-protocol]] e a [[skill-minimize-site-approvals]] obedecem a ela em alertas e ações destrutivas.
