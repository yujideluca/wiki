---
id: project-template
lang: pt-BR
source_hash: 67177b954ef2
title: project-template (caminho padrão)
aliases: [modelo de projeto]
---

## What it is
O ponto de partida de todo projeto de software novo do Giovanni (`~/dev/project-template`, repositório `yujideluca/project-template`), para que o jeito certo de trabalhar seja também o mais rápido. Escolhido na revisão de manutenção e evolução de 22/10/2026.

## What it does
Dá a um projeto novo, desde o primeiro dia: princípios, cada um verificado por algo; um arquivo de desenho com diagramas C4 e registro de decisões; ADRs; uma lista de requisitos com testes marcados ([[check-traceability]]); um portão de qualidade ([[template-quality-gate]]); CI; e a política de dívida técnica e revisão ([[maintenance-policy]]).

## How it does it
Copiado com `cp -r` para uma pasta nova; a primeira sessão preenche o CLAUDE.md, a seção 1 do DESIGN.md, os primeiros requisitos, os passos do portão e o ADR-0002 da escolha de tecnologia, e depois cria o repositório privado no GitHub com seus rótulos ([[new-project]]). Antes de tudo, o Giovanni escolhe a linguagem de programação ([[work-ask-language]]).

## Where it sits in the pipeline
Antes de todo projeto novo; o QuizApp foi a referência de onde ele foi extraído. Este [[wiki]] foi o primeiro projeto criado a partir dele.

## Who receives its output
Projetos novos como o [[wiki]]; soluções melhores encontradas nos projetos voltam para ele na [[monthly-architecture-review]].
