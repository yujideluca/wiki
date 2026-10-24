---
id: giovanni
lang: pt-BR
source_hash: 9a6b8e5ea277
title: Giovanni
---

## What it is
Giovanni é o dono de todos os sistemas descritos neste wiki e a pessoa para quem tudo é construído. Giovanni é médico de emergência pré-hospitalar no Brasil (médico que atende emergências fora do hospital, por exemplo em ambulâncias) e se prepara para o exame Goethe B2 de alemão (novembro de 2026) e depois para a FSP (Fachsprachprüfung, a prova alemã de linguagem médica), a fim de trabalhar como médico na Alemanha.

## What it does
Giovanni decide o que é construído e aprova tudo o que chega ao mundo exterior ou não pode ser desfeito. Correções e preferências que Giovanni declara viram entradas na memória compartilhada ([[mem]]). Giovanni estuda alemão com o [[quizapp]] e o [[quizweb]] e lê este [[wiki]] para entender como as peças se encaixam.

## How it does it
Giovanni conversa com o [[claude-code]] no terminal do notebook, com o [[remote-assistant]] pelo celular e com o [[claude-app]] no claude.ai. As regras permanentes (responder no idioma da mensagem, explicar em linguagem simples, perguntar antes de ações voltadas ao exterior) ficam no [[workflow-memory]], não neste wiki.

## Where it sits in the pipeline
No começo e no fim de toda cadeia de trabalho: Giovanni é a fonte dos requisitos (o que precisa ser construído) e o aprovador final. A decisão que dá forma a esse papel é a ADR-0003 no [[workflow-memory]] (uma ADR, "architecture decision record", é uma nota curta que registra uma decisão importante e seus motivos).

## Who receives its output
As instâncias do Claude recebem as instruções do Giovanni; o sistema de memória recebe as correções do Giovanni.
