---
id: monthly-architecture-review
lang: pt-BR
source_hash: 49982297d165
title: Revisão mensal de arquitetura
aliases: [revisão de arquitetura]
---

## What it is
Uma sessão por mês que faz o papel que um staff engineer tem numa empresa: conferir a coerência entre todos os projetos (ADR-0003 do workflow-memory). É um item em aberto na memória, então toda conversa a mostra até ser feita.

## What it does
Percorre a lista da [[maintenance-policy]] para cada projeto ativo em `~/dev` e registra o resultado. Desde 2026-10-24 ela é conduzida pela [[skill-revisao-manutencao]] sobre o relatório do [[pipeline-check]] ([[maintenance-pipeline]]).

## How it does it
Usa o portão, as métricas (`tools/metrics.py` onde houver), as funções de aptidão, o DESIGN.md, os ADRs e a lista de dívidas de cada projeto.

## Where it sits in the pipeline
Todo mês, passando por [[quizapp]], [[quizweb]], [[workflow-memory]], [[wiki]] e o modelo.

## Who receives its output
O registro de decisões de cada projeto (uma linha Preventiva) e o [[project-template]] (soluções melhores vão para ele).

## Steps
1. O portão passa localmente e as últimas execuções da CI estão verdes.
2. Métricas: frequência de entrega, tempo de entrega, taxa de retrabalho, fatia preventiva (meta de cerca de 20 %).
3. Funções de aptidão: o que está mais perto do limite? Agir antes de passar ([[fitness-check]]).
4. Os diagramas do DESIGN.md e os ADRs ainda batem com o código; toda mudança estrutural tem ADR.
5. Manutenção adaptativa: atualizações de ferramentas, SDK e dependências, num branch e passando pelo portão.
6. Lista de dívidas: ainda verdadeira, prioridade certa; um P1 com mais de um mês é agendado agora ([[maintenance-policy]]).
7. Entre projetos: o mesmo problema resolvido duas vezes de jeitos diferentes? Levar o melhor para o [[project-template]].
8. Memória: as entradas ainda valem (`mem search <projeto>`); as desatualizadas recebem `mem feedback REF stale` ([[workflow-memory]]).
9. Registrar uma linha Preventiva por projeto e informar com [[mem-use]].
