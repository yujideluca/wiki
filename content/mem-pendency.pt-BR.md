---
id: mem-pendency
lang: pt-BR
source_hash: c56b96c7a701
title: Pendências: regras (pendency.py)
---

## What it is
São as regras das "pendências" (open items; veja [[mem-task]]): metas inacabadas e problemas conhecidos que são mantidos diante do Giovanni. Formam um fluxo próprio dentro da memória, com orçamento de tamanho próprio, para que uma enxurrada de preferências antigas nunca expulse uma pendência. O código está em `mem/pendency.py`.

## What it does
Nada expira: um item aparece em toda conversa até ser resolvido, guardado ou apagado. Por padrão aparece em todos os projetos; só quando o Giovanni diz é que um item ou categoria passa a valer para um projeto (`mem scope project:X`). O orçamento é de 2.000 tokens (um token é um pedacinho de texto, cerca de três quartos de uma palavra), separado do orçamento do brief; um item tem no máximo 500 caracteres; os mais recentemente ativos vêm primeiro.

## How it does it
O início de sessão sempre diz como registrar, resolver, guardar, apagar e delimitar um item. Quando itens são mostrados, acrescenta a regra de verificação: execute a verificação do item antes de lembrar o Giovanni; se o item não vale mais, feche-o; se não foi possível verificar, diga "unchecked". A regra foi criada depois de um item ser informado como pendente a partir da lembrança da conversa em 2026-10-20, embora já estivesse resolvido.

## Where it sits in the pipeline
Parte do brief que o [[hook-session-start]] monta.

## Who receives its output
O [[session-brief]].
