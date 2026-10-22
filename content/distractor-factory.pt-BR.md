---
id: distractor-factory
lang: pt-BR
source_hash: c0cc2484b2db
title: DistractorFactory
aliases: [distratores, opções erradas]
---

## What it is
Cria as opções erradas de cada pergunta: plausíveis, mas nunca corretas por acidente.

## What it does
Preposições: tiradas de preposições comuns, sem a resposta e sem o que também vale. Plurais: de padrões de plural do alemão (-e, -en, -er, trema), com -n só depois de -e e -s só depois de vogal, para falsos como “Tischn” nunca aparecerem. Präteritum: a forma fraca regularizada, o Partizip II, o Präsens e o infinitivo.

## How it does it
Gerado a partir de uma semente da própria entrada, então uma carta sempre mostra as mesmas opções (testes e relatos de erro reproduzíveis).

## Where it sits in the pipeline
Dentro do fluxo de conteúdo, chamado pelo [[card-factory]].

## Who receives its output
O [[card-factory]].
