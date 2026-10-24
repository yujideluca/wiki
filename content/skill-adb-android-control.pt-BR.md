---
id: skill-adb-android-control
lang: pt-BR
source_hash: a58d90469ff0
title: Skill: adb-android-control
---

## What it is
A skill "adb-android-control" é a referência de comandos para trabalhar com o celular do Giovanni (um Motorola edge 50 fusion) por adb durante o desenvolvimento de apps, como o QuizApp. adb é a Android Debug Bridge ([documentação](https://developer.android.com/tools/adb)): uma ferramenta que permite a um computador controlar um celular por cabo. Sua descrição diz: usar em trabalho Android por adb durante o desenvolvimento de apps: instalar um APK (Android Package, o arquivo instalável do app), abrir o app, tocar, deslizar e digitar para exercitar um fluxo, tirar uma captura de tela, ler o logcat (o log do sistema do Android, [documentação](https://developer.android.com/tools/logcat)) em busca de travamentos, o dumpsys (um despejo do estado dos serviços do sistema) e permissões. É a referência de comandos da verificação de depuração depois de programar. Não serve para perguntas gerais sobre o celular, problemas de USB ou Kubuntu ([[skill-reparo-kubuntu]]) nem nada sem adb. É adaptada da skill de código aberto hah23255/adb-android-control 2.0.1 (licença MIT): só a referência de comandos e os fluxos; os scripts do Termux, o scanner de portas de rede, o scanner de rádio e o pacote Python foram deixados de fora, e um escaneamento de rede nunca deve ser executado a partir desta skill.

## What it does
Permite ao Claude exercitar um app no celular e ler o que aconteceu: a verificação de depuração de primeira linha depois de programar o [[quizapp]]. Seu papel é "domínio"; remete ao CLAUDE.md do projeto (no QuizApp, `source ~/dev/env.sh` coloca o adb no caminho e descreve os passos de build e instalação), à [[skill-verification-before-completion]] (o que conta como prova) e à [[skill-reparo-kubuntu]] (problemas de USB e do hospedeiro).

## How it does it
Um `SKILL.md` em `~/.claude/skills/adb-android-control`; o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
Parte do processo de desenvolvimento no Claude Code, usada em todo projeto que tenha um app Android.

## Who receives its output
O [[phone]]; a saída do logcat ([[study-debug-log]]) volta ao Claude.

## Steps
A skill é uma referência de comandos, agrupada por tarefa. Os grupos são:
1. **Conexão.** `adb devices` lista os aparelhos conectados; `adb connect <ip>:<porta>` e `adb disconnect` tratam da depuração sem fio; `adb kill-server && adb start-server` reinicia o processo de fundo do adb quando algo trava.
2. **Gestão de apps.** `adb install -r app.apk` instala (substitui), `-d` permite voltar a uma versão anterior, `-g` concede todas as permissões; `adb uninstall`, `adb shell pm clear <pacote>` (apagar os dados do app), `adb shell am force-stop <pacote>`, `pm list packages` (opcionalmente filtrado), `pm path` e `adb pull` para extrair o APK.
3. **Arquivos.** `adb push` e `adb pull` copiam arquivos; `adb shell ls`, `mkdir`, `rm` e `df -h` inspecionam o armazenamento do celular.
4. **Tela.** `adb exec-out screencap -p > shot.png` tira uma captura direto para o notebook; `adb shell screenrecord` grava vídeo (até 180 segundos).
5. **Entrada.** `adb shell input tap X Y`, `input swipe X1 Y1 X2 Y2 ms`, `input text "..."` (espaços escritos como `%s`) e `input keyevent KEYCODE_...` (Home 3, Back 4, Power 26, Enter 66 e assim por diante).
6. **Activities e intents.** `adb shell am start -n <pacote>/.Activity` abre uma tela; `am start -a android.intent.action.VIEW -d <url>` abre um link; `am broadcast` envia uma mensagem do sistema.
7. **Informações.** `getprop` (modelo, versão do Android), `dumpsys battery|meminfo|cpuinfo|wifi`, `wm size`, `ps -A`, `top -n 1`.
8. **Logcat.** `adb logcat -c` limpa o log, `adb logcat -d` despeja e sai, `-s TAG:*` filtra por tag, `"*:E"` mostra só erros, `--pid=$(adb shell pidof -s <pacote>)` mostra um app, `-b crash` mostra travamentos, `-v time` acrescenta horários.
9. **Configurações e rede.** `adb shell settings get|put`, `svc wifi enable|disable`, `adb forward` e `adb reverse` (redirecionamento de portas entre notebook e celular).
10. **Energia.** `adb reboot` (também `recovery` e `bootloader`), `svc power stayon usb` mantém a tela acesa enquanto conectado.
11. **Avançado.** `uiautomator dump` grava a estrutura da tela em XML, `monkey -p <pacote> -v 500` envia eventos aleatórios, `pm grant|revoke` muda uma permissão, `dumpsys package <pacote>` mostra permissões.
12. **Fluxos prontos.** Automação de teste de app (instalar, abrir, captura, tocar, rolar, captura final, logs do processo do app), checagem de saúde do aparelho (modelo, versão do Android, bateria, armazenamento, memória, número de processos), capturas em série com intervalo e extração do APK e das permissões de um app.
13. **Solução de problemas.** Aparelho não encontrado: reiniciar o servidor adb e listar os aparelhos. Aparelho offline: desconectar e conectar de novo. Permissão negada: algumas operações exigem root. Conexão recusada: parear de novo com `adb pair <ip>:PORTA CÓDIGO`.
