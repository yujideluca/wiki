---
id: claude-app
lang: pt-BR
source_hash: aff0088ffa10
title: App Claude (claude.ai)
---

## What it is
O app Claude é o Claude como o Giovanni o usa no claude.ai, no celular e no navegador, incluindo "projetos" (espaços de conversa salvos, com instruções próprias). Ele difere do [[claude-code]] em um ponto importante: não alcança o notebook, então não pode executar programas nem ler arquivos de projeto lá.

## What it does
É usado para conversa, escrita e estudo: prática de alemão ([[skill-alemao-goethe-fsp]]), perguntas clínicas ([[skill-consulta-clinica]]) e candidaturas à Alemanha ([[skill-candidatura-alemanha]]).

## How it does it
Um texto curto, colado uma vez nas configurações do claude.ai ([[claude-ai-settings-pointer]]), faz cada conversa ler o arquivo `views/BRIEF.md` do [[workflow-memory]] por meio do conector do GitHub (um complemento que permite ao app ler e escrever arquivos no GitHub). Quando o Giovanni o corrige, ele registra a correção criando um novo arquivo de evento ([[mem-github-connector]]). Suas skills são as cópias do claude.ai listadas em [[claude-ai-skills]].

## Where it sits in the pipeline
Fora do notebook. Sua única interface compartilhada com as outras instâncias do Claude é o [[workflow-memory]] (decidido na ADR-0003; uma ADR é uma nota curta que registra uma decisão e seus motivos).

## Who receives its output
O registro de memória [[events-log]], por meio do conector do GitHub.
