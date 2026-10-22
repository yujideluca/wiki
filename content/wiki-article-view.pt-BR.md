---
id: wiki-article-view
lang: pt-BR
source_hash: 14654ceacdd4
title: Página de artigo
aliases: [caixa de informações, faixa do fluxo]
---

## What it is
A página completa de um conceito, no estilo da Wikipédia (opção A dos protótipos).

## What it does
Título e tipo, o parágrafo de abertura, uma caixa de informações (tipo, projeto, status, local, desde/até, fontes, entradas de memória) com a faixa do fluxo (o que alimenta → ele → quem recebe o que produz) e um pequeno mapa das páginas ligadas, depois as seções com títulos traduzidos e o histórico da página no git. Páginas de processo ganham um diagrama passo a passo: pontos numerados, o passo atual aceso, seu texto e as páginas envolvidas, com Anterior/Próximo.

## How it does it
Markdown desenhado com o elm-markdown depois que os links `[[id]]` viram `/p/<id>` (MP-3). Mostra um aviso quando a página ainda não tem tradução ou pode estar desatualizada.

## Where it sits in the pipeline
Dentro do [[wiki-frontend]], em `/p/<id>`.

## Who receives its output
O [[wiki-frontend]].
