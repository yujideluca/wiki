---
id: codex-status-line
lang: pt-BR
source_hash: 4b6bfd83fb91
title: Linha de status nativa do Codex
---

## What it is
A linha de status nativa mostra o uso dentro do terminal do Codex. Ela complementa a linha separada de progresso da tarefa em [[laptop-setup]].

## What it does
Mostra as porcentagens restantes dos limites de cinco horas e semanal, os tokens usados no contexto atual e o tamanho da janela de contexto. Tokens são as unidades de texto contadas pelo modelo. A janela de contexto determina quanto texto uma solicitação pode conter.

## How it does it
A lista `tui.status_line` em `~/.codex/config.toml` contém `five-hour-limit`, `weekly-limit`, `used-tokens`, `context-window-size` e `task-progress`. Um novo terminal carrega essas configurações. Os valores do contexto aparecem depois que uma solicitação informa o uso.

## Where it sits in the pipeline
Funciona dentro do Codex, acima da linha separada de progresso.

## Who receives its output
Giovanni lê a exibição.

## Notes
Um teste no terminal em 2026-10-25 com Codex 0.164.0 mostrou `5h 44% left · weekly 76% left · 10.5K used · 475K window`. Um segundo terminal novo confirmou a configuração salva sem substituições pela linha de comando. Não foi verificado se terminais já abertos recarregam a configuração.

Com `tui.fullscreen_transcript = false`, o histórico usa a rolagem do terminal. Um teste confirmou que isso remove o aviso persistente duplicado acima da entrada e mantém os dois limites na linha de status. O aviso inicial permanece no histórico.
