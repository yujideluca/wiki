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
sources: [home:.claude/skills/regras-magic/SKILL.md]
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
