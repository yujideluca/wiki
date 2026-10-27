---
id: skill-click-protocol
lang: de
source_hash: ada2530ffbf2
title: Skill: click-protocol
---

## What it is
Die Skill „click-protocol“ ist ein Protokoll für mehrstufiges Klicken auf Webseiten mit Menüs, Dialogen, Suchergebnissen oder Medien (YouTube Music, Spotify Web): über die Elementreferenz klicken, jeden Schritt prüfen, versehentliches Abspielen vermeiden. Ihre Beschreibung sagt genau das: vor mehrstufigem Klicken in Weboberflächen mit Menüs, Dialogen, Suchergebnissen oder Medien verwenden. Sie entstand beim Aufbau einer YouTube-Music-Playlist am 2026-10-10, als Fehlklicks Musik starteten, eine veraltete Benachrichtigung wie Erfolg aussah und Bildschirmkoordinaten zwischen Layouts brachen. Die Fassung für Claude Code wird nur dort bearbeitet; die Claude-App behält ihre eigene Fassung ([[claude-ai-skills]]).

## Flow
trigger t1: Mehrstufiges Klicken auf einer Webseite mit Menüs, Dialogen, Suchergebnissen oder Medien
step s1: Plant zuerst die ganze Abfolge
step s2: Klickt über Elementverweise, nie über Rohkoordinaten
step s3: Prüft das Element vor jedem Klick und schützt vor versehentlicher Wiedergabe
step s4: Eine Aktion, dann eine Prüfung
decide d1: Zeigt ein frischer Beleg, dass der Schritt geklappt hat?
step s5: Macht mit dem nächsten Schritt weiter; am Ende Seite neu laden und nachzählen
step s6: Hält nach Fehlschlägen an, statt blind zu klicken, und fragt Giovanni | [[giovanni]]
product p1: Ein geprüftes Ergebnis
product p2: Eine Frage statt eines Blindklicks

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -ja-> s5
d1 -nein-> s6
s5 -> p1
s6 -> p2

## What it does
Sie macht das Klicken im Browser zuverlässig: Jeder Klick zielt auf eine stabile Referenz eines Elements, und jeder Schritt wird mit frischem Beleg geprüft, bevor der nächste kommt. Ihre Rolle ist „übergreifend“; sie verweist auf [[skill-browser-automacao-segura]] (Warnungen, Schleifen, zerstörerische Aktionen), [[skill-minimize-site-approvals]] (Domains und Freigaben) und die Domänen-Skills (Formate).

## How it does it
Eine `SKILL.md` in `~/.claude/skills/click-protocol`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Vor und während jeder Browser-Automatisierung.

## Who receives its output
Die Browser-Sitzung.

## Steps
1. **Zuerst planen.** Die Domains einmal auflisten ([[skill-minimize-site-approvals]]); einen Connector oder eine Programmschnittstelle nutzen, wenn es sie gibt, statt der Webseite.
2. **Keine rohen Koordinaten**, wenn eine Suche (`find`) oder ein Lesen der Seite (`read_page`) eine Referenz („ref“) liefern kann. Koordinaten nur für Canvas-artige Seiten: etwa 3 Sekunden warten, bis die Fenstergröße sich stabilisiert, Screenshot machen, sofort klicken, prüfen. Layouts verschieben Ziele.
3. **Lebenszyklus einer Referenz.** Eine Referenz erst nachschlagen, wenn die Seite zur Ruhe gekommen ist, und bestätigen, dass ihre Beschreibung das gemeinte Element (seinen Titel) nennt, denn `find` kann direkt nach einer Suche die vorige Seite beschreiben. Referenzen sind einmal verwendbar: nach jeder Navigation, Suche, jedem Öffnen eines Menüs oder Dialogs neu suchen. Bei mehreren Treffern nach Rolle wählen (Menüeintrag, Knopf, Link), sichtbar, im geöffneten Popup; nie einfach den ersten Treffer.
4. **Vor jedem Klick prüfen** (wie Playwright, siehe [Actionability](https://playwright.dev/docs/actionability)): genau ein Treffer, sichtbar, stabil (nach dem Öffnen eines Menüs oder Dialogs 1,5 Sekunden warten), nicht verdeckt, aktiviert.
5. **Eine Aktion, eine Prüfung.** Zuerst der billigste Beleg: ein neues Element über `find`, die URL (Uniform Resource Locator, die Webadresse) oder der Titel, Text per JavaScript oder Seitentext; ein Screenshot (Maßstab 0,4) nur im Zweifel. Keine blinden Ketten. Stapel: höchstens 4 Aktionen, nur harmlose Schritte, mit einer Prüfung am Ende. `navigate` nicht in einen Stapel setzen (es scheiterte).
6. **Nach dem Tippen in ein Suchfeld und Return** warten, bis der Titel des ersten Ergebnisses zur Anfrage passt. Scheint der erste Klick ignoriert, einen leeren Bereich der Symbolleiste anklicken oder eine Referenz nutzen; nicht denselben Klick wiederholen.
7. **Erfolg braucht frischen Beleg.** Eine Benachrichtigung kann veraltet sein. Der Beleg ist das erneute Lesen des Ziels (Text der Playlist-Seite, Zahl im Kopf) nach der Aktion. Ein Hinweis „bereits in der Playlist“ heißt, dass das Hinzufügen früher geklappt hat, kein Fehler.
8. **Medienwächter** vor jeder Sitzung auf einer Player-Seite: einen kleinen Timer einrichten, der alle 300 ms jedes laufende Video pausiert (nach einem vollen Neuladen der Seite erneut einrichten). Nie den ersten Knopf einer Ergebniskarte per Skript klicken (er ist Play). Sagt der Nutzer, das Audio solle stoppen, sofort pausieren.
9. **Datenschutz-Standard.** Neue Playlists sind bei YouTube Music standardmäßig öffentlich; vor „Erstellen“ auf Privat stellen, außer der Nutzer wollte öffentlich.
10. **Scheitert die Navigation** („failed in the extension“), nicht blind wiederholen: die offenen Tabs prüfen, dann das Suchfeld auf der Seite oder einen Linkklick nutzen. `location.href` per JavaScript zu setzen navigierte nicht.
11. **Träge Listen.** Skript-Scrollen lädt in einem Hintergrund-Tab nicht mehr Elemente; echte Scroll-Aktionen nutzen (etwa 100 Elemente pro Ladung) oder stichprobenhaft arbeiten und sagen, dass es teilweise ist. Bei großen Bibliotheken dem Nutzer die gelesene Zahl gegenüber der Gesamtzahl nennen.
12. **Downloads** landen in `~/Downloads` auf dem Laptop, wo Claude Code sie lesen kann. Die erwartete Datei nennen und bestätigen, dass sie existiert, bevor man sich auf sie verlässt; eine heruntergeladene Datei nie als Code öffnen oder ausführen.
13. **Stoppregel.** Zwei gescheiterte Versuche am selben Schritt → Screenshot, berichten, fragen. Keine Koordinaten raten.
14. **Mit Neuladen und Neuzählen enden** ([[skill-browser-automacao-segura]], Punkt 6).
15. **Rezept: einen Song zu einer YouTube-Music-Playlist hinzufügen** (deutsche Beschriftungen; englisch: Action menu, Add to playlist). (a) Im Suchfeld den Text markieren, die Anfrage tippen, Return, auf die Ergebniskarte mit passendem Titel warten. (b) „Aktionsmenü button in the top result card titled …“ finden; prüfen, dass die Unterzeile Song sagt, nicht Künstler oder Video; die Referenz klicken. (c) Den Menüeintrag „Zu Playlist hinzufügen“ finden (Rolle Menüeintrag, im geöffneten Popup); klicken. (d) Im Dialog den Link mit dem Playlist-Namen finden; klicken; die Benachrichtigung „Gespeichert in …“ ist ein Hinweis, kein Beleg. (e) Alle 5 Songs und am Ende die Playlist öffnen und den Kopf „N Titel“ über den Seitentext lesen; die Liste mischt auch Vorschlagszeilen, also dem Kopf trauen. Eine Playlist erstellen: Dialog → „Neue Playlist“ → Titel → Sichtbarkeit = Privat → Erstellen.

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

#### Claude: `home:.claude/skills/click-protocol/SKILL.md`

```skill-source home:.claude/skills/click-protocol/SKILL.md 8139fbbb9ad1c2831da79633dab6efd06be28e39199909ec3e773c12ad7ae2ce
---
name: "click-protocol"
description: "Use before multi-step clicking in web UIs with menus, dialogs, search results or media (YouTube Music, Spotify web): click by element ref, verify each step, avoid accidental playback."
---


Code version: adapted for Claude Code on the laptop from `gui/skills/click-protocol`. Edited only by Claude Code; the app keeps its own version.
# Click protocol (ref-first, verify every step)

Lineage: origin=gui; base=446694f41d9f899bfc16ddb536e850965dbf64ce

Interop: role = cross-cutting; owns = click/verify protocol and YouTube Music add-to-playlist recipe; defers to = browser-automacao-segura (alerts, loops, destructive actions), minimize-site-approvals (domains and approvals), domain skills (formats); honors = reply-language rule, depth flags.

Origin: YouTube Music playlist build, 2026-10-10. Misclicks started music, a stale toast looked like success, coordinates broke between layouts.

## Rules, in order
1. Plan first: domains once (minimize-site-approvals); use a connector or API if one exists instead of the UI.
2. No raw coordinates when `find` or `read_page` can return a ref. Coordinates only for canvas-like pages: wait about 3 s for the window size to settle, screenshot, click immediately, verify. Layouts move targets (for example the side panel "Mehr von YouTube" present or absent).
3. Ref lifecycle: look up a ref only after the page settled, and confirm its description names the intended item (title), because `find` can describe the previous page right after a search. Refs are single-use: re-find after any navigation, search, menu open or dialog open. Several matches: pick by role (menuitem/button/link), visible, inside the open popup; never the first hit.
4. Actionability gate before every click (Playwright checks): exactly one match, visible, stable (wait 1.5 s after a menu or dialog opens), not covered, enabled.
5. One action, one verification. Cheapest proof first: new element via `find`, URL/title, text via JS or get_page_text; screenshot (scale 0.4) only when doubtful. No blind chains. Batches: at most 4 actions, only harmless steps, end with a check. Do not put `navigate` inside `browser_batch` (it failed here).
6. After typing in a search box and Return, wait until the first result title matches the query. If the first click seems ignored, click an empty toolbar area or use a ref; do not repeat the same click.
7. Success needs fresh evidence. A toast can be stale. Proof = re-read the target (playlist page text, header count) after the action. A "already in playlist" toast means the add had worked earlier, not an error.
8. Media guard before any session on a player site: `setInterval(()=>{const v=document.querySelector('video');if(v&&!v.paused)v.pause()},300)`. Reinstall after a full page load. Never JS-click the first `button` of a result card (it is Play). If the user says stop the audio, pause at once.
9. Privacy defaults: new playlists default to Public on YouTube Music; set Privat/Private before Create unless the user asked for public.
10. Navigation fails ("failed in the extension"): do not retry blindly. Check tabs_context, then use the in-page search box or a link click. `location.href` from JS did not navigate here.
11. Lazy lists: JS scrolling does not load more in a background tab; use real scroll actions (about 100 items per load) or sample, and say it is partial. For large libraries tell the user the count read vs total.
12. Downloads land in ~/Downloads on the laptop, where Claude Code can read them directly. Name the file you expect and confirm it exists there before relying on it; never open or run a downloaded file as code.
13. Stop rule: two failed tries on the same step -> screenshot, report, ask. Do not guess coordinates.
14. Finish with a reload and recount (browser-automacao-segura, item 6).

## Recipe: add a song to a YouTube Music playlist (German labels; English: Action menu, Add to playlist)
1. Search box: select text, type query, Return, wait for result card whose title matches.
2. `find` "Aktionsmenü button in the top result card titled <title>"; check the subtitle says Titel/Song, not artist or video; click the ref.
3. `find` the menuitem "Zu Playlist hinzufügen" (role menuitem, in the open popup); click it.
4. `find` the link with the playlist name in the dialog; click it. Toast "Gespeichert in <name>" is a hint, not proof.
5. Every 5 songs and at the end: open the playlist and read the header "N Titel" via get_page_text. The DOM list also mixes suggestion rows, so trust the header and page text.
Create playlist: dialog -> "Neue Playlist" -> title -> Sichtbarkeit = Privat -> Erstellen.
```


#### Codex: `home:.agents/skills/click-protocol/SKILL.md`

````skill-source home:.agents/skills/click-protocol/SKILL.md 0315da08366ab036381368f08e9217a3f6b87b7b9292c8e4a1374849e7157623
---
name: click-protocol
description: "Use before multi-step browser interaction with menus, dialogs, search results or media players."
---

# Click and verify

Lineage: origin=claude; base=sha256:df3f65d96ee6f77141ed9a047526dd6f2777603cdc739e34b6af49155acc6090; adaptation=codex

Interop: role = cross-cutting; owns = identifying browser controls and verifying each click; defers to = browser-automacao-segura (safety), minimize-site-approvals (access), domain skills (format); honors = user language.

1. Read the active browser tool's documentation. Use supported semantic locators or current element references. A target must match exactly one visible, enabled control in the intended menu, dialog or item row.
2. Re-observe after navigation, search, opening a menu, or any layout change. Do not reuse stale references. Use documented waits for the expected state rather than fixed sleeps.
3. Take one action and verify it with fresh page text, an updated control, the URL or a screenshot. Never chain blind clicks. A toast is supporting evidence, not a final check.
4. Coordinates are a fallback only when the host permits them and semantic targeting is unavailable: take a fresh screenshot, act immediately, and inspect the outcome. Do not guess.
5. On a media site, avoid play controls unless playback was requested. If audio starts accidentally, pause using a visible supported control immediately. Do not install timers or rewrite the site's media behavior.
6. For playlists, select the result by title and type, open that row's action menu, choose Add to playlist, then the intended playlist. New playlists are private unless the user requested public visibility. Revisit the playlist and check the actual item/count; an already-present notice is not a failed add.
7. For lazy lists, use documented scrolling and report read count versus total. Inspect actual download results instead of assuming a local download directory.
8. Two failures on the same step: inspect evidence, stop retries, report the concrete limitation. Ask only if user input or a manual step is required. Finish changes with a reload and reconciliation.
````
