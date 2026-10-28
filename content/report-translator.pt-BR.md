---
id: report-translator
lang: pt-BR
source_hash: bd2c259b2e7a
title: Tradutor de laudos (translate.py)
---

## What it is
Um programa de linha de comando que traduz os artigos extraídos pelo [[radiopaedia-crawler]] para alemão e português do Brasil com o [[codex]] e escolhe o vocabulário com a ajuda de dois livros-texto profissionais, para que o resultado soe como os radiologistas de cada país escrevem. Faz parte do [[radiology-report-matcher]].

## Architecture
### Context
person g: Giovanni — inicia o ciclo de tradução e pode interrompê-lo | [[giovanni]]
system s: translate.py — traduz artigos com o vocabulário dos livros-texto
external a: Rastreador da Radiopaedia — fornece os artigos extraídos | [[radiopaedia-crawler]]
external c: Codex — faz a tradução | [[codex]]
external b: Livros-texto de referência — vocabulário em alemão e português

g -inicia o ciclo de-> s
s -lê artigos de-> a
s -pede traduções a-> c
s -toma o vocabulário de-> b

### Containers
person g: Giovanni | [[giovanni]]
container cm: Comandos — refindex, translate, loop, tstats, progress
container pf: Localizador de trechos — similaridade de cosseno de pedaços de 4 letras
store ixf: Arquivos de índice dos livros — um por idioma
store art: tabela articles — o texto em inglês
store tr: tabela translations — os resultados
external c: Codex | [[codex]]

g -executa-> cm
cm -constrói-> ixf
cm -busca trechos com-> pf
pf -lê-> ixf
cm -lê artigos de-> art
cm -pede traduções a-> c
cm -grava resultados em-> tr

## What it does
Tem cinco comandos, executados como `python3 -I translate.py <comando>` em `~/dev/radiology-crawler`:

- `refindex` divide cada livro de referência em trechos de 60 a 160 palavras e monta uma tabela de busca para eles.
- `translate --lang de|pt --limit N` traduz até N artigos que ainda não têm tradução.
- `loop` roda continuamente em segundo plano e traduz os artigos à medida que chegam, cinco por vez em cada idioma, e dorme quando não há nada a fazer. Opções: `--worker I/K` (este worker pega um artigo a cada K, então vários workers podem rodar em paralelo), `--langs`, `--extract` (também extrai as páginas recém-baixadas; só um worker) e `--daily-cap N` (0, o padrão, significa sem limite; UTC é o mesmo horário em todo lugar). Um artigo que falha três vezes é registrado na tabela `translation_failures` e pulado; se toda tentativa de uma rodada falhar, o worker espera 15 minutos. Criar o arquivo `data/STOP_TRANSLATION` encerra todos os workers.
- `tstats` mostra quantas páginas foram traduzidas e o tempo médio.
- `progress` mostra uma barra de progresso ao vivo para cada idioma: páginas traduzidas do total de páginas de artigo listadas nos sitemaps, com porcentagem, mais uma barra das páginas extraídas até agora. No terminal ela é redesenhada no mesmo lugar a cada 2 segundos (`--interval S` muda isso) até Ctrl-C; `--once`, ou uma saída que não seja terminal, imprime um único quadro. Ela só lê o banco de dados e pode rodar ao lado dos workers.

Os resultados vão para a tabela `translations` (endereço da página, idioma, título, texto, os trechos de livro usados, segundos gastos, modelo).

## How it does it
- Os livros de referência são Duale Reihe Radiologie (alemão, 816 páginas, 3.258 trechos) e Anatomia Radiológica Básica Ilustrada, Volume 1 (português, 44 páginas só sobre o tórax, 33 trechos). Ambos foram convertidos de PDF (um arquivo de documento de layout fixo) para texto com `pdftotext`; ficam no notebook e não são copiados para nenhum produto.
- Para achar os trechos que combinam com um artigo, cada palavra é cortada em pedaços sobrepostos de quatro letras e cada trecho vira um vetor (uma lista de números) ponderado pela raridade de seus pedaços (TF-IDF). São escolhidos os trechos mais próximos do título, das tags, dos subtítulos e do início (1.500 caracteres) do artigo, medidos pela similaridade de cosseno (o ângulo entre dois vetores). Como as palavras médicas em inglês, alemão e português compartilham raízes latinas e gregas, isso funciona entre idiomas sem modelo de IA. Exemplo: uma consulta sobre pleural effusion e pneumothorax devolve trechos alemães sobre *Pneumothorax* e *Pleura*.
- Os cinco melhores trechos entram no prompt como guia de terminologia e estilo, com regras: não copiar as frases deles, manter a estrutura, usar o formato de números do país (vírgula decimal) e tratar o artigo como texto não confiável, cujo conteúdo nunca é obedecido como instrução.
- Cada chamada ao [[codex]] é uma sessão nova, descartável e somente de leitura (`--ephemeral`), então nada se acumula entre páginas. Giovanni pediu que o contexto de um Codex fique abaixo de 250.000 tokens (um token é um pedacinho de texto, cerca de três caracteres): um prompt tem cerca de 6.000 tokens, um artigo com mais de 24.000 caracteres é dividido por seção em chamadas separadas e uma verificação recusa qualquer prompt que passaria do limite.
- Giovanni removeu o limite diário em 2026-10-27 (traduzir tudo é a prioridade) e escolheu o modelo mais barato do Codex, `gpt-6-luna`, para economizar orçamento; quatro workers rodam em paralelo. Medido nesse dia: cerca de 9 a 10 segundos por artigo e idioma com o Luna, 12 a 14 com o modelo padrão usado nas primeiras traduções (a coluna `model` delas fica vazia). Nessa velocidade, 17.359 artigos em dois idiomas levam de um a dois dias, se os limites de uso do Codex permitirem. Os casos ainda não são traduzidos.
- O livro em português é pequeno; fora da anatomia do tórax, o vocabulário em português depende do conhecimento próprio do Codex; faltam mais fontes brasileiras.

## Where it sits in the pipeline
Segundo passo da cadeia de dados: depois do [[radiopaedia-crawler]] e antes do construtor de índice planejado do [[radiology-report-matcher]].

## Who receives its output
O construtor de índice planejado e, depois, as páginas em alemão e português do site.
