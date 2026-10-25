---
id: wiki
lang: pt-BR
source_hash: d3d738b452f0
title: Wiki (este site)
---

## What it is
Este site é um wiki: uma enciclopédia de todos os projetos, programas, skills e processos dos sistemas do Giovanni, com um mapa que mostra como eles se ligam. Cada assunto tem sua própria página, escrita para que um leitor que não sabe nada sobre o sistema nem sobre sua linguagem técnica consiga acompanhar. Uma palavra nova? Abra o [[glossary]], que explica os termos usados nas páginas. O repositório `yujideluca/wiki` é público (desde 2026-10-25), a pasta é `~/dev/wiki` e o projeto foi iniciado em 2026-10-22 a partir do [[project-template]].

## What it does
Permite ao Giovanni responder uma pergunta de arquitetura com uma busca e no máximo dois cliques: busca com sugestões enquanto digita, passar o mouse sobre um ponto do mapa para ver o que é em quatro caixas, clicar no ponto para a página completa ([[wiki-frontend]]). É mantido em dia automaticamente no fim de cada tarefa ([[end-of-task]]).

## How it does it
O conteúdo são arquivos de texto Markdown, cada um com um pequeno cabeçalho ([[wiki-content]]); são verificados pelo [[wiki-check]] e transformados em dados JSON (JavaScript Object Notation) pelo [[wiki-build]]. A parte que se vê é escrita em Elm ([[wiki-frontend]]); o servidor é escrito em Elixir ([[wiki-server]]) e deixa entrar só uma conta Google, mostrando uma isca a todos os outros ([[wiki-router]], [[decoy-page]]). Na internet é alcançado pelo [[tailscale-funnel]]. Os idiomas são inglês, alemão e português do Brasil.

## Where it sits in the pipeline
Ao lado do [[workflow-memory]]: a memória guarda regras e preferências, enquanto o wiki descreve o que existe e como funciona, e aponta para entradas da memória em vez de copiá-las.

## Who receives its output
O [[giovanni]], no navegador do notebook ou do celular.
