---
id: wiki-frontend
lang: pt-BR
source_hash: 5f9a770d29aa
title: Front end do wiki (Elm)
---

## What it is
O front end é a parte do wiki que se vê e clica. É escrito em [Elm](https://elm-lang.org/) (escolha do Giovanni), uma linguagem para páginas web que se recusa a compilar muitos tipos de erro, de modo que os erros são pegos antes de a página rodar.

## What it does
A tela inicial é o mapa do sistema ([[wiki-map-view]]) com busca e sugestões ([[wiki-search]]), um filtro de projeto, um controle de linha do tempo e uma legenda dos tipos. Passar o mouse sobre um ponto preenche quatro caixas com sua descrição; clicar em um ponto abre seu artigo ([[wiki-article-view]]). Um link "Glossário" na barra superior leva à página do glossário, e links para outros sites abrem em uma nova aba. A interface fica em inglês, alemão ou português do Brasil, lembrada no navegador.

## How it does it
É uma `Browser.application` (um programa Elm que controla a página inteira e seu endereço) com as rotas `/` e `/p/<id>`. Carrega `data/graph.json` uma vez e cada artigo no idioma escolhido sob demanda; o idioma é guardado no localStorage (o pequeno armazenamento chave-valor do navegador) por meio de uma porta (a passagem controlada do Elm para o JavaScript, em `boot.js`). O mapa é escuro e cinematográfico (inspirado em visualizações "Dark explorer") e os artigos são claros com letra serifada, como a Wikipédia. É testado com elm-test (requisitos MP-1 a MP-9 e LG-2).

## Where it sits in the pipeline
O topo do wiki, servido pelo [[wiki-router]] depois do login.

## Who receives its output
O [[giovanni]], no notebook ou no celular.
