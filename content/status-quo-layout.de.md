---
id: status-quo-layout
lang: de
source_hash: b39dd7aa29a1
title: Status Quo — Layoutentwurf im Terminalstil
---

## What it is
Dies ist der vorgeschlagene Aufbau für [[status-quo-design]], ein Desktop-Panel, das die Nutzung der Assistenten und laufende Arbeit zeigt. Alle folgenden Namen, Zahlen, Aufgabenbezeichnungen und Ereignisse sind erfundene Beispieldaten. Sie stammen nicht aus einer aktuellen Kontoabfrage. Die Diagramme sind Entwürfe im Terminalstil: Bilder aus Text, die Anordnung und Verhalten vor dem Schreiben des Programms zeigen.

## What it does
Die Übersicht zeigt oben die Nutzung im Fünfstunden- und Wochenfenster, darunter Sitzungen, Aktivitäten in den Quellcodearchiven und Gedächtniseinträge. Ein schmales Panel ordnet die beiden Nutzungsanzeigen untereinander an; ein breiteres stellt sie nebeneinander. Widgets, also eigenständige Anzeigeelemente, lassen sich ausblenden, vergrößern, verkleinern, als eigenes Fenster lösen und umordnen. Neben Ziehgriffen gibt es Tastaturbefehle zum Verschieben nach oben und unten. Die Abbildung zeigt die ausführliche Darstellung; der Kompaktmodus behält Kontingente und Quellenzustand bei und klappt Einzelheiten ein.

## How it does it
### Unabhängige Widgets im Tray
Die genehmigte visuelle Anordnung bleibt ein Entwurf, keine feste Zusammenfassung von Funktionen. Jede Kontingentanzeige, jedes Token-Diagramm, jede Sitzungsliste sowie der GitHub- und Gedächtnis-Feed ist ein unabhängig entfernbares und austauschbares Widget. Ein nah beieinander gezeichnetes Diagramm und eine Anzeige werden dadurch nicht zu einer Komponente. Der Widget-Katalog des Trays stellt entfernte Widgets wieder her oder ersetzt sie durch andere kompatible Arten. Jede Instanz behält eigene Einstellungen. Im laufenden Layout macht der Bearbeitungsmodus diese Grenzen sichtbar; weitere visuelle Verfeinerung folgt nach dem ersten lauffähigen Stand.

### Übersichtsreiter — breites Panel
```text
┌─ STATUS QUO ────────────────────────────────────────────────────────┐
│ [Übersicht] [Anpassen] [Quellen]          Layout bearbeiten: aus ─ × │
├────────────────────────────────┬───────────────────────────────────┤
│ :: CLAUDE              ↗ lösen │ :: CODEX                   ↗ lösen│
│ 5h genutzt ███████░░░  68%     │ 5h genutzt ███░░░░░░░  32%       │
│ Woche      ████░░░░░░  41%     │ Woche      █████░░░░░  54%       │
│ Reset in 02h 14m / Fr 18:00    │ Reset in 03h 02m / So 12:00       │
│ [24h] [7T] [30T] [Intervalle ▾]│ [24h] [7T] [30T] [Intervalle ▾]  │
│ Tokens/Stunde                 │ Tokens/Stunde                     │
│ 12k ┤       ╭╮                │ 12k ┤  ╭╮                         │
│  6k ┤ ╭╮ ╭──╯╰─╮              │  6k ┤╭─╯╰╮  ╭──╮                  │
│   0 └────────────────── Zeit  │   0 └─────────────────── Zeit      │
│ Eingabe / Ausgabe / Cache14:32 │ Eingabe / Ausgabe / Cache   14:32 │
├────────────────────────────────┴───────────────────────────────────┤
│ :: SITZUNGEN                            3 Haupt- / 2 Unteragenten │
│ ▾ sample-project                                                  │
│   ▾ Claude · Diagrammintervalle bauen    LÄUFT       3/6 · vor 4s  │
│     ├ Unteragent · Zeitgrenzen prüfen   LÄUFT             vor 2s │
│     └ Unteragent · Testdaten prüfen     ABGESCHLOSSEN    vor 32s │
│   ▸ Codex · Verlaufsimport prüfen       WARTET AUF EINGABE        │
│ ▸ another-project · Codex               INAKTIV                   │
├───────────────────────────────────────────────────────────────────┤
│ :: LETZTE AKTIVITÄTEN              [Archive ▾] [Alle Ereignisse ▾]│
│ sample-project · Commit · Intervallgrenzen korrigieren    vor 6m  │
│ sample-project · Prüfungen bestanden · Revision abc123   vor 7m  │
│ another-project · Problem eröffnet · Ladezustand ändern  vor 25m  │
├───────────────────────────────────────────────────────────────────┤
│ :: WORKFLOW-GEDÄCHTNIS           [Beide Assistenten ▾] [Alle ▾]    │
│ ▸ Entscheidung · Quellenzeit sichtbar halten             vor 9m  │
│ ▸ Erledigt · Wiederherstellung nach Neustart prüfen      vor 18m  │
│ ▸ Präferenz · Kompakte Darstellung bevorzugen           vor 45m  │
├───────────────────────────────────────────────────────────────────┤
│ KDE · hinter Fenstern · Navigation an · Quellen 5/5 aktuell       │
└───────────────────────────────────────────────────────────────────┘
```

Diagramme verwenden getrennte Datenreihen mit Beschriftung und Legende; der Textentwurf zeigt nur eine Linie, damit er keine gemessenen Werte suggeriert. Zeiger oder Tastatur zeigen das genaue Zeitintervall, die Zeitzone und die Zählerkategorien. Zeitpunkt und Abdeckung der Quelle bleiben auch im Kompaktmodus erreichbar. Die Schließen-Schaltfläche blendet das Panel aus; das Beenden des Datensammlers ist eine eigene ausdrückliche Aktion in den Einstellungen.

### Anpassungsreiter
```text
┌─ STATUS QUO / ANPASSEN ────────────────────────────────────────────┐
│ [Übersicht] [Anpassen] [Quellen]                                  │
│ Stil           [Terminal ▾]     Modus      [Dunkel ▾]             │
│ Akzent         [#7DDE8A]        Textgröße  [14 px]                 │
│ Hintergrund    [#111816]        Text       [#E0E8E2]               │
│ Hintergrunddeckkraft ───────●── 85%      Text bleibt lesbar        │
│ Anwenden auf   [Alle Widgets ▾] Dichte     [Ausführlich ▾]         │
│ Fensterebene   [Hinter Fenstern ▾]                                │
│ [✓] Quellenlinks und lokale Navigation öffnen                    │
│ [✓] Beim Anmelden starten       [ ] Layout sperren               │
│                                                                  │
│ Layout        [Anordnung bearbeiten] [Layouts ▾]                 │
│ Vorlagen      [Speichern als…] [Import…] [Export…]                │
│                                                                  │
│ Vorschau      ┌─ CLAUDE ───────────────────────────────────────┐  │
│               │ 5h ███████░░░ 68%      Woche ████░░░░░░ 41%   │  │
│               └───────────────────────────────────────────────┘  │
│                         [Zurücksetzen] [Abbrechen] [Speichern]   │
└──────────────────────────────────────────────────────────────────┘
```

Farb- und Deckkraftänderungen werden vorab angezeigt. Abbrechen stellt die zuletzt gespeicherten Werte wieder her. Die Stilauswahl listet installierte Rust-Stile auf und lädt keine ausführbaren Erweiterungen herunter. Ausgeschaltete Navigation deaktiviert Programmstarts und Quellenlinks; Einstellungen und lokale Anzeige bleiben bedienbar. Schriftgröße und Tastaturfokus bleiben bei hellen und dunklen Stilen nutzbar.

### Quellenreiter und Fehlerbeispiel
```text
┌─ QUELLEN ─────────────────────────────────────────────────────────┐
│ Claude     VERALTET · letzter Erfolg 14:27 · neuer Versuch 14:37   │
│            Letzte bekannte Kontingente, keine neue Messung        │
│ Codex      AKTUELL · letzter Erfolg 14:32                         │
│ GitHub     OFFLINE · 3 gewählte Archive · letzter Erfolg 14:20     │
│ Gedächtnis AKTUELL · nur lesen · beide Assistenten                 │
│ Sitzungen  AKTUELL · 1 Sitzung mit unbekanntem Zustand             │
│ Tokenlog   TEILWEISE · 1 unfertiger letzter Datensatz · Versuch folgt│
│ Desktop    KDE / Wayland · gewählte Ebene: hinter Fenstern        │
│            Platzierung durch Umgebungswrapper geprüft            │
└──────────────────────────────────────────────────────────────────┘
```

Jedes Widget behält seinen Titel und zeigt den eigenen Zustand an: lädt, leer, nicht verfügbar, veraltet oder fehlerhaft. Aus einem Fehler wird keine irreführende Null. Die Zustandsleiste zählt fünf Quellengruppen: Claude, Codex, GitHub, Gedächtnis und Sitzungen. Einzelne Sitzungszeilen werden nicht gezählt; Einzelheiten benennen den fehlerhaften Adapter, also die Übersetzungsschicht zur Datenquelle. KDE Plasma ist die Desktop-Oberfläche, die Panels und Fenster verwaltet; Wayland ist das Anzeigeprotokoll, über das Anwendungen ihre Flächen darstellen. Geheimnisse und vollständige Gesprächsinhalte erscheinen nie in der Diagnose.

### Schmales Panel und künftige Umgebungen
Bei geringer Breite steht jedes Nutzungswidget vollständig in einer eigenen Zeile, gefolgt von Sitzungen, letzten Aktivitäten und Gedächtnis. Überlange Listen scrollen innerhalb einer einstellbaren Höhe; Text wird umgebrochen oder in einer lokalen Detailansicht geöffnet. Die Schrift wird nicht automatisch verkleinert. Ein gelöstes Widget verwendet dieselbe Komponente und dieselben Darstellungswerte. Eine Browserumgebung verwendet dieselben Komponenten mit Beispieldaten und kennzeichnet Desktop-Platzierung als nicht unterstützt.

## Where it sits in the pipeline
Dieser Entwurf begleitet die Prüfung von [[status-quo-design]]. Er legt Informationsreihenfolge und Bedienverhalten fest, keine endgültigen Pixelmaße. Visuelle Umsetzungsprüfungen vergleichen echte Desktop-Bildschirmaufnahmen mit diesen Anordnungen, einschließlich schmaler Breiten, hellem Modus, geringer Deckkraft, Tastaturfokus und nicht verfügbaren Quellen. [[project-template]] liefert die Entwicklungsprüfungen nach der Freigabe.

## Who receives its output
Giovanni prüft die Anordnung zusammen mit dem schriftlichen Entwurf. Die Entwicklung überführt das genehmigte Verhalten in Anforderungen und echte Oberflächentests. Künftige Stile behalten Bedeutungen und Fähigkeiten bei und ersetzen die Darstellung.

## Notes
Der Entwurf enthält keine echten privaten Archivaktivitäten oder Inhalte aus workflow-memory. Das Layout wurde am 2026-11-01 freigegeben und das Desktop-Panel ist inzwischen gebaut (den aktuellen Stand beschreibt [[status-quo-design]]); diese Seite bleibt das Entwurfsmockup, und der gebaute Stand entsprach seiner Informationsreihenfolge. Ein bewusster Unterschied: In den Desktop-Ebenen-Hosts ist das Tray nackt, ohne die gerahmte Titelleiste „STATUS QUO“ und ohne eigenen Hintergrund; sichtbar sind nur die Widgets und die zwei kleinen Schaltflächen „Add widget“ und „Customize“, und die Widget-Zeilen füllen den Tray-Platz genau aus.

![Status Quo — static English interface mockup; sample data](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDgwIiBoZWlnaHQ9IjExNjAiIHZpZXdCb3g9IjAgMCAxMDgwIDExNjAiPgo8cmVjdCB3aWR0aD0iMTA4MCIgaGVpZ2h0PSIxMTYwIiBmaWxsPSIjMGIxMDBmIi8+CjxnIGZvbnQtZmFtaWx5PSJEZWphVnUgU2FucyBNb25vLG1vbm9zcGFjZSIgZm9udC1zaXplPSIxNCIgZmlsbD0iI2RjZThkZiI+Cjx0ZXh0IHg9IjQwIiB5PSIzNiIgZmlsbD0iIzdkZGU4YSIgZm9udC1zaXplPSIyMiI+U1RBVFVTIFFVTyAvIERFU0lHTiBQUkVWSUVXPC90ZXh0Pgo8dGV4dCB4PSI0MCIgeT0iNjEiIGZpbGw9IiM5MmE3OWIiPkludmVudGVkIHNhbXBsZSBkYXRhIMK3IHRlcm1pbmFsIHN0eWxlIMK3IEtERSBkZXNrdG9wIHdyYXBwZXI8L3RleHQ+CjxyZWN0IHg9IjMyIiB5PSI4MiIgd2lkdGg9IjEwMTYiIGhlaWdodD0iNjcwIiByeD0iOCIgZmlsbD0iIzExMTgxNiIgc3Ryb2tlPSIjNDk2MjUzIi8+Cjx0ZXh0IHg9IjUyIiB5PSIxMTMiIGZpbGw9IiM3ZGRlOGEiIGZvbnQtc2l6ZT0iMTgiPiZndDtfIFNUQVRVUyBRVU88L3RleHQ+Cjx0ZXh0IHg9IjY3MCIgeT0iMTExIiBmaWxsPSIjOTJhNzliIj5iZWhpbmQgd2luZG93cyDCtyBsYXlvdXQgbG9ja2VkPC90ZXh0Pgo8cGF0aCBkPSJNMzIgMTMxIEgxMDQ4IiBzdHJva2U9IiM0OTYyNTMiLz4KPHJlY3QgeD0iNDkiIHk9IjE0NCIgd2lkdGg9IjExOCIgaGVpZ2h0PSIzMCIgZmlsbD0iIzI2M2QyZSIgcng9IjMiLz4KPHRleHQgeD0iNjMiIHk9IjE2NCIgZmlsbD0iIzdkZGU4YSI+T3ZlcnZpZXc8L3RleHQ+PHRleHQgeD0iMTkwIiB5PSIxNjQiPkN1c3RvbWl6ZTwvdGV4dD48dGV4dCB4PSIzMjUiIHk9IjE2NCI+U291cmNlczwvdGV4dD4KPHJlY3QgeD0iNTAiIHk9IjE5MCIgd2lkdGg9IjQ4MCIgaGVpZ2h0PSIyMjYiIGZpbGw9IiMxNjIxMWMiIHN0cm9rZT0iIzM1NGIzZSIvPgo8cmVjdCB4PSI1NDkiIHk9IjE5MCIgd2lkdGg9IjQ4MCIgaGVpZ2h0PSIyMjYiIGZpbGw9IiMxNjIxMWMiIHN0cm9rZT0iIzM1NGIzZSIvPgo8dGV4dCB4PSI2OCIgeT0iMjE4IiBmaWxsPSIjN2RkZThhIj46OiBDTEFVREU8L3RleHQ+PHRleHQgeD0iNTY3IiB5PSIyMTgiIGZpbGw9IiM3ZGRlOGEiPjo6IENPREVYPC90ZXh0Pgo8dGV4dCB4PSI2OCIgeT0iMjUwIj41aCB1c2VkPC90ZXh0Pjx0ZXh0IHg9IjQ1OSIgeT0iMjUwIiBmaWxsPSIjN2RkZThhIj42OCU8L3RleHQ+CjxyZWN0IHg9IjE2OCIgeT0iMjM3IiB3aWR0aD0iMjcwIiBoZWlnaHQ9IjE0IiBmaWxsPSIjMmMzYzMxIi8+PHJlY3QgeD0iMTY4IiB5PSIyMzciIHdpZHRoPSIxODQiIGhlaWdodD0iMTQiIGZpbGw9IiM3ZGRlOGEiLz4KPHRleHQgeD0iNjgiIHk9IjI3OCI+V2Vla2x5PC90ZXh0Pjx0ZXh0IHg9IjQ1OSIgeT0iMjc4IiBmaWxsPSIjN2RkZThhIj40MSU8L3RleHQ+CjxyZWN0IHg9IjE2OCIgeT0iMjY1IiB3aWR0aD0iMjcwIiBoZWlnaHQ9IjE0IiBmaWxsPSIjMmMzYzMxIi8+PHJlY3QgeD0iMTY4IiB5PSIyNjUiIHdpZHRoPSIxMTEiIGhlaWdodD0iMTQiIGZpbGw9IiM3ZGRlOGEiLz4KPHRleHQgeD0iNTY3IiB5PSIyNTAiPjVoIHVzZWQ8L3RleHQ+PHRleHQgeD0iOTU4IiB5PSIyNTAiIGZpbGw9IiM4MGM4ZDUiPjMyJTwvdGV4dD4KPHJlY3QgeD0iNjY3IiB5PSIyMzciIHdpZHRoPSIyNzAiIGhlaWdodD0iMTQiIGZpbGw9IiMyYzNjMzEiLz48cmVjdCB4PSI2NjciIHk9IjIzNyIgd2lkdGg9Ijg2IiBoZWlnaHQ9IjE0IiBmaWxsPSIjODBjOGQ1Ii8+Cjx0ZXh0IHg9IjU2NyIgeT0iMjc4Ij5XZWVrbHk8L3RleHQ+PHRleHQgeD0iOTU4IiB5PSIyNzgiIGZpbGw9IiM4MGM4ZDUiPjU0JTwvdGV4dD4KPHJlY3QgeD0iNjY3IiB5PSIyNjUiIHdpZHRoPSIyNzAiIGhlaWdodD0iMTQiIGZpbGw9IiMyYzNjMzEiLz48cmVjdCB4PSI2NjciIHk9IjI2NSIgd2lkdGg9IjE0NiIgaGVpZ2h0PSIxNCIgZmlsbD0iIzgwYzhkNSIvPgo8ZyBmaWxsPSIjOTJhNzliIiBmb250LXNpemU9IjEyIj48dGV4dCB4PSI2OCIgeT0iMzAxIj41aCByZXNldCBpbiAwMmggMTRtIMK3IHdlZWtseSBGcmkgMTg6MDA8L3RleHQ+PHRleHQgeD0iNTY3IiB5PSIzMDEiPjVoIHJlc2V0IGluIDAzaCAwMm0gwrcgd2Vla2x5IFN1biAxMjowMDwvdGV4dD48L2c+CjxwYXRoIGQ9Ik04MSAzMjAgVjM3NiBINTA1IE01ODAgMzIwIFYzNzYgSDEwMDQiIHN0cm9rZT0iIzQ5NjI1MyIgZmlsbD0ibm9uZSIvPgo8cGF0aCBkPSJNODIgMzY4IEwxMTAgMzY4IEwxMjUgMzUyIEwxNTAgMzU4IEwxNzMgMzQ1IEwyMDUgMzQ5IEwyMjggMzMwIEwyNTEgMzUxIEwyODMgMzU1IEwzMDYgMzQxIEwzMzAgMzQ4IEwzNTUgMzM1IEwzODAgMzUwIEw0MTUgMzUyIEw0NDAgMzYzIEw0NzggMzU4IEw1MDMgMzY5IiBzdHJva2U9IiM3ZGRlOGEiIGZpbGw9Im5vbmUiIHN0cm9rZS13aWR0aD0iMiIvPgo8cGF0aCBkPSJNNTgxIDM2NiBMNjExIDM1NSBMNjM3IDM2MCBMNjYwIDMyOSBMNjg1IDM0NCBMNzE0IDM1MCBMNzQwIDM2NyBMNzYyIDM2NCBMNzg4IDM0OSBMODE2IDM1MiBMODQzIDM0NSBMODcwIDM1NyBMODk5IDM1OSBMOTI0IDM2MyBMOTYwIDM1MyBMMTAwMyAzNjUiIHN0cm9rZT0iIzgwYzhkNSIgZmlsbD0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIyIi8+Cjx0ZXh0IHg9IjY4IiB5PSI0MDAiIGZpbGw9IiM5MmE3OWIiIGZvbnQtc2l6ZT0iMTIiPnRva2Vucy9ob3VyIMK3IFsyNGhdIDdkIDMwZCDCtyBpbnB1dC9vdXRwdXQvY2FjaGU8L3RleHQ+PHRleHQgeD0iNTY3IiB5PSI0MDAiIGZpbGw9IiM5MmE3OWIiIGZvbnQtc2l6ZT0iMTIiPnRva2Vucy9ob3VyIMK3IFsyNGhdIDdkIDMwZCDCtyBpbnB1dC9vdXRwdXQvY2FjaGU8L3RleHQ+CjxwYXRoIGQ9Ik01MCA0MzYgSDEwMjgiIHN0cm9rZT0iIzM1NGIzZSIvPjx0ZXh0IHg9IjY4IiB5PSI0NjMiIGZpbGw9IiM3ZGRlOGEiPjo6IFNFU1NJT05TIC8gc2FtcGxlLXByb2plY3Q8L3RleHQ+PHRleHQgeD0iNzYxIiB5PSI0NjMiIGZpbGw9IiM5MmE3OWIiPjMgbWFpbiDCtyAyIGNoaWxkcmVuPC90ZXh0Pgo8dGV4dCB4PSI4MiIgeT0iNDkwIj52IENsYXVkZSDCtyBJbXBsZW1lbnQgZ3JhcGggYnVja2V0czwvdGV4dD48dGV4dCB4PSI3MzQiIHk9IjQ5MCIgZmlsbD0iIzdkZGU4YSI+UlVOTklORyAgIDMvNjwvdGV4dD4KPHRleHQgeD0iMTEwIiB5PSI1MTQiIGZpbGw9IiM5MmE3OWIiPuKUnCBjaGlsZCDCtyBDaGVjayB0aW1lIGJvdW5kYXJpZXM8L3RleHQ+PHRleHQgeD0iNzM0IiB5PSI1MTQiIGZpbGw9IiM3ZGRlOGEiPlJVTk5JTkc8L3RleHQ+Cjx0ZXh0IHg9IjExMCIgeT0iNTM4IiBmaWxsPSIjOTJhNzliIj7ilJQgY2hpbGQgwrcgUmV2aWV3IGZpeHR1cmVzPC90ZXh0Pjx0ZXh0IHg9IjczNCIgeT0iNTM4IiBmaWxsPSIjOTJhNzliIj5DT01QTEVURUQ8L3RleHQ+Cjx0ZXh0IHg9IjgyIiB5PSI1NjIiPiZndDsgQ29kZXggwrcgVmVyaWZ5IGhpc3RvcnkgaW1wb3J0PC90ZXh0Pjx0ZXh0IHg9IjczNCIgeT0iNTYyIiBmaWxsPSIjZTZjNTc1Ij5XQUlUSU5HIEZPUiBJTlBVVDwvdGV4dD4KPHBhdGggZD0iTTUwIDU4MCBIMTAyOCIgc3Ryb2tlPSIjMzU0YjNlIi8+PHRleHQgeD0iNjgiIHk9IjYwNiIgZmlsbD0iIzdkZGU4YSI+OjogUkVDRU5UIEFDVElWSVRZPC90ZXh0Pjx0ZXh0IHg9IjY4IiB5PSI2MzAiPnNhbXBsZS1wcm9qZWN0IMK3IGNvbW1pdCDCtyBDb3JyZWN0IGJ1Y2tldCBib3VuZGFyaWVzPC90ZXh0Pjx0ZXh0IHg9Ijk0MCIgeT0iNjMwIiBmaWxsPSIjOTJhNzliIj42bTwvdGV4dD4KPHRleHQgeD0iNjgiIHk9IjY1NiIgZmlsbD0iIzdkZGU4YSI+OjogV09SS0ZMT1cgTUVNT1JZPC90ZXh0Pjx0ZXh0IHg9IjY4IiB5PSI2ODAiPiZndDsgRGVjaXNpb24gwrcgS2VlcCBzb3VyY2UgdGltZXN0YW1wcyB2aXNpYmxlPC90ZXh0Pjx0ZXh0IHg9Ijk0MCIgeT0iNjgwIiBmaWxsPSIjOTJhNzliIj45bTwvdGV4dD4KPHBhdGggZD0iTTMyIDcwNyBIMTA0OCIgc3Ryb2tlPSIjNDk2MjUzIi8+PHRleHQgeD0iNTIiIHk9IjczMyIgZmlsbD0iIzkyYTc5YiI+S0RFIC8gV2F5bGFuZCDCtyBuYXZpZ2F0aW9uIG9uIMK3IHNvdXJjZXMgNS81IGZyZXNoIMK3IHVwZGF0ZWQgMTQ6MzI8L3RleHQ+CjxyZWN0IHg9IjMyIiB5PSI3ODAiIHdpZHRoPSIxMDE2IiBoZWlnaHQ9IjMzNSIgcng9IjgiIGZpbGw9IiMxMTE4MTYiIHN0cm9rZT0iIzQ5NjI1MyIvPgo8dGV4dCB4PSI1MiIgeT0iODEzIiBmaWxsPSIjN2RkZThhIiBmb250LXNpemU9IjE4Ij5DVVNUT01JWkUgLyBsaXZlIHByZXZpZXcgYmVmb3JlIHNhdmluZzwvdGV4dD4KPHRleHQgeD0iNTIiIHk9Ijg1MCI+U3R5bGUgIFtUZXJtaW5hbCB2XTwvdGV4dD48dGV4dCB4PSI1NTAiIHk9Ijg1MCI+TW9kZSAgW0Rhcmsgdl08L3RleHQ+Cjx0ZXh0IHg9IjUyIiB5PSI4ODQiPkFjY2VudCBbIzdEREU4QV08L3RleHQ+PHJlY3QgeD0iMjIzIiB5PSI4NjYiIHdpZHRoPSIyOCIgaGVpZ2h0PSIyMiIgZmlsbD0iIzdkZGU4YSIvPgo8dGV4dCB4PSI1NTAiIHk9Ijg4NCI+VGV4dCBzaXplICBbMTQgcHhdPC90ZXh0Pgo8dGV4dCB4PSI1MiIgeT0iOTE4Ij5CYWNrZ3JvdW5kIG9wYWNpdHk8L3RleHQ+PHBhdGggZD0iTTI1NSA5MTMgSDQ3MiIgc3Ryb2tlPSIjNDk2MjUzIiBzdHJva2Utd2lkdGg9IjQiLz48Y2lyY2xlIGN4PSI0NDAiIGN5PSI5MTMiIHI9IjciIGZpbGw9IiM3ZGRlOGEiLz48dGV4dCB4PSI0ODciIHk9IjkxOCI+ODUlPC90ZXh0Pgo8dGV4dCB4PSI1NTAiIHk9IjkxOCI+TGF5ZXIgW0JlaGluZCB3aW5kb3dzIHZdPC90ZXh0Pgo8dGV4dCB4PSI1MiIgeT0iOTUyIj5beF0gTmF2aWdhdGlvbiAgIFt4XSBTdGFydCBhdCBsb2dpbjwvdGV4dD48dGV4dCB4PSI1NTAiIHk9Ijk1MiI+QXBwbHkgdG8gW0FsbCB3aWRnZXRzIHZdPC90ZXh0Pgo8dGV4dCB4PSI1MiIgeT0iOTg2IiBmaWxsPSIjOTJhNzliIj5bRWRpdCBhcnJhbmdlbWVudF0gW1ByZXNldHNdIFtJbXBvcnRdIFtFeHBvcnRdPC90ZXh0Pgo8cGF0aCBkPSJNNTIgMTAwNSBIMTAyOCIgc3Ryb2tlPSIjMzU0YjNlIi8+PHRleHQgeD0iNTIiIHk9IjEwMzMiIGZpbGw9IiM5MmE3OWIiPlBlci13aWRnZXQgY29sb3JzIMK3IGZvbnQgc2l6ZXMgwrcgY29tcGFjdCBtb2RlIMK3IHNhdmVkIGxheW91dHM8L3RleHQ+Cjx0ZXh0IHg9IjUyIiB5PSIxMDgwIj5bUmVzdG9yZSBkZWZhdWx0c108L3RleHQ+PHRleHQgeD0iNzYwIiB5PSIxMDgwIj5bQ2FuY2VsXTwvdGV4dD48cmVjdCB4PSI5MDAiIHk9IjEwNTciIHdpZHRoPSIxMTUiIGhlaWdodD0iMzUiIHJ4PSIzIiBmaWxsPSIjMjYzZDJlIi8+PHRleHQgeD0iOTI5IiB5PSIxMDgwIiBmaWxsPSIjN2RkZThhIj5TYXZlPC90ZXh0Pgo8dGV4dCB4PSI0MCIgeT0iMTE0NCIgZmlsbD0iIzkyYTc5YiIgZm9udC1zaXplPSIxMiI+U3RhdGljIG1vY2t1cCBvbmx5LiBHcmFwaHMgYW5kIGV2ZW50cyBhcmUgc2FtcGxlIGRhdGE7IGNvbnRyb2xzIGFyZSBpbGx1c3RyYXRpdmUuPC90ZXh0Pgo8L2c+PC9zdmc+Cg==)
