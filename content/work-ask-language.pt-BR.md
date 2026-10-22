---
id: work-ask-language
lang: pt-BR
source_hash: f2303979a520
title: Regra: perguntar a linguagem de programação
aliases: [escolha da linguagem]
---

## What it is
Uma regra permanente do Giovanni (22/10/2026): antes de qualquer projeto que envolva programação, o Claude pergunta quais linguagens usar em cada parte — front-end, back-end, ferramentas — e nunca escolhe sozinho.

## What it does
Põe a escolha da linguagem nas mãos do Giovanni no começo do desenho, não depois que já existe código. Surgiu quando o front-end (Elm) e o back-end (Elixir) do wiki só foram definidos depois do rascunho do desenho.

## How it does it
Guardada na memória (chave `work.ask-language`) e escrita na seção "como é feito" da skill de brainstorming, onde a decisão é tomada.

## Where it sits in the pipeline
O passo 2 do [[new-project]]; aplicada pela [[skill-brainstorming]].

## Who receives its output
O [[claude-code]] e o [[remote-assistant]].
