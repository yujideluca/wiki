---
id: radiology-report-matcher
lang: pt-BR
source_hash: beb2b2ad70dc
title: Radiology Report Matcher (site planejado)
---

## What it is
Um projeto para construir um site em que um radiologista digita o laudo em texto livre de um exame de imagem, informa qual foi o exame e a técnica, acrescenta os dados básicos do paciente e a história clínica e recebe de volta: uma lista ordenada de diagnósticos prováveis com as palavras do laudo que causaram cada um, links para artigos que explicam o caso e escores estruturados (um "escore estruturado" é um sistema fixo de pontos que transforma achados descritos em uma categoria de risco; o primeiro planejado é o ACR TI-RADS, um escore para nódulos de tireoide na ultrassonografia). A correspondência é só contagem e aritmética com palavras, não um modelo de inteligência artificial. Deve funcionar para laudos em inglês, alemão e português do Brasil. Giovanni pretende rodá-lo em um computador desktop comprado para isso, e ele pode se tornar uma ferramenta comercial no futuro.

Em 2026-10-27 existe apenas a parte de coleta de dados: um rastreador ([[radiopaedia-crawler]]) e um tradutor ([[report-translator]]). A busca, o cálculo dos escores e o site estão planejados, não construídos. O plano, com diagramas e um diário de desenvolvimento, é um site offline em `~/Documents/Radiology Report Matcher/`; o script `site_src/build.py` o reconstrói com números atuais do banco de dados.

## Flow
trigger t1: Giovanni pede o projeto e o próximo passo | [[claude-code]]
step s1: Baixar devagar as páginas do site de referência | [[radiopaedia-crawler]]
step s2: Traduzir cada página para alemão e português com o vocabulário dos livros-texto | [[report-translator]], [[codex]]
step s3: Montar tabelas de termos e um índice de busca a partir das páginas (planejado)
step s4: Comparar um laudo digitado com artigos e diagnósticos (planejado)
decide d1: O laudo descreve todas as características de um escore?
step s5: Calcular o escore a partir de uma tabela fixa de pontos (planejado)
step s6: Dizer qual característica falta, nunca adivinhar (planejado)
product p1: Sugestões ordenadas, links de artigos e escore em uma página web (planejado)
product p2: O site de plano offline com o diário de desenvolvimento

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -yes-> s5
d1 -no-> s6
s5 -> p1
s6 -> p1
t1 -> p2

## Architecture
### Context
person g: Giovanni — pede cada passo e lê o plano | [[giovanni]]
system s: Radiology Report Matcher — coleta, traduz e (depois) compara laudos
external r: Radiopaedia — o site de referência gratuito de onde vêm as páginas
external c: Codex — escreve as versões em alemão e português | [[codex]]
external b: Livros-texto de referência — guias de vocabulário em alemão e português

g -pede passos e lê o plano em-> s
s -baixa páginas de-> r
s -pede traduções a-> c
s -toma o vocabulário de-> b

### Containers
person g: Giovanni | [[giovanni]]
container cr: Rastreador — baixa e extrai as páginas | [[radiopaedia-crawler]]
container tr: Tradutor — versões em alemão e português | [[report-translator]]
container ps: Gerador do site de plano — reconstrói o site de plano offline
store raw: Páginas brutas — cópias comprimidas de cada página baixada
store db: Banco SQLite — urls, articles, cases, translations
store ix: Índice de trechos dos livros — trechos por pedaços de 4 letras
external r: Radiopaedia
external c: Codex | [[codex]]

g -inicia-> cr
g -lê o plano em-> ps
cr -baixa de-> r
cr -guarda cópias em-> raw
cr -grava linhas em-> db
tr -lê artigos e grava traduções em-> db
tr -encontra trechos dos livros em-> ix
tr -pede traduções a-> c
ps -lê contagens atuais de-> db

## What it does
Hoje ele coleta e prepara texto. O site planejado transformará um laudo digitado em observações (um achado, onde está, seu tamanho e se está presente, ausente, incerto ou antigo), vai compará-las com os artigos coletados usando BM25 (uma fórmula padrão que ordena um texto pelo número de palavras raras e informativas que ele compartilha com a consulta) e mostrará as evidências. Decisões já tomadas: a primeira versão cobre uma área estreita (ultrassonografia de tireoide com TI-RADS); nenhum dado de paciente é guardado; o computador não tem placa de vídeo e deve atender várias pessoas ao mesmo tempo; Claude e Codex escrevem o código e Giovanni revisa e testa.

## How it does it
Fonte do conteúdo: Radiopaedia, um site de referência de radiologia gratuito. Suas páginas existem só em inglês; o sitemap não lista versões em alemão nem em português. O arquivo `robots.txt` dele (o arquivo em que um site diz a visitantes automáticos o que podem fazer) permite páginas de artigos e de casos com 10 segundos de intervalo entre as requisições e traz uma reserva contra o uso para treinar modelos de IA. As páginas têm licença CC BY-NC-SA (Creative Commons, não comercial, compartilhamento pela mesma licença). Giovanni decidiu prosseguir: o produto não vai exibir texto da Radiopaedia, constrói um mapeamento estatístico e não um modelo de IA, outras fontes serão acrescentadas e Giovanni conversará com a Radiopaedia se houver objeção. Se isso basta para uso comercial é uma questão jurídica que não foi respondida.

O método foi escolhido a partir de um relatório de pesquisa escrito pelo [[codex]] em 2026-10-27: BM25 mais um léxico de termos, regras de negação e uma tabela fixa de escores, com reordenação aprendida e embeddings (números que representam o significado de um texto) só se um teste mostrar que ajudam. O próprio relatório disse que nenhum estudo publicado prova que algum método atenda exatamente a esse objetivo; por isso é preciso um conjunto de teste com laudos escritos por médicos.

A pasta `~/dev/radiology-crawler` ainda não é um repositório git (git é a ferramenta que guarda cada alteração como um commit) e não tem portão de qualidade automático nem integração contínua; ambos estão planejados antes de o site ser construído.

## Where it sits in the pipeline
Ele inicia a cadeia: [[radiopaedia-crawler]] → [[report-translator]] → (planejado) construtor de índice → (planejado) site.

## Who receives its output
Giovanni, agora pelo site de plano e depois pelo site planejado.
