---
id: wiki-map-view
lang: pt-BR
source_hash: 939e487ec841
title: Mapa e caixas de informação
aliases: [mapa do sistema]
---

## What it is
O mapa da tela inicial: cada página como um ponto colorido pelo tipo, linhas para alimenta (setas) e menciona (tracejadas), e as quatro caixas embaixo.

## What it does
Passar o mouse num ponto acende ele e os vizinhos em dourado e apaga o resto; as caixas mostram O que é, O que faz, Alimentado por e Quem recebe o que produz (e guardam o último ponto quando o mouse sai). Clicar no ponto abre o artigo. Arrastar move, rodinha ou pinça dá zoom; o filtro de projeto e a linha do tempo escondem o que não pertence.

## How it does it
As posições são calculadas uma vez com uma simulação de forças (elm-visualization): páginas ligadas se atraem, todas se repelem, os projetos começam agrupados. Os filtros são funções puras (`Filter.visible`). Zoom e arrasto vêm do `Zoom` do elm-visualization; o SVG declara uma viewBox do tamanho dele e começa no canto superior esquerdo da janela (a barra de busca flutua por cima), então a rodinha, o arrastar e a pinça com dois dedos fazem zoom em volta do ponteiro.

## Where it sits in the pipeline
Dentro do [[wiki-frontend]], em `/`.

## Who receives its output
O [[wiki-frontend]] (e por ele o Giovanni).
