---
id: skill-reparo-kubuntu
lang: de
source_hash: 4e4c84a33b6b
title: Skill: reparo-kubuntu (Laptop-Reparatur)
---

## What it is
Die Skill „reparo-kubuntu“ („Kubuntu-Reparatur“) diagnostiziert und behebt Probleme von Giovannis Laptop (ein Acer Nitro mit Kubuntu 24.04, der Plasma-5.27-Oberfläche, dem Anzeigesystem X11 und einer Nvidia-Grafikkarte) und macht die Reparaturen neustartfest. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt genau das. Ihre Rolle ist „Domäne“: Sie besitzt den Diagnose- und Reparaturablauf auf seinem Linux; sie verweist auf [[skill-browser-automacao-segura]], falls ein Browser benutzt wird; und sie beachtet die Sprache der Nachricht und die Tiefe-Flags `!!`, `***` und `...`. Die Fassung für Claude Code wird nur dort bearbeitet; die Claude-App behält ihre eigene Fassung ([[claude-ai-skills]]).

## Flow
trigger t1: Ein Problem an Giovannis Laptop: Kubuntu, Plasma, X11 oder die Nvidia-Karte | [[acer-nitro]]
step s1: Sammelt Diagnosen ohne etwas zu ändern, gespeichert in einer diag-Datei
step s2: Ordnet das Symptom einer ersten Hypothese und einem sicheren Test zu
decide d1: Bestätigt der sichere Test die Hypothese?
step s3: Ändert eine Sache sicher, mit bereitem Rückweg
step s4: Macht die Korrektur über Neustarts hinweg dauerhaft
step s5: Testet nach einem Neustart erneut und hält das Ergebnis fest
step s6: Fragt nur, was das Protokoll nicht beantwortet: was sich änderte und ob es reproduzierbar ist | [[giovanni]]
product p1: Eine Korrektur, die Neustarts übersteht, mit Verify- und Undo-Schritten
product p2: Eine engere Hypothese; noch nichts geändert

t1 -> s1
s1 -> s2
s2 -> d1
d1 -ja-> s3
d1 -nein-> s6
s3 -> s4
s4 -> s5
s5 -> p1
s6 -> p2

## What it does
Sie deckt Probleme mit Anzeige, Treibern, Ton, Netzwerk, Desktop und Start ab, Schritt für Schritt, wobei Befehle, die Administratorrechte brauchen (`sudo`), Giovanni zum Ausführen mit dem Präfix `!` übergeben werden. Ihre Methode stammt aus Googles „Effective Troubleshooting“ ([SRE-Buch](https://sre.google/sre-book/effective-troubleshooting/); SRE ist Site Reliability Engineering) und dem siebenstufigen Troubleshooting von Ubuntu: stabilisieren und Beweise sichern → untersuchen → nach Wahrscheinlichkeit geordnete Hypothesen → eine Änderung nach der anderen → beheben → nach einem Neustart erneut testen → dokumentieren. Die Fallen sind, einem irrelevanten Symptom nachzujagen, eine unsichere Änderung während des Tests und die Annahme, die alte Ursache sei zurückgekehrt.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/reparo-kubuntu`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Wartung des Laptops selbst.

## Who receives its output
Der [[acer-nitro]].

## Steps
0. **Format.** Zuerst die Schlussfolgerung: die Haupthypothese plus der nächste Schritt. Mit `!!`: bis zu 5 Zeilen (Hypothese, 1 Test, 1 Reparatur, wie man prüft). Jede Antwort, die eine Reparatur vorschlägt, endet mit **Prüfen** (was nach dem Neustart zu kontrollieren ist) und **Rückgängig** (wie man zurückdreht).
1. **Stabilisieren und sammeln, ohne etwas zu ändern.** Claude Code läuft auf dem Laptop selbst, also die Befehle selbst ausführen, ohne Giovanni etwas einfügen zu lassen. Ein Block sammelt Systemversion, Kernel, Plasma-Version, Sitzungstyp, Nvidia-Treiberversion, die Warnungen und Fehler des Benutzer- und Systemjournals dieses Starts, aktuelle Absturzabbilder und die jüngste Verlaufsliste des Paketmanagers und speichert sie in `~/diag_<Datum>_<Uhrzeit>.txt`. Befehle mit `sudo` fragen nach einem Passwort: Giovanni die Zeile zum Ausführen mit `! sudo ...` geben. Nur fragen, was das Log nicht beantwortet: was sich geändert hat (Update, Konfiguration, Theme) und ob es reproduzierbar ist.
2. **Symptom → erste Hypothese → sicherer Test** (aus seiner Geschichte). Schwarzer Bildschirm, kein Panel oder Absturz von plasmashell oder krunner → Absturz von plasmashell (ein Fehler der Schriftbibliothek oder ein fehlendes Theme) → `coredumpctl info plasmashell`, `systemctl --user restart plasma-plasmashell`. Absturz in libfontconfig → beschädigter Schriftcache oder schlecht passende Webschrift → `fc-cache -r -v`, `fc-match sans`. Akzentuierte Großbuchstaben oder seltsame Tastatur → die Eingabemethode Fcitx plus Layout und Modell (`pc104alt`, `br`) → `fcitx5-diagnose`, `setxkbmap -query`. Touchpad ohne Konfiguration → Modul oder Treiber (libinput gegenüber synaptics, ein XCTECH-Empfänger) → `xinput list`, `journalctl -k | grep -i touch`. Langsamer Start → `NetworkManager-wait-online` oder fstab → `systemd-analyze blame | head`, `systemd-analyze critical-chain`. Flackern → Nvidia-Treiber gegenüber Kernel → `ubuntu-drivers devices`, `dkms status`.
3. **Sicher ändern.** Eine Änderung nach der anderen und sagen, was sie beweist. Vor dem Bearbeiten ein datiertes Backup machen (`cp -a`). Nie `rm -rf` in `~/.config` oder `/etc`: stattdessen in einen Quarantäneordner verschieben. Vor Eingriffen in Treiber oder Kernel einen Snapshot (Timeshift) machen, falls verfügbar. `sudo`-Befehle in einer Zeile erklären und ihn mit `! sudo ...` ausführen lassen; ohne sudo selbst ausführen und die relevante Ausgabe zeigen.
4. **Dauerhaft machen (seine Priorität).** Eine Reparatur wird zu einem Skript `~/fixes/<Name>.sh` (idempotent, mit abschließender Prüfung). Muss sie in jeder Sitzung laufen, eine systemd-Benutzereinheit `~/.config/systemd/user/<Name>.service` anlegen (`Type=oneshot`, `After=graphical-session.target` und, falls sie Plasma berührt, `After=plasma-plasmashell.service`, `ExecStart=%h/fixes/<Name>.sh`, `WantedBy=graphical-session.target`) und mit `systemctl --user enable <Name>` aktivieren. Eine Plasma-Umgebungsvariable kommt nach `~/.config/plasma-workspace/env/`.
5. **Erneut testen und festhalten.** Neu starten, den Block aus Schritt 1 erneut ausführen und mit dem vorigen vergleichen. Ursache, Reparatur und Rückgängigmachen in `~/fixes/LEIAME.md` festhalten.

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

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
