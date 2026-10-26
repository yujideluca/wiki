---
id: acer-nitro
lang: pt-BR
source_hash: 0dddfd229fee
title: O notebook (Acer Nitro, yuji-nitro)
---

## What it is
Este é o notebook do Giovanni: um Acer Nitro com placa de vídeo Nvidia, rodando [Kubuntu](https://kubuntu.org/) (uma versão do sistema operacional [Linux](https://en.wikipedia.org/wiki/Linux) com a área de trabalho KDE Plasma). Na rede ele se chama `yuji-nitro`. Quase tudo neste wiki mora nele: as pastas dos projetos em `~/dev` (o `~` é a pasta pessoal do Giovanni), os programas do Claude e o servidor web deste wiki.

## What it does
É a máquina onde o trabalho acontece. Nele rodam o [[claude-code]] (o assistente de IA que escreve o código), o [[claude-assistant]] sempre ligado, os builds e testes de todos os projetos e o servidor deste wiki ([[wiki-service]]). Com o notebook desligado ou em suspensão, nada disso roda e o wiki fica inacessível.

## How it does it
A conta de usuário tem o "linger" ligado. Normalmente os programas de fundo de um usuário param quando ele sai da sessão; com o linger eles continuam rodando sem ninguém logado, e é isso que permite os serviços acima iniciarem junto com o sistema. Problemas do próprio notebook (tela, drivers, som, rede) são tratados com a skill [[skill-reparo-kubuntu]], e cada correção é tornada permanente para sobreviver a uma reinicialização. A área de trabalho roda em [Wayland](https://wayland.freedesktop.org/) (o sistema que desenha as janelas na tela) com Plasma 6 e quatro áreas de trabalho virtuais (espaços de trabalho separados). Win+1…4 vão para uma área, e Win+Shift+1…4 enviam a janela em foco para ela. No layout de teclado brasileiro do Giovanni, o segundo grupo precisa ser salvo como Win+!, Win+@, Win+# e Win+$, porque Shift+1…4 digita esses símbolos; ficam no arquivo `~/.config/kglobalshortcutsrc` do KDE.

## Where it sits in the pipeline
O "pipeline" neste wiki é a cadeia de etapas pela qual o trabalho passa. O notebook é o andar térreo sob tudo: o projeto [[laptop-setup]] descreve o que está instalado nele, e todo o resto roda por cima. A ferramenta [[machine-bootstrap]] registra a configuração deste notebook para que ela possa ser reconstruída após uma reinstalação.

## Who receives its output
Toda instância do Claude que roda localmente (veja [[claude-code]] e [[remote-assistant]]) e todo projeto construído nele.
