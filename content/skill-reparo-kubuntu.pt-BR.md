---
id: skill-reparo-kubuntu
lang: pt-BR
source_hash: ab9b9d26c71d
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

## Notes

O Codex agora usa a versão mantida separadamente em [[codex-skills]]. A fonte completa abaixo contém as regras de execução do Codex; o procedimento Claude acima continua sendo a versão Claude. Navegador, memória e conexões podem funcionar de formas diferentes.

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/reparo-kubuntu/SKILL.md`

````skill-source home:.claude/skills/reparo-kubuntu/SKILL.md 2998b68f21662719e79ac67210a207db06ac642f63df741ce2cc5778d0c1fac2
---
name: "reparo-kubuntu"
description: "Diagnostica e corrige problemas do notebook Acer Nitro do Giovanni (Kubuntu 24.04, Plasma 5.27, X11, Nvidia) e torna as correções permanentes entre reinicializações."
---


Code version: adapted for Claude Code on the laptop from `gui/skills/reparo-kubuntu`. Edited only by Claude Code; the app keeps its own version.
# Reparo Kubuntu

Lineage: origin=gui; base=00a09e5a0e1ea10c59d76c038d4b1cc404987b9a

Interop: role = domain; owns = fluxo de diagnóstico/correção no Linux dele; defers to = browser-automacao-segura (se usar navegador); honors = idioma da mensagem, flags !! *** ...

Método (Google SRE "Effective Troubleshooting" 2016; Ubuntu Seven-Step Troubleshooting): estabilizar e preservar evidência → examinar → hipóteses ordenadas por probabilidade → **uma mudança por vez** → corrigir → retestar após reboot → documentar. Armadilhas: perseguir sintoma irrelevante, mudança insegura durante o teste, assumir que a causa antiga voltou.

## 0. Formato
Conclusão primeiro: hipótese principal + o próximo passo. `!!` → até 5 linhas: hipótese, 1 teste, 1 correção, como verificar. Toda resposta que propõe correção termina com **Verificar** (o que checar após reiniciar) e **Desfazer** (como reverter).

## 1. Estabilizar e coletar (sem mudar nada)
Claude Code roda no próprio notebook: rode você mesmo, sem pedir para colar. Comandos com `sudo` pedem senha; entregue a linha para ele rodar com `! sudo ...` no prompt.
```bash
{ lsb_release -ds; uname -r; plasmashell --version; echo "session=$XDG_SESSION_TYPE";
  nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null;
  journalctl --user -b -p warning --no-pager | tail -60; journalctl -b -p err --no-pager | tail -40;
  coredumpctl list --since=-2d --no-pager | tail -10; ls -lt /var/log/apt/history.log* | head -2; tail -30 /var/log/apt/history.log; } > ~/diag_$(date +%F_%H%M).txt 2>&1; echo salvo
```
Pergunte só o que o log não responde: o que mudou (update, config, tema) e se é reproduzível.

## 2. Mapa de sintomas → primeira hipótese (do histórico dele)
| Sintoma | Hipótese 1 | Teste seguro |
|---|---|---|
| tela preta / sem painel / plasmashell ou krunner cai | crash do plasmashell (fontconfig `FcCharSetHasChar`, tema ausente) | `coredumpctl info plasmashell`; `systemctl --user restart plasma-plasmashell` |
| crash em libfontconfig | cache de fontes corrompido / fonte web (woff) mal casada | `fc-cache -r -v`; `fc-match sans` |
| letras acentuadas maiúsculas / teclado estranho | Fcitx + layout/modelo (`pc104alt`, `br`) | `fcitx5-diagnose`; `setxkbmap -query` |
| touchpad sem configuração | módulo/driver (libinput × synaptics, receptor XCTECH) | `xinput list`; `journalctl -k \| grep -i touch` |
| boot lento | `NetworkManager-wait-online`, fstab | `systemd-analyze blame \| head`; `systemd-analyze critical-chain` |
| flicker / tela | driver Nvidia × kernel | `ubuntu-drivers devices`; `dkms status` |

## 3. Mudar com segurança
- Uma mudança por vez; diga o que ela prova.
- Antes de editar: backup com data (`cp -a`). Nunca `rm -rf` em `~/.config` ou `/etc`: mova para quarentena. Antes de mexer em driver/kernel: snapshot (Timeshift) se disponível.
- Comandos com `sudo` explicados em uma linha; ele roda com `! sudo ...`. Sem sudo, rode você mesmo e mostre a saída relevante.

## 4. Tornar permanente (prioridade dele)
- Correção vira `~/fixes/<nome>.sh` (idempotente, com checagem final).
- Precisa rodar a cada sessão → unit systemd do usuário `~/.config/systemd/user/<nome>.service` (`Type=oneshot`, `After=graphical-session.target` e, se mexer no Plasma, `After=plasma-plasmashell.service`, `ExecStart=%h/fixes/<nome>.sh`, `WantedBy=graphical-session.target`) + `systemctl --user enable <nome>`.
- Variável de ambiente do Plasma → `~/.config/plasma-workspace/env/`.

## 5. Retestar e registrar
Reiniciar, rodar o bloco do passo 1, comparar com o anterior. Registre causa, correção e como desfazer em `~/fixes/LEIAME.md`.
````


#### Codex: `home:.agents/skills/reparo-kubuntu/SKILL.md`

````skill-source home:.agents/skills/reparo-kubuntu/SKILL.md 4e416dd2a7aba1d72057fff20977a5e6d3e8fe21418d8f5cdaa8c0036b866389
---
name: "reparo-kubuntu"
description: "Diagnostica e corrige problemas do notebook Acer Nitro do Giovanni (Kubuntu 24.04, Plasma 5.27, X11, Nvidia) e torna as correções permanentes entre reinicializações."
---


# Reparo Kubuntu

Lineage: origin=claude; base=sha256:bc5e579a53a63a9eb03ee01733abe8f2b2bfdf3fc533b675d008ad1fd1c92cbc; adaptation=codex

Interop: role = domain; owns = fluxo de diagnóstico/correção no Linux dele; defers to = browser-automacao-segura (se usar navegador); honors = idioma da mensagem, flags !! *** ...

Método (Google SRE "Effective Troubleshooting" 2016; Ubuntu Seven-Step Troubleshooting): estabilizar e preservar evidência → examinar → hipóteses ordenadas por probabilidade → **uma mudança por vez** → corrigir → retestar após reboot → documentar. Armadilhas: perseguir sintoma irrelevante, mudança insegura durante o teste, assumir que a causa antiga voltou.

## 0. Formato
Conclusão primeiro: hipótese principal + o próximo passo. `!!` → até 5 linhas: hipótese, 1 teste, 1 correção, como verificar. Toda resposta que propõe correção termina com **Verificar** (o que checar após reiniciar) e **Desfazer** (como reverter).

## 1. Estabilizar e coletar (sem mudar nada)
Codex roda no próprio notebook: rode você mesmo, sem pedir para colar. Comandos com `sudo` pedem senha; entregue a linha para ele rodar com `sudo ...` num terminal local.
```bash
{ lsb_release -ds; uname -r; plasmashell --version; echo "session=$XDG_SESSION_TYPE";
  nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null;
  journalctl --user -b -p warning --no-pager | tail -60; journalctl -b -p err --no-pager | tail -40;
  coredumpctl list --since=-2d --no-pager | tail -10; ls -lt /var/log/apt/history.log* | head -2; tail -30 /var/log/apt/history.log; } > ~/diag_$(date +%F_%H%M).txt 2>&1; echo salvo
```
Pergunte só o que o log não responde: o que mudou (update, config, tema) e se é reproduzível.

## 2. Mapa de sintomas → primeira hipótese (do histórico dele)
| Sintoma | Hipótese 1 | Teste seguro |
|---|---|---|
| tela preta / sem painel / plasmashell ou krunner cai | crash do plasmashell (fontconfig `FcCharSetHasChar`, tema ausente) | `coredumpctl info plasmashell`; `systemctl --user restart plasma-plasmashell` |
| crash em libfontconfig | cache de fontes corrompido / fonte web (woff) mal casada | `fc-cache -r -v`; `fc-match sans` |
| letras acentuadas maiúsculas / teclado estranho | Fcitx + layout/modelo (`pc104alt`, `br`) | `fcitx5-diagnose`; `setxkbmap -query` |
| touchpad sem configuração | módulo/driver (libinput × synaptics, receptor XCTECH) | `xinput list`; `journalctl -k \| grep -i touch` |
| boot lento | `NetworkManager-wait-online`, fstab | `systemd-analyze blame \| head`; `systemd-analyze critical-chain` |
| flicker / tela | driver Nvidia × kernel | `ubuntu-drivers devices`; `dkms status` |

## 3. Mudar com segurança
- Uma mudança por vez; diga o que ela prova.
- Antes de editar: backup com data (`cp -a`). Nunca `rm -rf` em `~/.config` ou `/etc`: mova para quarentena. Antes de mexer em driver/kernel: snapshot (Timeshift) se disponível.
- Comandos com `sudo` explicados em uma linha; ele roda com `sudo ...` num terminal local. Sem sudo, rode você mesmo e mostre a saída relevante.

## 4. Tornar permanente (prioridade dele)
- Correção vira `~/fixes/<nome>.sh` (idempotente, com checagem final).
- Precisa rodar a cada sessão → unit systemd do usuário `~/.config/systemd/user/<nome>.service` (`Type=oneshot`, `After=graphical-session.target` e, se mexer no Plasma, `After=plasma-plasmashell.service`, `ExecStart=%h/fixes/<nome>.sh`, `WantedBy=graphical-session.target`) + `systemctl --user enable <nome>`.
- Variável de ambiente do Plasma → `~/.config/plasma-workspace/env/`.

## 5. Retestar e registrar
Reiniciar, rodar o bloco do passo 1, comparar com o anterior. Registre causa, correção e como desfazer em `~/fixes/LEIAME.md`.

## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
