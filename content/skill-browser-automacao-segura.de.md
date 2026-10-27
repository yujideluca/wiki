---
id: skill-browser-automacao-segura
lang: de
source_hash: 9208c8496d7c
title: Skill: browser-automacao-segura (sichere Browser-Automatisierung)
---

## What it is
Die Skill „browser-automacao-segura“ („sichere Browser-Automatisierung“) enthält die Sicherheitsregeln für jede Aktion in einem Webbrowser (dem eingebauten Browser der App oder Claude in Chrome), besonders für Stapelaktionen, Löschungen, Massenänderungen und Skripte auf Seiten. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: immer verwenden, wenn Aktionen in irgendeinem Browser ausgeführt werden, besonders Stapelaktionen, Löschungen, Massenänderungen und JavaScript-Skripte auf Seiten.

## Flow
trigger t1: Jede Aktion in einem Browser, besonders Stapelaktionen, Löschungen, Massenänderungen oder Seitenskripte
trigger t2: Ein Warndialog ist schon offen
step s1: Entschärft Warnungen vor einem Stapel und protokolliert sie zum späteren Lesen
step s2: Führt eine Schleife nach der anderen aus und wartet nach jeder Aktion auf die echte Wirkung | [[skill-click-protocol]]
decide d1: Ist die Aktion zerstörend oder unumkehrbar?
step s3: Fragt Giovanni, bevor es handelt | [[giovanni]]
step s4: Lange Schleifen laufen im Hintergrund und werden auf Fortschritt geprüft
step s5: Stoppt die frühere Schleife und löscht die offene Warnung
step s6: Lädt die Seite neu, um den Endzustand zu prüfen
product p1: Ein geprüftes Ergebnis auf der Seite
product p2: Keine eingefrorene Sitzung und nichts Zerstörendes ohne Ja

t1 -> s1
s1 -> s2
s2 -> d1
d1 -ja-> s3
d1 -nein-> s4
s3 -> s4
s4 -> s6
t2 -> s5
s5 -> s6
s6 -> p1
s3 -> p2

## What it does
Sie verhindert Dialoge, die die Sitzung einfrieren, sich überlappende Schleifen und zerstörerische Fehler, und sie fragt vor allem Unumkehrbaren. Für die Mechanik des Klickens verweist sie auf [[skill-click-protocol]], für weniger Freigabeklicks auf [[skill-minimize-site-approvals]]; wo sie sich widersprechen, gewinnen die Sicherheitsregeln dieser Skill.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/browser-automacao-segura`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Vor und während jeder Browser-Automatisierung.

## Who receives its output
Die Browser-Sitzung; [[skill-click-protocol]] und [[skill-minimize-site-approvals]] verweisen für Warnungen und zerstörerische Aktionen auf sie.

## Steps
Warum es wichtig ist: Ein geöffneter nativer `alert()`-Dialog blockiert alle Browser-Werkzeuge (Screenshot, JavaScript, Klicks), bis jemand auf OK klickt. Er entsteht oft, wenn zwei gleichzeitige Aktionen dasselbe Element treffen (zum Beispiel zwei Schleifen, die in derselben Zeile auf „Entfernen“ klicken, und der Server lehnt die zweite ab). Eine bekannte Falle: Scheitert das `javascript_tool` an einem Zeitlimit, läuft das Skript auf der Seite weiter, und eine weitere Schleife zu starten erzeugt einen parallelen Lauf.
1. **Nie überlappende Schleifen** auf derselben Seite laufen lassen. Vor dem Start einer neuen Schleife die vorige stoppen (ein Flag wie `window.stopRem = true`) und bestätigen, dass sie beendet ist.
2. **Nacheinander, mit echtem Warten.** Nach jeder Aktion warten, bis die Wirkung eintritt (zum Beispiel die Zeile von der Seite verschwindet), statt eines festen Intervalls. Elemente überspringen, die gerade bearbeitet werden (kein Aktionsknopf oder ein Spinner).
3. **Warnungen vor Stapelaktionen neutralisieren** und für späteres Lesen protokollieren: `window.alertLog = []; window.alert = m => window.alertLog.push(String(m));`. `confirm` nicht überschreiben, sodass es automatisch `true` liefert, denn das könnte zerstörerische Aktionen freigeben, die niemand verlangt hat; wird ein `confirm` für die vom Nutzer gewünschte Aktion erwartet, es einzeln behandeln.
4. **Lange Schleifen im Hintergrund.** Mit einer asynchronen, sofort aufgerufenen Funktion ohne `await` ganz oben starten, die sofort zurückkehrt, und den Fortschritt in getrennten Aufrufen abfragen; die Schleife prüft in jeder Runde das Stopp-Flag, klickt das nächste Element mit aktivem Knopf und wartet (bis etwa 10 Sekunden), bis seine Zeile weg ist, bevor das nächste kommt.
5. **Ist schon eine Warnung offen**, scheitern die Werkzeuge. Einmal Return versuchen; bleibt es blockiert, den Nutzer bitten, auf OK zu klicken, und den Grund erklären. Danach Schleifen stoppen (`window.stopRem = true`) und die Überschreibung von alert installieren.
6. **Am Ende durch Neuladen der Seite prüfen** und neu zählen; die lokale Seite muss den Server nicht widerspiegeln. `window.alertLog` lesen, um aufgetretene Fehler zu sehen.
7. **Zerstörerische Aktionen** (entfernen, senden, kaufen) nur auf ausdrückliche Bitte des Nutzers. Erst an einem Element testen, das Ergebnis prüfen und erst dann den Stapel ausführen.

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

#### Claude: `home:.claude/skills/browser-automacao-segura/SKILL.md`

````skill-source home:.claude/skills/browser-automacao-segura/SKILL.md b7af9b1c5de7150838245fff92b0c66952fe5162e7cea162b7050b067b300132
---
name: "browser-automacao-segura"
description: "Use sempre que for executar ações em qualquer navegador (navegador embutido do app ou Claude in Chrome), especialmente ações em lote, remoções, edições em massa ou scripts JS em páginas."
---

# Automação de navegador segura

Lineage: origin=gui; base=5b02179bdeb6f1c75930350dbdd74cf0992d71eb

Objetivo: evitar que alertas/diálogos do site (alert, confirm) ou ações sobrepostas travem a tarefa. Vale para os dois navegadores (embutido e Claude in Chrome); para reduzir cliques de aprovação de sites, veja também a skill minimize-site-approvals. Para a mecânica dos cliques (refs, verificação a cada passo, menus, diálogos, players de mídia), siga também a skill click-protocol; as regras de segurança abaixo prevalecem.

## Por que isso importa
Um `alert()` nativo aberto bloqueia TODAS as ferramentas do navegador (screenshot, JS, cliques) até alguém clicar em OK. Ele costuma surgir quando duas ações concorrentes atingem o mesmo item (ex.: dois laços clicando em "remover" na mesma linha), e o servidor recusa a segunda.

Armadilha conhecida: quando o `javascript_tool` falha por tempo esgotado, o script **continua rodando na página**. Iniciar outro laço depois disso cria execução paralela.

## Regras
1. **Nunca rode laços sobrepostos** na mesma página. Antes de iniciar um novo laço, pare o anterior (flag `window.stopRem = true`) e confirme que terminou.
2. **Sequencial e com espera real**: após cada ação, espere o efeito acontecer (ex.: a linha sumir do DOM) em vez de um intervalo fixo. Pule itens em processamento (sem botão de ação / com spinner).
3. **Neutralize alertas antes de ações em lote** e registre-os para leitura posterior:
   ```js
   window.alertLog = [];
   window.alert = m => window.alertLog.push(String(m));
   ```
   Não sobrescreva `confirm` para retornar `true` automaticamente, pois isso pode aprovar ações destrutivas não pedidas. Se um `confirm` for esperado para a ação que o usuário pediu, trate-o pontualmente.
4. **Laços longos em segundo plano**: inicie com uma IIFE assíncrona sem `await` no topo, que retorna imediatamente, e consulte o progresso em chamadas separadas:
   ```js
   window.stopRem = false; window.doneRem = false;
   (async () => {
     for (let i = 0; i < 500 && !window.stopRem; i++) {
       const alvo = encontrarProximo();          // só itens com botão ativo
       if (!alvo) break;
       const linha = alvo.closest('tr');
       alvo.click();
       for (let t = 0; t < 40 && linha.isConnected; t++)  // espera a linha sumir (até ~10 s)
         await new Promise(r => setTimeout(r, 250));
     }
     window.doneRem = true;
   })(); 'iniciado'
   ```
5. **Se um alerta já estiver aberto**: as ferramentas falham. Tente `key Return` uma vez; se continuar bloqueado, peça ao usuário para clicar em OK e explique o motivo. Depois pare laços (`window.stopRem = true`) e instale o override de alert.
6. **Verifique no final recarregando a página** e contando de novo. O DOM local pode não refletir o servidor. Leia `window.alertLog` para ver erros ocorridos.
7. Ações destrutivas (remover, enviar, comprar) só com pedido explícito do usuário. Teste em 1 item primeiro, confira o resultado e só então rode o lote.
````


#### Codex: `home:.agents/skills/browser-automacao-segura/SKILL.md`

````skill-source home:.agents/skills/browser-automacao-segura/SKILL.md 13853b38c3eb189733876aabe72c8b3f61570d474b84e6e10c42fc377a9201b9
---
name: browser-automacao-segura
description: "Use when controlling a browser in Codex, especially multi-step changes, batch edits, removals or page scripts."
---

# Safe browser automation

Lineage: origin=claude; base=sha256:93af23975c340f1b49850a522a06f32810163e27da6787527ab91f8dd12f740b; adaptation=codex

Interop: role = cross-cutting; owns = sequential browser actions and verified effects; defers to = host browser documentation, click-protocol (target selection), minimize-site-approvals (access), domain skills (format); honors = user language and existing authorization.

1. Prefer a connected service tool when it can complete the task. For browser control, initialize the actual browser tool exactly as documented, read its returned instructions, and use only the APIs it exposes. In the CUA REPL, the first call contains exactly one documented entrypoint.
2. Inspect the current page before acting. Use visible, uniquely identified controls and observed page state. Never infer selectors from memory of a previous site version.
3. One mutation at a time. After each action, read fresh state and verify the expected effect before continuing. Batch only independent reads. For a batch change, test one authorized item, verify it, then continue sequentially.
4. A timeout does not prove cancellation. Inspect whether the previous action finished; do not start a duplicate loop. Use only documented cancellation or dialog APIs. Do not replace page alert/confirmation handlers, auto-accept dialogs, inject detached loops, or use page JavaScript for hidden state, network calls, or mutations when the host does not permit it.
5. Handle an expected confirmation individually, within the user's authorization. If a native dialog blocks every available tool and there is no documented handler, explain the specific block and ask for that manual step.
6. End by reloading or revisiting the target and checking server-backed state, quantities and errors. Local page changes and toasts alone are insufficient proof.
7. Authorization persists within scope. Do not ask repeatedly for routine reversible work already requested; ask for an unapproved destructive action, purchase, message send or required technical permission. A skill cannot grant it.
````
