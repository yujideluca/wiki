---
id: radiology-report-matcher
lang: pt-BR
source_hash: 27daa4a10c5e
title: Radiology Report Matcher (site planejado)
---

## What it is
Um projeto para construir um site em que um radiologista digita o laudo em texto livre de um exame de imagem, informa qual foi o exame e a técnica, acrescenta os dados básicos do paciente e a história clínica e recebe de volta: uma lista ordenada de diagnósticos prováveis com as palavras do laudo que causaram cada um, links para artigos que explicam o caso e escores estruturados (um "escore estruturado" é um sistema fixo de pontos que transforma achados descritos em uma categoria de risco; o primeiro planejado é o ACR TI-RADS, um escore para nódulos de tireoide na ultrassonografia). A correspondência é só contagem e aritmética com palavras, não um modelo de inteligência artificial. Deve funcionar para laudos em inglês, alemão e português do Brasil. Giovanni pretende rodá-lo em um computador desktop comprado para isso, e ele pode se tornar uma ferramenta comercial no futuro.

Em 2026-10-27 existe apenas a parte de coleta de dados: um rastreador ([[radiopaedia-crawler]]) e um tradutor ([[report-translator]]). A busca, o cálculo dos escores e o site estão planejados, não construídos. O plano, com diagramas e um diário de desenvolvimento, é um site offline em `~/Documents/Radiology Report Matcher/`; o script `site_src/build.py` o reconstrói com números atuais do banco de dados. `python3 -I site_src/build.py watch` reescreve a cada 5 segundos um pequeno arquivo de dados (`progress-data.js`); todas as páginas abertas o recarregam e movem suas barras de progresso e os contadores das caixas de resumo: artigos e casos baixados, artigos extraídos, artigos traduzidos para alemão e português, tempo médio de tradução. Se o atualizador não estiver rodando, a página avisa que os números estão antigos.

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

## Engineering practices
Como este projeto segue o caminho dourado do [[project-template]].

### Principles
1. **Requisito, depois teste, depois código**: uma promessa vira uma linha em `docs/REQUIREMENTS.md`, depois um teste com a marca `REQ <ID>`, depois código.
2. **Linguagens decididas por Giovanni (2026-10-27)**: ferramentas pequenas em Python; back end da web em Elixir; front end em Elm; a matemática estatística e a comparação de um laudo com as páginas em Python numérico de alta velocidade (Cython, NumPy, bibliotecas em C), nunca laços em Python puro, que são lentos demais. O primeiro commit do motor acrescenta um requisito de velocidade para que um teste imponha isso.
3. **O portão decide**: `tools/quality_gate.sh` é a única definição de "aprovado".
4. **Coleta educada e legal**: o rastreador obedece ao `robots.txt`; páginas baixadas, bancos de dados e livros-texto nunca entram no git.
5. **O uso do Codex é limitado**: sessões novas abaixo de 250.000 tokens, o modelo mais barato nas traduções.
6. **As decisões ficam onde está o código**: um registro de decisões em `DESIGN.md` e um registro de decisão de arquitetura (ADR) para as estruturais.

### Decisions
Quatro registros de decisão de arquitetura (ADRs, notas curtas que guardam os motivos de uma decisão) em `docs/adr/`: registrar decisões (0001), a stack e a regra para a matemática (0002), o programa de manutenção mede e a skill de revisão julga (0003), além do modelo em branco (0000).

### Requirements
Treze requisitos em `docs/REQUIREMENTS.md`: cinco para o rastreador (prefixo CW), seis para o tradutor (TL) e dois para o site de plano (WS). Cada um tem um teste com a marca `REQ <ID>`; a etapa de rastreabilidade falha quando algum não tem.

### Quality gate
`tools/quality_gate.sh` tem três etapas: compilar o código e rodar os 13 testes; rastreabilidade dos requisitos; as funções de aptidão do `pipeline-check` (o programa de manutenção, veja [[pipeline-check]]): regra de arquitetura, lint dos scripts de shell, limite de 800 linhas por arquivo Python e tempo do portão.

### Continuous integration
Integração contínua (CI) significa verificações automáticas a cada push. O workflow `quality-gate.yml` roda o portão no GitHub; uma verificação local antes do push o roda antes de `main` ser enviada. Em 2026-10-27 a primeira execução falhou porque uma cópia nova do repositório não tem a pasta `data/` e a função de log do rastreador supunha que existia; a correção passou.

### Maintenance
A dívida técnica é registrada como issues do GitHub com o rótulo `debt` e prioridades P1 a P3, conforme a [[maintenance-policy]]; os rótulos existem. Uma revisão mensal está planejada.

## What it does
Hoje ele coleta e prepara texto. O site planejado transformará um laudo digitado em observações (um achado, onde está, seu tamanho e se está presente, ausente, incerto ou antigo), vai compará-las com os artigos coletados usando BM25 (uma fórmula padrão que ordena um texto pelo número de palavras raras e informativas que ele compartilha com a consulta) e mostrará as evidências. Decisões já tomadas: a primeira versão cobre uma área estreita (ultrassonografia de tireoide com TI-RADS); nenhum dado de paciente é guardado; o computador não tem placa de vídeo e deve atender várias pessoas ao mesmo tempo; Claude e Codex escrevem o código e Giovanni revisa e testa.

## How it does it
Fonte do conteúdo: Radiopaedia, um site de referência de radiologia gratuito. Suas páginas existem só em inglês; o sitemap não lista versões em alemão nem em português. O arquivo `robots.txt` dele (o arquivo em que um site diz a visitantes automáticos o que podem fazer) permite páginas de artigos e de casos com 10 segundos de intervalo entre as requisições e traz uma reserva contra o uso para treinar modelos de IA. As páginas têm licença CC BY-NC-SA (Creative Commons, não comercial, compartilhamento pela mesma licença). Giovanni decidiu prosseguir: o produto não vai exibir texto da Radiopaedia, constrói um mapeamento estatístico e não um modelo de IA, outras fontes serão acrescentadas e Giovanni conversará com a Radiopaedia se houver objeção. Se isso basta para uso comercial é uma questão jurídica que não foi respondida.

O método foi escolhido a partir de um relatório de pesquisa escrito pelo [[codex]] em 2026-10-27: BM25 mais um léxico de termos, regras de negação e uma tabela fixa de escores, com reordenação aprendida e embeddings (números que representam o significado de um texto) só se um teste mostrar que ajudam. O próprio relatório disse que nenhum estudo publicado prova que algum método atenda exatamente a esse objetivo; por isso é preciso um conjunto de teste com laudos escritos por médicos.

O código está no repositório privado `yujideluca/radiology-report-matcher` (pasta `~/dev/radiology-crawler`, mantida com esse nome porque tarefas longas rodam nela). O site de plano também está publicado abertamente, sem login, pelo Tailscale Funnel na porta 8443 (o wiki mantém a porta principal atrás do seu login); um pequeno servidor estático, `radiology-plan-site.service`, serve a pasta `~/Documents/Radiology Report Matcher/` a partir deste notebook, então fica no ar enquanto o notebook estiver ligado. Linguagens decididas por Giovanni em 2026-10-27: ferramentas em Python, back end em Elixir, front end em Elm e a matemática de comparação em Python numérico de alta velocidade (Cython, NumPy, bibliotecas em C), nunca laços em Python puro.

Plano de modelagem, decidido por Giovanni em 2026-10-30 (texto completo em `docs/modelling-directives.md` do repositório): quando o download dos artigos terminar, quatro modelos matemáticos concorrentes serão construídos e pontuados do mesmo modo, no estilo da skill [[skill-skill-forge]] (várias versões comparadas por testes). A versão 1 é a análise própria de Claude de todos os artigos, sem viés prévio; a versão 2 é a mesma tarefa feita pelo Codex; a versão 3 é uma abordagem totalmente acadêmica após pesquisa profunda, com Claude e Codex debatendo; a versão 4 é a ideia do próprio Giovanni. A ideia dele trabalha em camadas: primeiro filtros duros que removem diagnósticos que não podem caber (grupo do paciente, como criança ou adulto, e sexo; método de imagem; localização no corpo), depois filtros mais suaves que apenas rebaixam um diagnóstico (textura, brilho ou densidade do achado, lado, tamanho e margens, captação de contraste e fluxo sanguíneo, história clínica) e, por fim, uma etapa puramente estatística sobre o vocabulário subjetivo do laudo, que dá pouco peso a palavras de enchimento usadas quando o radiologista está inseguro. A falta de informação nunca remove um diagnóstico; em vez disso, uma rotina "estilo akinator" (como o jogo de adivinhação, faz a pergunta que elimina mais candidatos) pergunta ao usuário, que pode sempre pular ou digitar texto. A página começa com a escolha entre busca guiada e caixa de texto aberta. Cada artigo é marcado pelo Codex e por listas de palavras, e os dois são comparados. Para cada diagnóstico, metade dos casos reais ajusta o modelo e a outra metade o testa; diagnósticos com poucos casos recebem casos da literatura científica.

## Where it sits in the pipeline
Ele inicia a cadeia: [[radiopaedia-crawler]] → [[report-translator]] → (planejado) construtor de índice → (planejado) site.

## Who receives its output
Giovanni, agora pelo site de plano e depois pelo site planejado.
