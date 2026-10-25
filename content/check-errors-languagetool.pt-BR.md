---
id: check-errors-languagetool
lang: pt-BR
source_hash: 9aebd9a95f23
title: check_errors_languagetool.py
---

## What it is
`check_errors_languagetool.py` é uma verificação gramatical das frases do modo "achar o erro", feita com o [LanguageTool](https://languagetool.org/), um corretor gramatical que roda localmente em Java.

## What it does
Impõe duas regras. (1) Toda frase corrigida deve estar limpa no nível PICKY (a configuração mais rigorosa do LanguageTool), para que nenhuma frase ensine alemão que o LanguageTool rejeita. (2) Nenhum aviso pode cair em um trecho diferente do marcado, para o jogador nunca encontrar um segundo erro não intencional.

## How it does it
Um script [Python](https://www.python.org/) que chama o programa de linha de comando do LanguageTool (um arquivo Java, Java 17 ou mais novo; instalado no laptop em `~/.local/opt/languagetool-dl`, LanguageTool 6.6). O LanguageTool reconhece só cerca de um quarto dos erros plantados, então se o trecho marcado está mesmo errado continua sendo revisado à mão.

## Where it sits in the pipeline
Depois do [[build-vocab]], sempre que as frases com erro mudam.

## Who receives its output
O Claude, como aprovado ou reprovado antes de o conteúdo ser commitado.
