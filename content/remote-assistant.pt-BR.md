---
id: remote-assistant
lang: pt-BR
source_hash: c65b5d957be4
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

A verificação real em 2026-10-26 encontrou o serviço habilitado e ativo, com a sessão tmux `remote`, mas o comando falhava a cada 15 segundos: `socket parent must be owned by the user or root and prevent other users from replacing socket entries`. O Codex criava seu diretório temporário de socket com permissão de escrita para o grupo (modo `0775`). O lançador e o instalador agora definem `umask 077`, uma máscara de criação que restringe novos arquivos e diretórios ao proprietário. Depois de reiniciar apenas esse serviço, o terminal tmux informou `This machine is available for remote control as yuji-nitro.` e o processo `codex remote-control --no-daemon` continuou rodando. O serviço permanece habilitado. A conexão pelo celular não foi testada. O script do Codex não define o marcador `MEM_INSTANCE=assistant` do Claude.
