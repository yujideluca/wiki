---
id: skill-ligamagic-listas
lang: pt-BR
source_hash: 6aecdf82064d
title: Skill: ligamagic-listas
---

## What it is
A skill "ligamagic-listas" trata do trabalho do Giovanni com a Lista de Compras da LigaMagic e o formulário de compra em massa ("Compra por Lista"). A [LigaMagic](https://www.ligamagic.com.br/) é um marketplace brasileiro de cartas de [Magic: The Gathering](https://en.wikipedia.org/wiki/Magic:_The_Gathering). A skill é escrita em português. Sua descrição diz: usar ao trabalhar com a Lista de Compras ou o Compra por Lista: extrair cartas, gerar listas com edição, remover ou editar itens em lote. Para refazer ou conferir o carrinho por loja nos sites das lojas, usar a [[skill-ligamagic-replicar-carrinho-nas-lojas]].

## What it does
Extrai cartas, gera listas com edição e remove ou edita itens em lote. Seu papel é "domínio": é dona do formato do Compra por Lista e do manuseio da Lista de Compras; remete à [[skill-browser-automacao-segura]] (ações em lote) e à [[skill-ligamagic-replicar-carrinho-nas-lojas]] (carrinho por loja e montagem nos sites das lojas); e respeita o idioma da mensagem e as flags de profundidade `!!`, `***` e `...`.

## How it does it
Um `SKILL.md` em `~/.claude/skills/ligamagic-listas`; o Claude o carrega quando um pedido combina com a descrição. Antes de ações em lote no navegador, segue também a [[skill-browser-automacao-segura]].

## Where it sits in the pipeline
O hobby de Magic: The Gathering do Giovanni.

## Who receives its output
As listas da LigaMagic do Giovanni e a [[skill-ligamagic-replicar-carrinho-nas-lojas]] para os carrinhos por loja.

## Steps
1. **Formato do Compra por Lista** (`?view=cards/lista`): uma carta por linha como `[Quantidade] [Card] [TAGS]`. As tags aceitas, confirmadas no site, são: edição `[EDICAO=PIP]` (a sigla da edição, por exemplo M10, MH3, PIP); qualidade mínima `[QUALIDADE=NM]` (M mint, NM near mint, SP slightly played, MP moderately played, HP heavily played, D damaged); idioma `[IDIOMA=PT]` ou `[idioma=en]` (omitir para "qualquer idioma"); extras `[EXTRAS=FOIL]` ou `[extras=textless, fnm]`.
2. **Exemplo e regras.** `1 Command Tower [EDICAO=PIP] [QUALIDADE=NM]`. Usar o nome da carta em inglês. Terrenos numerados funcionam assim: `1 Forest (#0326) [EDICAO=PIP]`. As sintaxes `[PIP]`, `(PIP)` ou `|PIP` NÃO funcionam. Para conferir, colar a lista e clicar em "Detalhar Características": a coluna Edição deve vir preenchida.
3. **A Lista de Compras** (`?view=mp/carrinho&open=1`). A mesma página tem duas estruturas: a Lista de Compras (uma tabela, abaixo) e o carrinho por loja (blocos com linhas e campos de quantidade, um bloco por loja), que pertence à [[skill-ligamagic-replicar-carrinho-nas-lojas]]. A tabela de itens é a primeira tabela da página. Cada linha tem um campo numérico (quantidade) e seletores (edição, qualidade, idioma, extras); o nome aparece na primeira célula, com o nome em inglês na última linha. A primeira linha com seletores é a de "Aplicar Valores", não uma carta. O texto da edição selecionada tem o formato `SIGLA - Nome` (por exemplo `PIP - Fallout`).
4. **Remover itens.** O botão de remover é `.btn-circle.remove`. A remoção é imediata no servidor (aparece um aviso de que o item foi removido da Lista de Compras); durante o processamento o botão vira um spinner. O carrinho por loja usa a mesma classe, então conferir a qual estrutura o botão pertence antes de clicar.
5. **Armadilhas.** Clicar duas vezes no mesmo item em processamento gera o alerta "Ops! Não foi possível realizar a operação", que trava o navegador: remover um por vez e esperar a linha sumir. O `javascript_tool` pode falhar com seletores contendo certas strings ou com saídas longas: usar a primeira tabela, guardar resultados em variáveis `window.*` e ler em blocos de cerca de 1.000 caracteres. O cabeçalho mostra "Total: N cards", que soma as quantidades.

## Notes

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

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

```skill-source home:.agents/skills/ligamagic-listas/SKILL.md d0c466478a6b31dbb47d7dec088c8af5fae291714dc00e17ce2d3e9b1e0dc29a
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
