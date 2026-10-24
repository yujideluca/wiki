---
id: wiki-quality-gate
lang: pt-BR
source_hash: 845e5e02101d
title: Portão de qualidade do wiki
---

## What it is
O portão de qualidade é a definição única de "aprovado" do wiki, derivada do [[template-quality-gate]]. A CI (integração contínua, as verificações automáticas no GitHub) executa o mesmo script.

## What it does
Executa: os testes Elixir (`mix test`: verificador, build, hook, publicação, portão de login, isca), os testes Elm (`elm-test`), um build Elm, a rastreabilidade de requisitos ([[check-traceability]]), `wiki check` sobre o conteúdo real e verificações de aptidão (a isca não contém conteúdo real; o app compilado continua pequeno).

## How it does it
É um script [Bash](https://www.gnu.org/software/bash/). No GitHub executa `wiki check` sem `--local`, porque os outros repositórios privados não são visíveis lá.

## Where it sits in the pipeline
Antes de publicar mudanças de código e a cada push.

## Who receives its output
O [[github]] (o resultado da CI).
