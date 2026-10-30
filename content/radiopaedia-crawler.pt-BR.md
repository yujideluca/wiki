---
id: radiopaedia-crawler
lang: pt-BR
source_hash: 2b4d39cf3707
title: Rastreador da Radiopaedia (crawl.py)
---

## What it is
Um programa de linha de comando que baixa as páginas de artigos e de casos da Radiopaedia (um site de referência de radiologia gratuito) devagar e com educação, guarda uma cópia bruta de cada página e extrai delas texto limpo para um banco de dados. Um "rastreador" (crawler) é um programa que visita páginas web uma após a outra; "extrair" significa retirar o título, os subtítulos e o texto principal e descartar menus e scripts. Faz parte do [[radiology-report-matcher]].

## Architecture
### Context
person g: Giovanni — inicia e interrompe os downloads | [[giovanni]]
system s: crawl.py — baixa páginas da Radiopaedia e extrai o texto delas
external r: Radiopaedia — o site de referência gratuito
external t: Tradutor de laudos — lê os artigos extraídos | [[report-translator]]

g -executa-> s
s -baixa páginas de-> r
s -entrega artigos a-> t

### Containers
person g: Giovanni | [[giovanni]]
container cm: Comandos — sitemap, fetch, extract, run, stats
store u: tabela urls — cada endereço e seu estado
store raw: Páginas brutas — cópia comprimida de cada página
store a: tabelas articles e cases — o texto extraído
store pj: progress-data.js — números ao vivo para o site do plano
external r: Radiopaedia

g -executa-> cm
cm -lê listas e páginas de-> r
cm -acompanha cada página em-> u
cm -guarda cópias em-> raw
cm -grava texto em-> a
cm -reescreve a cada poucos segundos-> pj

## What it does
Tem cinco comandos, executados como `python3 -I crawl.py <comando>` em `~/dev/radiology-crawler`:

- `sitemap` lê o mapa do site (a lista de páginas do próprio site) e grava cada endereço de artigo e de caso na tabela `urls` com o estado `pending`.
- `fetch` baixa as páginas pendentes, uma a cada 10 a 12 segundos, e salva cada uma como arquivo comprimido em `data/raw/`. Opções: `--kind articles|cases`, `--limit N`. Dentro de cada tipo, as páginas são baixadas em uma ordem pseudoaleatória fixa (não alfabética); assim, um download interrompido cedo ainda contém uma amostra justa de todos os diagnósticos.
- `extract` transforma as páginas salvas em linhas das tabelas `articles` e `cases` em `data/radiopaedia.sqlite` (SQLite é um banco de dados guardado em um único arquivo). Páginas já extraídas são puladas, a menos que se use `--all`.
- `run` faz tudo o que está acima em sequência (sitemap, artigos, casos, extração) e repete enquanto uma passada ainda reduz a lista de pendentes. Enquanto trabalha, reescreve a cada 5 segundos o `progress-data.js` na pasta do site do plano `~/Documents/Radiology Report Matcher/` (o código está em `progress.py`), de modo que as barras de progresso do site do plano ficam ao vivo. Termina com sucesso quando não sobra nada, com falha quando sobram páginas (por exemplo sem rede) e com o código 75 após bloqueios repetidos. Se o crawl for iniciado com `run_all.sh`, esse script também inicia o serviço em segundo plano `radiology-plan-updater` (systemd, o gerenciador de serviços do Linux, nível de usuário), que mantém o mesmo arquivo atualizado e se reinicia após uma falha ou reinício do computador.
- `stats` mostra quantas páginas estão pendentes, prontas ou sumidas e quantos dias faltam.

`run_all.sh` é a forma manual mais antiga: executa sitemap, depois fetch dos artigos, depois fetch dos casos, depois extract, e pode simplesmente ser executado de novo para continuar. Em 2026-10-27 os sitemaps listavam 17.359 artigos e 70.535 casos, cerca de 11 dias de download nessa velocidade. Os artigos baixados também alimentam a análise estatística: `analysis/codex_tags.py` (Codex, retomável) e `analysis/haiku_batches.py` (subinstâncias Haiku em ondas) marcam cada artigo com o mesmo vocabulário fechado, lendo a cópia congelada do banco de dados, nunca os arquivos do crawler.

## How it does it
- Lê primeiro o `robots.txt` e pula qualquer endereço que esse arquivo bloqueie (busca, tags, playlists, a interface de programação, páginas de administração). O intervalo de 10 segundos é o valor `Crawl-delay` desse arquivo; somam-se 0 a 2 segundos aleatórios.
- Envia uma linha User-Agent honesta (o nome que um programa dá a um site) dizendo que é um rastreador de pesquisa pessoal e com o endereço de contato de Giovanni, além de cabeçalhos Accept normais. Sem eles, o site respondeu HTTP 406 ("não aceitável") no primeiro teste.
- Uma resposta 429 ou 503 (muitas requisições, ocupado) faz esperar e tentar de novo até três vezes. Uma resposta 404 ou 410 marca a página como `gone`. Três respostas 403 ou 406 (recusado) encerram a execução inteira; ele não tenta contornar um bloqueio.
- O estado de cada página fica no banco de dados, então uma execução interrompida continua de onde parou. As páginas brutas são mantidas para que a extração possa ser melhorada sem baixar de novo.
- Um artigo é guardado com título, lista de sinônimos e tags, autor, data de modificação, texto principal dividido por subtítulo e links para outros artigos. Um caso é guardado com título, apresentação, idade e sexo, o texto de achados de cada série de imagens com sua modalidade, tags e artigos vinculados. O idioma é gravado como `en`; a Radiopaedia não tem outro.
- O arquivo do banco é aberto em modo write-ahead (um modo do SQLite que permite que vários programas usem um mesmo arquivo), para que o rastreador, o extrator e o [[report-translator]] possam rodar juntos.

## Where it sits in the pipeline
Primeiro passo da cadeia de dados do [[radiology-report-matcher]]. Roda em segundo plano no notebook ([[acer-nitro]]), com a suspensão bloqueada enquanto trabalha.

O serviço de usuário `radiology-crawler.service` (systemd, o programa do Linux que inicia serviços em segundo plano) executa `python3 -I crawl.py run` sempre que o notebook liga. Depois de uma falha ele reinicia em 10 minutos; depois de sucesso (tudo baixado e extraído) ou do código 75 (bloqueado) fica parado. As barras do site do plano dizem "the crawler is not running" se os números tiverem mais de um minuto. Verifique com `systemctl --user status radiology-crawler`.

## Who receives its output
O [[report-translator]] lê a tabela `articles`. O construtor de índice planejado lerá as duas tabelas.
