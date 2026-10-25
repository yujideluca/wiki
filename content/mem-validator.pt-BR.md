---
id: mem-validator
lang: pt-BR
source_hash: cef217f52476
title: Validador e quarentena (validate.py)
---

## What it is
O validador é o guarda de privacidade e de formato da memória, seja quem for o escritor. Seus padrões para segredos, telefones e números de CPF (Cadastro de Pessoas Físicas, o número brasileiro de contribuinte) ficam em `mem/privacy-patterns.tsv`, a lista única que a verificação de privacidade do próprio wiki ([[wiki-check]]) também usa.

## What it does
Rejeita tokens e chaves, endereços de e-mail, telefones, números de CPF e eventos malformados. Um arquivo rejeitado é movido para a pasta `quarantine/` com uma nota `.reason` e aparece no arquivo de revisão. Não há, de propósito, filtro de vocabulário de saúde (decisão do Giovanni de 2026-10-19); não guardar dados clínicos de outras pessoas é uma regra permanente que o Claude segue, não uma verificação automática.

## How it does it
A função `check_event` examina um evento, `load_checked` separa os válidos dos inválidos e `quarantine` move os ruins. É testado por `test_privacy_boundary` e pelos testes de caça a erros em `tests/test_bughunt.py`; os padrões de token incluem tokens granulares do GitHub, tokens do GitLab e chaves de API (interface de programação de aplicações) do Google, e telefones também são detectados na forma internacional.

## Where it sits in the pipeline
Antes de toda escrita feita pelo [[mem]] e, no GitHub, no [[mem-action]].

## Who receives its output
O [[memory-fold]] (só eventos válidos) e o [[memory-views]] (o arquivo de revisão lista o que foi para a quarentena).
