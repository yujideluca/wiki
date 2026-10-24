---
id: skill-gerar-teste-automatizado
lang: pt-BR
source_hash: 866037e1feec
title: Skill: gerar-teste-automatizado
aliases: [gerar-teste-automatizado]
---

## What it is
A skill que cria, e depois atualiza, a suíte de testes automatizados que caça bugs reais em um projeto.

## What it does
Modo criar (ainda sem `docs/TESTES-AUTOMATIZADOS.md`): diagnóstico completo do código, matriz de testes ligada aos requisitos, testes cujos resultados esperados são independentes do código, e depois verificações de que os testes detectam defeitos (teste de mutação, cobertura, execuções repetidas). Modo atualizar: lê o registro e a suíte, encontra o que mudou desde o commit citado e atualiza os dois. Nunca altera código de produção para os testes passarem e propõe qualquer correção à parte.

## How it does it
Um `SKILL.md` em `~/.claude/skills/gerar-teste-automatizado`, baseado em um prompt escrito pelo Giovanni. O registro `docs/TESTES-AUTOMATIZADOS.md` é a marca de que a suíte existe.

## Where it sits in the pipeline
Chamada pela [[skill-revisao-manutencao]] no passo 4 de toda revisão.

## Who receives its output
O Giovanni (defeitos encontrados, riscos residuais) e as pastas de teste do projeto.
