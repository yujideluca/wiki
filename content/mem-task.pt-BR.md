---
id: mem-task
lang: pt-BR
source_hash: bbabc7f00743
title: mem task (pendências)
---

## What it is
Uma "pendência" (open item) é uma meta inacabada ou um problema conhecido que o Giovanni não deve esquecer. `mem task --check COMO [--category C] "texto"` é o comando (CLI, interface de linha de comando) que registra uma, para ela continuar visível até ser resolvida.

## What it does
Cria um evento `task` no formato `o que está pendente | check: como verificar que ainda vale`. O item aparece no início de toda conversa até o Giovanni decidir: resolvido (`mem done`), guardado (`mem archive`, de volta com `mem reopen`) ou apagado (`mem forget`). As regras das pendências estão em [[mem-pendency]].

## How it does it
O comando recusa uma tarefa sem verificação, porque um item que não pode ser verificado vira um lembrete obsoleto. Antes de lembrar o Giovanni de um item, o Claude executa a verificação dele; se o item não vale mais, o Claude o fecha em vez de mencioná-lo.

## Where it sits in the pipeline
Criada no fim de uma sessão para tudo o que ainda estiver pendente.

## Who receives its output
[[events-log]] e depois o [[session-brief]] de toda conversa.
