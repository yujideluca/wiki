---
id: wiki-search
lang: pt-BR
source_hash: 92adc83dc419
title: Busca com autocompletar
---

## What it is
É a barra de busca no alto de toda tela e sua lista de sugestões (autocompletar: a lista que aparece enquanto você digita).

## What it does
Enquanto o Giovanni digita, até 8 páginas são sugeridas, a melhor primeiro: nome exato, depois prefixo, depois início de palavra, depois contido em qualquer lugar, depois letras em ordem. Títulos e aliases (outros nomes pelos quais uma página é conhecida) são comparados no idioma escolhido e em inglês, ignorando maiúsculas e acentos. As setas ↑ e ↓ escolhem, Enter centraliza o mapa na página (ou a abre a partir de um artigo) e Esc fecha a lista.

## How it does it
É uma função pura de classificação e é testada (requisito MP-1).

## Where it sits in the pipeline
Na barra superior do [[wiki-frontend]].

## Who receives its output
O [[wiki-frontend]].
