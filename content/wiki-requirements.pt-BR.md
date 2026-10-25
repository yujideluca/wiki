---
id: wiki-requirements
lang: pt-BR
source_hash: a767a3868957
title: Requisitos do wiki
---

## What it is
Um requisito é uma promessa testável do software. Esta página descreve a lista de promessas do próprio wiki (`docs/REQUIREMENTS.md`), cada uma com um ID formado por uma família de duas letras e um número: AU (o portão de login), DC (a isca), CO (regras de conteúdo), LG (idiomas), BU (o build), UP (a cadeia de atualização), ST (a desatualização das páginas) e MP (o mapa e as páginas).

## What it does
Toda linha precisa ter pelo menos um teste etiquetado `REQ <ID>`; o arquivo gerado `docs/TRACEABILITY.md` liga cada requisito aos seus testes.

## How it does it
As linhas são escritas a partir das declarações do Giovanni (fonte G) e do design aprovado (fonte D). A verificação [[check-traceability]] garante que toda promessa tenha um teste e toda etiqueta nomeie uma promessa real.

## Where it sits in the pipeline
Ao lado do documento de design `docs/2026-10-22-wiki-design.md`.

## Who receives its output
O [[check-traceability]] e o [[wiki-quality-gate]].
