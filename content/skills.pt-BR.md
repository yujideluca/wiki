---
id: skills
lang: pt-BR
source_hash: 9c6d93a525ca
title: Skills
---

## What it is
Uma skill é um conjunto empacotado de instruções que o Claude carrega quando surge uma tarefa desse tipo ([documentação de skills](https://docs.claude.com/en/docs/claude-code/skills)). Pense nela como um capítulo de um livro de receitas que o Claude lê só quando o pedido combina: um capítulo sobre corrigir alemão, outro sobre depuração, outro sobre conserto do notebook. Cada skill é uma pasta com um arquivo `SKILL.md`: primeiro um nome, depois uma "descrição" que decide quando a skill é carregada, depois as instruções. As skills do Giovanni ficam em `~/.claude/skills`; o app Claude tem cópias próprias ([[claude-ai-skills]]).

## What it does
As skills registram como o Giovanni quer que tarefas recorrentes sejam feitas: treino de alemão, respostas clínicas, avaliação de artigos científicos, candidaturas à Alemanha, Magic: The Gathering, automação segura do navegador, conserto do notebook e o processo de desenvolvimento (brainstorming, depuração, verificação, revisões de manutenção, criação de testes e criação de skills). Cada skill tem uma página neste wiki que contém sua própria definição, então nunca é preciso abrir o arquivo `SKILL.md` para entendê-la.

## How it does it
O Claude vê a lista de nomes e descrições em toda conversa; quando um pedido combina com uma descrição, carrega o texto completo dessa skill e o segue. Skills novas ou refeitas passam pela [[skill-skill-forge]]. A pasta foi um dia preenchida pelo pipeline desativado ([[retired-workflow-pipeline]]); as skills agora são pastas comuns.

## Where it sits in the pipeline
Ao lado de toda tarefa: uma skill é carregada pela instância do Claude quando sua descrição combina com o pedido.

## Who receives its output
O [[claude-code]], o [[remote-assistant]] e, por suas cópias, o [[claude-app]].

## Notes
- [[skill-brainstorming]]
- [[skill-systematic-debugging]]
- [[skill-verification-before-completion]]
- [[skill-adb-android-control]]
- [[skill-skill-forge]]
- [[skill-wiki-page-writer]]
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

As 20 skills mantidas localmente têm cópias instaladas separadas do Claude e do Codex, em `~/.claude/skills` e `~/.agents/skills`. Suas páginas agora mantêm os dois arquivos `SKILL.md` originais completos em Notes, junto das explicações traduzidas. Isso inclui toda a descrição do cabeçalho e as instruções, em vez de apenas um resumo dos gatilhos. Arquivos auxiliares citados não ficam embutidos. A regra de fontes completas e suas verificações são descritas em [[wiki-content]] e [[wiki-skill-source]].


As adaptações próprias do Codex ficam em [[codex-skills]] e são instaladas por [[codex-skillsctl]]. As skills de documentos dos fornecedores continuam sob a manutenção deles. A lista abaixo reúne cada adaptação com sua fonte completa.

| Skill | Version |
|---|---|
| [[skill-adb-android-control]] | Codex |
| [[skill-alemao-goethe-fsp]] | Codex |
| [[skill-analise-artigo-cientifico]] | Codex |
| [[skill-bias-risk-triage]] | Codex |
| [[skill-brainstorming]] | Codex |
| [[skill-browser-automacao-segura]] | Codex |
| [[skill-candidatura-alemanha]] | Codex |
| [[skill-click-protocol]] | Codex |
| [[skill-consulta-clinica]] | Codex |
| [[skill-deutsch-gespraech-memory]] | Codex |
| [[skill-gerar-teste-automatizado]] | Codex |
| [[skill-google-workspace]] | Codex |
| [[skill-gui-code-protocol]] | Codex |
| [[skill-import-memory]] | Codex |
| [[skill-ligamagic-listas]] | Codex |
| [[skill-ligamagic-replicar-carrinho-nas-lojas]] | Codex |
| [[skill-minimize-site-approvals]] | Codex |
| [[skill-morning]] | Codex |
| [[skill-regras-magic]] | Codex |
| [[skill-reparo-kubuntu]] | Codex |
| [[skill-revisao-manutencao]] | Codex |
| [[skill-setup-writing-style]] | Codex |
| [[skill-skill-forge]] | Codex |
| [[skill-systematic-debugging]] | Codex |
| [[skill-verification-before-completion]] | Codex |
| [[skill-wiki-page-writer]] | Codex |
