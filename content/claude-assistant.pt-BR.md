---
id: claude-assistant
lang: pt-BR
source_hash: 3a342a0d50f2
title: Serviço claude-assistant
---

## What it is
Este é o pequeno serviço em segundo plano que mantém o [[remote-assistant]] vivo. É um "serviço de usuário do systemd" ([systemd](https://en.wikipedia.org/wiki/Systemd) é o programa do Linux que inicia serviços em segundo plano e os reinicia se pararem). Foi configurado em 2026-10-10. O serviço se chama `claude-assistant.service` e executa o script `~/.local/bin/claude-assistant start`.

## What it does
Inicia um servidor [tmux](https://github.com/tmux/tmux/wiki) dedicado (tmux é um "multiplexador de terminal": um programa que mantém uma sessão de terminal rodando mesmo sem nenhuma janela mostrando-a). Dentro dele, numa sessão chamada `assistant`, executa `claude remote-control --name yuji-nitro-assistant` em um laço de reinício, a partir da pasta `~/assistant`. Remote Control é o recurso que permite ao Giovanni conversar com essa sessão do Claude pelo app Claude no celular. Uma entrada de autostart do KDE também abre uma janela do Konsole (o terminal do KDE) ligada a essa sessão, para o Giovanni poder acompanhar.

## How it does it
Antes de cada início, o laço espera a rede conseguir resolver nomes: executa `getent hosts api.anthropic.com` e repete até dar certo. Isso é necessário porque, na inicialização, o serviço começa antes de o Wi-Fi conectar, e sem um [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) (Domain Name System, que converte nomes em endereços de rede) funcionando o início falharia. O tmux é uma instalação em espaço de usuário. Para verificar: `systemctl --user status claude-assistant`; para ver a tela: `tmux -L claude capture-pane -p -t assistant`.

## Where it sits in the pipeline
Roda no [[acer-nitro]] e é ativado na inicialização (o "linger" do usuário está ligado, então não é preciso fazer login).

## Who receives its output
O [[remote-assistant]].
