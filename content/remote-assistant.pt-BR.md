---
id: remote-assistant
lang: pt-BR
source_hash: 2a75b28e07de
title: Assistente remoto
---

## What it is
O assistente remoto é uma sessão do Claude Code que roda o tempo todo no notebook e que o [[giovanni]] alcança pelo app Claude no celular, por um recurso chamado Remote Control. No app ele aparece como `yuji-nitro-assistant`. Pense nele como uma segunda porta para o mesmo notebook: o mesmo Claude, os mesmos repositórios, mas acessível de qualquer lugar.

## What it does
Faz tarefas curtas no notebook enquanto o Giovanni está longe dele. Segue as mesmas regras do [[claude-code]] e escreve na memória compartilhada com o nome de instância `assistant`, para a memória saber quem escreveu o quê.

## How it does it
O serviço [[claude-assistant]] o mantém vivo: uma sessão tmux (um terminal que continua rodando sem janela) executa `claude remote-control` em um laço de reinício, a partir da pasta `~/assistant`. Essa pasta tem seu próprio CLAUDE.md (um arquivo de texto com instruções permanentes que o Claude Code lê ao iniciar) pedindo respostas curtas, boas de ler no celular. O modo de permissão dele (quanto o Claude pode fazer sem perguntar) foi escolhido pelo próprio Giovanni.

## Where it sits in the pipeline
É uma segunda entrada para o mesmo notebook e os mesmos repositórios de projeto do Claude Code; a diferença é só como o Giovanni chega até ele.

## Who receives its output
Os mesmos destinatários do [[claude-code]]: os repositórios dos projetos e o registro de memória [[events-log]] (as entradas levam a marca `MEM_INSTANCE=assistant`).

## Notes

### Controle remoto do Codex
O Codex é outro assistente de programação neste notebook. Seu serviço separado `codex-remote-tmux.service` usa o systemd, o programa do Linux que administra serviços em segundo plano, para executar `~/.local/bin/codex-remote-tmux start`. O script mantém um terminal funcionando sem janela visível por meio do tmux. Usa o socket próprio do tmux `codex-remote` e a sessão `remote`, iniciando na pasta pessoal.

A ação `run` executa repetidamente `codex remote-control --no-daemon`. Quando esse comando termina, mesmo com erro, o script espera 15 segundos antes de tentar novamente. O serviço declara `Restart=always` e `RestartSec=15`. São duas camadas separadas: o script repete o comando e o systemd reinicia o serviço. `start` preserva uma sessão existente; `attach` abre seu terminal; `stop` encerra essa sessão. Sem argumento, o script conecta ao terminal.

O instalador em `~/Documents/Codex/2026-10-25/i-w/outputs/install-codex-remote.sh` faz cópias de segurança dos arquivos existentes, grava o script e o serviço, verifica sua sintaxe, recarrega o systemd e habilita e inicia o serviço no alvo padrão do usuário. O comando de pareamento indicado no instalador é `codex remote-control pair`; o terminal pode ser aberto com `codex-remote-tmux attach`.

Nesta revisão, o script e o serviço instalados correspondiam ao instalador. O estado real do serviço e a conexão pelo celular não foram verificados: a sandbox negou acesso ao barramento de serviços do usuário e ao socket do tmux. O serviço não foi reiniciado nem alterado. O script do Codex não define o marcador `MEM_INSTANCE=assistant` do Claude.
