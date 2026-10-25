---
id: skill-regras-magic
lang: pt-BR
source_hash: 1e1375599ec3
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

## Notes

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/regras-magic/SKILL.md`

```skill-source home:.claude/skills/regras-magic/SKILL.md eae8b79d04abe6950def6f44fe6ecd80d65beb4178fa40ab7a85b2fba524fb01
---
name: "regras-magic"
description: "Responde dúvidas de regras de Magic: The Gathering do Giovanni — interações entre cartas, pilha, gatilhos, camadas, cópias, tokens, comandante; não para listas/compras da LigaMagic."
---

# Regras de Magic

Lineage: origin=gui; base=bba4d064687fa0cf1f4d04312cd7433c5e7785aa

Interop: role = domain; owns = formato de rulings de Magic; defers to = ligamagic-listas (compras), browser-automacao-segura (se usar navegador); honors = idioma da mensagem, flags !! *** ...

## Template
**Ruling:** <resultado em 1 linha>
**Cartas (Oracle):** <texto relevante de cada carta; marque "de memória" se não conferiu no Scryfall/Gatherer>
**Linha do tempo:** <passo a passo: lançar → pilha → resolução → ações baseadas em estado → gatilhos>
**Regras:** <números das Comprehensive Rules>
**Confiança:** alta / média (texto de memória ou caso raro)

## Exemplo
P: "Kona, Rescue Beastie coloca um Brontodon no campo pelo gatilho dela. Posso anular com Remove Soul?"
**Ruling:** não — não há magia para anular.
**Cartas (Oracle):** Remove Soul anula uma *mágica* de criatura; Kona *coloca* a criatura no campo de batalha (de memória — conferir no Scryfall).
**Linha do tempo:** o gatilho da Kona resolve → o Brontodon é colocado direto no campo, sem ser lançado → nunca existiu como mágica na pilha.
**Regras:** 601.2a (lançar começa movendo a carta para a pilha; colocar no campo pula isso).
**Confiança:** alta.
```


#### Codex: `home:.agents/skills/regras-magic/SKILL.md`

```skill-source home:.agents/skills/regras-magic/SKILL.md eae8b79d04abe6950def6f44fe6ecd80d65beb4178fa40ab7a85b2fba524fb01
---
name: "regras-magic"
description: "Responde dúvidas de regras de Magic: The Gathering do Giovanni — interações entre cartas, pilha, gatilhos, camadas, cópias, tokens, comandante; não para listas/compras da LigaMagic."
---

# Regras de Magic

Lineage: origin=gui; base=bba4d064687fa0cf1f4d04312cd7433c5e7785aa

Interop: role = domain; owns = formato de rulings de Magic; defers to = ligamagic-listas (compras), browser-automacao-segura (se usar navegador); honors = idioma da mensagem, flags !! *** ...

## Template
**Ruling:** <resultado em 1 linha>
**Cartas (Oracle):** <texto relevante de cada carta; marque "de memória" se não conferiu no Scryfall/Gatherer>
**Linha do tempo:** <passo a passo: lançar → pilha → resolução → ações baseadas em estado → gatilhos>
**Regras:** <números das Comprehensive Rules>
**Confiança:** alta / média (texto de memória ou caso raro)

## Exemplo
P: "Kona, Rescue Beastie coloca um Brontodon no campo pelo gatilho dela. Posso anular com Remove Soul?"
**Ruling:** não — não há magia para anular.
**Cartas (Oracle):** Remove Soul anula uma *mágica* de criatura; Kona *coloca* a criatura no campo de batalha (de memória — conferir no Scryfall).
**Linha do tempo:** o gatilho da Kona resolve → o Brontodon é colocado direto no campo, sem ser lançado → nunca existiu como mágica na pilha.
**Regras:** 601.2a (lançar começa movendo a carta para a pilha; colocar no campo pula isso).
**Confiança:** alta.
```
