---
id: new-project
lang: pt-BR
source_hash: ceeed30e6773
title: Começando um novo projeto (caminho dourado)
---

## What it is
Esta página lista os passos que todo novo projeto de software do Giovanni segue, para que comece com testes, portão de qualidade, verificações automáticas e decisões registradas, em vez de acrescentá-los depois.

## What it does
Transforma uma ideia aprovada em um repositório privado que já tem as práticas do [[project-template]] no lugar.

## How it does it
Primeiro vem o design (com a skill de brainstorming), o Giovanni escolhe a linguagem de programação, e então o modelo é copiado e preenchido.

## Where it sits in the pipeline
Antes da primeira linha de código de qualquer novo projeto. O [[wiki]] foi construído assim em 2026-10-22.

## Who receives its output
Um novo repositório de projeto no [[github]].

## Steps
1. Fazer brainstorming do que se quer e dimensionar ([[skill-brainstorming]]); um projeto recebe um documento de design escrito que o Giovanni aprova.
2. O Giovanni escolhe a(s) linguagem(ns) de programação ([[work-ask-language]]).
3. `cp -r ~/dev/project-template ~/dev/NewProject`, depois um `git init -b main` novo ([[project-template]]).
4. Preencher o CLAUDE.md, a seção 1 do DESIGN.md, os primeiros requisitos e seus testes, os passos do portão ([[template-quality-gate]]), os limites em `pipeline-check.toml` ([[fitness-check]]) e a ADR-0002 da tecnologia (uma ADR é um architecture decision record, uma nota curta que registra uma decisão e seus motivos).
5. Criar o repositório privado no GitHub, fazer push, conferir que a primeira execução de CI (integração contínua: verificações automáticas) está verde, criar os rótulos `debt idea P1 P2 P3` ([[github]]) e ativar a verificação local antes do push com `git config core.hooksPath tools/hooks` ([[maintenance-pipeline]]).
6. Construir de ponta a ponta e então fazer a verificação de depuração de primeira linha ([[skill-verification-before-completion]]).
7. Acrescentar as páginas do projeto a este wiki ([[end-of-task]]).
