---
id: wiki-service
lang: pt-BR
source_hash: 24b12cbf9a62
title: wiki.service (systemd)
---

## What it is
É a unidade de usuário do systemd (uma configuração para o [systemd](https://en.wikipedia.org/wiki/Systemd), o programa do Linux que inicia e vigia serviços em segundo plano) que mantém o [[wiki-server]] rodando no notebook.

## What it does
Inicia o release Elixir na inicialização (o "linger" do usuário está ligado, então não é preciso fazer login), o reinicia se parar e carrega os segredos de `~/.config/wiki/oauth.env` e `secret.env`.

## How it does it
Para verificar, execute `systemctl --user status wiki`; para ler os logs, `journalctl --user -u wiki`. Ela não tem `ExecStop` próprio: um release Elixir normalmente é parado por um pedido enviado ao nó em execução pela distribuição do Erlang, mas o [[wiki-server]] desliga essa distribuição, então o systemd o para do jeito simples, com o sinal TERM (um pedido padrão do Linux para terminar), que o servidor já responde encerrando de forma organizada.

## Where it sits in the pipeline
No [[acer-nitro]], por baixo do [[tailscale-funnel]].

## Who receives its output
O [[wiki-server]].
