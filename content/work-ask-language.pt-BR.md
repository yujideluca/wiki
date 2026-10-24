---
id: work-ask-language
lang: pt-BR
source_hash: 316d9a735700
title: Regra: perguntar qual linguagem de programação
---

## What it is
É uma regra permanente do Giovanni (2026-10-22): antes de qualquer projeto que envolva programação, o Claude deve perguntar qual(is) linguagem(ns) de programação usar em cada parte (front end = o que o usuário vê, back end = o servidor por trás, ferramentas) e nunca escolher sozinho.

## What it does
Coloca a escolha da linguagem nas mãos do Giovanni no começo do design, e não depois de o código existir. A regra surgiu quando o front end (Elm) e o back end (Elixir) do wiki só foram nomeados depois de o design já estar rascunhado.

## How it does it
Está guardada na memória com a chave `work.ask-language` e escrita na seção "how it gets made" da skill de brainstorming ([[skill-brainstorming]]), que é o lugar onde a decisão é tomada.

## Where it sits in the pipeline
Passo 2 de [[new-project]]; aplicada pela [[skill-brainstorming]].

## Who receives its output
O [[claude-code]] e o [[remote-assistant]].
