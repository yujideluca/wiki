---
id: study-view-model
lang: pt-BR
source_hash: fa832083ac66
title: StudyViewModel (estado da interface)
aliases: [telas]
---

## What it is
O único ViewModel do [[quizapp]]: expõe um `UiState` selado (`ModeSelect`, `Studying`, `Finished`, `Settings`, `Failed`) para as telas em Compose.

## What it does
Transforma os resultados do [[study-controller]] no que as telas mostram: tela inicial (calendário, meta diária, cartões de modo), a pergunta com retorno (verde/vermelho, explicação, avanço automático em 0,5 s, exceto no Fehler finden), configurações e o aviso de atualização.

## How it does it
Sobrevive à recriação da activity quando o idioma muda; o texto que ele mesmo produz passa pelo auxiliar `t()`. As telas escalam com a altura (`ScreenScale`); o teste de encaixe de tela confere que nada fica escondido abaixo da dobra em celulares altos.

## Where it sits in the pipeline
O topo do app: `ui → StudyController`.

## Who receives its output
O Giovanni no [[phone]].
