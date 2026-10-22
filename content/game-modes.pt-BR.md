---
id: game-modes
lang: pt-BR
source_hash: 8b7c4446aa4e
title: Os cinco modos de jogo
aliases: [modos]
---

## What it is
As cinco formas como o [[quizapp]] e o [[quizweb]] testam alemão B2, todas sobre um conjunto fixo do que todo falante B2 deve saber.

## What it does
Der · Die · Das (artigo de 484 substantivos), Präpositionen (309 frases com a preposição faltando), Pluralformen (plural dos mesmos substantivos), Präteritum (forma er/sie/es de 253 verbos), Fehler finden (tocar no único pedaço errado de 121 frases de post de fórum ou e-mail formal, construídas a partir de erros que o Giovanni cometeu em simulados B2 corrigidos).

## How it does it
Cada modo é um valor `GameMode` com um id de armazenamento; todos produzem o mesmo formato de `Card` pelo [[card-factory]], então um modo novo é um acréscimo pequeno. Só o Fehler finden espera um toque em Próxima (`autoAdvances = false`).

## Where it sits in the pipeline
O menu da tela inicial; decidem quais arquivos de conteúdo alimentam o [[card-factory]].

## Who receives its output
O [[card-factory]].
