---
id: checks-project-template
lang: pt-BR
source_hash: e4d01b793367
title: project-template: verificadores e regras
---

## What it is
Estes são os verificadores que o [[project-template]] entrega a todo projeto novo. São a linha de base da qual as outras páginas de projeto se diferenciam.

## What it does
O gate do modelo tem três passos: um espaço para build e testes (`TODO`, a preencher), rastreabilidade de requisitos com a matriz commitada (o modelo tem um requisito de exemplo, `XX-1`) e os limites de fitness, terminando com o teto de 1200 segundos para o gate ([[template-quality-gate]]). Seu `pipeline-check.toml` traz exemplos comentados de cada seção opcional (tamanho de arquivo, GitHub, DORA, guarda de pre-push, pastas de rastreabilidade, ShellCheck). DORA significa DevOps Research and Assessment. Princípios: primeiro o requisito, depois o teste, depois o código; lógica livre de framework; o gate decide; ferramentas compartilhadas são consumidas por versão fixada; decisões ficam onde está o código.

## How it does it
Um projeto novo copia a pasta, preenche os espaços e fixa uma versão em `pipeline-check.version` ([[new-project]]). Dois ADRs (registros de decisão de arquitetura) acompanham o modelo: 0001 (registrar decisões como ADRs) e 0003 (o programa mede, um skill julga); o 0002 fica para a escolha da tecnologia ([[adr-explained]]).

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
