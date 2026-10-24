---
id: skill-ligamagic-listas
lang: pt-BR
source_hash: 2a626c489bc2
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
