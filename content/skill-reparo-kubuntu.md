---
id: skill-reparo-kubuntu
title: Skill: reparo-kubuntu (laptop repair)
aliases: [reparo-kubuntu]
kind: skill
project: skills
status: active
location: home:.claude/skills/reparo-kubuntu
fed_by: []
feeds: []
sources: [home:.claude/skills/reparo-kubuntu/SKILL.md, home:.agents/skills/reparo-kubuntu/SKILL.md]
reviewed: 2026-10-25T20:41Z
---

## What it is
The skill "reparo-kubuntu" ("Kubuntu repair") diagnoses and fixes problems of Giovanni's laptop (an Acer Nitro running Kubuntu 24.04 with the Plasma 5.27 desktop, the X11 display system and an Nvidia graphics card) and makes the fixes survive reboots. It is written in Portuguese. Its description says exactly that. Its role is "domain": it owns the diagnosis and fix flow on his Linux; it defers to [[skill-browser-automacao-segura]] if a browser is used; and it honours the language of the message and the depth flags `!!`, `***` and `...`. The version for Claude Code is edited only there; the Claude app keeps its own version ([[claude-ai-skills]]).

## Flow
trigger t1: A problem on Giovanni's laptop: Kubuntu, Plasma, X11 or the Nvidia card | [[acer-nitro]]
step s1: Collects diagnostics without changing anything, saved to a diag file
step s2: Maps the symptom to a first hypothesis and a safe test
decide d1: Does the safe test confirm the hypothesis?
step s3: Changes one thing safely, with a way back ready
step s4: Makes the fix permanent across reboots
step s5: Retests after a restart and records the result
step s6: Asks only what the log cannot answer: what changed, and is it reproducible | [[giovanni]]
product p1: A fix that survives reboots, with its Verify and Undo steps
product p2: A narrower hypothesis; nothing changed yet

t1 -> s1
s1 -> s2
s2 -> d1
d1 -yes-> s3
d1 -no-> s6
s3 -> s4
s4 -> s5
s5 -> p1
s6 -> p2

## What it does
It covers display, driver, audio, network, desktop and boot problems, step by step, with the commands that need administrator rights (`sudo`) handed to Giovanni to run with the `!` prefix. Its method comes from Google's "Effective Troubleshooting" ([SRE book](https://sre.google/sre-book/effective-troubleshooting/); SRE is site reliability engineering) and the Ubuntu seven-step troubleshooting: stabilise and preserve evidence → examine → hypotheses ordered by probability → one change at a time → fix → retest after a reboot → document. The traps are chasing an irrelevant symptom, an unsafe change during testing and assuming the old cause has returned.

## How it does it
A `SKILL.md` in `~/.claude/skills/reparo-kubuntu`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Maintenance of the laptop itself.

## Who receives its output
The [[acer-nitro]].

## Steps
0. **Format.** Conclusion first: the main hypothesis plus the next step. With `!!`: up to 5 lines (hypothesis, 1 test, 1 fix, how to verify). Every answer that proposes a fix ends with **Verify** (what to check after restarting) and **Undo** (how to revert).
1. **Stabilise and collect, changing nothing.** Claude Code runs on the laptop itself, so run the commands yourself without asking Giovanni to paste anything. One block collects the system version, kernel, Plasma version, session type, Nvidia driver version, the user and system journal warnings and errors of this boot, recent crash dumps and the recent package-manager history, and saves them to `~/diag_<date>_<time>.txt`. Commands with `sudo` ask for a password: give Giovanni the line to run with `! sudo ...`. Ask only what the log cannot answer: what changed (update, configuration, theme) and whether it is reproducible.
2. **Symptom → first hypothesis → safe test** (from his history). Black screen, no panel, or plasmashell or krunner crashing → crash of plasmashell (a font-library fault, or a missing theme) → `coredumpctl info plasmashell`, `systemctl --user restart plasma-plasmashell`. Crash in libfontconfig → corrupted font cache or a badly matched web font → `fc-cache -r -v`, `fc-match sans`. Accented capitals or odd keyboard → the Fcitx input method plus layout and model (`pc104alt`, `br`) → `fcitx5-diagnose`, `setxkbmap -query`. Touchpad without configuration → module or driver (libinput versus synaptics, an XCTECH receiver) → `xinput list`, `journalctl -k | grep -i touch`. Slow boot → `NetworkManager-wait-online` or fstab → `systemd-analyze blame | head`, `systemd-analyze critical-chain`. Flicker → Nvidia driver versus kernel → `ubuntu-drivers devices`, `dkms status`.
3. **Change safely.** One change at a time, saying what it proves. Before editing, make a dated backup (`cp -a`). Never `rm -rf` in `~/.config` or `/etc`: move things to a quarantine folder instead. Before touching a driver or the kernel, take a snapshot (Timeshift) if available. Explain `sudo` commands in one line and let him run them with `! sudo ...`; without sudo, run them yourself and show the relevant output.
4. **Make it permanent (his priority).** A fix becomes a script `~/fixes/<name>.sh` (idempotent, with a final check). If it must run every session, make a user systemd unit `~/.config/systemd/user/<name>.service` (`Type=oneshot`, `After=graphical-session.target` and, if it touches Plasma, `After=plasma-plasmashell.service`, `ExecStart=%h/fixes/<name>.sh`, `WantedBy=graphical-session.target`) and enable it with `systemctl --user enable <name>`. A Plasma environment variable goes into `~/.config/plasma-workspace/env/`.
5. **Retest and record.** Reboot, run the block of step 1 again and compare with the previous one. Record the cause, the fix and how to undo it in `~/fixes/LEIAME.md`.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

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
