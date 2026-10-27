---
id: drachenkurve
lang: pt-BR
source_hash: b2557e7d3f94
title: drachenkurve (curva do dragão)
---

## What it is
Uma curva do dragão é um [fractal](https://en.wikipedia.org/wiki/Fractal): uma forma obtida dobrando uma tira de papel ao meio várias vezes e desdobrando-a (o dragão de Heighway, veja [curva do dragão](https://en.wikipedia.org/wiki/Dragon_curve)). `drachenkurve` ("curva do dragão" em alemão) é um sketch do [Processing](https://processing.org/) (Processing é um ambiente de programação para desenho e arte, baseado em Java) que a desenha, exportado como aplicação independente.

## Architecture
### Contexto
person g: Giovanni — desenha e executa o sketch | [[giovanni]]
system d: drachenkurve — um sketch que desenha a curva do dragão
external p: Processing — a ferramenta que executa um sketch
external q: QuizApp — o ícone de abertura veio deste sketch | [[quizapp]]

g -executa o-> d
d -roda dentro do-> p
d -desenhou o ícone de abertura do-> q

### Contêineres
person g: Giovanni | [[giovanni]]
container pd: drachenkurve.pde — o código que dobra a tira e a desenha
store bd: build/ — o aplicativo independente exportado
store ic: Ícone gerado — do rosa ao vermelho sobre fundo escuro
external q: QuizApp | [[quizapp-app]]

g -executa o-> pd
pd -exporta o-> bd
pd -gera o-> ic
ic -virou o ícone de abertura do-> q

## What it does
Gerou o ícone de lançamento do [[quizapp]] (versão 2.1): uma curva do dragão indo do rosa pastel ao vermelho sobre fundo escuro.

## How it does it
O código está no arquivo `drachenkurve.pde` e há uma pasta `build/` exportada.

## Where it sits in the pipeline
Sua única saída foi para os recursos de ícone do [[quizapp-app]].

## Who receives its output
O [[quizapp-app]] (o ícone).
