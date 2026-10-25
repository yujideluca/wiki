---
id: wiki-frontend
lang: pt-BR
source_hash: 42b65074e2e3
title: Front end do wiki (Elm)
---

## What it is
O front end é a parte do wiki que se vê e clica. É escrito em [Elm](https://elm-lang.org/) (escolha do Giovanni), uma linguagem para páginas web que se recusa a compilar muitos tipos de erro, de modo que os erros são pegos antes de a página rodar.

## What it does
A tela inicial é o mapa do sistema ([[wiki-map-view]]) com busca e sugestões ([[wiki-search]]), um filtro de projeto, um controle de linha do tempo e uma legenda dos tipos. Passar o mouse sobre um ponto preenche quatro caixas com sua descrição; clicar em um ponto abre seu artigo ([[wiki-article-view]]). Um link "Glossário" na barra superior leva à página do glossário, e links para outros sites abrem em uma nova aba. A interface fica em inglês, alemão ou português do Brasil, lembrada no navegador. No celular (uma janela de até 760 pixels de largura) o mapa ocupa a tela inteira com uma barra de busca em forma de pílula no alto, tocar em um ponto abre um balão, e as páginas de artigo seguem o layout do Wikipédia móvel; no desktop o mapa é visto por uma lente e seus pontos são elásticos (ambos descritos em [[wiki-map-view]] e [[wiki-article-view]]).

## How it does it
É uma `Browser.application` (um programa Elm que controla a página inteira e seu endereço) com as rotas `/` e `/p/<id>`. Carrega `data/graph.json` uma vez e cada artigo no idioma escolhido sob demanda; o idioma é guardado no localStorage (o pequeno armazenamento chave-valor do navegador) por meio de uma porta (a passagem controlada do Elm para o JavaScript, em `boot.js`). O mapa é escuro e cinematográfico (inspirado em visualizações "Dark explorer") e os artigos são claros com letra serifada, como a Wikipédia. O código é dividido em módulos: `Main` (estado e mensagens), `TopBar` (a barra superior e o campo de busca, em uma forma de desktop e uma de celular), `MapView`, `MapSize`, `Layout`, `Filter`, `MapCamera` (encaixar o mapa na janela, centralizar em um ponto, a lente, os pontos de partida das molas), `Touch` (um dedo move, dois dedos dão zoom), `Lens` (o olho de peixe) e `Motion` (o movimento elástico), `ArticleView`, `WikiText`, `Search`, `I18n` e `Data`. O `index.html` marca a página como não traduzível, porque a tradução própria do Chrome cobriria a barra de busca e reescreveria o texto que o app controla. É testado com elm-test (requisitos MP-1 a MP-9, LG-2, MB-1 a MB-8, LN-1 a LN-4, DY-1 a DY-6, LY-1 e TC-1 a TC-3).

## Where it sits in the pipeline
O topo do wiki, servido pelo [[wiki-router]] depois do login.

## Who receives its output
O [[giovanni]], no notebook ou no celular.
