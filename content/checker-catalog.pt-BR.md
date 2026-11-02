---
id: checker-catalog
lang: pt-BR
source_hash: 49651e8fe928
title: Catálogo de todos os verificadores e quais projetos os usam
---

## What it is
Um verificador é qualquer teste, varredura ou limite automático que pode fazer uma alteração falhar. Esta página lista cada verificador compartilhado uma vez, diz o que ele procura e mostra quais dos 13 projetos o usam. Os termos (gate, rastreabilidade, mutação, função de fitness) estão explicados em [[quality-gate-explained]]. Regras que pertencem a um só projeto estão na página dele, alcançável a partir de [[code-security-pipeline]].

## What it does
Verificadores compartilhados (rodados pelo [[pipeline-check]]):
- **Gate do projeto**: roda `tools/quality_gate.sh` uma vez (todos os projetos).
- **Rastreabilidade de requisitos** (`--traceability`, [[check-traceability]]): usada por [[checks-quizapp]], [[checks-wiki]], [[checks-pipeline-check]], [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-radiology-crawler]], [[checks-status-quo]] e [[checks-project-template]]. Não é usada por [[checks-quizweb]] (suas promessas estão na lista do QuizApp e são lidas dos testes web, veja abaixo), [[checks-workflow-memory]], [[checks-remote-terminal]] nem [[checks-processing-sketches]].
- **Limites de fitness** (`[[fitness]]` em `pipeline-check.toml`): um teto de tamanho de arquivo, de tamanho do APK ou de duração do gate, com aviso a partir de 80 % e falha em 100 %. Todo projeto exceto [[checks-pipeline-check]] define pelo menos o teto de duração do gate (300 s em [[checks-quizweb]], [[checks-workflow-memory]], [[checks-remote-terminal]] e [[checks-processing-sketches]]; 1200 s nos demais).
- **Imports de arquitetura** (`[architecture]`): pacotes proibidos nas pastas puras. Ativo só em [[checks-quizapp]] (`core/src` não pode importar `android` nem `androidx`) e [[checks-codex-pbar]] (`src/codex_pbar` não pode importar `requests`, `urllib` nem `socket`).
- **ShellCheck** (`[shellcheck]`): os 13 projetos listam pelo menos `tools/hooks/pre-push`; todo arquivo `.sh` rastreado pelo git também é verificado.
- **Estado do GitHub** (`[github]`, só no modo local): última execução de CI verde e proteção de branch exigindo o job ([[branch-protection-explained]]). Configurado em [[checks-quizapp]], [[checks-quizweb]] (job `test`), [[checks-wiki]], [[checks-workflow-memory]] e [[checks-codex-pbar]] (ambos com exceção), [[checks-machine-bootstrap]], [[checks-remote-terminal]] e [[checks-processing-sketches]]; ausente nos outros.
- **Números DORA** (`[dora]`): métricas de entrega a partir do git, informadas mas nunca com falha; definidas em nove projetos.
- **Guarda de pre-push** (`[pre_push]`, [[branch-protection-explained]]): todo projeto exceto [[checks-pipeline-check]].

Verificadores dentro do gate de cada projeto:
- **Verificação de mutação**: [[mutation-check]] em [[checks-quizapp]] (`tools/mutation_check.py`, também semanal na CI), `mutants.py` em [[checks-pipeline-check]], `tools/mutation_check.py` em [[checks-codex-pbar]] e [[checks-codex-skills]].
- **Limiares de cobertura**: 90 % das linhas nos pacotes de lógica e nenhum arquivo abaixo de 80 % em [[checks-quizapp]]; pelo menos 85 % em [[checks-codex-pbar]].
- **Regras de conteúdo**: `wiki check` em [[checks-wiki]]; o validador de eventos em [[checks-workflow-memory]]; `mb scan` em [[checks-machine-bootstrap]]; `skillsctl check` em [[checks-codex-skills]]; `content_manifest.py --check` e a verificação de sincronia em [[checks-quizapp]].
- **Dependências declaradas**: `check_dependencies.py` em [[checks-radiology-crawler]].

## How it does it
`pipeline-check.toml` decide quais seções existem; um projeto sem a seção simplesmente não recebe aquele verificador. Uma `falha` faz a execução falhar, um `aviso` não, e uma verificação que não pôde rodar é `pulado`. [[security-layers]] agrupa os verificadores que protegem contra vazamentos.

## Where it sits in the pipeline
Fica ao lado de [[quality-gate-explained]] no passo 3 de [[code-security-pipeline]].

## Who receives its output
Leitores que querem saber "qual verificação protege isto?" e o skill [[skill-revisao-manutencao]], que lê os mesmos números.
