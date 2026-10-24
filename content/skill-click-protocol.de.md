---
id: skill-click-protocol
lang: de
source_hash: 714ca0ee71a1
title: Skill: click-protocol
---

## What it is
Die Skill „click-protocol“ ist ein Protokoll für mehrstufiges Klicken auf Webseiten mit Menüs, Dialogen, Suchergebnissen oder Medien (YouTube Music, Spotify Web): über die Elementreferenz klicken, jeden Schritt prüfen, versehentliches Abspielen vermeiden. Ihre Beschreibung sagt genau das: vor mehrstufigem Klicken in Weboberflächen mit Menüs, Dialogen, Suchergebnissen oder Medien verwenden. Sie entstand beim Aufbau einer YouTube-Music-Playlist am 2026-10-10, als Fehlklicks Musik starteten, eine veraltete Benachrichtigung wie Erfolg aussah und Bildschirmkoordinaten zwischen Layouts brachen. Die Fassung für Claude Code wird nur dort bearbeitet; die Claude-App behält ihre eigene Fassung ([[claude-ai-skills]]).

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
