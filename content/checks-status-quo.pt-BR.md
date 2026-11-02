---
id: checks-status-quo
lang: pt-BR
source_hash: 4aabc030f0c3
title: status-quo: verificadores e regras
---

## What it is
Estes são os verificadores do repositório `status-quo` (veja [[status-quo-design]] e [[status-quo-layout]]), um workspace Rust iniciado a partir de [[project-template]]. Ele está no repositório privado `yujideluca/status-quo` no GitHub. A execução de integração contínua do primeiro commit passou em 2026-11-02; a proteção de branch não pode ser ativada em repositório privado no plano gratuito, então a verificação `protecao-de-branch` continua falhando.

## What it does
O gate (`tools/quality_gate.sh`) executa cinco etapas em ordem: formatação Rust (`cargo fmt --check`), diagnósticos do compilador sem avisos permitidos (clippy) junto com toda a suíte de testes, uma verificação de fronteiras própria do projeto (`tools/rust_architecture.rs`), rastreabilidade de requisitos e o limite de fitness para a duração do gate (1200 segundos). Em 2026-11-02 as cinco passaram.

Uma sexta etapa opcional só roda quando a variável `STATUS_QUO_E2E=1` está definida: `tools/ui_e2e.sh`, o teste de ponta a ponta no desktop da bandeja real (pausa a bandeja ativa, controla uma cópia privada com um mouse virtual e escreve `build/e2e/report.json`). É opcional porque exige uma sessão Wayland, `/dev/uinput` com permissão de escrita e `spectacle`; por isso uma execução normal e a da integração contínua (CI, sem desktop) a deixam de fora, e o próprio script se pula com o motivo quando algo falta. O teste não faz parte da definição de passar em cinco etapas: complementa o gate verificando o que nenhum teste unitário consegue, e a seção 7 de `docs/MAINTENANCE.md` o pede antes de encerrar uma atualização grande da bandeja e antes de um release. Uma execução real em 2026-11-02 passou em 22 verificações. Sua verificação de CPU em repouso é um teto de 2%, enquanto a meta de 1% do SQ-23 (o requisito de custo em repouso) é registrada como dado e continua não atingida (1,30% de um núcleo). Detalhes: [[status-quo]].

A verificação de fronteiras existe porque o verificador compartilhado (`pipeline-check` v0.4.0) só examina Java e Kotlin. Ela rejeita dependências gráficas, de arquivo, de processo ou de rede nos três pacotes portáteis, permite apenas a biblioteca de interface egui na bandeja reutilizável e tem autotestes próprios que plantam defeitos e exigem que sejam rejeitados. Todos os 29 requisitos (grupo SQ; SQ-29 está na árvore de trabalho não commitada no momento da revisão) em `docs/REQUIREMENTS.md` têm um teste marcado com um comentário isolado `// REQ SQ-n`; a varredura cobre arquivos `.rs` em `crates` e `tools`. O texto do SQ-29 foi substituído em 2026-11-02 (Edit tray como tela livre, decisão ADR-0005 (registro de decisão de arquitetura), veja [[status-quo]]); sua marca está em `crates/core/tests/behavior.rs`, `crates/tray/src/layout.rs` e `crates/tray/tests/layout.rs`, e `docs/TRACEABILITY.md` lista `behavior.rs, layout.rs` para ele. O gate não foi executado para esta atualização da página. Uma marca prova que existe um teste, não que o desktop real se comporta corretamente; empilhamento de janelas, início no login e limites de recursos exigem observação separada (a CPU ociosa está em 2,05% de um núcleo contra uma meta de 1%).

## How it does it
O CI (integração contínua) usa o workflow padrão (`pipeline-check --mode ci`, no máximo 60 minutos) e acrescenta uma compilação para navegador no alvo `wasm32`. O `pipeline-check.toml` nomeia o projeto, aponta para o repositório `yujideluca/status-quo`, exige a verificação `gate` em `main` e lista `tools/hooks/pre-push` para o verificador de shell. Existem quatro ADRs (registros de decisão de arquitetura), além de um modelo em branco `docs/adr/0000-template.md`: 0001 (registrar decisões), 0002 (widgets Rust portáteis), 0003 (o programa mede, a skill julga) e 0004 (camada de compatibilidade de host).

Três documentos em `docs/` apoiam as verificações. `TRACEABILITY.md` é gerado por `pipeline-check --traceability`: uma linha por requisito com os arquivos de teste que levam sua marca (por exemplo, SQ-8 lista `lifecycle.rs`, `models.rs`, `workers.rs`). `TESTES-AUTOMATIZADOS.md`, escrito em português, é o registro dos testes que buscam defeitos: uma tabela de riscos (configuração, contrato, modelos de visão em `crates/widgets/tests/models.rs`, persistência, fontes, transporte, bandeja, verificador de fronteiras, reuso no navegador) contra o arquivo de teste e o comportamento esperado, depois as primeiras execuções de recursos de cinco minutos (2,05% de um núcleo, 115 MiB) e as observações da camada de compatibilidade de host. Ele afirma que nenhuma porcentagem de cobertura nem pontuação de mutação foi registrada; a única evidência do tipo mutação é uma execução do verificador de fronteiras com defeitos plantados. `MAINTENANCE.md` guarda o método do modelo para dívida, revisão mensal e `pipeline-check`.

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias comuns estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
