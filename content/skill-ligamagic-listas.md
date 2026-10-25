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
sources: [home:.claude/skills/ligamagic-listas/SKILL.md, home:.agents/skills/ligamagic-listas/SKILL.md]
reviewed: 2026-10-25T20:41Z
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

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/ligamagic-listas/SKILL.md`

```skill-source home:.claude/skills/ligamagic-listas/SKILL.md d0c466478a6b31dbb47d7dec088c8af5fae291714dc00e17ce2d3e9b1e0dc29a
---
name: "ligamagic-listas"
description: "Use ao trabalhar com a Lista de Compras ou o Compra por Lista da LigaMagic - extrair cartas, gerar listas com edição, remover ou editar itens em lote. Para refazer ou conferir o carrinho por loja nos sites das lojas, use ligamagic-replicar-carrinho-nas-lojas."
---

# LigaMagic: listas e carrinho

Lineage: origin=gui; base=8a97b14fecb67eb7def4bb7e9d387630f5236c2f

Interop: role = domain; owns = formato do Compra por Lista e manuseio da Lista de Compras; defers to = browser-automacao-segura (ações em lote), ligamagic-replicar-carrinho-nas-lojas (carrinho por loja e montagem nos sites das lojas); honors = idioma da mensagem, flags !! *** ...

Antes de ações em lote no navegador, siga também a skill `browser-automacao-segura`.

## Formato do Compra por Lista (?view=cards/lista)
Uma carta por linha: `[Quantidade] [Card] [TAGS]`. Tags aceitas (confirmadas no site):
- Edição: `[EDICAO=PIP]` (sigla da edição, ex.: M10, MH3, PIP)
- Qualidade mínima: `[QUALIDADE=NM]` (M, NM, SP, MP, HP, D)
- Idioma: `[IDIOMA=PT]`, `[idioma=en]`; omita para "Qualquer idioma"
- Extras: `[EXTRAS=FOIL]`, `[extras=textless, fnm]`

Exemplo: `1 Command Tower [EDICAO=PIP] [QUALIDADE=NM]`
Use o nome em inglês. Terrenos numerados funcionam assim: `1 Forest (#0326) [EDICAO=PIP]`.
Sintaxes como `[PIP]`, `(PIP)` ou `|PIP` NÃO funcionam.
Para conferir, cole a lista e clique em "Detalhar Características": a coluna Edição deve vir preenchida.

## Lista de Compras (?view=mp/carrinho&open=1)
A mesma página tem duas estruturas: a Lista de Compras (tabela, abaixo) e o carrinho por loja (blocos `.pad-bot-10` com `div.row` e `input.qty`, um bloco por loja). O carrinho por loja é tratado pela skill `ligamagic-replicar-carrinho-nas-lojas`.
- A tabela de itens é `document.querySelectorAll('table')[0]`. Por linha: `input[type=number]` (quantidade) e selects (edição, qualidade, idioma, extras). O nome aparece em `cells[0]`, com o nome em inglês na última linha.
- A primeira linha com selects é a de "Aplicar Valores", não uma carta.
- O texto da edição selecionada tem o formato `SIGLA - Nome` (ex.: `PIP - Fallout`).
- O botão de remover é `.btn-circle.remove`. A remoção é imediata no servidor (aparece um aviso "foi removido da sua Lista de Compras"). Durante o processamento, o botão vira um spinner. O carrinho por loja usa a mesma classe: confira em qual estrutura o botão está antes de clicar.
- Clicar duas vezes no mesmo item em processamento gera o alerta "Ops! Não foi possível realizar a operação", que trava o navegador. Remova um por vez e espere a linha sumir.
- O `javascript_tool` pode falhar com seletores contendo certas strings ou com saídas longas. Use `querySelectorAll('table')[0]`, guarde resultados em `window.*` e leia em blocos de ~1000 caracteres.
- O cabeçalho mostra "Total: N cards", que soma as quantidades.
```


#### Codex: `home:.agents/skills/ligamagic-listas/SKILL.md`

````skill-source home:.agents/skills/ligamagic-listas/SKILL.md 3449cdde304f211f961af116215c58e34e55b059d89c57e4345e4577093735fc
---
name: "ligamagic-listas"
description: "Use ao trabalhar com a Lista de Compras ou o Compra por Lista da LigaMagic - extrair cartas, gerar listas com edição, remover ou editar itens em lote. Para refazer ou conferir o carrinho por loja nos sites das lojas, use ligamagic-replicar-carrinho-nas-lojas."
---

# LigaMagic: listas e carrinho

Lineage: origin=claude; base=sha256:32a511da7caa37b7661f299f9c058c911d2aeae0ea3a9c9bc4eb9d1220d884c9; adaptation=codex

Interop: role = domain; owns = formato do Compra por Lista e manuseio da Lista de Compras; defers to = browser-automacao-segura (ações em lote), ligamagic-replicar-carrinho-nas-lojas (carrinho por loja e montagem nos sites das lojas); honors = idioma da mensagem, flags !! *** ...

Antes de ações em lote no navegador, siga também a skill `browser-automacao-segura`.

## Formato do Compra por Lista (?view=cards/lista)
Uma carta por linha: `[Quantidade] [Card] [TAGS]`. Tags aceitas (confirmadas no site):
- Edição: `[EDICAO=PIP]` (sigla da edição, ex.: M10, MH3, PIP)
- Qualidade mínima: `[QUALIDADE=NM]` (M, NM, SP, MP, HP, D)
- Idioma: `[IDIOMA=PT]`, `[idioma=en]`; omita para "Qualquer idioma"
- Extras: `[EXTRAS=FOIL]`, `[extras=textless, fnm]`

Exemplo: `1 Command Tower [EDICAO=PIP] [QUALIDADE=NM]`
Use o nome em inglês. Terrenos numerados funcionam assim: `1 Forest (#0326) [EDICAO=PIP]`.
Sintaxes como `[PIP]`, `(PIP)` ou `|PIP` NÃO funcionam.
Para conferir, cole a lista e clique em "Detalhar Características": a coluna Edição deve vir preenchida.

## Lista de Compras (?view=mp/carrinho&open=1)
A mesma página tem duas estruturas: a Lista de Compras (tabela, abaixo) e o carrinho por loja (blocos `.pad-bot-10` com `div.row` e `input.qty`, um bloco por loja). O carrinho por loja é tratado pela skill `ligamagic-replicar-carrinho-nas-lojas`.
- A tabela de itens é `document.querySelectorAll('table')[0]`. Por linha: `input[type=number]` (quantidade) e selects (edição, qualidade, idioma, extras). O nome aparece em `cells[0]`, com o nome em inglês na última linha.
- A primeira linha com selects é a de "Aplicar Valores", não uma carta.
- O texto da edição selecionada tem o formato `SIGLA - Nome` (ex.: `PIP - Fallout`).
- O botão de remover é `.btn-circle.remove`. A remoção é imediata no servidor (aparece um aviso "foi removido da sua Lista de Compras"). Durante o processamento, o botão vira um spinner. O carrinho por loja usa a mesma classe: confira em qual estrutura o botão está antes de clicar.
- Clicar duas vezes no mesmo item em processamento gera o alerta "Ops! Não foi possível realizar a operação", que trava o navegador. Remova um por vez e espere a linha sumir.
- O a ferramenta de leitura disponível pode falhar com seletores contendo certas strings ou com saídas longas. Use `querySelectorAll('table')[0]`, retorne os resultados em blocos pequenos, sem gravar estado na página.
- O cabeçalho mostra "Total: N cards", que soma as quantidades.

## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.

Os seletores históricos são pistas, não prova de que o site atual os usa. Confirme a estrutura observável. Só use extração de DOM quando a documentação da ferramenta permitir; caso contrário leia a interface e reporte os campos não acessíveis.
````
