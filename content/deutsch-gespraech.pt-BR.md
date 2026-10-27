---
id: deutsch-gespraech
lang: pt-BR
source_hash: 8fb37893e5cf
title: Projeto Deutsch-Gespräch (app Claude)
---

## What it is
Deutsch-Gespräch ("conversa em alemão") é um projeto dentro do [[claude-app]] para praticar alemão falado. Como o app não tem memória entre conversas, esse projeto guarda sua memória em um Google Doc chamado `deutsch-gespraech-state`.

## Flow
trigger t1: Giovanni abre um chat no projeto Deutsch-Gespräch | [[claude-app]]
step s1: A skill carrega deutsch-gespraech-state do Google Docs | [[skill-deutsch-gespraech-memory]]
step s2: Conversam em alemão; as correções seguem a skill de treino para a prova | [[skill-alemao-goethe-fsp]]
decide d1: O que o Giovanni digita?
step s3: Salva a sessão de volta no Doc
step s4: Mostra os itens guardados
step s5: Apaga o item indicado
product p1: Um estado atualizado no Google Doc, pronto para a próxima conversa
product p2: A lista de itens guardados na tela

t1 -> s1
s1 -> s2
s2 -> d1
d1 -Ende-> s3
d1 -Gedächtnis?-> s4
d1 -Vergiss …-> s5
s3 -> p1
s5 -> p1
s4 -> p2

## What it does
Na primeira mensagem de cada conversa desse projeto, o estado é carregado do Doc. Quando o Giovanni escreve "Ende" (fim), a sessão é salva lá. "Gedächtnis?" mostra o que está guardado e "Vergiss …" apaga um item.

## How it does it
Quem faz isso é a skill deutsch-gespraech-memory no app ([[claude-ai-skills]]). Essa skill mostra um aviso no início das conversas que não é destinado ao [[claude-code]]; o Claude Code o ignora.

## Where it sits in the pipeline
Só no [[claude-app]], ao lado de [[skill-alemao-goethe-fsp]].

## Who receives its output
O Google Doc e o Giovanni na próxima conversa.

## Steps
1. O Giovanni abre uma conversa no projeto Deutsch-Gespräch do [[claude-app]].
2. A skill carrega `deutsch-gespraech-state` do Google Docs.
3. Eles conversam em alemão; as correções seguem [[skill-alemao-goethe-fsp]].
4. "Ende" salva a sessão de volta no Doc.
5. "Gedächtnis?" mostra os itens guardados, "Vergiss …" apaga um.
