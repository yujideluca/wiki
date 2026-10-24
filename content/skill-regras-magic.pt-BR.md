---
id: skill-regras-magic
lang: pt-BR
source_hash: 1d01fa6d0557
title: Skill: regras-magic (regras de Magic)
---

## What it is
A skill "regras-magic" responde às dúvidas de regras do Giovanni sobre [Magic: The Gathering](https://en.wikipedia.org/wiki/Magic:_The_Gathering), o jogo de cartas colecionáveis. É escrita em português. Sua descrição diz: responde dúvidas de regras de Magic do Giovanni: interações entre cartas, pilha, gatilhos, camadas, cópias, tokens, comandante; não serve para listas ou compras da LigaMagic ([[skill-ligamagic-listas]]).

## What it does
Dá rulings em um modelo fixo. Seu papel é "domínio": é dona do formato dos rulings de Magic; remete à [[skill-ligamagic-listas]] (compras) e à [[skill-browser-automacao-segura]] (se usar navegador); e respeita o idioma da mensagem e as flags de profundidade `!!`, `***` e `...`.

## How it does it
Um `SKILL.md` em `~/.claude/skills/regras-magic`; o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
O hobby de Magic: The Gathering do Giovanni.

## Who receives its output
O Giovanni.

## Steps
1. **Usar este modelo.** *Ruling* (o resultado em 1 linha); *Cartas (Oracle)* (o texto relevante de cada carta; marcar "de memória" se não foi conferido no [Scryfall](https://scryfall.com/) ou Gatherer); *Linha do tempo* (passo a passo: lançar → pilha → resolução → ações baseadas em estado → gatilhos); *Regras* (números das [Comprehensive Rules](https://magic.wizards.com/en/rules)); *Confiança* (alta, ou média quando o texto da carta é de memória ou o caso é raro).
2. **Exemplo anotado.** Pergunta: "Kona, Rescue Beastie coloca um Brontodon no campo pelo gatilho dela. Posso anular com Remove Soul?" Ruling: não, não há magia para anular. Cartas: Remove Soul anula uma mágica de criatura; Kona coloca a criatura no campo de batalha (de memória, conferir no Scryfall). Linha do tempo: o gatilho da Kona resolve → o Brontodon é colocado direto no campo, sem ser lançado → nunca existiu como mágica na pilha. Regras: 601.2a (lançar começa movendo a carta para a pilha; colocar no campo pula isso). Confiança: alta.
