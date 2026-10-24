---
id: check-traceability
lang: pt-BR
source_hash: 7feb1ba28744
title: pipeline-check --traceability
---

## What it is
Rastreabilidade de requisitos é poder seguir cada promessa de um programa até o teste que a verifica. Esta verificação é compartilhada por todos os projetos: todo requisito tem um teste e toda etiqueta de teste nomeia um requisito real.

## What it does
Lê os ids dos requisitos de `docs/REQUIREMENTS.md`, coleta as etiquetas `REQ <ID>` (comentários como `REQ GR-1`) das pastas de teste e falha se um requisito não tem teste etiquetado ou se uma etiqueta nomeia um requisito inexistente. Escreve `docs/TRACEABILITY.md`, uma tabela que liga cada requisito aos seus arquivos de teste.

## How it does it
É um subcomando do programa [[pipeline-check]] (escrito em Rust, opção `--traceability`, disponível desde a versão v0.3.0). Todo projeto o executa pelo seu próprio script `tools/pipeline-check.sh`, fixado em uma versão; ele substituiu o `check_traceability.py`, que antes era copiado para cada repositório. Cada projeto lista suas pastas de teste, extensões de arquivo e um rótulo opcional em uma seção `[traceability]` do `pipeline-check.toml` (QuizApp: Kotlin e JavaScript, com os testes do gêmeo web rotulados `web`; o wiki: Elixir e Elm).

## Where it sits in the pipeline
Passo 2 de todo portão de qualidade.

## Who receives its output
[[template-quality-gate]], [[quizapp-quality-gate]] e [[wiki-quality-gate]].
