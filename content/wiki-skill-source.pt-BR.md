---
id: wiki-skill-source
lang: pt-BR
source_hash: 0af807178e15
title: Verificador de fontes completas de skills
---

## What it is
`Wiki.Content.SkillSource` é o módulo Elixir que verifica se uma página de skill contém seus arquivos originais de instruções completos. Uma skill é um conjunto de instruções para um tipo de tarefa. Seu `SKILL.md` contém a descrição usada na seleção e as instruções seguidas depois dela.

## What it does
Exige uma cópia completa de cada `SKILL.md` em `sources` numa página de skill. Verifica a impressão digital SHA-256 (um valor calculado a partir de todo o texto para detectar mudanças), descrição e instruções e originais idênticos nas duas traduções. No modo local, também lê os arquivos instalados e compara todo o texto. Erros impedem a publicação. Sem arquivos locais, a impressão digital não comprova a atualidade.

## How it does it
Quem escreve localiza e lê a fonte primeiro, seguindo a [[skill-wiki-page-writer]]. Copia o original em Notes num bloco de código identificado por `skill-source <repo:path/to/SKILL.md> <sha256>`. O delimitador é maior que qualquer sequência de crases no original. Os finais de linha viram LF, e uma quebra de linha final só é acrescentada se faltar. O leitor preserva títulos e exemplos aninhados da fonte como texto. As traduções mantêm os originais no idioma de origem. Arquivos auxiliares citados não são incluídos automaticamente. A verificação de privacidade continua lendo todo o texto copiado.

## Where it sits in the pipeline
Chamado pelo [[wiki-check]] para páginas de skills. O lembrete do [[wiki-hook-stop]] encaminha quem escreve para esta regra, definida no [[wiki-content]] e no `AGENTS.md` do projeto.

## Who receives its output
O [[wiki-check]] recebe os erros; o [[wiki-cli]] recusa publicar páginas que falham.

## Functions
- `check`: valida uma página de skill e suas traduções; lê os originais instalados somente no modo local.

## Notes

Uma página de skill é identificada por `kind: skill` no cabeçalho. Rode `wiki check --local` para ativar o modo local, que lê os arquivos instalados; um arquivo ilegível é um erro. Um caminho como `home:.agents/skills/example/SKILL.md` começa na pasta pessoal do usuário; `wiki:path` começa em `~/dev/wiki`, e outros nomes de repositórios começam na pasta correspondente em `~/dev`. As cópias ficam sob o título `## Notes` da página. As traduções são `<id>.de.md` (alemão) e `<id>.pt-BR.md` (português brasileiro); uma tradução ausente é um erro no verificador geral. LF significa Line Feed, o caractere de quebra de linha usado no texto copiado. As verificações de privacidade rejeitam segredos e dados de contato de outras pessoas, mesmo dentro das cópias. Verificações sem `--local` não leem originais instalados e não avisam sobre atualidade quando as impressões digitais conferem; passar nesse modo sozinho não comprova que a cópia está atualizada.
