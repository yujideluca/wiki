---
id: new-project
lang: pt-BR
source_hash: 5fe0aa8b2e7c
title: Começando um projeto novo (caminho padrão)
aliases: [projeto novo]
---

## What it is
Os passos que todo projeto de software novo do Giovanni segue, para começar com testes, portão, CI e decisões registradas.

## What it does
Transforma uma ideia aprovada num repositório privado com as práticas do modelo já no lugar.

## How it does it
Primeiro o desenho (a skill de brainstorming), linguagem escolhida pelo Giovanni, depois copiar o [[project-template]] e preenchê-lo.

## Where it sits in the pipeline
Antes da primeira linha de código de qualquer projeto novo. O [[wiki]] foi feito assim em 22/10/2026.

## Who receives its output
Um repositório novo no [[github]].

## Steps
1. Entender o que se quer e dimensionar ([[skill-brainstorming]]); um projeto ganha um documento de desenho escrito que o Giovanni aprova.
2. O Giovanni escolhe a(s) linguagem(ns) de programação ([[work-ask-language]]).
3. `cp -r ~/dev/project-template ~/dev/NovoProjeto`, `git init -b main` novo ([[project-template]]).
4. Preencher o CLAUDE.md, a seção 1 do DESIGN.md, os primeiros requisitos com seus testes, os passos do portão ([[template-quality-gate]]) e o ADR-0002 da tecnologia.
5. Criar o repositório privado no GitHub, fazer push, conferir que a primeira CI ficou verde e criar os rótulos `debt idea P1 P2 P3` ([[github]]).
6. Construir de ponta a ponta e fazer a primeira rodada de depuração ([[skill-verification-before-completion]]).
7. Acrescentar as páginas do projeto a este wiki ([[end-of-task]]).
