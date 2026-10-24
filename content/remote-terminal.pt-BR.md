---
id: remote-terminal
lang: pt-BR
source_hash: dd80b6955bc1
title: Configuração do remote-terminal (SSH + Tailscale)
---

## What it is
`~/dev/remote-terminal/setup-sudo.sh` é um script de configuração de uso único (pode ser executado de novo sem risco) que permite abrir o terminal do notebook pelo celular. Terminal é a janela de texto onde se digitam comandos; alcançá-lo remotamente significa que o Giovanni pode executar comandos no notebook de qualquer lugar.

## What it does
Instala três coisas de fontes oficiais: um servidor OpenSSH (o programa que aceita logins remotos criptografados via [SSH](https://en.wikipedia.org/wiki/Secure_Shell), Secure Shell), o [[tailscale]] (uma rede privada entre os dispositivos do Giovanni) e o tmux (um terminal que continua rodando quando você se desconecta). Depois fecha o SSH: só chaves (sem senhas), só o usuário `yuji`, sem login de root. Se receber a chave pública do celular, autoriza o celular.

## How it does it
É um script [Bash](https://www.gnu.org/software/bash/) que o Giovanni executa com direitos de administrador: `sudo bash ~/dev/remote-terminal/setup-sudo.sh ["ssh-ed25519 … phone"]`. Ele para no primeiro erro (`set -euxo pipefail`) e verifica a configuração do SSH com `sshd -t` antes de reiniciar o serviço, para que um erro de digitação não tranque o Giovanni do lado de fora. Desde 2026-10-24 é um repositório privado no GitHub (`yujideluca/remote-terminal`) com portão de qualidade, integração contínua (CI, verificações automáticas a cada push) e a verificação [[pipeline-check]] antes do push.

## Where it sits in the pipeline
É a base de todo o acesso remoto ao [[acer-nitro]].

## Who receives its output
O [[tailscale]] e o serviço SSH.
