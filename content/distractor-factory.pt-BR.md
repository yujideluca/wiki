---
id: distractor-factory
lang: pt-BR
source_hash: 910c9f11949d
title: DistractorFactory
---

## What it is
A `DistractorFactory` cria as opções de resposta erradas de cada pergunta. Um "distrator" precisa ser plausível o bastante para fazer o jogador pensar, mas nunca pode ser correto por acidente.

## What it does
Para preposições, sorteia entre as preposições comuns, excluindo a resposta certa e qualquer outra que também caberia. Para plurais, usa padrões alemães de plural (-e, -en, -er, trema), com -n só depois de -e e -s só depois de vogais, para que falsificações como "Tischn" nunca apareçam. Para o Präteritum, oferece a forma fraca regularizada, o particípio (Partizip II), o presente (Präsens) e o infinitivo.

## How it does it
A escolha é "semeada" a partir da entrada (um número inicial fixo para o sorteio), então uma carta sempre mostra as mesmas opções. Isso torna testes e relatos de bug reproduzíveis.

## Where it sits in the pipeline
Dentro do pipeline de conteúdo, chamado pelo [[card-factory]].

## Who receives its output
O [[card-factory]].
