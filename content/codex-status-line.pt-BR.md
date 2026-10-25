---
id: codex-status-line
lang: pt-BR
source_hash: 62df6c20d581
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

Com `tui.fullscreen_transcript = true`, o Codex posiciona a entrada e a linha de status nativa no rodapé imediatamente; a rolagem acontece dentro do Codex. No modo de rolagem do terminal (`false`), elas começam perto do topo e descem conforme a saída preenche a tela, afastadas do rodapé fixo de progresso. Uma comparação no Codex 0.164.0 mostrou os limites na linha 13 de 52 no modo de rolagem e na linha 51 em tela cheia, sem enviar solicitação. A tela cheia também manteve a posição inferior com 70 colunas e 24 linhas. Reabra a visualização do terminal para aplicar a configuração salva. A tela cheia pode mostrar o aviso adicional de limite baixo do Codex acima da entrada.
