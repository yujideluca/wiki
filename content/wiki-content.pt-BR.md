---
id: wiki-content
lang: pt-BR
source_hash: 1a821c508079
title: Conteúdo do wiki (páginas Markdown)
---

## What it is
São as próprias páginas: a fonte da verdade deste wiki. Há um arquivo [Markdown](https://en.wikipedia.org/wiki/Markdown) (um arquivo de texto com marcas simples para títulos, listas e links) por conceito na pasta `content/`, em inglês, com uma versão em alemão `<id>.de.md` e uma em português do Brasil `<id>.pt-BR.md`. Mais três arquivos guardam configurações: `_kinds.json`, a lista aberta de tipos de página e suas cores; `_acronyms.tsv`, a lista de siglas cujo primeiro uso em uma página deve vir com o nome completo; e `_ignore.txt`, as pastas de dados que o hook Stop não vigia arquivo por arquivo ([[wiki-hook-stop]]).

## What it does
Cada página tem um cabeçalho (`id, title, aliases, kind, project, status, location, fed_by, feeds, sources, memory, since, until, reviewed`) e seções fixas: What it is, What it does, How it does it, Where it sits in the pipeline, Who receives its output, mais, opcionalmente, Steps (para processos e skills), Functions e Notes. O campo `reviewed` é obrigatório em toda página: diz quando a página foi comparada com suas fontes pela última vez, como data e minuto em UTC (tempo universal coordenado, o mesmo horário em qualquer lugar), por exemplo `2026-10-24T18:30Z`, ou só como data (o início desse dia), e nunca está no futuro. Só quem de fato comparou a página com suas fontes o define.

As regras de escrita são estas: toda página deve ser compreensível para quem não sabe nada do sistema; um termo técnico é definido onde aparece pela primeira vez e, quando é complexo, aponta para uma definição (uma fonte externa ou o [[glossary]]); uma sigla é escrita por extenso no primeiro uso em cada página; e uma página de skill traz a definição da própria skill na seção Steps, de modo que a página basta para entender a skill.

## How it does it
Os links entre páginas são escritos `[[id]]`. Os cabeçalhos `fed_by` e `feeds` são as arestas do pipeline (o que alimenta o quê) e devem concordar nos dois sentidos. `sources` são escritos `repo:path`, para que uma fonte que mudou depois do `reviewed` da página marque a página como desatualizada ([[wiki-stale]]). Uma tradução guarda um hash (uma impressão digital curta) do texto em inglês de que foi feita, então uma tradução desatualizada é detectada. As páginas dizem o que existe; regras e preferências ficam na memória e são ligadas pelo `#code`.

## Where it sits in the pipeline
Escrito pelo [[claude-code]] no fim de cada tarefa ([[end-of-task]]); verificado pelo [[wiki-check]]; transformado em dados pelo [[wiki-build]]. É publicado com `wiki publish`; a sessão informa a própria linha `--co-author "Name <email>"`, ou nenhuma ([[wiki-cli]]).

## Who receives its output
O [[wiki-check]] e o [[wiki-build]].

## Notes

Para uma página do tipo `skill`, quem escreve primeiro localiza e lê o `SKILL.md` instalado inteiro. A página mantém a explicação legível e os passos e inclui em Notes o arquivo original completo: a descrição do cabeçalho, todas as instruções, exemplos, limites e caminhos de referências. Arquivos distintos do Claude e do Codex são copiados separadamente. As páginas em alemão e português mantêm os mesmos originais, com introduções em seus próprios idiomas. Um resumo ou link sozinho não cumpre esta regra. Arquivos auxiliares citados não são incluídos automaticamente. Cada fonte aparece em `sources`; sua cópia em bloco de código leva uma impressão digital SHA-256 (um valor calculado a partir de todo o texto para detectar mudanças). A cópia usa finais de linha LF e acrescenta uma quebra de linha final se faltar no original. O [[wiki-skill-source]] valida as cópias; `wiki check --local` as compara com os arquivos instalados. A regra do projeto fica em `AGENTS.md`, é ligada pelo `CLAUDE.md` e se repete na [[skill-wiki-page-writer]] e no lembrete do [[wiki-hook-stop]].
