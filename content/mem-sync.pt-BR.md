---
id: mem-sync
lang: pt-BR
source_hash: e17f788cfb6a
title: mem sync (pull e push)
---

## What it is
Mantém o clone do repositório de memória no notebook em dia com o GitHub.

## What it does
`pull` antes de ler (início da sessão); `push` depois de gravar (hook Stop), com novas tentativas; nunca mescla arquivos derivados.

## How it does it
Git simples com limites de tempo; se perder a corrida, recomeça do `main` mais novo. Nunca faz force-push.

## Where it sits in the pipeline
Entre o clone local e o [[github]].

## Who receives its output
O [[github]] e o [[hook-session-start]].
