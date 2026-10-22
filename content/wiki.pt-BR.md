---
id: wiki
lang: pt-BR
source_hash: 7b48652c48e1
title: Wiki (este site)
---

## What it is
Este site: um wiki de todos os projetos, programas, skills e processos dos sistemas do Giovanni, com um mapa no estilo de Dark mostrando como se ligam. Repositório `yujideluca/wiki` (privado), pasta `~/dev/wiki`. Criado em 22/10/2026 a partir do [[project-template]].

## What it does
Permite ao Giovanni responder uma pergunta de arquitetura com uma busca e no máximo dois cliques: busca com autocompletar, passar o mouse num ponto mostra o que ele é em quatro caixas, clicar abre o artigo completo ([[wiki-frontend]]). Fica atualizado automaticamente no fim de cada tarefa ([[end-of-task]]).

## How it does it
O conteúdo são arquivos Markdown com cabeçalho ([[wiki-content]]), verificados pelo [[wiki-check]] e transformados em JSON pelo [[wiki-build]]. O front-end é escrito em Elm ([[wiki-frontend]]); o back-end em Elixir ([[wiki-server]]), com login Google para uma única conta e uma isca para todos os outros ([[wiki-router]], [[decoy-page]]). Fica acessível na web pelo [[tailscale-funnel]]. Idiomas: inglês, alemão e português do Brasil.

## Where it sits in the pipeline
Ao lado do [[workflow-memory]]: a memória guarda regras e preferências; o wiki descreve o que existe e como funciona, e aponta para as entradas de memória em vez de copiá-las.

## Who receives its output
O [[giovanni]], no navegador do notebook ou do celular.
