---
id: wiki-map-view
lang: pt-BR
source_hash: 1762ebcb0383
title: Mapa e caixas de informação
aliases: [mapa do sistema]
---

## What it is
O mapa da tela inicial: cada página como um ponto colorido pelo tipo, linhas para alimenta (setas) e menciona (tracejadas), e as quatro caixas embaixo.

## What it does
Passar o mouse num ponto acende ele e os vizinhos em dourado e apaga o resto; as caixas mostram O que é, O que faz, Alimentado por e Quem recebe o que produz (e guardam o último ponto quando o mouse sai). Clicar no ponto abre o artigo. Arrastar move, rodinha ou pinça dá zoom; o filtro de projeto e a linha do tempo escondem o que não pertence.

## How it does it
As posições são calculadas uma vez com uma simulação de forças (elm-visualization): páginas ligadas se atraem, todas se repelem, os projetos começam agrupados. Os filtros são funções puras (`Filter.visible`).

## Where it sits in the pipeline
Dentro do [[wiki-frontend]], em `/`.

## Who receives its output
O [[wiki-frontend]] (e por ele o Giovanni).
