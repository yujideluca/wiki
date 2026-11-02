---
id: status-quo
lang: de
source_hash: 0f5420a0795c
title: Status-Quo-Desktop-Widget-Tray
---

## What it is
Status Quo ist eine in Rust geschriebene Desktop-Widget-Umgebung: kleine, immer sichtbare Panels direkt auf dem Desktop, ohne Fensterrahmen, die zeigen, wie viel von Giovannis Claude- und Codex-Nutzungslimits verbraucht ist, dazu Token-Diagramme, die laufenden Sitzungen der Assistenten, neue GitHub-Aktivitäten und aktuelle Einträge aus workflow-memory. Der Code liegt in `~/dev/status-quo` und im privaten GitHub-Repository `yujideluca/status-quo`. Man beginnt mit seiner `README.md`. Der freigegebene Umfang steht auf [[status-quo-design]], der Layoutentwurf auf [[status-quo-layout]]; diese Seite beschreibt den Code, wie er gebaut ist.

Jede Anzeige ist ein eigenes Widget, das entfernt, ersetzt oder in ein anderes Programm verschoben werden kann; auch das Tray, das sie anordnet, ist wiederverwendbar. KDE, die Desktop-Oberfläche des Laptops, ist der erste Host; nichts Portables hängt davon ab.

## Flow
trigger t1: Giovanni öffnet das Panel, oder es startet beim Login
trigger t2: Eine Claude- oder Codex-Sitzung startet, wartet oder endet | [[claude-code]], [[codex]]
step s1: Das Panel startet den Collector, einen Hintergrundprozess pro Nutzer, falls keiner läuft
step s2: Der Collector liest Kontostatus, Sitzungsprotokolle, GitHub und Gedächtnis | [[workflow-memory]], [[github]]
step s3: Ein Assistenten-Hook hält das Ereignis für den Collector fest
step s4: Ergebnisse landen in einem privaten Ordner, der den letzten guten Wert jeder Quelle behält
step s5: Das Panel fragt den Collector über einen lokalen Socket nach einem Schnappschuss
decide d1: Ist eine Quelle nicht verfügbar oder veraltet?
step s6: Das Tray zeichnet jedes registrierte Widget im gewählten Terminal-Stil
product p1: Widgets zeigen Nutzung, Diagramme, Sitzungen, Aktivität und Gedächtnis
product p2: Das betroffene Widget nennt, was fehlt und wie alt seine Daten sind

t1 -> s1
t2 -> s3
s1 -> s2
s2 -> s4
s3 -> s4
s4 -> s5
s5 -> d1
d1 -no-> s6
d1 -yes-> p2
s6 -> p1

## Architecture
### Context
person g: Giovanni — liest Nutzung, Sitzungen und Aktivität auf dem Desktop | [[giovanni]]
system sq: Status Quo — das Widget-Panel und sein Collector
external cc: Claude Code — seine Protokolle und Hooks | [[claude-code]]
external cx: Codex — seine Protokolle und Hooks | [[codex]]
external gh: GitHub — Repository-Aktivität, gelesen über das Programm gh | [[github]]
external wm: workflow-memory — gemeinsame Notizen, nur lesend | [[workflow-memory]]

cc -sends session events and transcripts to-> sq
cx -sends session events and transcripts to-> sq
gh -supplies repository activity to-> sq
wm -supplies recent entries to-> sq
g -reads the panel of-> sq

### Containers
container co: Kern — geprüfte Konfiguration, Token-Hauptbuch und normalisierte Datensätze, ohne Ein- und Ausgabe
container ct: Vertrag — Widget-Register und die versionierten Nachrichten zwischen Host und Collector
container wd: Widgets — Anzeigemodelle, die keine Dateien lesen und keine Programme starten können
container sc: Quellen — lesende Adapter für Konten, Protokolle, GitHub und Gedächtnis
container cl: Collector — Hintergrundarbeiter und der Socket pro Nutzer
container tr: Tray — egui-Layout und Anpassung, mit Terminal-Stil
container dk: Desktop-Hülle — Kompatibilitätsschicht, die Layer-Shell, X11-Hinweise oder ein normales Fenster wählt; Installer und Hooks
store st: Privater Zustandsordner — Konfiguration, Schnappschuss und Lebenszyklus-Ereignisse

wd -uses-> co
tr -draws models from-> wd
tr -registers widgets through-> ct
cl -fills records from-> sc
cl -serves snapshots through-> ct
cl -saves data in-> st
dk -hosts-> tr
dk -starts-> cl

## What it does
Das Panel hat fünf anfängliche Widgets, soweit sinnvoll je Assistent angelegt, also standardmäßig sieben: Kontonutzung für Claude und Codex, Token-Verlauf für Claude und Codex, nach Projekt gruppierte Sitzungen, neue GitHub-Aktivität und Einträge aus workflow-memory. Die Nutzung zeigt den verbrauchten Prozentsatz der Fünf-Stunden- und Wochenlimits mit Rücksetzzeiten; ein Prozentsatz wird nie aus lokalen Token-Zahlen abgeleitet. Die Token-Diagramme wechseln zwischen 24 Stunden, 7 Tagen und 30 Tagen sowie zwischen Einzel- und Summenansicht. Fehlende Werte erscheinen als nicht verfügbar, nie als null.

Der Anpassungs-Reiter ändert hellen, dunklen oder Systemmodus, Akzentfarben, Hintergrunddeckkraft, Textgröße sowie Reihenfolge und Größe der Widgets. Änderungen werden zuerst in der Vorschau gezeigt und lassen sich abbrechen. Widgets können hinzugefügt, entfernt, ausgeblendet oder abgelöst werden. Standardmäßig liegt das Panel hinter normalen Fenstern, verankert in der oberen rechten Ecke; auf dem Laptop war es hinter einem maximierten Browser verborgen und auf einer leeren Arbeitsfläche sichtbar.

## How it does it
Der Code ist ein Rust-Workspace aus neun Paketen. `sq-core`, `sq-contract` und `sq-widgets` enthalten die portable Logik und dürfen weder Grafik, Dateien, Prozesse noch Netzwerk nutzen; `tools/rust_architecture.rs` prüft das bei jedem Gate-Lauf, weil der gemeinsame Prüfer nur Java und Kotlin versteht. `sq-sources` liest äußere Daten, `sq-store` schreibt sie atomar, `sq-collector` führt die Arbeiter aus und bedient einen versionierten Socket mit Größenlimit, `sq-tray` ist die wiederverwendbare egui-Oberfläche (egui ist eine Rust-Bibliothek zum Zeichnen von Oberflächen), `status-quo` ist die Linux-Hülle und `sq-web` eine Browser-Vorführung mit erfundenen Daten.

**Collector.** `crates/collector/src/lib.rs` enthält den Socket-Server und die Prozesssperre, sodass pro Nutzer nur ein Collector läuft. `workers.rs` führt je Quelle einen Arbeiter aus: Kontostatus, Sitzungsprotokolle, GitHub und Gedächtnis. Jeder Arbeiter behält seine letzten gültigen Daten mit Frische- und Fehlerstatus, sodass eine defekte Quelle nie die übrigen blockiert. Die Arbeiter beobachten Ordner auf Änderungen und greifen nur auf 2-Sekunden-Abfragen zurück, wenn eine Beobachtung fehlschlägt. Der Collector legt seinen eigenen privaten Ordner `events` an, bevor er ihn beobachtet; vor dieser Korrektur erzwang ein fehlender Ordner die Abfragen und verdreifachte die Leerlauf-CPU. `events.rs` schreibt unter einer Sperre eine kleine Datei je Lebenszyklus-Ereignis einer Sitzung und behält keinen Prompt- oder Werkzeugtext. Ein Stop-Ereignis bedeutet, dass die Sitzung wartet, nicht dass ihre Aufgabe erledigt ist.

**Widgets.** `crates/widgets/src/lib.rs` (Paket `sq-widgets`) registriert über `registry()` die fünf eingebauten Widget-Arten `quota`, `tokens`, `sessions`, `activity` und `memory`. Jede Art macht aus einem Schnappschuss des Collectors eine Ansicht, eine Liste einfacher Knoten (Text, Zeilen, Hinweise), die der Tray zeichnet; das Paket kann keine Dateien lesen und keine Programme starten. Bei GitHub-Aktivität und Memory behält eine Ansicht höchstens 100 Einträge. Ein Widget fügt außerdem einen Hinweis hinzu, wenn seine Quelle nicht frisch ist oder fehlerhafte oder zurückgestellte Datensätze hat, und "Waiting for source status", solange noch kein Status vorliegt. Das Sitzungs-Widget zeigt laufende, wartende und blockierte Sitzungen immer, abgeschlossene eine Stunde lang und andere 24 Stunden lang, außer seine Option `history` ist `true`. `format_utc` gibt Zeiten als `YYYY-MM-DD HH:MM UTC` aus, ohne eine Uhr zu lesen. Die Tests in `crates/widgets/tests/models.rs` (Anforderungen SQ-5, SQ-6, SQ-8, SQ-10, SQ-11) prüfen unter anderem, dass ein fehlendes Kontingent nicht als null erscheint, dass Projekte mit gleichem Ordnernamen getrennt bleiben, dass verschachtelte Agenten unter ihrem echten Elternteil bleiben und dass Datumsextreme nicht überlaufen.

**Vertrag.** `crates/contract` legt fest, wie ein Host Widget-Arten registriert und wie Anfragen und Schnappschüsse gerahmt werden. Inkompatible Versionen und zu große Rahmen werden abgewiesen, und ein unabhängiges Beispiel-Widget belegt, dass die Registrierung ohne Änderung am Tray funktioniert (`tests/registry.rs`, `tests/transport.rs`).

**Hooks.** Der Installer trägt Status-Quo-Einträge in `~/.claude/settings.json` und `~/.codex/hooks.json` ein und behält jeden bestehenden Hook. Er wurde am 2026-11-02 ausgeführt.

**Kompatibilitätsschicht.** `crates/desktop/src/host/` ist der einzige Code, der weiß, wie das Tray auf einem bestimmten Linux-Desktop platziert wird, und er wählt zur Laufzeit, sodass ein Programm über Distributionen hinweg funktioniert (Entscheidung in `docs/adr/0004-host-compatibility-layer.md`). Layer-Shell, ein Wayland-Protokoll, mit dem ein Programm auf die Desktop-Ebene zeichnet, wird genutzt, wenn der Compositor es anbietet (KDE Plasma, Hyprland, sway); das Tray hat dann keinen Rahmen, ist an einer Kante oder Ecke verankert (`STATUS_QUO_ANCHOR`, Standard oben rechts) und zeichnet nur bei Änderungen. In einer X11-Sitzung nutzt es ein rahmenloses Fenster mit Fenstermanager-Hinweisen für „unten“, ohne Taskleiste und ohne Pager; „alle Arbeitsflächen“ ist nur ein Versuch, weil KDEs X11-Kompatibilität es ignoriert. Überall sonst, zum Beispiel GNOME unter Wayland, fällt es auf ein normales Fenster zurück und sagt das. `STATUS_QUO_HOST=layer-shell|x11|window` erzwingt eine Wahl, wenn sie möglich ist. In diesen beiden Hosts ist das Tray nackt: Es hat weder Hintergrund noch Titel, sichtbar sind nur die Widgets und die drei kleinen Schaltflächen „Add widget“, „Edit tray“ und „Customize“ (der Verbindungsstatus erscheint nur bei getrennter Verbindung), und die Widget-Zeilen werden so skaliert, dass sie den Tray-Platz mit gleichen Abständen genau ausfüllen. Anpassung und Screenshots nutzen das normale Fenster, weil der Layer-Host noch keine Tastatureingabe hat.

**Edit tray (Anforderung SQ-29).** Die Schaltfläche „Edit tray“ macht das Tray zu einem direkten Editor, der nur mit dem Zeiger arbeitet. Zieht man den unteren Rand eines Widgets, ändert sich seine Höhe (100 bis 1400 Pixel); zieht man einen Seitenrand, ändert sich die Breite, eine oder zwei Spalten (ein Rand, der über drei Viertel der Tray-Breite gezogen wird, bedeutet zwei Spalten); zieht man den Widget-Körper und lässt ihn auf einem anderen Widget los, wandert es an diese Position. Alle Änderungen betreffen eine Entwurfskopie: „Done“ speichert sie über denselben geprüften Konfigurationsweg wie „Customize“, „Cancel“ verwirft sie. Tests steuern echte Zeigerereignisse durch das Tray; ein Ziehen im echten Desktop-Compositor wurde noch nicht beobachtet.

## Where it sits in the pipeline
Es läuft auf dem Laptop neben [[claude-code]] und [[codex]]. Seine Prüfungen stehen auf [[checks-status-quo]], und es folgt [[project-template]] und [[pipeline-check]].

## Who receives its output
Giovanni liest das Panel. Andere Programme können das Tray oder einzelne Widgets über den Vertrag wiederverwenden.

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Principles
1. **Anforderungen gehen Änderungen voraus**: Tests tragen einen eigenständigen Kommentar `// REQ SQ-n`, und der Rückverfolgbarkeitsschritt ([[check-traceability]]) schlägt fehl, wenn eine Anforderung keinen hat.
2. **Portable Pakete bleiben frei von Ein- und Ausgabe**: Kern, Vertrag und Widgets, geprüft von einem projekteigenen Detektor mit Selbsttests mit eingepflanzten Fehlern.
3. **Alles ist ein entfernbares Widget**: keine festen Anbieter-Plätze im Tray.
4. **Das Gate entscheidet**: `tools/quality_gate.sh` ist die einzige Definition von bestanden, und kein Limit wird gesenkt, damit es besteht.
5. **Nichts Privates wird gespeichert**: keine Zugangsdaten, Gespräche oder Gedächtnisinhalte in Testdaten, Diagnosen oder der Browser-Vorführung.

### Decisions
`DESIGN.md` enthält das Architekturdiagramm und ein datiertes Entscheidungsprotokoll mit dem Typ jeder Entscheidung. Vier ADRs (Architecture Decision Records, kurze Notizen, die die Gründe einer Entscheidung festhalten) liegen in `docs/adr/`: 0001 Entscheidungen festhalten, 0002 portable Rust-Widgets, 0003 das Programm misst und der Skill urteilt, 0004 die Host-Kompatibilitätsschicht. `docs/adr/0000-template.md` ist das leere Formular für den nächsten (Status, Datum, Typ, Entscheider, Kontext, Entscheidung, Alternativen, Folgen) und `docs/adr/README.md` das Verzeichnis; ein beschlossener ADR wird nie umgeschrieben, ein neuer ersetzt ihn. Der freigegebene Umfang liegt in `docs/2026-11-01-status-quo-design.md`.

### Requirements
29 Anforderungen (Präfix SQ) in `docs/REQUIREMENTS.md`, am 2026-11-02 alle durch markierte Tests abgedeckt (SQ-29 liegt zum Zeitpunkt dieser Prüfung im Arbeitsverzeichnis, noch nicht committet). `docs/TRACEABILITY.md` ist die Tabelle, die der Rückverfolgbarkeitsschritt erzeugt: jede Anforderung mit den Testdateien, die ihre Markierung tragen; sie wird nicht von Hand bearbeitet. Eine Markierung belegt, dass ein Test existiert, nicht dass sich der echte Desktop richtig verhält.

### Quality gate
Fünf Schritte: Formatierung, Compiler-Diagnose ohne zugelassene Warnungen samt aller Tests, die Rust-Grenzprüfung, Anforderungs-Rückverfolgbarkeit und die Gate-Dauergrenze von 1200 Sekunden. `tools/resource_check.rs` misst die echten Prozesse über fünf Minuten. Die erste Beobachtung erfüllte das Speicherziel (115 MiB von 200 MiB) und verfehlte die Leerlauf-CPU (2,05 % eines Kerns bei 1 %).

### Continuous integration
Continuous Integration (CI) bedeutet automatische Prüfungen bei jedem Push. `quality-gate.yml` installiert Rust 1.87, führt `pipeline-check --mode ci` aus (festgelegt in `pipeline-check.version`) und baut die Browser-Version. Es bestand beim ersten Commit.

### Maintenance
`docs/MAINTENANCE.md` nennt die Methode: Schulden sind ein GitHub-Issue mit dem Label `debt` (P1 bis P3), Features `idea`, etwa eine von fünf Sitzungen geht in Schulden oder Vorbeugung, und eine monatliche Prüfung jedes Projekts hält eine Zeile vom Typ Preventive im Entscheidungsprotokoll fest. Sie folgt der Datei der Vorlage und ergänzt, dass die verlangte CI-Prüfung `gate` auf dem genauen Commit bestehen muss, bevor er nach `main` befördert wird. Technische Schulden gehören in GitHub-Issues mit dem Label `debt` nach der [[maintenance-policy]], und der [[monthly-architecture-review]] prüft das Projekt. Branch-Schutz lässt sich bei einem privaten Repository im kostenlosen GitHub-Tarif nicht aktivieren.

## Notes
Bauen mit `cargo build --release --locked -p status-quo`; der Installer ist `status-quo install`, und `status-quo uninstall` macht ihn rückgängig. Der Zustand liegt in `~/.local/state/status-quo`; `STATUS_QUO_STATE_DIR` leitet ihn für Tests um. Auf dem Laptop zeigten Testläufe am 2026-11-02 den Layer-Shell-Host mit Live-Daten, den Collector mit echten Assistenten-Sitzungen über die Hooks, einen Mausklick, der ein Widget änderte, und eine 60-Sekunden-Leerlaufmessung von 1,08 % eines Kerns und 195 MB zusammen (die Bibliotheken des Grafiktreibers machen den größten Teil der 156 MB des Panels aus). `docs/TESTES-AUTOMATIZADOS.md` (auf Portugiesisch, wie der Name sagt) ist die Aufzeichnung der fehlerfindenden Tests; siehe [[checks-status-quo]]. Noch nicht beobachtet: Start beim Login, die 100-ms-Grenze der Bedienung, der volle Fünf-Minuten-Lauf, Tastatureingabe im Layer-Host, GNOME oder ein anderer Desktop als KDE Plasma sowie eine echte X11-Sitzung. Die Ursache der verbleibenden Leerlauf-CPU ist offen.
