---
id: laptop-setup
lang: pt-BR
source_hash: 226376c49473
title: Configuração do notebook
---

## What it is
A "configuração do notebook" é o conjunto de tudo o que está instalado e configurado no notebook ([[acer-nitro]]) para que os assistentes Claude possam trabalhar. Não é um programa só, e sim uma caixa de ferramentas: configurações do [[claude-code]], o assistente em segundo plano, ferramentas auxiliares, as ferramentas de build do Android e os meios de alcançar o notebook pelo celular.

## What it does
Ela fornece o chão sobre o qual todo projeto se apoia. As partes são: as configurações e instruções do Claude Code ([[claude-code-settings]], [[global-claude-md]]), o serviço sempre ligado [[claude-assistant]], a barra de status [[pbar]], o enviador de Telegram [[tg-send]], as ferramentas de build do Android ([[android-toolchain]]), as ferramentas extras em `~/.local` ([[user-space-tools]]), a rede privada [[tailscale]] e o acesso remoto seguro [[remote-terminal]].

## How it does it
A maioria das instalações é "em espaço de usuário": fica nas pastas do próprio usuário (`~/.local` e `~/dev`) em vez de pastas do sistema, então não exige direitos de administrador (nada de `sudo`, o comando que executa algo como administrador). Os poucos passos que exigem esses direitos são entregues ao Giovanni para ele executar. Fatos duradouros sobre a configuração ficam em [[claude-auto-memory]] e na memória compartilhada [[workflow-memory]].

## Where it sits in the pipeline
Abaixo de todos os outros projetos: o [[quizapp]] é construído com suas ferramentas, o wiki roda como um dos seus serviços e o assistente vive no gerenciador de serviços dela (systemd, o programa do Linux que inicia e vigia serviços em segundo plano).

## Who receives its output
O [[claude-code]], o [[remote-assistant]] e todos os projetos em `~/dev`.

O painel do Codex [[codex-pbar]] adapta essa exibição para sessões do Codex.

O terminal usa [[codex-status-line]] para as cotas de uso e o tamanho de contexto do Codex. [[machine-bootstrap]] registra a configuração do notebook e pode reconstruí-la após uma reinstalação.

O arquivo global de instruções do Codex [[global-codex-agents]] descreve progresso de tarefas, verificação, relatórios e encerramento de mudanças no sistema real.
