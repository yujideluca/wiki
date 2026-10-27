---
id: wiki-article-view
lang: pt-BR
source_hash: 5264a59f305e
title: Vista do artigo
---

## What it is
A vista do artigo é a página completa de um conceito, organizada como a Wikipédia (opção A dos esboços de design).

## What it does
Mostra o título e o tipo, o parágrafo de abertura, uma caixa de informações (tipo, projeto, status, local, datas desde e até, fontes, entradas de memória) com a faixa do pipeline (o que o alimenta → ele → quem recebe sua saída) e uma lista alfabética das páginas ligadas com títulos completos como links, marcadores coloridos e rótulos de tipo. Títulos longos quebram em mais de uma linha, depois as seções com títulos traduzidos e o histórico da página vindo do git. Uma página de processo (uma com seção Steps, como uma skill ou um procedimento) recebe também um diagrama passo a passo: pontos numerados, o passo atual aceso, seu texto e as páginas envolvidas, com botões Anterior e Próximo.

O anel ao redor do passo aceso (seu brilho e seu leve crescimento) fica inteiro graças ao espaçamento em volta da fileira de pontos.

Em um celular (janela de até 760 pixels de largura) a página segue o layout do Wikipédia móvel: no alto uma barra com seta de volta ao mapa, botão de menu e campo de busca; depois título, parágrafo de abertura e infobox em uma coluna; cada outra seção começa fechada e abre ao tocar no título. Uma página com uma seção Flow a mostra como fluxograma sob o parágrafo de abertura: uma pílula para o que inicia a cadeia, caixas para os passos, um losango para uma pergunta e uma caixa dupla para um produto final, coloridos pelo tipo da página a que se ligam, com uma legenda embaixo ([[wiki-flow-view]]).

## How it does it
O texto Markdown é renderizado com elm-markdown depois que os links `[[id]]` são reescritos para `/p/<id>` (requisito MP-3); links para outros sites abrem em uma nova aba (MP-8). Mostra um aviso quando uma página ainda não tem tradução ou pode estar desatualizada.

## Where it sits in the pipeline
Dentro do [[wiki-frontend]], em `/p/<id>`.

## Who receives its output
O [[wiki-frontend]].

## Notes

Nas páginas de skills, a seção Steps exibe apenas a caixa estilizada de passos interativos. A lista de texto repetida abaixo dela é omitida. Anterior e Próximo continuam mostrando cada passo numerado, e os arquivos originais completos das skills permanecem em Notes. Isso vale no desktop e nas seções abertas no celular, nos três idiomas. Outros tipos de página mantêm a apresentação existente.
