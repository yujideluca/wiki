---
id: radiology-analysis
lang: pt-BR
source_hash: fff513e234de
title: Pacote de análise de radiologia (analysis/)
---

## What it is
O código Python que estuda os artigos e casos do Radiopaedia coletados pelo [[radiopaedia-crawler]] e tenta associar as palavras de um laudo radiológico a diagnósticos prováveis. É a parte estatística do [[radiology-report-matcher]]: conta palavras e faz aritmética com elas, não é um modelo de inteligência artificial. O plano é construir quatro versões concorrentes da associação e pontuá-las todas do mesmo modo; este pacote reúne as ferramentas comuns e as versões 1 e 4. A pasta é `analysis/` em `~/dev/radiology-crawler`, com um auxiliar fora dela, `tools/analysis_status.py`.

## What it does
Fornece as peças abaixo, cada uma em seu arquivo. Cada peça tem um requisito (linhas AN-1 a AN-17 em `docs/REQUIREMENTS.md`) e um teste marcado com ele.

- Uma cópia congelada dos artigos, para que todas as versões leiam os mesmos dados enquanto o rastreador continua escrevendo.
- Uma camada de hardware que usa todas as threads do processador e uma placa de vídeo (GPU, Graphics Processing Unit) quando houver. O mesmo código dá a mesma classificação só com o processador.
- Um arcabouço de avaliação: dos casos de cada diagnóstico, metade ajusta um modelo e metade o testa (semente aleatória fixa, para que todas as versões vejam as mesmas metades); uma classificação é pontuada pela frequência com que o diagnóstico verdadeiro está entre os 1, 5 e 10 primeiros.
- A versão 4, ideia do Giovanni, em camadas: um marcador por regras que dá a cada artigo o mesmo conjunto de marcas (grupo de pacientes, sexo, método de imagem, região do corpo, textura, brilho, margens, captação de contraste, lado ou número, sintomas); filtros que removem um diagnóstico só quando o artigo afirma um fato que contradiz o laudo, ou apenas reduzem sua pontuação nas camadas mais fracas; um seletor da próxima pergunta ao usuário no estilo "akinator" (como o jogo de adivinhação: pergunta o que elimina mais candidatos); e uma última camada que pontua a redação do laudo.
- A versão 1, modelo próprio do Claude sem viés prévio: um modelo suavizado de probabilidade de palavras de cada artigo, com o número de artigos que apontam para um diagnóstico como peso inicial.
- Marcação pelo [[codex]] e pelo Haiku (um modelo Claude pequeno) com a mesma lista fechada de valores permitidos, e a comparação dos marcadores.
- Um teste científico da lista de palavras de enchimento (palavras que o radiologista usa quando está inseguro e que carregam pouca informação), escrito em `docs/filler-list-protocol.md` antes de qualquer resultado.
- `tools/analysis_status.py`, o único lugar que registra em que ponto está a análise.

## How it does it
- **Desconhecido não é "não".** Uma camada de marcas que o artigo nunca menciona é guardada como desconhecida, o que é diferente de um "não" declarado. Só um fato declarado e contraditório remove um diagnóstico; informação ausente nunca remove. Em vez disso, o seletor de perguntas pergunta.
- **Camada de redação.** Cada artigo de diagnóstico vira um saco de palavras e pares de palavras ponderado com BM25 (uma fórmula padrão que dá mais peso a palavras raras e informativas); as seções de imagem contam por inteiro e o resto do artigo um pouco. No laudo, palavras dentro de uma negação recebem sinal negativo, palavras após uma atenuação ("possivelmente") são suavizadas e palavras de enchimento são descartadas. A pontuação é um único produto de matrizes esparsas (tabelas de números multiplicadas de uma vez), executado no processador ou na GPU; o resultado lista as palavras que moveram cada pontuação.
- **Marcação por modelos.** `analysis/codex_tags.py` envia um artigo por chamada em uma sessão nova e descartável do [[codex]], bem abaixo de 250.000 tokens (limite do Giovanni), com o artigo marcado como texto não confiável. Uma resposta fora dos valores permitidos é rejeitada, não corrigida em silêncio. Os resultados são acrescentados uma linha por artigo, então uma parada não perde nada e uma retomada marca só o que falta. `analysis/haiku_batches.py` corta lotes de 100 artigos da outra ponta da mesma fila para subagentes Haiku e incorpora só respostas válidas.
- **Registro de status.** O estado do trabalho é o arquivo `docs/analysis-status.json`; `tools/analysis_status.py set STEP STATUS --note "..."` o altera, reescreve a cópia legível `docs/ANALYSIS-STATUS.md` e reconstrói o site de plano, de modo que os três nunca divergem. Quem continua o trabalho lê esse arquivo primeiro. O `AGENTS.md` do repositório dá ao [[codex]] as mesmas notas de trabalho que o `CLAUDE.md` dá ao [[claude-code]].
- **Um conjunto de modelos por idioma (desde 2026-11-01).** Instantâneos, o marcador por regras, a camada de redação, o modelo da versão 1 e o motor da versão 4 recebem um idioma (`en`, `de`, `pt`). Cada idioma tem seu próprio instantâneo congelado (alemão e português vêm das traduções, com as seções reconstruídas a partir dos títulos traduzidos) e seus próprios arquivos de dados em `analysis/wordlists/`: `tags.<lang>.json` (palavras das etiquetas), `lang.<lang>.json` (títulos de seção e palavras do título) e `wording.<lang>.json` (palavras de negação, atenuação, enchimento e stop words). As listas em alemão e português são listas iniciais, ainda não testadas no corpus real; as avaliações por idioma aguardam os casos traduzidos.
- **Verificação da etiquetagem por idioma (2026-11-01).** `analysis/codex_tags.py N LANG` repete o piloto de etiquetagem nas traduções para alemão ou português dos mesmos 300 artigos. O Codex esgotou o orçamento, então o Haiku (um modelo mais barato) etiquetou no lugar. Contra o marcador por regras, a concordância do tipo é 0,72 nos dois idiomas (inglês: 0,75); modalidade e região são quase tão boas quanto em inglês. As listas de sexo, único-ou-múltiplo e textura são fracas e serão as próximas a corrigir. O Haiku lendo a tradução concorda com o Codex lendo o inglês em 0,89 no tipo; as traduções, portanto, mantêm o conteúdo.
- **Os dados ficam locais.** A cópia, as marcas e os resultados ficam em `data/analysis/`, que o git ignora como o resto de `data/`.

## Functions
- `corpus.make_snapshot`, `corpus.load_snapshot`: gravam o arquivo congelado de artigos com contagem e soma de verificação; leem de volta e recusam um arquivo cuja soma mudou.
- `hardware.detect`, `hardware.array_module`, `hardware.parallel_map`: descobrem threads e GPU; devolvem CuPy (arrays na GPU) ou NumPy (arrays no processador); executam uma função sobre itens em todas as threads.
- `harness.split_by_diagnosis`, `harness.topk_hit_rates`, `harness.diagnosis_label`, `harness.case_label`: dividem os casos por diagnóstico; pontuam uma classificação nos 1, 5 e 10 primeiros; acham o artigo de um caso por título exato ou sinônimo (um nome compartilhado por dois artigos não dá rótulo, em vez de um palpite).
- `tagger.tag_article`, `tagger.tag_all`, `tagger.article_type`, `tagger.coverage`: marcam artigos com listas de palavras guardadas como dados em `analysis/wordlists/`; dão o tipo do artigo; informam com que frequência cada camada é desconhecida.
- `filters.build`, `filters.FilterModel.apply`, `filters.best_question`: constroem o modelo de filtros; aplicam as camadas aos fatos declarados de um laudo; escolhem a próxima pergunta.
- `wording.build_index`, `wording.read_report`, `wording.score`: indexam os artigos de diagnóstico; leem um laudo com negação, atenuação e enchimento; classificam os diagnósticos.
- `pipeline.Engine`: versão 4 de ponta a ponta, do texto do laudo a uma classificação e à próxima pergunta.
- `v1_model.build`, `v1_model.rank`: versão 1.
- `codex_tags.run_all`, `codex_tags.parse_answer`, `codex_tags.compare`: marcam com o Codex todo artigo faltante; validam uma resposta; comparam dois marcadores.
- `haiku_batches.make`, `haiku_batches.merge`: cortam lotes para o Haiku; incorporam respostas válidas.
- `tag_agreement.agreement`: com que frequência os marcadores concordam entre si.
- `filler_test.run`, `filler_test.classify`, `filler_test.holm`: executam o teste das palavras de enchimento; classificam uma palavra como enchimento, informativa ou indecisa; corrigem para muitos testes simultâneos (método de Holm).
- `sanity.main`: uma verificação da maquinaria nos casos baixados até agora; não é a avaliação de verdade.

## Where it sits in the pipeline
Depois do [[radiopaedia-crawler]], que fornece os artigos e casos no banco de dados. Roda ao lado do [[report-translator]] e não lê a saída dele. É a base do motor numérico planejado do [[radiology-report-matcher]].

## Who receives its output
Giovanni, pelo guia passo a passo da página inicial do site de plano e por `docs/ANALYSIS-STATUS.md`; mais tarde o motor de correspondência planejado.
