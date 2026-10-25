---
id: pbar
lang: pt-BR
source_hash: 96fc10bffeec
title: pbar.py (linha de status)
---

## What it is
`pbar.py` desenha a linha de status do Claude Code no notebook: a única linha de texto na parte de baixo do terminal. Enquanto um comando roda, ela se parece com a barra de progresso que o instalador de pacotes `apt` desenha. Funciona só localmente: não usa rede nem tokens do modelo (as unidades em que o uso de IA é medido), então não custa nada.

## What it does
Enquanto um comando de shell roda, mostra `Progress: [ 45%]` e uma barra, estimada pelo tempo que esse mesmo programa levou nas execuções anteriores. Quando nada roda, mostra a pasta, o branch do git, o modelo, o custo, quanto da janela de contexto está usada e o uso do limite de 5 horas com o horário de reinício.

## How it does it
São duas partes. Um laço de verificação examina `/proc` (a lista de programas em execução do Linux) em busca do programa que cada comando do Claude Code executa e aprende durações típicas, guardadas em `~/.local/share/claude-pbar/history.json`. A segunda parte, `line`, é o comando que o Claude Code chama para obter a linha de status ([documentação](https://docs.claude.com/en/docs/claude-code/statusline)); ele imprime uma linha com a largura do terminal. Ambas são iniciadas a partir de [[claude-code-settings]].

## Where it sits in the pipeline
Na parte de baixo de todo terminal do Claude Code.

## Who receives its output
O Giovanni, olhando o terminal.

O painel do Codex [[codex-pbar]] adapta essa exibição para sessões do Codex.
