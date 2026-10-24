---
id: skill-ligamagic-replicar-carrinho-nas-lojas
title: Skill: ligamagic-replicar-carrinho-nas-lojas
aliases: [ligamagic-replicar-carrinho-nas-lojas]
kind: skill
project: skills
status: active
location: home:.claude/skills/ligamagic-replicar-carrinho-nas-lojas
fed_by: [skill-ligamagic-listas]
feeds: []
sources: [home:.claude/skills/ligamagic-replicar-carrinho-nas-lojas/SKILL.md]
reviewed: 2026-10-22T16:33Z
---

## What it is
The skill "ligamagic-replicar-carrinho-nas-lojas" rebuilds LigaMagic's per-store cart on each store's own website and reconciles the two before checkout. It is written in Portuguese. Its description says: it redoes the per-store cart of LigaMagic on each store's own site (the same card, edition, language, condition, extras and quantity) and reconciles both before checkout; use it when Giovanni asks to check the LigaMagic carts and build or check them on the stores' sites, without using LigaMagic's links. It comes from a task on 12 October 2026 (5 stores, 90 items) and prevents the errors found then: a foil or promo item skipped when reading, stock read as quantity, a duplicate copy from a repeated click, a similar edition chosen instead of the right one, and a check done only by item count.

## What it does
It copies the same card, edition, language, condition, extras and quantity into each store's cart, without using LigaMagic's links; the purchases themselves need Giovanni's approval. Its role is "domain": it owns the flow from LigaMagic to the store, the scripts that read the per-store cart and the product page, the reconciliation and the final report; it defers to [[skill-ligamagic-listas]], to [[skill-browser-automacao-segura]] (alerts, loops, destructive actions: this one prevails), to [[skill-click-protocol]] (click mechanics) and to [[skill-minimize-site-approvals]] (domains).

## How it does it
A `SKILL.md` in `~/.claude/skills/ligamagic-replicar-carrinho-nas-lojas`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Giovanni's Magic: The Gathering hobby.

## Who receives its output
Giovanni, before paying.

## Steps
Fixed rules:
1. LigaMagic is read-only. Never click `.btn-circle.remove` (it removes the item or a whole store).
2. In the store: search, BUY (the product's "COMPRAR" button) and correct the quantity. Never log in, create an account, pay, fill forms or press the cart's "COMPRAR" button (checkout).
3. Items that were already in the store's cart stay (his default: keep and add). Ask only if he has not said.
4. Do not reach the stores through LigaMagic's links.
5. Before adding, install the alert log (rule 3 of [[skill-browser-automacao-segura]]). One item at a time; never two clicks without a check between them.
6. A short progress message every 5 items and at every store change.
7. `navigate` alone, outside batches. Batches of at most 4 harmless actions, ending in a check ([[skill-click-protocol]]).

Checklist (copy and tick): S1 read LigaMagic (script A) → the expected list E per store, list the domains and ask for access at once; S2 for each store read R0 (the cart before touching it); S3 add each item of E (script B + the choice rule); S4 reconcile the store until it passes; S5 report.

S1. **The LigaMagic cart** (`?view=mp/carrinho&open=1`). Script A (tested on 12 Oct 2026; 90 lines, 5 stores) reads, for each store block: the store name, the number of items in the header, the total, and for each row the card name (the English name after the last " / "), edition (from the edition icon's title), language, condition, extras (Foil, Promo, Pre-release, Textless, Etched, signed, altered, oversize), quantity (the quantity input), stock and subtotal. Validate before using: the header count equals the number of lines of each store and no edition, language or condition field is empty; if it fails (the site changed), read row by row from the page. Read the items in slices; the tool cuts long output and blocks URLs. "N unids." is STOCK, never quantity; quantity is the input's value. If a quantity is above 1, ask whether it is intended before copying it (an extra copy was once made by mistake). The shopping list (a table with selects) belongs to [[skill-ligamagic-listas]]; do not confuse it with the per-store cart. To find the store's website, click the store's name; confirmed domains: primemtg.com.br and tavernagamehouse.com.br.

S2. **R0 of the store.** Open `https://<store>/?view=ecom/carrinho` and read the page text: keep the lines, the subtotal and the `txt_qty_*` fields (inputs whose name starts with that). Without "Olá, <name>" at the top, the cart is a guest cart: warn at the end.

S3. **Adding one item.** (a) Direct search: `https://<store>/?view=ecom/itens&busca=<English name>`; one result opens the product; with several, art cards, "with signature" and tokens are other products, so open candidates until the edition is found. (b) Script B (product page; tested on Prime MTG, the same platform as the other stores) lists the purchasable rows with edition, language, condition, extras, stock and price; if no rows are found, hover over each row's edition icon and zoom in. (c) Choice rule (stop at the first filter that gives 1 row): rows with the same edition, language, condition and extras as LigaMagic → buy that one; plus equal stock and a final price equal to LigaMagic's unit price breaks ties; 0 rows → the variant is missing: do not substitute, record it. Stores use LigaMagic's system, so edition, language, stock and price come with the same text; similar editions are different rows (for example "FINAL FANTASY Commander (Extended Art)" is the right one and "FINAL FANTASY Commander" is another on the same page). (d) BUY on row i, one click only; for the first item of the session test the click by script, and if the cart counter does not rise, use `find` (the ref of that row's BUY) or, if `find` fails, scroll the row to the centre, take a screenshot and click the BUY of the central row; use whichever path worked for the rest of the store. (e) Expected change: the cart counter (the number next to the cart icon at the top right) rises by exactly 1; any other value → stop and read the cart before clicking again. Two failures on the same step → screenshot, report, ask.

S4. **Reconcile the store** (cheapest to most expensive; stop at the first that fails). (1) Counter (counts units) = units of R0 + sum of the quantities of E. (2) Cart subtotal = subtotal of R0 + LigaMagic's total. (3) The `txt_qty_*` of the new items = the quantities of E; a row subtotal different from the unit price reveals quantity 2. (4) If all is right, the store is done; otherwise compare by key `name | edition | language | condition | extras` (expected = R0 + E) and fix: missing → S3; extra quantity from this session → triple-click the field, type the value, Tab, click "Alterar", reload and check; a wrong row added in this session → ask before removing. (5) Reload and repeat until it passes; without a reload it is not checked.

S5. **Report** (in the language of Giovanni's message): a table of store | items | LigaMagic total | subtotal in the store; then only what applies: earlier items kept (and their value), a guest cart, missing variants, quantities above 1 coming from LigaMagic, a header mismatch explained. Say that it stopped before checkout. With `!!`: only the table and the caveats. With `***`: include the reconciliation by key for each store.
