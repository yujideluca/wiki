---
id: skill-ligamagic-listas
title: Skill: ligamagic-listas
aliases: [ligamagic-listas]
kind: skill
project: skills
status: active
location: home:.claude/skills/ligamagic-listas
fed_by: []
feeds: [skill-ligamagic-replicar-carrinho-nas-lojas]
sources: [home:.claude/skills/ligamagic-listas/SKILL.md]
---

## What it is
The skill "ligamagic-listas" handles Giovanni's work with LigaMagic's shopping list ("Lista de Compras") and the bulk-purchase form ("Compra por Lista"). [LigaMagic](https://www.ligamagic.com.br/) is a Brazilian marketplace for [Magic: The Gathering](https://en.wikipedia.org/wiki/Magic:_The_Gathering) cards. The skill is written in Portuguese. Its description says: use it when working with the shopping list or the purchase-by-list form: extract cards, generate lists with edition, remove or edit items in batch. To rebuild or check the per-store cart on the stores' own websites, use [[skill-ligamagic-replicar-carrinho-nas-lojas]].

## What it does
It extracts cards, generates lists with their edition, and removes or edits items in batch. Its role is "domain": it owns the format of the purchase-by-list form and the handling of the shopping list; it defers to [[skill-browser-automacao-segura]] (batch actions) and to [[skill-ligamagic-replicar-carrinho-nas-lojas]] (per-store carts and building them on the stores' sites); and it honours the language of the message and the depth flags `!!`, `***` and `...`.

## How it does it
A `SKILL.md` in `~/.claude/skills/ligamagic-listas`; Claude loads it when a request matches its description. Before batch actions in the browser it also follows [[skill-browser-automacao-segura]].

## Where it sits in the pipeline
Giovanni's Magic: The Gathering hobby.

## Who receives its output
Giovanni's LigaMagic lists, and [[skill-ligamagic-replicar-carrinho-nas-lojas]] for the per-store carts.

## Steps
1. **Format of the purchase-by-list form** (`?view=cards/lista`): one card per line as `[Quantity] [Card] [TAGS]`. The accepted tags, confirmed on the site, are: edition `[EDICAO=PIP]` (the edition's code, for example M10, MH3, PIP); minimum condition `[QUALIDADE=NM]` (M mint, NM near mint, SP slightly played, MP moderately played, HP heavily played, D damaged); language `[IDIOMA=PT]` or `[idioma=en]` (omit for "any language"); extras `[EXTRAS=FOIL]` or `[extras=textless, fnm]`.
2. **Example and rules.** `1 Command Tower [EDICAO=PIP] [QUALIDADE=NM]`. Use the English card name. Numbered lands work like this: `1 Forest (#0326) [EDICAO=PIP]`. The syntaxes `[PIP]`, `(PIP)` or `|PIP` do NOT work. To check, paste the list and click "Detalhar Características": the Edition column must come back filled.
3. **The shopping list** (`?view=mp/carrinho&open=1`). The same page has two structures: the shopping list (a table, below) and the per-store cart (blocks with rows and quantity inputs, one block per store), which belongs to [[skill-ligamagic-replicar-carrinho-nas-lojas]]. The item table is the first table on the page. Each row has a number input (quantity) and drop-down selects (edition, condition, language, extras); the name is in the first cell, with the English name on the last line. The first row with selects is the "Aplicar Valores" (apply values) row, not a card. The selected edition's text has the form `CODE - Name` (for example `PIP - Fallout`).
4. **Removing items.** The remove button is `.btn-circle.remove`. Removal is immediate on the server (a notice appears saying the item was removed from the shopping list); while processing, the button turns into a spinner. The per-store cart uses the same class, so check which structure the button belongs to before clicking.
5. **Pitfalls.** Clicking twice on an item that is being processed gives the alert "Ops! Não foi possível realizar a operação", which freezes the browser: remove one at a time and wait for the row to disappear. The `javascript_tool` can fail with selectors containing certain strings or with long outputs: use the first table, store results in `window.*` variables and read them in blocks of about 1,000 characters. The header shows "Total: N cards", which adds up the quantities.
