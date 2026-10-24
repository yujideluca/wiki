---
id: skill-revisao-manutencao
lang: pt-BR
source_hash: ae1ab28f63d1
title: Skill: revisao-manutencao
aliases: [revisao-manutencao]
---

## What it is
A metade que julga do [[maintenance-pipeline]]: uma skill que lê o que o [[pipeline-check]] mediu e propõe o que fazer a respeito.

## What it does
Executa `tools/pipeline-check.sh`, lê o `report.json` e nunca mede de novo. Para cada `aviso` ou `falha`, propõe uma issue `debt` com prioridade P1 (risco de dados ou resultado errado), P2 (atrasa toda mudança) ou P3 (desejável). Depois confere o que a máquina não vê: o `DESIGN.md` e os ADRs batem com o código, toda mudança estrutural tem ADR, o mesmo problema foi resolvido duas vezes (levar a melhor solução ao [[project-template]]). Acrescenta uma linha Preventiva ao registro de decisões de cada projeto revisado, chama a [[skill-gerar-teste-automatizado]] (criar na primeira revisão, atualizar nas seguintes) e termina com `mem use`, `wiki publish` e "Verified by:". Ela propõe; não fecha issues, não muda limite, não promove versão e não altera a proteção de branch.

## How it does it
Um `SKILL.md` em `~/.claude/skills/revisao-manutencao`. Acionada pelo item de revisão mensal no workflow-memory e no fim de uma tarefa em projeto de software.

## Where it sits in the pipeline
Conduz a [[monthly-architecture-review]] e a revisão de fim de tarefa de todo projeto de software.

## Who receives its output
O Giovanni (propostas e decisões) e o registro de decisões de cada projeto.
