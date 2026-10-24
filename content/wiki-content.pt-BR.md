---
id: wiki-content
lang: pt-BR
source_hash: 0f8ca2dbbce9
title: Conteúdo do wiki (páginas Markdown)
---

## What it is
São as próprias páginas: a fonte da verdade deste wiki. Há um arquivo [Markdown](https://en.wikipedia.org/wiki/Markdown) (um arquivo de texto com marcas simples para títulos, listas e links) por conceito na pasta `content/`, em inglês, com uma versão em alemão `<id>.de.md` e uma em português do Brasil `<id>.pt-BR.md`. Mais dois arquivos guardam configurações: `_kinds.json`, a lista aberta de tipos de página e suas cores, e `_acronyms.tsv`, a lista de siglas cujo primeiro uso em uma página deve vir com o nome completo.

## What it does
Cada página tem um cabeçalho (`id, title, aliases, kind, project, status, location, fed_by, feeds, sources, memory, since, until, reviewed`) e seções fixas: What it is, What it does, How it does it, Where it sits in the pipeline, Who receives its output, mais, opcionalmente, Steps (para processos e skills), Functions e Notes.

As regras de escrita são estas: toda página deve ser compreensível para quem não sabe nada do sistema; um termo técnico é definido onde aparece pela primeira vez e, quando é complexo, aponta para uma definição (uma fonte externa ou o [[glossary]]); uma sigla é escrita por extenso no primeiro uso em cada página; e uma página de skill traz a definição da própria skill na seção Steps, de modo que a página basta para entender a skill.

## How it does it
Os links entre páginas são escritos `[[id]]`. Os cabeçalhos `fed_by` e `feeds` são as arestas do pipeline (o que alimenta o quê) e devem concordar nos dois sentidos. `sources` são escritos `repo:path`, para que uma mudança no código possa marcar a página como desatualizada. Uma tradução guarda um hash (uma impressão digital curta) do texto em inglês de que foi feita, então uma tradução desatualizada é detectada. As páginas dizem o que existe; regras e preferências ficam na memória e são ligadas pelo `#code`.

## Where it sits in the pipeline
Escrito pelo [[claude-code]] no fim de cada tarefa ([[end-of-task]]); verificado pelo [[wiki-check]]; transformado em dados pelo [[wiki-build]].

## Who receives its output
O [[wiki-check]] e o [[wiki-build]].
