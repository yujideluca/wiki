---
id: checks-codex-pbar
lang: pt-BR
source_hash: c09b03d3d9fd
title: codex-pbar: verificadores e regras
---

## What it is
Estes são os verificadores do [[codex-pbar]], um programa em Python que mostra um rodapé de progresso permanente para o Codex no terminal.

## What it does
O gate roda: os testes unitários sob `coverage`, com medição de ramos dos módulos core e reader, que falham abaixo de 85 % (`--fail-under=85`); uma verificação de mutação própria do projeto (`tools/mutation_check.py`) que injeta falhas, como trocar códigos de cor do terminal ou a configuração do mouse, em cópias temporárias do código; um teste de fumaça que inicia a janela do aplicativo sem tela e salva `build/window.png`, com uma pasta Codex descartável para não tocar nos dados reais; rastreabilidade de requisitos (os requisitos PB); e os limites de fitness. Regra de arquitetura: `src/codex_pbar` não pode importar `requests`, `urllib` nem `socket` (nenhum código de rede). O gate pode levar 1200 segundos.

## How it does it
A CI (integração contínua) instala os extras de teste com pip e roda `pipeline-check --mode ci` (no máximo 60 minutos). O repositório é privado no plano gratuito, então a proteção de branch não está disponível: `protection_exception` registra isso e a verificação local de pre-push faz o papel ([[branch-protection-explained]]). Cinco ADRs descrevem suas escolhas.

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
