---
id: skill-regras-magic
lang: de
source_hash: 1e1375599ec3
title: Skill: regras-magic (Magic-Regeln)
---

## What it is
Die Skill „regras-magic“ beantwortet Giovannis Regelfragen zu [Magic: The Gathering](https://en.wikipedia.org/wiki/Magic:_The_Gathering), dem Sammelkartenspiel. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: sie beantwortet Giovannis Magic-Regelfragen: Karteninteraktionen, der Stapel, Trigger, Ebenen, Kopien, Spielmarken, Commander; nicht für LigaMagic-Listen oder Käufe ([[skill-ligamagic-listas]]).

## What it does
Sie gibt Regelentscheidungen in einer festen Vorlage. Ihre Rolle ist „Domäne“: Sie besitzt das Format von Magic-Rulings; sie verweist auf [[skill-ligamagic-listas]] (Käufe) und [[skill-browser-automacao-segura]] (falls ein Browser benutzt wird); und sie beachtet die Sprache der Nachricht und die Tiefe-Flags `!!`, `***` und `...`.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/regras-magic`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Giovannis Hobby Magic: The Gathering.

## Who receives its output
Giovanni.

## Steps
1. **Diese Vorlage verwenden.** *Ruling* (das Ergebnis in einer Zeile); *Karten (Oracle)* (der relevante Text jeder Karte; „aus dem Gedächtnis“ markieren, wenn er nicht auf [Scryfall](https://scryfall.com/) oder Gatherer geprüft wurde); *Zeitablauf* (Schritt für Schritt: wirken → Stapel → Auflösung → zustandsbasierte Aktionen → Trigger); *Regeln* (Nummern aus den [Comprehensive Rules](https://magic.wizards.com/en/rules)); *Sicherheit* (hoch, oder mittel, wenn der Kartentext aus dem Gedächtnis stammt oder der Fall selten ist).
2. **Kommentiertes Beispiel.** Frage: „Kona, Rescue Beastie legt mit ihrem Trigger einen Brontodon auf das Schlachtfeld. Kann ich ihn mit Remove Soul kontern?“ Ruling: nein, es gibt keinen Zauber zu kontern. Karten: Remove Soul kontert einen Kreaturenzauber; Kona legt die Kreatur auf das Schlachtfeld (aus dem Gedächtnis, auf Scryfall prüfen). Zeitablauf: Konas Trigger löst sich auf → der Brontodon wird direkt auf das Schlachtfeld gelegt, ohne gewirkt zu werden → er war nie ein Zauber auf dem Stapel. Regeln: 601.2a (Wirken beginnt damit, die Karte auf den Stapel zu legen; das Legen auf das Schlachtfeld überspringt das). Sicherheit: hoch.

## Notes

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

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
