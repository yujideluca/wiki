---
id: maintenance-policy
lang: pt-BR
source_hash: a13b2e481871
title: Política de manutenção (dívida técnica)
---

## What it is
É o regulamento para manter todo projeto saudável enquanto ele muda ao longo do tempo (`docs/MAINTENANCE.md` no [[project-template]]). Baseia-se em quatro ideias conhecidas: os tipos de manutenção da norma ISO/IEC/IEEE 14764 (corretiva = consertar defeitos, adaptativa = ajustar a um ambiente que muda, perfectiva = melhorar, preventiva = preparar-se contra problemas futuros; veja [manutenção de software](https://en.wikipedia.org/wiki/Software_maintenance)); as [leis de Lehman](https://en.wikipedia.org/wiki/Lehman%27s_laws_of_software_evolution) da evolução do software (software em uso precisa continuar mudando e fica mais complexo se nada for feito contra isso); funções de aptidão (verificações automáticas de qualidades do design, veja [[fitness-check]]); e as métricas de entrega DORA (DevOps Research and Assessment), como a frequência e a rapidez com que mudanças são lançadas ([dora.dev](https://dora.dev/)).

## What it does
Define dívida técnica: tudo o que funciona hoje, mas torna a próxima mudança mais lenta ou arriscada ([dívida técnica](https://en.wikipedia.org/wiki/Technical_debt)). A dívida vira uma issue do GitHub (uma tarefa rastreada) com o rótulo `debt` e uma prioridade de P1 (mais urgente) a P3; ideias de novas funções usam o rótulo `idea`. Cerca de uma em cada cinco sessões de trabalho vai para dívida ou prevenção: quando as últimas quatro sessões foram só de funcionalidades, o Claude avisa e propõe a principal issue de dívida, e o Giovanni decide.

## How it does it
Uma limitação encontrada durante o trabalho vira uma issue na mesma sessão, e a revisão mensal confere a lista.

## Where it sits in the pipeline
Parte do modelo, copiada para cada projeto.

## Who receives its output
A [[monthly-architecture-review]] e toda sessão do Claude (pelo CLAUDE.md de cada projeto).
