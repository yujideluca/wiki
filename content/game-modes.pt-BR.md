---
id: game-modes
lang: pt-BR
source_hash: 0ccc7c1e2438
title: Os cinco modos de jogo
---

## What it is
São as cinco formas como o [[quizapp]] e o [[quizweb]] testam alemão de nível B2. Todas usam um conjunto selecionado do que todo falante B2 deveria saber; o conjunto pode crescer sem atualizar o app ([[question-pack]]), e os números abaixo são os do conjunto embutido no app (versão de conteúdo 1). Um "modo de jogo" é um tipo de pergunta.

## What it does
- **Der · Die · Das**: escolher o artigo (a palavra alemã para "o/a", que depende do gênero do substantivo) de 484 substantivos.
- **Präpositionen** (preposições): completar a preposição que falta em 309 frases.
- **Pluralformen** (formas de plural): dar o plural dos mesmos substantivos.
- **Präteritum** (passado simples): dar a forma er/sie/es ("ele/ela") de 253 verbos.
- **Fehler finden** (achar o erro): tocar na única parte errada de 121 frases no estilo de postagens de fórum ou e-mails formais, construídas a partir dos erros que o Giovanni cometeu em simulados B2 corrigidos.

## How it does it
Cada modo é um valor `GameMode` com um id de armazenamento. Todos produzem a mesma forma `Card` pelo [[card-factory]], então acrescentar um modo é uma mudança pequena. Só o Fehler finden espera um toque em "Próximo" (`autoAdvances = false`); os outros avançam sozinhos depois do feedback.

## Where it sits in the pipeline
O menu da tela inicial. O modo escolhido decide quais arquivos de conteúdo alimentam o [[card-factory]].

## Who receives its output
O [[card-factory]].
