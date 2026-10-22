---
id: wiki-hook-stop
lang: de
source_hash: eed4aff55ffd
title: Wiki-Stop-Hook (Sicherheitsnetz)
---

## What it is
Das Sicherheitsnetz der Aktualisierungskette: ein Claude-Code-Stop-Hook (`wiki hook-stop`), der eine vergessene Wiki-Aktualisierung in derselben Sitzung auffängt.

## What it does
Wenn Claude eine Runde beendet, sieht er sich die Repos unter `~/dev` an, die eine Seite als Quelle nennt. Haben seit dem letzten `wiki publish` Commits die Quellen einer Seite berührt oder Dateien hinzugefügt, die keine Seite abdeckt, blockiert er das Beenden (Exit 2) und sagt Claude, welche Seiten zu aktualisieren sind. Er blockiert nie vor der ersten Veröffentlichung, nie für Repos ohne Wiki-Abdeckung, nie zweimal pro Sitzung für dieselben Änderungen und nie, wenn schon ein Stop-Hook aktiv ist; er kann also keine Schleife bilden und greift nie bei Deutsch-, Klinik- oder anderen Chats ohne Code.

## How it does it
Nur lesendes git; Zustand in `~/.local/state/wiki/` (letzte Veröffentlichung, schon blockierte Sitzungen). Datenordner, die sich ständig ändern (Gedächtnisereignisse und -ansichten, Quiz-Sicherungen, der Release-Feed), stehen in `content/_ignore.txt` und werden nicht Datei für Datei beobachtet. Muss keine Seite geändert werden, führt Claude trotzdem `wiki publish -m "review: no page change"` aus, um die Prüfung festzuhalten.

## Where it sits in the pipeline
Läuft am Ende jeder Runde, neben dem [[hook-stop]] des Gedächtnisses.

## Who receives its output
[[claude-code]] (die Meldung).
