---
id: wiki-article-view
lang: pt-BR
source_hash: b1f8a6299d38
title: Vista do artigo
---

## What it is
A vista do artigo é a página completa de um conceito, organizada como a Wikipédia (opção A dos esboços de design).

## What it does
Mostra o título e o tipo, o parágrafo de abertura, uma caixa de informações (tipo, projeto, status, local, datas desde e até, fontes, entradas de memória) com a faixa do pipeline (o que o alimenta → ele → quem recebe sua saída) e um pequeno mapa das páginas ligadas, depois as seções com títulos traduzidos e o histórico da página vindo do git. Uma página de processo (uma com seção Steps, como uma skill ou um procedimento) recebe também um diagrama passo a passo: pontos numerados, o passo atual aceso, seu texto e as páginas envolvidas, com botões Anterior e Próximo.

## How it does it
O texto Markdown é renderizado com elm-markdown depois que os links `[[id]]` são reescritos para `/p/<id>` (requisito MP-3); links para outros sites abrem em uma nova aba (MP-8). Mostra um aviso quando uma página ainda não tem tradução ou pode estar desatualizada.

## Where it sits in the pipeline
Dentro do [[wiki-frontend]], em `/p/<id>`.

## Who receives its output
O [[wiki-frontend]].
