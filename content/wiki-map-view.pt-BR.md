---
id: wiki-map-view
lang: pt-BR
source_hash: a84260504f93
title: Vista do mapa e caixas de informação
---

## What it is
O mapa é a tela inicial do wiki: cada página é um ponto colorido conforme seu tipo, com linhas para a relação "alimenta" (setas: o que alimenta o quê) e a relação "menciona" (tracejadas: uma página aponta para outra), e quatro caixas de informação embaixo.

## What it does
Passar o mouse sobre um ponto o ilumina, junto com seus vizinhos, em dourado e escurece o resto; as caixas mostram What it is, What it does, Fed by e Who receives its output (e mantêm o último ponto quando o mouse sai). Clicar em um ponto abre seu artigo. Arrasta-se para mover e usa-se a roda do mouse ou o gesto de pinça com dois dedos para dar zoom; o filtro de projeto e a linha do tempo escondem o que não pertence. O destaque é rápido (cada transição dura 0,07 segundo). Numa janela grande o mapa ocupa toda a altura de que as quatro caixas não precisam, então a página nunca rola ao passar o mouse sobre um ponto; um texto maior que sua caixa rola dentro dela.

## How it does it
As posições são calculadas uma vez com uma simulação de forças ([layout dirigido por forças](https://en.wikipedia.org/wiki/Force-directed_graph_drawing), feito com a biblioteca elm-visualization): páginas ligadas se atraem, todas as páginas se repelem e mantêm um espaço mínimo, os projetos começam em grupos, e uma atração para uma linha horizontal faz a nuvem se assentar larga e achatada. `Layout.matchAspect` a remodela então para a forma da área do mapa (só esticando, no máximo 3 vezes, para que dois pontos nunca se aproximem), de modo que os pontos usem toda a largura. `MapSize` decide as alturas: numa janela larga e alta o bastante, as caixas recebem a altura de que seu texto precisa (cerca de 226 pixels em 1920 pixels de largura) e o mapa recebe o resto; numa janela mais baixa ou estreita o mapa mantém sua parcela de 58 % e as caixas se ajustam sozinhas. Os filtros são funções puras (`Filter.visible`). Zoom e arrastar vêm do módulo `Zoom` do elm-visualization; o SVG (Scalable Vector Graphics, um formato para desenhos feitos de formas) declara um `viewBox` igual ao seu tamanho e começa no canto superior esquerdo da janela (a barra de busca flutua sobre ele), de modo que a roda do mouse, o arrastar e a pinça dão zoom em torno do ponteiro.

## Where it sits in the pipeline
Dentro do [[wiki-frontend]], no endereço `/`.

## Who receives its output
O [[wiki-frontend]] (e, por ele, o Giovanni).
