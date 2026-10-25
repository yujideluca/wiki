---
id: codex-skillsctl
title: Codex skills manager
lang: pt-BR
source_hash: 3b08da2cc882
---

## What it is
Um comando Python para verificar, instalar e restaurar os arquivos de skills de [[codex-skills]]. Gerencia arquivos e vínculos; não executa as skills.

## What it does
Mantém 26 adaptações, fontes originais completas e impressões digitais dos arquivos. Uma impressão digital é um valor calculado para detectar mudanças. Informa mudanças nas fontes sem sobrescrever as adaptações. Skills de documentos de fornecedores continuam sob os responsáveis anteriores.

## How it does it
Repositório: `yujideluca/codex-skills`; pasta: `~/dev/codex-skills`. Python verifica e instala com possibilidade de reversão por [[codex-skillsctl]]. A verificação de qualidade, um comando que decide se a mudança passa, é `tools/quality_gate.sh`; o GitHub a executa a cada envio. Comece por README.md e AGENTS.md.

## Where it sits in the pipeline
As fontes Claude passam por revisão manual e as pastas Codex seguem para o instalador. [[skills]] lista as instruções adaptadas.

## Who receives its output
O Codex lê as skills instaladas. A pessoa usuária recebe resultados e informações sobre capacidades ausentes.

## Notes

Os comandos e a reversão estão no README.md. Os recibos de instalação ficam fora do controle de versões. Capacidades ausentes de navegador, Google ou agendamento continuam sendo limitações explícitas.

[[skill-adb-android-control]], [[skill-alemao-goethe-fsp]], [[skill-analise-artigo-cientifico]], [[skill-bias-risk-triage]], [[skill-brainstorming]], [[skill-browser-automacao-segura]], [[skill-candidatura-alemanha]], [[skill-click-protocol]], [[skill-consulta-clinica]], [[skill-deutsch-gespraech-memory]], [[skill-gerar-teste-automatizado]], [[skill-google-workspace]], [[skill-gui-code-protocol]], [[skill-import-memory]], [[skill-ligamagic-listas]], [[skill-ligamagic-replicar-carrinho-nas-lojas]], [[skill-minimize-site-approvals]], [[skill-morning]], [[skill-regras-magic]], [[skill-reparo-kubuntu]], [[skill-revisao-manutencao]], [[skill-setup-writing-style]], [[skill-skill-forge]], [[skill-systematic-debugging]], [[skill-verification-before-completion]], [[skill-wiki-page-writer]]
