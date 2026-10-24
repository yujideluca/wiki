---
id: skill-reparo-kubuntu
lang: pt-BR
source_hash: efb7759868da
title: Skill: reparo-kubuntu (conserto do notebook)
---

## What it is
A skill "reparo-kubuntu" ("conserto do Kubuntu") diagnostica e corrige problemas do notebook do Giovanni (um Acer Nitro com Kubuntu 24.04, a área de trabalho Plasma 5.27, o sistema de exibição X11 e uma placa de vídeo Nvidia) e faz as correções sobreviverem a reinicializações. É escrita em português. Sua descrição diz exatamente isso. Seu papel é "domínio": é dona do fluxo de diagnóstico e correção no Linux dele; remete à [[skill-browser-automacao-segura]] se usar navegador; e respeita o idioma da mensagem e as flags de profundidade `!!`, `***` e `...`. A versão do Claude Code só é editada lá; o app Claude mantém a sua ([[claude-ai-skills]]).

## What it does
Cobre problemas de tela, drivers, áudio, rede, desktop e boot, passo a passo, com os comandos que exigem direitos de administrador (`sudo`) entregues ao Giovanni para executar com o prefixo `!`. O método vem do "Effective Troubleshooting" do Google ([livro SRE](https://sre.google/sre-book/effective-troubleshooting/); SRE é site reliability engineering) e do troubleshooting de sete passos do Ubuntu: estabilizar e preservar evidências → examinar → hipóteses ordenadas por probabilidade → uma mudança por vez → corrigir → retestar após reiniciar → documentar. As armadilhas são perseguir um sintoma irrelevante, uma mudança insegura durante o teste e assumir que a causa antiga voltou.

## How it does it
Um `SKILL.md` em `~/.claude/skills/reparo-kubuntu`; o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
Manutenção do próprio notebook.

## Who receives its output
O [[acer-nitro]].

## Steps
0. **Formato.** Conclusão primeiro: a hipótese principal mais o próximo passo. Com `!!`: até 5 linhas (hipótese, 1 teste, 1 correção, como verificar). Toda resposta que propõe uma correção termina com **Verificar** (o que checar após reiniciar) e **Desfazer** (como reverter).
1. **Estabilizar e coletar, sem mudar nada.** O Claude Code roda no próprio notebook, então executar os comandos você mesmo, sem pedir ao Giovanni que cole nada. Um bloco coleta a versão do sistema, o kernel, a versão do Plasma, o tipo de sessão, a versão do driver Nvidia, os avisos e erros do journal do usuário e do sistema deste boot, despejos de travamento recentes e o histórico recente do gerenciador de pacotes, e salva em `~/diag_<data>_<hora>.txt`. Comandos com `sudo` exigem a senha do administrador, então entregar ao Giovanni a linha para executar com `! sudo ...`. Perguntar só o que o log não responde: o que mudou (atualização, configuração, tema) e se é reproduzível.
2. **Sintoma → primeira hipótese → teste seguro** (do histórico dele). Tela preta, sem painel, ou plasmashell ou krunner caindo → travamento do plasmashell (uma falha da biblioteca de fontes ou um tema ausente) → `coredumpctl info plasmashell`, `systemctl --user restart plasma-plasmashell`. Travamento na libfontconfig → cache de fontes corrompido ou fonte web mal casada → `fc-cache -r -v`, `fc-match sans`. Letras acentuadas maiúsculas ou teclado estranho → o método de entrada Fcitx mais layout e modelo (`pc104alt`, `br`) → `fcitx5-diagnose`, `setxkbmap -query`. Touchpad sem configuração → módulo ou driver (libinput versus synaptics, um receptor XCTECH) → `xinput list`, `journalctl -k | grep -i touch`. Boot lento → `NetworkManager-wait-online` ou fstab → `systemd-analyze blame | head`, `systemd-analyze critical-chain`. Cintilação → driver Nvidia versus kernel → `ubuntu-drivers devices`, `dkms status`.
3. **Mudar com segurança.** Uma mudança por vez, dizendo o que ela prova. Antes de editar, fazer backup datado (`cp -a`). Nunca `rm -rf` em `~/.config` ou `/etc`: mover para uma pasta de quarentena. Antes de mexer em driver ou kernel, tirar um snapshot (Timeshift) se disponível. Explicar comandos `sudo` em uma linha e deixá-lo executar com `! sudo ...`; sem sudo, executar você mesmo e mostrar a saída relevante.
4. **Tornar permanente (prioridade dele).** Uma correção vira um script `~/fixes/<nome>.sh` (idempotente, com checagem final). Se precisar rodar a cada sessão, criar uma unidade systemd de usuário `~/.config/systemd/user/<nome>.service` (`Type=oneshot`, `After=graphical-session.target` e, se mexer no Plasma, `After=plasma-plasmashell.service`, `ExecStart=%h/fixes/<nome>.sh`, `WantedBy=graphical-session.target`) e ativá-la com `systemctl --user enable <nome>`. Uma variável de ambiente do Plasma vai em `~/.config/plasma-workspace/env/`.
5. **Retestar e registrar.** Reiniciar, executar de novo o bloco do passo 1 e comparar com o anterior. Registrar causa, correção e como desfazer em `~/fixes/LEIAME.md`.
