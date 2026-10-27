---
id: hook-prompt
lang: pt-BR
source_hash: 0e6998e9e11d
title: Hook UserPromptSubmit (mem hook-prompt)
---

## What it is
Um hook é um pequeno programa que o [[claude-code]] executa automaticamente em um certo evento ([hooks explicados](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Este roda toda vez que o Giovanni envia uma mensagem: o comando `mem hook-prompt`, com limite de 10 segundos.

## What it does
Passa o texto da mensagem ao [[mem-harvester]], que procura uma preferência declarada pelo Giovanni e a registra, para que uma regra dita uma vez não se perca. O hook em si não imprime nada.

## How it does it
Foi feito para nunca atrapalhar. Qualquer erro vai para o log do hook, e o programa sempre termina com código de saída 0 (o número que um programa devolve para dizer "tudo certo"), então uma falha aqui nunca impede que uma mensagem chegue ao Claude. Mensagens com mais de 1500 caracteres não são lidas em busca de preferências, porque são documentos colados ou prompts escritos por um programa.

## Where it sits in the pipeline
Entre a mensagem do Giovanni e o modelo: a mensagem é lida de passagem.

## Who receives its output
O [[mem-harvester]].
