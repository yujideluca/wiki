---
id: skill-regras-magic
title: Skill: regras-magic (Magic rules)
aliases: [regras-magic]
kind: skill
project: skills
status: active
location: home:.claude/skills/regras-magic
fed_by: []
feeds: []
sources: [home:.claude/skills/regras-magic/SKILL.md, home:.agents/skills/regras-magic/SKILL.md]
reviewed: 2026-10-25T20:41Z
---

## What it is
The skill "regras-magic" answers Giovanni's rules questions about [Magic: The Gathering](https://en.wikipedia.org/wiki/Magic:_The_Gathering), the trading card game. It is written in Portuguese. Its description says: it answers Giovanni's Magic rules questions: card interactions, the stack, triggers, layers, copies, tokens, Commander; not for LigaMagic lists or purchases ([[skill-ligamagic-listas]]).

## What it does
It gives rulings in a fixed template. Its role is "domain": it owns the format of Magic rulings; it defers to [[skill-ligamagic-listas]] (purchases) and to [[skill-browser-automacao-segura]] (if a browser is used); and it honours the language of the message and the depth flags `!!`, `***` and `...`.

## How it does it
A `SKILL.md` in `~/.claude/skills/regras-magic`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Giovanni's Magic: The Gathering hobby.

## Who receives its output
Giovanni.

## Steps
1. **Use this template.** *Ruling* (the result in one line); *Cards (Oracle)* (the relevant text of each card; mark "from memory" if it was not checked on [Scryfall](https://scryfall.com/) or Gatherer); *Timeline* (step by step: cast → stack → resolution → state-based actions → triggers); *Rules* (numbers from the [Comprehensive Rules](https://magic.wizards.com/en/rules)); *Confidence* (high, or medium when the card text is from memory or the case is rare).
2. **Annotated example.** Question: "Kona, Rescue Beastie puts a Brontodon onto the battlefield with her trigger. Can I counter it with Remove Soul?" Ruling: no, there is no spell to counter. Cards: Remove Soul counters a creature spell; Kona puts the creature onto the battlefield (from memory, check on Scryfall). Timeline: Kona's trigger resolves → the Brontodon is put directly onto the battlefield without being cast → it never existed as a spell on the stack. Rules: 601.2a (casting starts by moving the card to the stack; putting onto the battlefield skips that). Confidence: high.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

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

````skill-source home:.agents/skills/regras-magic/SKILL.md ebf1b923e4d07329f3567c7372c686b0b786475b6bdc3f4953b04677467f4909
---
name: "regras-magic"
description: "Responde dúvidas de regras de Magic: The Gathering do Giovanni — interações entre cartas, pilha, gatilhos, camadas, cópias, tokens, comandante; não para listas/compras da LigaMagic."
---

# Regras de Magic

Lineage: origin=claude; base=sha256:6f9e35e63c5952ed7580647740f39782e2001fdd9e7fdec4efee2e58fe823415; adaptation=codex

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

## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
