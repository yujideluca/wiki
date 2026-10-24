---
id: quizapp-design-doc
lang: pt-BR
source_hash: 91ffb0551caa
title: DESIGN.md do QuizApp
---

## What it is
O `DESIGN.md` é o documento de design vivo do [[quizapp]]: o que o app é, sua arquitetura (diagramas C4, uma forma de desenhar software em vários níveis de zoom, escritos em Mermaid), repetição espaçada, conteúdo, persistência, a interface de usuário (UI), idiomas, depurabilidade, testes e o registro de decisões. "Vivo" significa que é mantido em dia com o código.

## What it does
Explica como o app é construído e por quê. Cada linha do registro de decisões tem um Tipo tirado das categorias de manutenção da norma ISO/IEC/IEEE 14764: corretiva (consertar uma falha), adaptativa (ajustar a um ambiente que muda), perfectiva (melhorar), preventiva (preparar-se contra problemas futuros) ou inicial.

## How it does it
É atualizado no mesmo commit de qualquer mudança em arquitetura, modos, agendador ou avaliador, persistência ou fluxo da UI; decisões estruturais também ganham uma ADR (architecture decision record, [[quizapp-adrs]]). É revisado todo mês ([[monthly-architecture-review]]).

## Where it sits in the pipeline
Ao lado do código que descreve. As páginas do QuizApp neste wiki são tiradas em grande parte dele.

## Who receives its output
O Claude (antes de mudar o app) e o Giovanni.
