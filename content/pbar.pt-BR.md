---
id: pbar
lang: pt-BR
source_hash: 533620cc5c3f
title: pbar.py (linha de status)
aliases: [barra de progresso]
---

## What it is
A linha de status do Claude Code no notebook: uma barra de progresso desenhada como a do apt durante uma instalação. Só local: sem rede, sem tokens do modelo.

## What it does
Enquanto um comando roda, mostra `Progress: [ 45%]` e uma barra, estimada pelo tempo que aquele programa levou antes; quando nada roda, mostra pasta, branch do git, modelo, custo, contexto usado e o uso de 5 horas com a hora de renovação.

## How it does it
Duas partes: um laço que varre o `/proc` atrás do programa de cada comando do Claude Code e aprende as durações (`~/.local/share/claude-pbar/history.json`), e o `line`, o comando da statusLine, que imprime uma linha da largura do terminal. Iniciado pelo [[claude-code-settings]].

## Where it sits in the pipeline
Na parte de baixo de todo terminal do Claude Code.

## Who receives its output
O Giovanni, olhando o terminal.
