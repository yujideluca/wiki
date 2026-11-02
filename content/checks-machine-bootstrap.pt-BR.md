---
id: checks-machine-bootstrap
lang: pt-BR
source_hash: 81d05f534430
title: machine-bootstrap: verificadores e regras
---

## What it is
Estes são os verificadores do [[machine-bootstrap]], a ferramenta que registra a configuração do laptop do Giovanni e a refaz em uma máquina nova. Um erro aqui pode vazar segredos ou destruir uma restauração, por isso tem as regras de privacidade mais estritas.

## What it does
O gate roda: os testes unitários (captura, configuração, plano, varredura, segredos, estado, notificação, backup de dados, bootstrap, prova em VM); ShellCheck em `bootstrap.sh`; `python3 -m mb scan`, que varre em busca de segredos todo arquivo em `state/`; rastreabilidade de requisitos (MB-1 a MB-16); e os limites de fitness (nenhum arquivo Python com mais de 300 linhas em `mb`, o gate com no máximo 1200 segundos). Regras: o planejamento é puro e só o `execute` com um executor altera o sistema; nada secreto vai para o git (lista de permissão mais scanner, ADR-0004, registro de decisão de arquitetura); segredos passam só pelo arquivo criptografado (ADR-0005); depois de mudar uma receita, o `plan.py` ou o `bootstrap.sh`, a restauração inteira é provada em uma máquina virtual limpa com `tools/vm-test.sh` (cerca de uma hora) e o resultado vai para o log de decisões (MB-15). Testes unitários provam lógica; só a VM prova uma restauração.

## How it does it
A CI (integração contínua) roda `pipeline-check --mode ci` (no máximo 60 minutos). O repositório é público, e o log de decisões registra que o job de CI `gate` é exigido na `main`, inclusive de administradores, e que force pushes e exclusão de branches são recusados (2026-10-26). Existem cinco ADRs.

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
