---
id: wiki
lang: pt-BR
source_hash: e26a9ade6c4e
title: Wiki (este site)
---

## What it is
Este site é um wiki: uma enciclopédia de todos os projetos, programas, skills e processos dos sistemas do Giovanni, com um mapa que mostra como eles se ligam. Cada assunto tem sua própria página, escrita para que um leitor que não sabe nada sobre o sistema nem sobre sua linguagem técnica consiga acompanhar. Uma palavra nova? Abra o [[glossary]], que explica os termos usados nas páginas. O repositório `yujideluca/wiki` é público (desde 2026-10-25), a pasta é `~/dev/wiki` e o projeto foi iniciado em 2026-10-22 a partir do [[project-template]].

## Flow
trigger t1: O Claude termina uma tarefa que mudou um sistema | [[end-of-task]]
step s1: Escreve páginas em Markdown, cada uma com um pequeno cabeçalho | [[wiki-content]]
step s2: wiki check aplica as regras de conteúdo | [[wiki-check]]
decide d1: As regras passam?
step s3: wiki build transforma as páginas em dados | [[wiki-build]]
step s4: Só content/ é commitado e enviado | [[github]]
step s5: O servidor serve o site: a conta Google do Giovanni entra, os demais veem uma isca | [[wiki-router]], [[decoy-page]]
trigger t2: Giovanni abre a wiki | [[giovanni]]
step s6: Busca, passa o mouse no mapa, clica num ponto | [[wiki-frontend]]
product p1: Publicação recusada, com a lista dos problemas
product p2: Uma página que responde à dúvida de arquitetura

t1 -> s1
s1 -> s2
s2 -> d1
d1 -não-> p1
d1 -sim-> s3
s3 -> s4
s4 -> s5
t2 -> s5
s5 -> s6
s6 -> p2

## What it does
Permite ao Giovanni responder uma pergunta de arquitetura com uma busca e no máximo dois cliques: busca com sugestões enquanto digita, passar o mouse sobre um ponto do mapa para ver o que é em quatro caixas, clicar no ponto para a página completa ([[wiki-frontend]]). No celular o mapa ocupa a tela com uma barra de busca no alto e tocar em um ponto abre um balão com sua descrição; no desktop o mapa é visto por uma lente e seus pontos se esticam elasticamente quando arrastados ([[wiki-map-view]]). É mantido em dia automaticamente no fim de cada tarefa ([[end-of-task]]). Para o sistema inteiro numa página, comece por [[system-overview]].

## How it does it
O conteúdo são arquivos de texto Markdown, cada um com um pequeno cabeçalho ([[wiki-content]]); são verificados pelo [[wiki-check]] e transformados em dados JSON (JavaScript Object Notation) pelo [[wiki-build]]. A parte que se vê é escrita em Elm ([[wiki-frontend]]); o servidor é escrito em Elixir ([[wiki-server]]) e deixa entrar só uma conta Google, mostrando uma isca a todos os outros ([[wiki-router]], [[decoy-page]]). Na internet é alcançado pelo [[tailscale-funnel]]. Os idiomas são inglês, alemão e português do Brasil.

## Where it sits in the pipeline
Ao lado do [[workflow-memory]]: a memória guarda regras e preferências, enquanto o wiki descreve o que existe e como funciona, e aponta para entradas da memória em vez de copiá-las.

## Who receives its output
O [[giovanni]], no navegador do notebook ou do celular.
