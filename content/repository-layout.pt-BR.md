---
id: repository-layout
lang: pt-BR
source_hash: 192e5c0ecc59
title: Layout do repositório (o caminho dourado)
---

## What it is
Um repositório é uma pasta de projeto acompanhada pelo [Git](https://git-scm.com/), uma ferramenta que registra cada alteração. Todo projeto de software do Giovanni começa a partir do [[project-template]] e por isso tem o mesmo esqueleto. Quem conhece um projeto encontra as mesmas coisas em outro.

## What it does
O esqueleto tem estas partes:
- `CLAUDE.md` (e `AGENTS.md` para o Codex): os princípios e as regras de trabalho para o assistente, cada princípio ligado à verificação que o faz valer.
- `DESIGN.md`: diagramas do sistema e o log de decisões, uma tabela com uma linha por decisão e seu tipo de manutenção.
- `docs/adr/`: um arquivo por decisão estrutural ([[adr-explained]]).
- `docs/REQUIREMENTS.md`: as promessas do programa, cada uma com um ID como `PC-3`; `docs/TRACEABILITY.md` é a tabela gerada que liga cada ID aos seus testes ([[check-traceability]]).
- `docs/MAINTENANCE.md`: a política de dívida técnica ([[maintenance-policy]]).
- `tools/quality_gate.sh`: a única definição de "passou" ([[quality-gate-explained]]).
- `tools/pipeline-check.sh`, `pipeline-check.version` e `pipeline-check.toml`: o executor que busca o [[pipeline-check]] fixado, a versão que ele fixa e os limites que ele aplica.
- `tools/hooks/pre-push`: o substituto local da proteção de branch ([[branch-protection-explained]]).
- `.github/workflows/quality-gate.yml`: as verificações automáticas no GitHub ([[ci-explained]]).

## How it does it
Projetos novos copiam a pasta modelo; a página da wiki [[new-project]] descreve os passos. Nem todo projeto mais antigo tem todas as partes: [[checks-remote-terminal]] e [[checks-processing-sketches]] têm um gate mais leve, e [[checks-status-quo]] ainda carrega passos de gate de preenchimento.

## Where it sits in the pipeline
É a forma compartilhada a que as páginas de projeto em [[code-security-pipeline]] se referem.

## Who receives its output
Projetos novos e as verificações em [[checker-catalog]], que procuram esses arquivos pelo nome.
