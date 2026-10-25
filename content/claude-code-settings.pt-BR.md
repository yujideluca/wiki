---
id: claude-code-settings
lang: pt-BR
source_hash: 9dc79892bd67
title: settings.json do Claude Code
---

## What it is
`~/.claude/settings.json` é o arquivo de configurações do Claude Code no nível do usuário, no notebook. É um arquivo [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, um formato de texto simples para dados estruturados) que o Claude Code lê ao iniciar. Veja a [documentação das configurações](https://docs.claude.com/en/docs/claude-code/settings).

## What it does
Registra os hooks, pequenos programas que o Claude Code executa automaticamente em certos momentos ([hooks explicados](https://docs.claude.com/en/docs/claude-code/hooks-guide)): no início de uma conversa ([[hook-session-start]]), quando o Giovanni envia uma mensagem ([[hook-prompt]]) e quando o Claude termina uma resposta ([[hook-stop]] e [[wiki-hook-stop]]). Também define a linha de status ([[pbar]]), duas variáveis de ambiente (`ANDROID_HOME` e `MOBILEMCP_DISABLE_TELEMETRY`, definida como 1), os plugins ativados ([[claude-plugins]]) com uma fonte extra de plugins (o repositório do GitHub `panicgit/android-test-pilot`), o modelo (`sonnet`), o tema de cores (`dark`), a chave `agentPushNotifEnabled` para notificações push e uma entrada `autoMode` que descreve o ambiente de trabalho em texto.

## How it does it
O Claude Code lê o arquivo ao iniciar. Os hooks da memória foram adicionados pelo comando `mem install-hooks`, e o hook do wiki pela sua própria configuração. O arquivo só é alterado de propósito; existe uma skill chamada update-config para essa tarefa.

## Where it sits in the pipeline
Lido no início de toda sessão do Claude Code ([[chat-start]]).

## Who receives its output
O próprio Claude Code.
