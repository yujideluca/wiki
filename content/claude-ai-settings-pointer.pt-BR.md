---
id: claude-ai-settings-pointer
lang: pt-BR
source_hash: a60b04d30bf6
title: Texto nas Configurações do claude.ai
---

## What it is
Um texto curto em português colado uma vez em claude.ai > Configurações > preferências; fica em `docs/CLAUDE-AI.md`.

## What it does
Manda toda conversa do app do Claude carregar as ferramentas do GitHub, ler o `views/BRIEF.md` e segui-lo; se falhar, seguir pelo menos três regras: responder no idioma da mensagem, explicar de forma simples, nunca guardar dados clínicos, secretos ou de contato de outras pessoas.

## How it does it
Só o Giovanni pode escrever esse campo, então é um ponteiro: o conteúdo fica no resumo, que a Action regenera. Substituiu a linha que fazia as conversas lerem o `code/CORE.md` do repositório antigo.

## Where it sits in the pipeline
No início de toda conversa do app do Claude.

## Who receives its output
O [[mem-github-connector]].
