---
id: mem-pendency
lang: pt-BR
source_hash: 233324a439b0
title: Itens em aberto: regras (pendency.py)
---

## What it is
As regras dos itens em aberto ([[mem-task]]): um fluxo de memória próprio, com orçamento próprio.

## What it does
Nada caduca: um item aparece em toda conversa até ser resolvido, estacionado ou apagado. Por padrão aparece em todo lugar; só quando o Giovanni diz um item ou categoria passa a depender do projeto (`mem scope project:X`). Orçamento de 2.000 tokens, separado do resumo; um item tem no máximo 500 caracteres; os mais recentemente ativos primeiro.

## How it does it
O início da sessão sempre explica como registrar, resolver, estacionar, apagar e definir escopo; quando há itens, acrescenta a regra de verificação (rodar a verificação antes de lembrar; se não vale mais, fechar; se não deu para verificar, dizer "não verificado"). Nasceu depois que, em 20/10/2026, um item foi dado como aberto pela lembrança da conversa, embora já estivesse resolvido.

## Where it sits in the pipeline
Parte do resumo montado pelo [[hook-session-start]].

## Who receives its output
O [[session-brief]].
