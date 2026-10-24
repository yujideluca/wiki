---
id: skill-browser-automacao-segura
lang: de
source_hash: 4b327b0609e6
title: Skill: browser-automacao-segura (sichere Browser-Automatisierung)
---

## What it is
Die Skill „browser-automacao-segura“ („sichere Browser-Automatisierung“) enthält die Sicherheitsregeln für jede Aktion in einem Webbrowser (dem eingebauten Browser der App oder Claude in Chrome), besonders für Stapelaktionen, Löschungen, Massenänderungen und Skripte auf Seiten. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: immer verwenden, wenn Aktionen in irgendeinem Browser ausgeführt werden, besonders Stapelaktionen, Löschungen, Massenänderungen und JavaScript-Skripte auf Seiten.

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
