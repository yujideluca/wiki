---
id: drachenfraktal
lang: pt-BR
source_hash: 39fc739e41ef
title: drachenfraktal (fractal do dragão)
---

## What it is
`drachenfraktal` ("fractal do dragão" em alemão) é um segundo sketch do [Processing](https://processing.org/) (Processing é um ambiente de programação para desenho e arte, baseado em Java) do fractal do dragão, com uma imagem renderizada `drachenfraktal.png`.

## Architecture
### Contexto
person g: Giovanni — desenha e executa o sketch | [[giovanni]]
system d: drachenfraktal — um sketch que desenha o fractal do dragão
external p: Processing — a ferramenta que executa um sketch
external k: drachenkurve — a outra versão da mesma forma | [[drachenkurve]]

g -executa o-> d
d -roda dentro do-> p
d -é uma versão da mesma forma que o-> k

### Contêineres
person g: Giovanni | [[giovanni]]
container pd: drachenfraktal.pde — o código que desenha o dragão de Heighway
store pn: drachenfraktal.png — a imagem gerada

g -executa o-> pd
pd -gera a-> pn

## What it does
Desenha o dragão de Heighway como uma imagem [fractal](https://en.wikipedia.org/wiki/Fractal); é uma versão anterior ou alternativa da [[drachenkurve]].

## How it does it
O código está no arquivo `drachenfraktal.pde`.

## Where it sits in the pipeline
Dentro de [[processing-sketches]]; nada mais o usa.

## Who receives its output
Nenhuma outra parte do sistema.
