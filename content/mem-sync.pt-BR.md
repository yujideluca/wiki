---
id: mem-sync
lang: pt-BR
source_hash: 951134bb249e
title: mem sync (pull e push)
---

## What it is
`mem sync` mantém a cópia do repositório da memória no notebook em dia com o GitHub. A cópia se chama clone; o original fica no GitHub.

## What it does
`pull` baixa a versão mais recente antes de a memória ser lida (no início de uma sessão). `push` envia os novos eventos depois de escritos (no hook Stop), com novas tentativas. Nunca mescla os arquivos derivados (as visões geradas), porque eles sempre podem ser regenerados.

## How it does it
Usa git simples com limites de tempo. Se outro escritor enviou no mesmo instante e o envio foi recusado, recomeça a partir do `main` mais recente (a linha principal do histórico). Nunca faz force-push.

## Where it sits in the pipeline
Entre o clone local e o [[github]].

## Who receives its output
O [[github]] e o [[hook-session-start]].
