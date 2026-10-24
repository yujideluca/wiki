---
id: skills
lang: pt-BR
source_hash: 9b0e6662b48a
title: Skills
---

## What it is
As skills do Claude do Giovanni: instruções empacotadas que o Claude carrega quando aparece uma tarefa daquele tipo. As cópias locais do Claude Code ficam em `~/.claude/skills`; o app do Claude tem as suas próprias ([[claude-ai-skills]]).

## What it does
Registram como o Giovanni quer as tarefas recorrentes: treino de alemão, respostas clínicas, análise de artigos, candidaturas na Alemanha, Magic: The Gathering, segurança no navegador, conserto do notebook e o processo de desenvolvimento (brainstorming, depuração, verificação, criação de skills).

## How it does it
Cada skill é uma pasta com um `SKILL.md` (nome, uma descrição que decide quando ela é acionada, e as instruções). Skills novas ou refeitas passam pela [[skill-skill-forge]]. A pasta era preenchida pelo fluxo aposentado ([[retired-workflow-pipeline]]); hoje são pastas de verdade.

## Where it sits in the pipeline
Ao lado de cada tarefa: a instância do Claude carrega uma skill quando a descrição dela combina com o pedido.

## Who receives its output
O [[claude-code]], o [[remote-assistant]] e (pelas cópias) o [[claude-app]].

## Notes
- [[skill-brainstorming]]
- [[skill-systematic-debugging]]
- [[skill-verification-before-completion]]
- [[skill-adb-android-control]]
- [[skill-skill-forge]]
- [[skill-revisao-manutencao]]
- [[skill-gerar-teste-automatizado]]
- [[skill-alemao-goethe-fsp]]
- [[skill-consulta-clinica]]
- [[skill-analise-artigo-cientifico]]
- [[skill-candidatura-alemanha]]
- [[skill-bias-risk-triage]]
- [[skill-browser-automacao-segura]]
- [[skill-click-protocol]]
- [[skill-minimize-site-approvals]]
- [[skill-ligamagic-listas]]
- [[skill-ligamagic-replicar-carrinho-nas-lojas]]
- [[skill-regras-magic]]
- [[skill-reparo-kubuntu]]
