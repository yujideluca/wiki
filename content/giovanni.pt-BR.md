---
id: giovanni
lang: pt-BR
source_hash: a241d37ebccd
title: Giovanni
---

## What it is
A pessoa dona de todos os sistemas deste wiki: atua em emergência pré-hospitalar no Brasil e se prepara para o exame Goethe B2 (nov. 2026) e a FSP, para exercer medicina na Alemanha.

## What it does
Decide o que é construído e aprova qualquer ação externa ou destrutiva. Dá correções e preferências, que viram entradas do [[mem]]. Usa o [[quizapp]] e o [[quizweb]] para estudar alemão e lê este [[wiki]] para responder perguntas de arquitetura.

## How it does it
Conversa com o [[claude-code]] no terminal do notebook, com o [[remote-assistant]] pelo celular e com o [[claude-app]] no claude.ai. As regras permanentes (responder no idioma da mensagem, linguagem simples, perguntar antes de ações externas) ficam no [[workflow-memory]].

## Where it sits in the pipeline
No começo e no fim de todo fluxo: a fonte dos requisitos e quem aprova por último (ver ADR-0003 no [[workflow-memory]]).

## Who receives its output
As instâncias do Claude recebem as instruções de Giovanni; o sistema de memória recebe as correções de Giovanni.
