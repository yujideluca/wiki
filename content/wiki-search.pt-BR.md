---
id: wiki-search
lang: pt-BR
source_hash: 85c137f5c4e6
title: Busca com autocompletar
aliases: [autocompletar]
---

## What it is
A barra de busca no topo de todas as telas e sua lista de sugestões.

## What it does
Enquanto o Giovanni digita, até 8 páginas são sugeridas, a melhor primeiro: nome exato, depois começo, depois começo de palavra, depois contido em qualquer lugar, depois letras na ordem. Títulos e apelidos são comparados no idioma escolhido e em inglês, sem diferenciar maiúsculas e acentos. ↑↓ escolhem, Enter centraliza o mapa na página (ou abre a página, quando se está num artigo), Esc fecha.

## How it does it
Uma função pura de ordenação, testada (MP-1).

## Where it sits in the pipeline
Na barra de cima do [[wiki-frontend]].

## Who receives its output
O [[wiki-frontend]].
