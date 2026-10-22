---
id: remote-assistant
lang: pt-BR
source_hash: e01b95e3fdf4
title: Assistente remoto
---

## What it is
Uma sessão do Claude Code que fica rodando o tempo todo no notebook e que o [[giovanni]] acessa pelo app do Claude no celular (Remote Control). Aparece no app como `yuji-nitro-assistant`.

## What it does
Tarefas curtas no notebook quando o Giovanni está fora: mesmas regras do [[claude-code]], gravando na memória como instância `assistant`.

## How it does it
Mantida viva pelo serviço [[claude-assistant]]: uma sessão tmux roda `claude remote-control` num laço de reinício a partir da pasta `~/assistant`, cujo próprio CLAUDE.md pede respostas curtas, boas para o celular. O modo de permissão foi definido pelo próprio Giovanni.

## Where it sits in the pipeline
Uma segunda porta para o mesmo notebook e os mesmos repositórios do Claude Code.

## Who receives its output
O mesmo que o [[claude-code]]: repositórios e o [[events-log]] (com `MEM_INSTANCE=assistant`).
