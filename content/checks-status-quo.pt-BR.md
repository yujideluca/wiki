---
id: checks-status-quo
lang: pt-BR
source_hash: 438a9c36dc16
title: status-quo: verificadores e regras
---

## What it is
Estes são os verificadores do repositório `status-quo` (veja [[status-quo-design]] e [[status-quo-layout]]), um workspace Rust iniciado a partir de [[project-template]]. Ele está no repositório privado `yujideluca/status-quo` no GitHub. A execução de integração contínua do primeiro commit passou em 2026-11-02; a proteção de branch não pode ser ativada em repositório privado no plano gratuito, então a verificação `protecao-de-branch` continua falhando.

## What it does
O gate (`tools/quality_gate.sh`) executa cinco etapas em ordem: formatação Rust (`cargo fmt --check`), diagnósticos do compilador sem avisos permitidos (clippy) junto com toda a suíte de testes, uma verificação de fronteiras própria do projeto (`tools/rust_architecture.rs`), rastreabilidade de requisitos e o limite de fitness para a duração do gate (1200 segundos). Em 2026-11-02 as cinco passaram.

A verificação de fronteiras existe porque o verificador compartilhado (`pipeline-check` v0.4.0) só examina Java e Kotlin. Ela rejeita dependências gráficas, de arquivo, de processo ou de rede nos três pacotes portáteis, permite apenas a biblioteca de interface egui na bandeja reutilizável e tem autotestes próprios que plantam defeitos e exigem que sejam rejeitados. Todos os 27 requisitos (grupo SQ) em `docs/REQUIREMENTS.md` têm um teste marcado com um comentário isolado `// REQ SQ-n`; a varredura cobre arquivos `.rs` em `crates` e `tools`. Uma marca prova que existe um teste, não que o desktop real se comporta corretamente; empilhamento de janelas, início no login e limites de recursos exigem observação separada (a CPU ociosa está em 2,05% de um núcleo contra uma meta de 1%).

## How it does it
O CI (integração contínua) usa o workflow padrão (`pipeline-check --mode ci`, no máximo 60 minutos) e acrescenta uma compilação para navegador no alvo `wasm32`. O `pipeline-check.toml` nomeia o projeto, aponta para o repositório `yujideluca/status-quo`, exige a verificação `gate` em `main` e lista `tools/hooks/pre-push` para o verificador de shell. Existem quatro ADRs (registros de decisão de arquitetura): 0001 (registrar decisões), 0002 (widgets Rust portáteis), 0003 (o programa mede, a skill julga) e 0004 (camada de compatibilidade de host).

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias comuns estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
