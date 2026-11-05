---
id: adr-explained
lang: pt-BR
source_hash: dda5a9ec4437
title: ADRs e o log de decisões explicados
---

## What it is
Um ADR (registro de decisão de arquitetura, do inglês architecture decision record) é uma nota curta que registra uma decisão importante: o contexto, a decisão, as alternativas consideradas e as consequências ([adr.github.io](https://adr.github.io/)). Ele responde à pergunta que um leitor futuro sempre tem: "por que foi construído assim?". Uma decisão que mexe na estrutura de um projeto ganha um ADR; uma menor ganha uma linha no log de decisões, uma tabela no `DESIGN.md`.

## What it does
Cada ADR é um arquivo Markdown numerado em `docs/adr/`, com status, data, o tipo de manutenção da norma ISO/IEC/IEEE 14764 (inicial, corretiva, adaptativa, perfectiva ou preventiva; veja [[maintenance-policy]]) e quem decidiu. O ADR-0001 de todo projeto é "registrar decisões como ADRs"; `0000-template.md` é o formulário em branco. A mesma decisão compartilhada aparece em cada repositório com número próprio: "o programa mede, um skill julga" é 0013 em [[quizapp-adrs]], 0005 na wiki, 0004 no workflow-memory, 0002 no pipeline-check e 0003 nos demais projetos. Número de ADRs por projeto: QuizApp 13, wiki 9, workflow-memory 7, codex-pbar 5, machine-bootstrap 5, pipeline-check 3, codex-skills 3, radiology-crawler 3, e 2 no [[project-template]] e 2 no status-quo (0001 e 0003).

## How it does it
Nada verifica o texto do ADR em si. A regra "decisões ficam onde está o código" é um princípio no `CLAUDE.md` de cada projeto; a revisão mensal ([[monthly-architecture-review]]) procura decisões tomadas sem registro. Uma decisão dita só no chat não conta como registrada.

## Where it sits in the pipeline
É o último passo de [[code-security-pipeline]]: depois que uma alteração estrutural é aceita, o motivo dela é escrito. As listas por projeto estão nas páginas `checks-`, e a decisão compartilhada está descrita em [[maintenance-pipeline]].

## Who receives its output
Leitores futuros: [[giovanni]], sessões do Claude e a [[monthly-architecture-review]].
