---
id: maintenance-pipeline
lang: pt-BR
source_hash: b8191acb8352
title: Pipeline de manutenção (medir, depois julgar)
aliases: [processo de manutenção]
---

## What it is
O jeito de manter os projetos de software do Giovanni sustentáveis: um programa mede e bloqueia, uma skill julga e propõe, e os dois só se falam pelo `report.json`.

## What it does
Transforma as regras da [[maintenance-policy]] em algo que uma máquina faz valer: o job do CI falha diante de uma `falha`, e a revisão mensal lê os mesmos números em vez de medir à mão.

## How it does it
O [[pipeline-check]] roda no CI e no notebook; a [[skill-revisao-manutencao]] lê o relatório. Bloquear um merge também exige uma proteção de branch que peça o job do CI; só o Giovanni a altera. Em repositório privado no plano gratuito do GitHub essa proteção não existe (o GitHub responde 403), então por isso uma verificação local antes do push (`pipeline-check --pre-push`, ativada com `git config core.hooksPath tools/hooks`) impede o push da `main` quando uma verificação falha. O Giovanni escolheu a verificação local em 2026-10-24. Aplicado primeiro ao [[quizapp]], depois copiado para os outros projetos e para o [[project-template]].

## Where it sits in the pipeline
Entre cada push e a revisão mensal: [[quizapp-ci]], depois [[monthly-architecture-review]].

## Who receives its output
O Giovanni.

## Steps
1. Um push dispara o job `gate` do CI, que executa o [[pipeline-check]].
2. Qualquer `falha` derruba o job; a proteção de branch impede o merge.
3. Um `aviso` nunca falha, mas aparece no relatório.
4. Na revisão mensal, a [[skill-revisao-manutencao]] transforma avisos e falhas em propostas `debt` priorizadas.
5. O Giovanni decide; a skill registra uma linha Preventiva no registro de decisões e publica a wiki.
