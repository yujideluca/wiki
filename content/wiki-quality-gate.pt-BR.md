---
id: wiki-quality-gate
lang: pt-BR
source_hash: e96e70cff52d
title: Portão de qualidade do wiki
---

## What it is
A única definição de "passou" do wiki, a partir do [[template-quality-gate]]; a CI roda o mesmo script.

## What it does
Testes Elixir (`mix test`: verificador, build, hook, publicação, portão de login, isca), testes Elm (`elm-test`), um build do Elm, rastreabilidade de requisitos ([[check-traceability]]), `wiki check` no conteúdo real e verificações de aptidão (a isca não contém nada real; o app gerado continua pequeno).

## How it does it
Bash; no GitHub roda `wiki check` sem `--local`, porque os outros repositórios privados não são visíveis lá.

## Where it sits in the pipeline
Antes de publicar mudanças de código e a cada push.

## Who receives its output
O [[github]] (resultado da CI).
