---
id: decoy-page
lang: pt-BR
source_hash: fe345081af28
title: Página isca (decoy)
---

## What it is
Uma isca (decoy) é algo que parece real mas esconde o real. A página isca é o que qualquer pessoa não autenticada vê ao abrir o endereço do wiki: um grafo animado e psicodélico de palavras inventadas e um botão "Entrar com o Google" (design do Giovanni). Serve para que um estranho que descubra o endereço não fique sabendo nada do que o wiki contém.

## What it does
Mostra nós brilhantes que mudam de cor, vagam, se ligam e reagem ao mouse, rotulados com palavras sem sentido geradas aleatoriamente no próprio navegador do visitante. Nada real está na página.

## How it does it
É um único arquivo [HTML](https://en.wikipedia.org/wiki/HTML) autossuficiente (HyperText Markup Language, a linguagem das páginas web) com JavaScript embutido que desenha em um canvas: nenhum arquivo externo e nenhuma requisição de rede. Testes verificam que não carrega nada de fora, não faz requisições e não contém nenhum título de página do conteúdo (requisito DC-1). Respeita a configuração "reduzir movimento" do navegador.

## Where it sits in the pipeline
Devolvida pelo [[wiki-router]] para toda requisição de página sem sessão válida.

## Who receives its output
Visitantes sem sessão (e o Giovanni, antes de entrar).
