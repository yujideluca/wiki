---
id: b2-vorlagen
lang: pt-BR
source_hash: 1fe4f89b73a1
title: Site de modelos de redação B2
---

## What it is
Uma única página web, "Goethe B2 Schreiben: texts that score 10", para o treino da parte de escrita (Schreiben) do Goethe-Zertifikat B2, uma prova de alemão como língua estrangeira. Ela é gerada a partir da pasta `~/dev/b2-vorlagen`. Uma "Vorlage" é um modelo: um texto cujas frases são fixas e cujas lacunas (chamadas slots) Giovanni preenche.

## Flow
trigger t1: Giovanni roda build/site.py
step s1: Os textos das tarefas e os valores dos slots são lidos dos arquivos em data/
step s2: Cada tarefa é encaixada no modelo de Forumsbeitrag ou de E-Mail
step s3: A página index.html é escrita e copiada para public/
product p1: Página com os 20 textos corrigidos e os 40 novos temas de prática

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> p1

## Architecture
### Context
person g: Giovanni — treina as tarefas de Schreiben | [[giovanni]]
system s: b2-vorlagen — gera uma página de prática

g -reads the page from-> s

### Containers
person g: Giovanni | [[giovanni]]
container bs: build/site.py — escreve a página
container tp: build/templates.py — os dois modelos
store dt: data/ — tarefas, valores dos slots e correções
store ev: eval/ — notas às cegas
store pg: index.html e public/index.html — a página

bs -reads-> tp
bs -reads-> dt
bs -reads-> ev
bs -writes-> pg
g -reads-> pg

## What it does
A página tem quatro partes: os dois modelos (Forumsbeitrag, uma postagem de fórum, e E-Mail formal) com um guia de cada slot; uma tabela de notas; as 20 tarefas que Giovanni já escreveu, cada uma com a tarefa, o texto dele, uma correção linha por linha e uma versão do modelo; e, desde 31/10/2026, 20 novos temas de Forumsbeitrag e 20 de E-Mail (seção 4). Os novos temas têm a tarefa e um texto-modelo feito a partir do modelo, mas nenhum texto de Giovanni, então não têm correção nem nota.

As notas são "notas às cegas": uma sessão separada de um modelo viu só os critérios, a tarefa e o texto. O build imprime as médias: 4,45 para os originais de Giovanni e 9,31 para as versões do modelo. São o julgamento de um modelo, não uma nota oficial do Goethe. Os novos temas não foram avaliados.

## How it does it
`python3 build/site.py` lê `data/` e `eval/` e escreve `index.html`; `public/index.html` é uma cópia. `build/templates.py` guarda cada modelo como frases marcadas como núcleo (sempre usadas) ou extra (só quando a tarefa pede mais); uma frase some quando um slot não tem valor. Exemplo: `Ehrlich gesagt bin ich der Ansicht, dass {MEINUNG_N}.` vira uma frase quando `MEINUNG_N` é dado. O nome do slot indica a gramática: `_N` é uma oração subordinada com o verbo no fim, `_H` uma oração principal com o verbo em segundo lugar, `_Z` um `zu` mais infinitivo.

Os novos temas ficam em `data/new_forum.py` e `data/new_mail.py`. Cada tarefa copia a forma de uma tarefa de prova: quatro pontos, um mínimo de palavras, saudação e despedida. Os links da página são verde-azulados (variável CSS `--lk`, contraste de cerca de 7:1 no tema claro e 10:1 no escuro).

## Where it sits in the pipeline
À parte dos outros projetos. Apoia o treino de alemão descrito em [[skill-alemao-goethe-fsp]]. Nada mais lê a saída dela.

## Who receives its output
Giovanni, que lê a página no navegador.

## Engineering practices
Como este projeto segue o caminho dourado de [[project-template]].

### Principles
Ainda não seguidos: a pasta não tem repositório git, portão de qualidade nem testes (verificado em 31/10/2026).

### Decisions
Sem registros de decisão.

### Requirements
Sem lista de requisitos.

### Quality gate
Ainda nenhum.

### Continuous integration
Ainda nenhuma.

### Maintenance
Não coberto pela [[monthly-architecture-review]]. Ainda não há repositório.

## Notes
Os textos-modelo dos novos temas foram escritos em uma sessão e conferidos só quanto à completude (todo slot preenchido) e ao tamanho (pelo menos 125 palavras num E-Mail e 224 num Forumsbeitrag, com as frases extras). Um falante nativo não revisou o alemão.
