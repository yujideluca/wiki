---
id: checker-catalog
lang: pt-BR
source_hash: 9121c9534379
title: Catálogo de todos os verificadores e quais projetos os usam
---

## What it is
Um verificador é qualquer teste, varredura ou limite automático que pode fazer uma alteração falhar. Esta página lista cada verificador compartilhado uma vez, diz o que ele procura e mostra quais dos 13 projetos o usam. Os termos (gate, rastreabilidade, mutação, função de fitness) estão explicados em [[quality-gate-explained]]. Regras que pertencem a um só projeto estão na página dele, alcançável a partir de [[code-security-pipeline]].

## What it does
Verificadores compartilhados (rodados pelo [[pipeline-check]]):
- **Gate do projeto**: roda `tools/quality_gate.sh` uma vez (todos os projetos).
- **Rastreabilidade de requisitos** (`--traceability`, [[check-traceability]]): usada por [[checks-quizapp]], [[checks-wiki]], [[checks-pipeline-check]], [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-radiology-crawler]], [[checks-status-quo]] e [[checks-project-template]]. Não é usada por [[checks-quizweb]] (suas promessas estão na lista do QuizApp e são lidas dos testes web, veja abaixo), [[checks-workflow-memory]], [[checks-remote-terminal]] nem [[checks-processing-sketches]].
- **Limites de fitness** (`[[fitness]]` em `pipeline-check.toml`): um teto de linhas de cada arquivo-fonte (`max_file_lines`), de tamanho de um arquivo nomeado (`file_size`, usado para o APK, o pacote Android, em [[checks-quizapp]]) ou de duração do gate (`gate_seconds`), com aviso a partir de 80 % e falha em 100 %. Todo projeto exceto [[checks-pipeline-check]] define pelo menos o teto de duração do gate (300 s em [[checks-quizweb]], [[checks-workflow-memory]], [[checks-remote-terminal]] e [[checks-processing-sketches]]; 1200 s nos demais).
- **Imports de arquitetura** (`[architecture]`): pacotes proibidos nas pastas puras. Ativo só em [[checks-quizapp]] (`core/src` não pode importar `android` nem `androidx`) e [[checks-codex-pbar]] (`src/codex_pbar` não pode importar `requests`, `urllib` nem `socket`).
- **ShellCheck** (`[shellcheck]`): 12 projetos listam `tools/hooks/pre-push` ([[checks-pipeline-check]] lista `consumer/pre-push`); todo arquivo `.sh` rastreado pelo git também é verificado.
- **Estado do GitHub** (`[github]`, só no modo local): última execução de CI verde e proteção de branch exigindo o job ([[branch-protection-explained]]). Configurado em [[checks-quizapp]], [[checks-quizweb]] (job `test`), [[checks-wiki]], [[checks-workflow-memory]] e [[checks-codex-pbar]] (ambos com exceção), [[checks-machine-bootstrap]], [[checks-remote-terminal]], [[checks-processing-sketches]] e [[checks-status-quo]] (sem exceção; o repositório privado não pode exigir o job no plano gratuito do GitHub, então a verificação de proteção deve continuar falhando ali, seu estado exato no relatório não foi verificado); ausente nos outros.
- **Números DORA** (`[dora]`): métricas de entrega a partir do git, informadas mas nunca com falha; definidas em nove projetos.
- **Guarda de pre-push** (`[pre_push]`, [[branch-protection-explained]]): todo projeto exceto [[checks-pipeline-check]].

Verificadores dentro do gate de cada projeto:
- **Verificação de mutação**: [[mutation-check]] em [[checks-quizapp]] (`tools/mutation_check.py`, só com `tools/quality_gate.sh --mutation` e na execução semanal da CI), `mutants.py` em [[checks-pipeline-check]], `tools/mutation_check.py` em [[checks-codex-pbar]] e [[checks-codex-skills]].
- **Limiares de cobertura**: 90 % das linhas nos pacotes de lógica e nenhum arquivo abaixo de 80 % em [[checks-quizapp]]; pelo menos 85 % em [[checks-codex-pbar]].
- **Regras de conteúdo**: `wiki check` em [[checks-wiki]]; o validador de eventos em [[checks-workflow-memory]]; `mb scan` em [[checks-machine-bootstrap]]; `skillsctl check` em [[checks-codex-skills]]; `content_manifest.py --check` no gate de [[checks-quizapp]] (a verificação de sincronia com a web roda no `promote`, não no gate).
- **Dependências declaradas**: `check_dependencies.py` em [[checks-radiology-crawler]].
- **Regras de Rust e teste de desktop**: [[checks-status-quo]] roda formatação, Clippy (o linter de Rust) com avisos proibidos, os testes do workspace, seu próprio detector de limites `tools/rust_architecture.rs` e verificador de recursos `tools/resource_check.rs` (cada um com autoteste), a rastreabilidade com a checagem de que `docs/TRACEABILITY.md` está commitado atualizado e o limite de fitness. Um passo 6 opcional roda o teste de ponta a ponta do desktop `tools/ui_e2e.sh`, só quando `STATUS_QUO_E2E=1` está definido e a tela é declarada livre com `STATUS_QUO_E2E_SCREEN_IS_FREE=1`; sem isso o gate o pula.

## How it does it
`pipeline-check.toml` decide quais seções existem; um projeto sem a seção simplesmente não recebe aquele verificador. Uma `falha` faz a execução falhar, um `aviso` não, e uma verificação que não pôde rodar é `pulado`. [[security-layers]] agrupa os verificadores que protegem contra vazamentos.

## Where it sits in the pipeline
Fica ao lado de [[quality-gate-explained]] no passo 3 de [[code-security-pipeline]].

## Who receives its output
Leitores que querem saber "qual verificação protege isto?" e o skill [[skill-revisao-manutencao]], que lê os mesmos números.
