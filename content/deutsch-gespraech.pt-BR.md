---
id: deutsch-gespraech
lang: pt-BR
source_hash: d61da8c22e56
title: Projeto Deutsch-Gespräch (app do Claude)
aliases: [conversa em alemão]
---

## What it is
Um projeto do app do Claude para praticar conversa em alemão, cuja memória é um documento do Google: `deutsch-gespraech-state`.

## What it does
Na primeira mensagem de cada conversa desse projeto carrega o estado da conversa do documento; com "Ende" salva a sessão lá; com "Gedächtnis?" ou "Vergiss …" mostra ou apaga itens guardados.

## How it does it
A skill deutsch-gespraech-memory do app ([[claude-ai-skills]]). O aviso dela no início da sessão não é para o Claude Code, que o ignora.

## Where it sits in the pipeline
Só no [[claude-app]], ao lado da [[skill-alemao-goethe-fsp]].

## Who receives its output
O documento do Google e o Giovanni na próxima conversa.

## Steps
1. O Giovanni abre uma conversa no projeto Deutsch-Gespräch do [[claude-app]].
2. A skill carrega o `deutsch-gespraech-state` do Google Docs.
3. A conversa é em alemão; as correções seguem a [[skill-alemao-goethe-fsp]].
4. "Ende" salva a sessão de volta no documento.
5. "Gedächtnis?" mostra os itens guardados, "Vergiss …" apaga um.
