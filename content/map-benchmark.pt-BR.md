---
id: map-benchmark
lang: pt-BR
source_hash: 567a528f7e82
title: Ferramentas de benchmark do mapa (wiki-bench)
---

## What it is
Um conjunto de scripts Python em `~/dev/wiki-bench` que medem quanto trabalho o navegador faz para desenhar o mapa do wiki enquanto alguém move o mouse, e que apontam as linhas do código do mapa que causam esse trabalho. Existem para que uma afirmação sobre a velocidade do mapa venha com um número, a variação entre execuções repetidas e o código a que se refere, e não com uma impressão.

## What it does
`map_bench.py` carrega uma versão do wiki em um Chrome headless (Chrome sem janela), executa um gesto e grava um trace do navegador: para cada quadro de animação, o tempo gasto em JavaScript, estilo, layout, pintura e commit na thread principal, mais o trabalho de raster (transformar formas em pixels) nas outras threads. Os gestos são `pan` (arrastar o globo), `pan-fast` (um arrasto rápido), `sweep` (o cursor passa sobre o globo sem botão apertado), `zoom` (roda do mouse), `idle` (nada acontece), `hover` e `drag` (arrasta um ponto, não o globo).

`compare.py` roda várias versões sob vários gestos por várias rodadas. Ele alterna a ordem das versões de uma rodada para outra e mede a primeira versão mais uma vez no fim de cada rodada; a diferença entre as duas execuções dela (foi observada uma deriva da máquina entre -17 % e +18 %) mostra quão grande uma diferença precisa ser para valer como resultado. Ele imprime mediana e mínimo-máximo de quadros desenhados, tempo médio e do percentil 95 por quadro, tempo ocupado da thread principal e tempo de raster.

`callprof.py` encontra o código. Para uma versão e um gesto, roda a página três vezes: sob o amostrador de CPU do Chrome, sob contagem exata de chamadas e com um `MutationObserver` (um recurso do navegador que relata cada mudança no DOM, o Document Object Model, a árvore de elementos da página) que conta os atributos escritos por evento de mouse. `elmmap.py` converte um nome compilado como `$author$project$Motion$step` em `src/Motion.elm:89`. `callcmp.py` coloca lado a lado os perfis de várias versões, por evento de mouse e por quadro, com as escritas na página, as linhas compiladas mais quentes e uma lista ordenada do que otimizar primeiro. `framelog.py` mostra quando uma versão pede quadros de animação e quais eventos a página recebeu.

## How it does it
Ele controla o Chrome pelo protocolo DevTools (a interface de controle remoto do Chrome) com a biblioteca `websockets`. A entrada do mouse é em malha aberta (open loop): `play()` em `map_bench.py` envia cada evento no horário programado e não espera a resposta da página. Isso foi acrescentado depois que `framelog.py` mostrou o mesmo arrasto durando 179 ms em uma versão e 826 ms em outra quando cada evento esperava a resposta da página: uma versão mais lenta recebia então um gesto mais longo, e a comparação favorecia a versão errada. O compilador Elm mantém os nomes das funções em builds `--optimize`, mas não escreve source map; por isso uma linha abaixo do nível da função é informada como a linha compilada sob a sua função Elm. Os builds vêm de `~/dev/wiki-globe-sandbox` (um worktree do repositório do wiki com variantes do código de coordenadas do mapa); `build.sh` apaga e recria a pasta de um build, então todo `http.server` que a serve precisa ser reiniciado.

O que as ferramentas encontraram até agora está em `globe/RESULTS.md` (rodadas 3 a 5). Na última rodada, com entrada em malha aberta: a variante v2 (uma visão do mapa mais leve) desenhou 273 quadros de 12,2 ms em um pan, onde o mapa atual desenhou 82 de 27,2 ms; uma variante que move uma imagem com uma transformação CSS entre redesenhos exatos não fez diferença mensurável sobre a v2; acrescentar `will-change: transform` ao SVG (Scalable Vector Graphics, o formato de desenho do mapa) reduziu o tempo de raster em cerca de 30 %; e a camada de molas `Motion.step` (cerca de 1,3 ms por quadro, só enquanto um ponto está sob o mouse) e as escritas na página (55-60 % de um quadro é trabalho nativo do navegador) são as partes que restam a otimizar. Não verificado: uma segunda máquina, um celular e uma olhada na imagem durante um gesto.

## Where it sits in the pipeline
Executado à mão por [[claude-code]] ou por Giovanni depois de uma mudança no mapa; seus resultados são a evidência por trás das notas de velocidade de [[wiki-map-view]].

## Who receives its output
Arquivos em `~/dev/wiki-bench/globe/results` (json bruto e tabelas Markdown) e `globe/RESULTS.md`; [[wiki-map-view]] descreve o mapa que ele mede.
