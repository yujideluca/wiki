---
id: claude-ai-settings-pointer
lang: pt-BR
source_hash: 342b34c30f7d
title: Ponteiro nas configurações do claude.ai
---

## What it is
Um "ponteiro" (pointer) é um texto curto que aponta para outro lugar em vez de guardar o conteúdo em si. Este é um texto curto em português que o Giovanni colou uma vez no campo de preferências das configurações do claude.ai. Uma cópia fica no arquivo `docs/CLAUDE-AI.md` do [[workflow-memory]].

## What it does
Manda cada conversa do app Claude carregar as ferramentas do GitHub, ler o arquivo `views/BRIEF.md` e segui-lo. Se isso falhar, a conversa ainda segue três regras básicas: responder no idioma da mensagem, explicar com simplicidade e nunca guardar dados clínicos, secretos ou de contato de outras pessoas.

## How it does it
Só o Giovanni consegue escrever nesse campo das configurações, então nada longo cabe ali. Por isso é só um ponteiro: o conteúdo de verdade fica no resumo (brief), que uma GitHub Action (uma tarefa automática no GitHub) regenera sempre que a memória muda. O ponteiro substituiu uma linha antiga que fazia as conversas lerem `code/CORE.md` do repositório antigo, já desativado.

## Where it sits in the pipeline
No início de toda conversa do [[claude-app]].

## Who receives its output
O [[mem-github-connector]], o processo pelo qual o app então lê e escreve a memória.
