---
id: mem-validator
lang: pt-BR
source_hash: e0ef67fa38e3
title: Validador e quarentena (validate.py)
aliases: [verificação de privacidade]
---

## What it is
O guarda de privacidade e formato da memória, seja quem for que escreve.

## What it does
Rejeita tokens e chaves, e-mails, telefones, CPFs e eventos malformados. Arquivos rejeitados vão para `quarantine/` com uma nota `.reason` e aparecem no REVIEW. De propósito não há filtro de vocabulário de saúde (decisão do Giovanni, 19/10/2026); não guardar dados clínicos de outras pessoas é uma regra permanente, não uma verificação automática.

## How it does it
`check_event` para cada evento; `load_checked` separa válidos de inválidos; `quarantine` move os ruins. Testado por `test_privacy_boundary`.

## Where it sits in the pipeline
Antes de toda gravação pelo [[mem]] e, no GitHub, na [[mem-action]].

## Who receives its output
O [[memory-fold]] (só eventos válidos) e as [[memory-views]] (o REVIEW lista a quarentena).
