---
id: check-errors-languagetool
lang: pt-BR
source_hash: 2e2f92aa7e84
title: check_errors_languagetool.py
aliases: [verificação LanguageTool]
---

## What it is
Uma verificação gramatical das frases do Fehler finden com o LanguageTool (um corretor gramatical que roda localmente em Java).

## What it does
1. Toda frase corrigida precisa estar limpa no nível PICKY, para nenhuma frase ensinar um alemão que o LanguageTool rejeita. 2. Nenhum aviso pode cair num pedaço diferente do marcado, para o jogador nunca encontrar um segundo erro não planejado.

## How it does it
Python chamando o jar de linha de comando do LanguageTool (Java 17+). O LanguageTool só reconhece cerca de um quarto dos erros plantados, então se o pedaço marcado está mesmo errado é conferido à mão.

## Where it sits in the pipeline
Depois do [[build-vocab]], sempre que as frases com erro mudam.

## Who receives its output
O Claude, como aprovado/reprovado antes de o conteúdo ir para o commit.
