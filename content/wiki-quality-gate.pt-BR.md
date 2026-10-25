---
id: wiki-quality-gate
lang: pt-BR
source_hash: dada3d67d078
title: Portão de qualidade do wiki
---

## What it is
O portão de qualidade é a definição única de "aprovado" do wiki, derivada do [[template-quality-gate]]. A CI (integração contínua, as verificações automáticas no GitHub) executa o mesmo script.

## What it does
Executa cinco etapas. (1) Os testes Elixir (`mix test`: verificador, build, desatualização, hook, publicação, portão de login, isca). (2) Os testes Elm (`elm-test`) e um build Elm otimizado. (3) A rastreabilidade de requisitos ([[check-traceability]]), que também falha quando o `docs/TRACEABILITY.md` regenerado difere do versionado. (4) `wiki check` sobre o conteúdo real, depois de comparar o arquivo de padrões de privacidade `server/priv/privacy-patterns.tsv` com a cópia do workflow-memory (no notebook). (5) Verificações de aptidão, limites que mantêm o projeto saudável: os limites de `pipeline-check.toml`, medidos pelo [[pipeline-check]] (a regra de arquitetura, shellcheck nos scripts, nenhum arquivo-fonte com mais de 800 linhas, o portão abaixo de 1200 segundos) e o pacote otimizado do app com no máximo 200.000 bytes comprimidos.

## How it does it
É um script [Bash](https://www.gnu.org/software/bash/). No GitHub executa `wiki check` sem `--local`, porque os outros repositórios privados não são visíveis lá.

## Where it sits in the pipeline
Antes de publicar mudanças de código e a cada push.

## Who receives its output
O [[github]] (o resultado da CI).
