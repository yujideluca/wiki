---
id: workflow-memory
lang: pt-BR
source_hash: ad81192bd3bb
title: workflow-memory (memória compartilhada)
aliases: [memória]
---

## What it is
A memória compartilhada e duradoura de todas as instâncias do Claude que o Giovanni usa. Repositório privado `yujideluca/workflow-memory`, pasta `~/dev/workflow-memory`. Substituiu o protocolo aposentado claude-workflow-backup ([[retired-workflow-pipeline]]).

## What it does
Guarda preferências, fatos, decisões e itens em aberto, e mostra os relevantes no início de cada conversa ([[session-brief]]). É a única interface entre as instâncias do Claude (ADR-0003, [[memory-adrs]]).

## How it does it
O registro é a memória: cada entrada é um arquivo novo, nunca editado, no [[events-log]]. O [[memory-fold]] calcula o estado atual (vale a regra mais recente de cada chave). A [[mem-action]] regenera as [[memory-views]] no GitHub. O Claude Code escreve com o [[mem]] e seus hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); o app do Claude escreve pelo [[mem-github-connector]]. Só biblioteca padrão do Python; o [[mem-validator]] barra segredos e dados de contato.

## Where it sits in the pipeline
Por baixo de todos os outros projetos: eles leem dali os padrões e respondem com `mem use`.

## Who receives its output
Todas as instâncias do Claude, pelo resumo; o [[giovanni]], pelas [[memory-views]] (REVIEW.md).
