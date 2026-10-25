---
id: skill-ligamagic-listas
lang: de
source_hash: 4534aa382f44
title: Skill: ligamagic-listas
---

## What it is
Die Skill „ligamagic-listas“ behandelt Giovannis Arbeit mit der Einkaufsliste von LigaMagic („Lista de Compras“) und dem Sammelkauf-Formular („Compra por Lista“). [LigaMagic](https://www.ligamagic.com.br/) ist ein brasilianischer Marktplatz für Karten von [Magic: The Gathering](https://en.wikipedia.org/wiki/Magic:_The_Gathering). Die Skill ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: verwenden bei der Arbeit mit der Einkaufsliste oder dem Kauf-nach-Liste-Formular: Karten extrahieren, Listen mit Edition erzeugen, Einträge im Stapel entfernen oder bearbeiten. Um den Warenkorb pro Shop auf den eigenen Websites der Shops nachzubauen oder zu prüfen, [[skill-ligamagic-replicar-carrinho-nas-lojas]] verwenden.

## What it does
Sie extrahiert Karten, erzeugt Listen mit Edition und entfernt oder bearbeitet Einträge im Stapel. Ihre Rolle ist „Domäne“: Sie besitzt das Format des Kauf-nach-Liste-Formulars und den Umgang mit der Einkaufsliste; sie verweist auf [[skill-browser-automacao-segura]] (Stapelaktionen) und [[skill-ligamagic-replicar-carrinho-nas-lojas]] (Warenkörbe pro Shop und ihr Aufbau auf den Shop-Seiten); und sie beachtet die Sprache der Nachricht und die Tiefe-Flags `!!`, `***` und `...`.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/ligamagic-listas`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt. Vor Stapelaktionen im Browser folgt sie zusätzlich [[skill-browser-automacao-segura]].

## Where it sits in the pipeline
Giovannis Hobby Magic: The Gathering.

## Who receives its output
Giovannis LigaMagic-Listen und [[skill-ligamagic-replicar-carrinho-nas-lojas]] für die Warenkörbe pro Shop.

## Steps
1. **Format des Kauf-nach-Liste-Formulars** (`?view=cards/lista`): eine Karte pro Zeile als `[Menge] [Karte] [TAGS]`. Die akzeptierten Tags, auf der Seite bestätigt, sind: Edition `[EDICAO=PIP]` (das Kürzel der Edition, zum Beispiel M10, MH3, PIP); Mindestzustand `[QUALIDADE=NM]` (M mint, NM near mint, SP slightly played, MP moderately played, HP heavily played, D damaged); Sprache `[IDIOMA=PT]` oder `[idioma=en]` (für „jede Sprache“ weglassen); Extras `[EXTRAS=FOIL]` oder `[extras=textless, fnm]`.
2. **Beispiel und Regeln.** `1 Command Tower [EDICAO=PIP] [QUALIDADE=NM]`. Den englischen Kartennamen benutzen. Nummerierte Länder gehen so: `1 Forest (#0326) [EDICAO=PIP]`. Die Schreibweisen `[PIP]`, `(PIP)` oder `|PIP` funktionieren NICHT. Zum Prüfen die Liste einfügen und auf „Detalhar Características“ klicken: Die Spalte Edition muss gefüllt zurückkommen.
3. **Die Einkaufsliste** (`?view=mp/carrinho&open=1`). Dieselbe Seite hat zwei Strukturen: die Einkaufsliste (eine Tabelle, unten) und den Warenkorb pro Shop (Blöcke mit Zeilen und Mengenfeldern, ein Block pro Shop), der zu [[skill-ligamagic-replicar-carrinho-nas-lojas]] gehört. Die Artikeltabelle ist die erste Tabelle der Seite. Jede Zeile hat ein Zahlenfeld (Menge) und Auswahllisten (Edition, Zustand, Sprache, Extras); der Name steht in der ersten Zelle, mit dem englischen Namen in der letzten Zeile. Die erste Zeile mit Auswahllisten ist die Zeile „Aplicar Valores“ (Werte anwenden), keine Karte. Der Text der gewählten Edition hat die Form `KÜRZEL - Name` (zum Beispiel `PIP - Fallout`).
4. **Einträge entfernen.** Der Entfernen-Knopf ist `.btn-circle.remove`. Das Entfernen ist auf dem Server sofort (ein Hinweis erscheint, dass der Eintrag aus der Einkaufsliste entfernt wurde); während der Bearbeitung wird der Knopf zu einem Spinner. Der Warenkorb pro Shop nutzt dieselbe Klasse, also vor dem Klick prüfen, zu welcher Struktur der Knopf gehört.
5. **Fallen.** Zweimal auf ein gerade bearbeitetes Element zu klicken ergibt die Warnung „Ops! Não foi possível realizar a operação“, die den Browser einfriert: eines nach dem anderen entfernen und warten, bis die Zeile verschwindet. Das `javascript_tool` kann bei Selektoren mit bestimmten Zeichenfolgen oder langen Ausgaben scheitern: die erste Tabelle benutzen, Ergebnisse in `window.*`-Variablen speichern und in Blöcken von etwa 1.000 Zeichen lesen. Der Kopf zeigt „Total: N cards“, was die Mengen addiert.

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

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
