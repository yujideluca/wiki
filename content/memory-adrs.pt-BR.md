---
id: memory-adrs
lang: pt-BR
source_hash: 8ab2016c765b
title: ADRs do workflow-memory
---

## What it is
ADRs ("architecture decision records", registros de decisão de arquitetura) são notas curtas, uma por decisão importante, que guardam os motivos para que ninguém precise adivinhar depois. Esta página cobre os ADRs do [[workflow-memory]]: 0001 registrar decisões assim; 0002 o log de eventos; 0003 os papéis do Giovanni e das instâncias do Claude; 0004 um programa mede e uma skill julga; 0005 enxugar o resumo de início e separar a memória por ferramenta; 0006 um evento nunca pode ser posterior ao momento em que é lido; 0007 as regras são buscadas pelo tipo de tarefa.

## What it does
A ADR-0002 diz que a memória é um registro só de acréscimo (apenas arquivos novos entram, os antigos nunca mudam) que uma função pura transforma no estado atual, em vez de um protocolo entre máquinas. A ADR-0003 diz que o Giovanni decide e aprova; o [[claude-code]] constrói; o [[remote-assistant]] faz tarefas curtas com as mesmas regras; o [[claude-app]] conversa e escreve apenas eventos de memória. As instâncias nunca conversam diretamente: o workflow-memory é a única interface compartilhada, e novos projetos nascem do [[project-template]]. O ADR-0004 diz que um programa determinístico, o [[pipeline-check]], mede e bloqueia, enquanto a skill [[skill-revisao-manutencao]] lê o relatório dele e só propõe; o programa vive em um repositório próprio e cada projeto fixa uma versão dele em vez de copiá-lo ([[maintenance-pipeline]]). O ADR-0005 (26/10/2026) enxuga o brief de início: o harvester ignora prompts gerados, o Codex usa seu próprio escopo `instance:codex`, e o brief era mais curto depois de `/clear` (o ADR-0007 depois deixou o brief inteiro curto). O ADR-0006 (30/10/2026) corrige um problema de relógio: um escritor sem relógio confiável, como o [[claude-app]], pode carimbar um evento com minutos no futuro, e um teste uma vez escolheu esse evento como o "mais novo" e falhou. Código e testes agora usam o caminho que `mem add` imprime, em vez da ordem de classificação do registro, e na leitura todo horário de evento é limitado ao horário atual (o carimbo original fica em `ts_claimed`), de modo que um escritor com relógio errado não consegue embaralhar a ordem. Um carimbo mais de um dia à frente continua indo para a quarentena. O ADR-0007 (05/11/2026) responde a uma falha de 04/11/2026: um programa de proteção automático travou as sessões do Giovanni, e as regras que teriam impedido isso existiam, mas nunca chegavam às conversas, porque o brief de início tinha cerca de 17 KB (quilobytes) e uma conversa vê só os primeiros 2 KB. Agora cada regra leva tags (os tipos de tarefa em que importa); o brief imprime só as poucas regras `always` e um índice das tags, e o [[mem-rules]] imprime as regras completas de um tipo de tarefa quando o Claude começa uma.

## How it does it
Cada princípio é aplicado por um teste ou uma tarefa de integração contínua citada no CLAUDE.md do repositório, de modo que as decisões são verificadas e não apenas escritas.

## Where it sits in the pipeline
Por trás de toda regra deste wiki sobre quem pode fazer o quê.

## Who receives its output
Todas as instâncias do Claude e o Giovanni.
