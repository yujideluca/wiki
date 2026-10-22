---
id: wiki-map-view
lang: pt-BR
source_hash: 97feea1545ea
title: Mapa e caixas de informação
aliases: [mapa do sistema]
---

## What it is
O mapa da tela inicial: cada página como um ponto colorido pelo tipo, linhas para alimenta (setas) e menciona (tracejadas), e as quatro caixas embaixo.

## What it does
Passar o mouse num ponto acende ele e os vizinhos em dourado e apaga o resto; as caixas mostram O que é, O que faz, Alimentado por e Quem recebe o que produz (e guardam o último ponto quando o mouse sai). Clicar no ponto abre o artigo. Arrastar move, rodinha ou pinça dá zoom; o filtro de projeto e a linha do tempo escondem o que não pertence. O destaque é rápido (cada transição dura 0,07 s). Numa janela grande o mapa ocupa toda a altura que as quatro caixas não precisam, então a página nunca rola ao passar o mouse num ponto; um texto maior que a caixa rola dentro dela.

## How it does it
As posições são calculadas uma vez com uma simulação de forças (elm-visualization): páginas ligadas se atraem, todas se repelem e mantêm uma distância mínima, os projetos começam agrupados, e uma atração por uma linha horizontal faz a nuvem se assentar larga e achatada. O `Layout.matchAspect` então a remodela para o formato da área do mapa (só estica, no máximo 3 vezes, então dois pontos nunca ficam mais perto), e os pontos usam toda a largura. O `MapSize` decide as alturas: numa janela larga e alta o bastante, as caixas ganham a altura que o texto precisa (cerca de 226 px com 1920 px de largura) e o mapa fica com o resto; numa janela mais baixa ou mais estreita o mapa mantém os 58 % e as caixas se ajustam ao texto. Os filtros são funções puras (`Filter.visible`). Zoom e arrasto vêm do `Zoom` do elm-visualization; o SVG declara uma viewBox do tamanho dele e começa no canto superior esquerdo da janela (a barra de busca flutua por cima), então a rodinha, o arrastar e a pinça com dois dedos fazem zoom em volta do ponteiro.

## Where it sits in the pipeline
Dentro do [[wiki-frontend]], em `/`.

## Who receives its output
O [[wiki-frontend]] (e por ele o Giovanni).
