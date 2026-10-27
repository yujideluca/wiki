---
id: wiki-flow-view
lang: pt-BR
source_hash: 5dc3a41d5db9
title: Vista do fluxograma
---

## What it is
A vista do fluxograma transforma a seção `Flow` de uma página num desenho lido de cima para baixo. Um fluxograma é um diagrama de caixas ligadas por setas que mostra a ordem em que as coisas acontecem.

## What it does
Mostra como um conceito grande é iniciado (no alto), o que ele aciona (as caixas do meio, com losangos para perguntas que dividem a cadeia) e o que ele produz (as caixas duplas embaixo). Cada caixa é colorida pelo tipo da primeira página a que se liga, e os nomes de páginas dentro de uma caixa abrem essas páginas. Uma legenda sob o diagrama dá nome às formas. O diagrama tem a largura de que precisa; no celular ele rola para os lados dentro da sua caixa. No servidor, o [[wiki-check]] recusa um fluxo que não pode ser desenhado com sentido: sem caixa inicial ou sem produto final, uma caixa a que nada leva, uma pergunta sem respostas rotuladas, um laço ou um link para uma página que não existe.

## How it does it
O texto tem uma linha por caixa (`trigger`, `step`, `decide` ou `product`, um id, um rótulo e links `| [[page]]`) e uma linha por seta (`a -> b`, ou `d -sim-> b` para uma resposta). Ele é lido duas vezes, por `Wiki.Content.Flow` para as verificações e por `Flow.elm` para o desenho, e ambos são testados no mesmo exemplo. `FlowLayout.layout` põe cada caixa numa linha abaixo da última caixa que leva a ela, acrescenta uma parada invisível em cada linha que uma seta pula, ordena cada linha pelo lugar médio de seus vizinhos (o método do baricentro) e depois fixa as colunas para que caixas ligadas fiquem alinhadas no que o espaçamento permitir (um ajuste por mínimos quadrados chamado regressão isotônica). `FlowView` desenha o resultado em SVG (Scalable Vector Graphics, um formato de imagem feito de formas), com as setas traçadas por `Shape.bumpYCurve` da biblioteca elm-visualization. Nenhum pacote de layout é usado de propósito: essa biblioteca não tem layout de grafo em camadas, e um pacote externo pequeno que pode parar de funcionar foi julgado um risco maior que cerca de 500 linhas de código próprio (ADR-0007; um ADR é um „Architecture Decision Record“, uma nota curta que guarda as razões de uma decisão).

## Where it sits in the pipeline
Dentro do [[wiki-frontend]], chamada pelo [[wiki-article-view]] para a seção `flow`.

## Who receives its output
O [[wiki-article-view]] e, por ele, o leitor.

## Functions
- `Flow.parse`: lê o texto da seção em caixas e setas.
- `FlowLayout.layout`: dá a cada caixa o seu lugar e a cada seta o seu caminho.
- `FlowView.view`: desenha o diagrama e sua legenda.
