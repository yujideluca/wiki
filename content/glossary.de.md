---
id: glossary
lang: de
source_hash: a31fdfea6dac
title: Glossar
---

## What it is
Das ist das Wörterbuch des Wikis: Definitionen in einfacher Sprache für die Fachwörter und Abkürzungen, die auf seinen Seiten vorkommen, mit einem Link auf eine gute externe Erklärung, wo es eine gibt. Stößt du auf ein unbekanntes Wort, schlage es hier nach; jede Seite erklärt einen Begriff außerdem dort, wo sie ihn zum ersten Mal benutzt. Einträge, die in diesem Wiki eine eigene Seite haben, verweisen darauf.

## What it does
Es lässt einen Leser ohne Vorkenntnisse in Software, in diesem System oder in Medizin jede Seite verstehen, ohne das Wiki lange zu verlassen. Die Begriffe stehen unter Notes in alphabetischer Reihenfolge. Auch ein Begriff in einer anderen Sprache (zum Beispiel deutsche Prüfungsnamen) wird hier erklärt.

## How it does it
Jeder Eintrag nennt den vollen Namen einer Abkürzung, eine kurze Definition in Alltagsworten und, wo nützlich, einen Link. Die Seite ist von der Art „reference“: Sie darf auf jede Seite verlinken, ohne Linien auf der Karte zu zeichnen (festgehalten als Anforderung BU-3). Die obere Leiste jedes Bildschirms verlinkt darauf.

## Where it sits in the pipeline
Neben den Seiten, die sie erklärt. Sie gehört zu keinem Projekt und nimmt an keiner Pipeline teil.

## Who receives its output
Jeder Leser des Wikis, vor allem [[giovanni]] und alle, die neu im System sind.

## Notes
- **Activity / Android-Activity**: eine bildschirmtragende Komponente einer Android-App ([Dokumentation](https://developer.android.com/guide/components/activities/intro-activities)).
- **adb** (Android Debug Bridge): ein Werkzeug, mit dem ein Computer ein Android-Handy über ein Kabel steuert ([Dokumentation](https://developer.android.com/tools/adb)); siehe [[skill-adb-android-control]].
- **ADR** (Architecture Decision Record): eine kurze Notiz, die eine wichtige Entscheidung festhält, warum sie getroffen wurde und welche Alternativen es gab ([adr.github.io](https://adr.github.io/)); siehe [[quizapp-adrs]] und [[memory-adrs]].
- **Anki**: ein Karteikartenprogramm mit Spaced Repetition ([apps.ankiweb.net](https://apps.ankiweb.net/)).
- **API** (Application Programming Interface): die Art, wie ein Programm seine Funktionen anderen Programmen anbietet, meist über das Web.
- **APK** (Android Package): die Datei, die eine Android-App enthält und auf dem Handy installiert wird ([APK](https://en.wikipedia.org/wiki/Apk_%28file_format%29)).
- **Approbation**: in Deutschland die Erlaubnis, den Arztberuf auszuüben. **Anerkennung** ist die Anerkennung einer ausländischen Qualifikation. Siehe [[skill-candidatura-alemanha]].
- **Append-only**: ein Protokoll, dem nur neue Einträge hinzugefügt, aber nie welche bearbeitet oder gelöscht werden; siehe [[events-log]].
- **Asset**: eine in eine App gepackte Datei, die kein Code ist, etwa Daten oder Bilder; siehe [[vocab-assets]].
- **Bash**: die Standard-Befehlssprache des Linux-Terminals; darin geschriebene Skripte enden auf `.sh` ([Bash](https://www.gnu.org/software/bash/)).
- **Beta / stabiler Kanal**: zwei Ströme von App-Versionen; die Beta wird zuerst ausprobiert, die stabile ist das, was der Nutzer normalerweise benutzt; siehe [[release-channels]].
- **Branch**: eine eigene Arbeitslinie in einem Git-Repository; `main` ist die Hauptlinie.
- **Brief**: die kurze Zusammenfassung des Gedächtnisses, mit der jeder Chat beginnt; siehe [[session-brief]].
- **CI** (Continuous Integration): automatische Prüfungen, die bei jeder hochgeladenen Änderung laufen, sodass ein Fehler sofort auffällt ([CI](https://en.wikipedia.org/wiki/Continuous_integration)); siehe [[quizapp-ci]].
- **CLAUDE.md**: eine Textdatei mit dauerhaften Anweisungen, die Claude Code zu Beginn einer Sitzung automatisch liest; siehe [[global-claude-md]].
- **CLI** (Command-Line Interface, Kommandozeilenschnittstelle): ein Programm, das man bedient, indem man Befehle in ein Terminal tippt ([CLI](https://en.wikipedia.org/wiki/Command-line_interface)).
- **Clone**: eine vollständige lokale Kopie eines Repositorys.
- **Commit**: ein gespeicherter Schritt in der Geschichte eines Git-Repositorys, mit einer Nachricht, was sich änderte.
- **Konformitätsvektoren**: gemeinsame Testfälle, die zwei Implementierungen beide bestehen müssen; siehe [[quizweb-conformance]].
- **Cookie**: ein kleines Datenstück, das eine Website den Browser aufbewahren und zurücksenden lässt, um etwa eine Anmeldung zu merken ([Cookie](https://en.wikipedia.org/wiki/HTTP_cookie)); siehe [[wiki-router]].
- **CPF** (Cadastro de Pessoas Físicas): die brasilianische persönliche Steuernummer; der Datenschutz-Scan blockiert sie ([[mem-validator]]).
- **CSP** (Content Security Policy): eine Regel, die dem Browser sagt, was eine Webseite laden darf ([CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)).
- **Schulden, technische**: alles, was heute funktioniert, die nächste Änderung aber langsamer oder riskanter macht ([technische Schulden](https://en.wikipedia.org/wiki/Technical_debt)); siehe [[maintenance-policy]].
- **Decoy / Köder**: eine Seite, die echt aussieht, aber das Echte verbirgt; siehe [[decoy-page]].
- **DNS** (Domain Name System): das Telefonbuch des Internets, das Namen in Netzwerkadressen übersetzt ([DNS](https://en.wikipedia.org/wiki/Domain_Name_System)).
- **DOM** (Document Object Model): das lebendige Modell des Browsers von einer Webseite ([Dokumentation](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)).
- **DORA** (DevOps Research and Assessment): ein Forschungsprogramm, das vier Kennzahlen dafür definierte, wie gut Software ausgeliefert wird, etwa wie oft und wie schnell Änderungen veröffentlicht werden ([dora.dev](https://dora.dev/)); siehe [[pipeline-check]].
- **Elixir**: die Programmiersprache des Wiki-Servers ([elixir-lang.org](https://elixir-lang.org/)); siehe [[wiki-server]].
- **Elm**: die Programmiersprache des Wiki-Front-Ends ([elm-lang.org](https://elm-lang.org/)); siehe [[wiki-frontend]].
- **Escript**: ein in eine einzige ausführbare Datei gepacktes Elixir-Programm; siehe [[wiki-cli]].
- **Event / Ereignis**: ein Eintrag, dass etwas geschehen ist; im Gedächtnis eine Datei pro Ereignis; siehe [[events-log]].
- **Exit-Code**: die Zahl, die ein Programm beim Beenden zurückgibt; 0 heißt Erfolg, alles andere einen Fehler ([Exit-Status](https://en.wikipedia.org/wiki/Exit_status)).
- **Fitnessfunktion**: eine automatische Prüfung, dass eine Eigenschaft des Entwurfs nicht abgedriftet ist ([Fitnessfunktion](https://en.wikipedia.org/wiki/Fitness_function)); siehe [[fitness-check]].
- **Fold / Faltung**: eine ganze Liste von Ereignissen zu einem aktuellen Zustand zusammenfassen; siehe [[memory-fold]].
- **FSP** (Fachsprachprüfung): die deutsche medizinische Sprachprüfung auf Niveau C1, die ausländische Ärzte vor der Zulassung ablegen; siehe [[skill-alemao-goethe-fsp]].
- **Gate / Quality Gate**: ein Skript, das „bestanden“ für ein Projekt definiert; siehe [[template-quality-gate]].
- **Git**: das Versionsverwaltungswerkzeug, das jede Änderung an einem Projekt festhält ([git-scm.com](https://git-scm.com/)).
- **GitHub / GitHub Actions**: eine Website, die Git-Repositories speichert; Actions führt automatische Aufträge auf ihren Rechnern aus ([Dokumentation](https://docs.github.com/en/actions)); siehe [[github]].
- **Goethe B2**: die allgemeine Deutschprüfung auf gehobenem Mittelstufenniveau (Niveau B2 des Europäischen Referenzrahmens) ([Goethe-Zertifikat B2](https://www.goethe.de/en/spr/prf/gzb2.html)).
- **GRADE** (Grading of Recommendations Assessment, Development and Evaluation): eine Methode, um einzustufen, wie sicher eine Menge medizinischer Evidenz ist ([GRADE](https://www.gradeworkinggroup.org/)); siehe [[skill-analise-artigo-cientifico]].
- **Gradle**: das Werkzeug, das Android-Projekte kompiliert und testet ([gradle.org](https://gradle.org/)); siehe [[android-toolchain]].
- **Hash**: ein kurzer Fingerabdruck, aus einem Inhalt berechnet; ändert sich der Inhalt, ändert sich der Fingerabdruck ([Hashfunktion](https://en.wikipedia.org/wiki/Hash_function)); siehe **SHA-256** (Secure Hash Algorithm 256).
- **Hook**: ein kleines Programm, das Claude Code zu einem bestimmten Zeitpunkt automatisch ausführt, etwa beim Start eines Chats ([Hooks erklärt](https://docs.claude.com/en/docs/claude-code/hooks-guide)); siehe [[hook-session-start]].
- **Hospitation**: in Deutschland ein Beobachtungsbesuch in einer Krankenhausabteilung.
- **HTML** (HyperText Markup Language): die Sprache, in der Webseiten geschrieben sind ([HTML](https://en.wikipedia.org/wiki/HTML)).
- **HTTPS** (Hypertext Transfer Protocol Secure): die verschlüsselte Art, wie Browser und Websites miteinander sprechen.
- **Idempotent**: zweimal ausgeführt ergibt dasselbe wie einmal ([Idempotenz](https://en.wikipedia.org/wiki/Idempotence)).
- **JSON** (JavaScript Object Notation): ein Klartextformat für strukturierte Daten ([JSON](https://en.wikipedia.org/wiki/JSON)).
- **Kenntnisprüfung**: die Prüfung des medizinischen Wissens, die im Ausland ausgebildete Ärzte in Deutschland statt einer Gleichwertigkeitsprüfung der Unterlagen ablegen können.
- **Kotlin / Jetpack Compose**: die Programmiersprache und das Bildschirm-Toolkit der Android-App ([Kotlin](https://kotlinlang.org/), [Compose](https://developer.android.com/compose)); siehe [[quizapp]].
- **Linger**: eine Linux-Einstellung, mit der die Hintergrunddienste eines Benutzers laufen, ohne dass jemand angemeldet ist; siehe [[acer-nitro]].
- **localStorage**: ein kleiner Schlüssel-Wert-Speicher, den jeder Webbrowser einer Webseite bietet ([Dokumentation](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage)).
- **logcat**: das Systemlog von Android, mit adb gelesen ([Dokumentation](https://developer.android.com/tools/logcat)).
- **Manifest**: eine Liste, die die Dateien eines Pakets beschreibt und wie man sie prüft; siehe [[content-manifest]].
- **Markdown**: ein Textformat mit einfachen Zeichen für Überschriften, Listen und Links ([Markdown](https://en.wikipedia.org/wiki/Markdown)); siehe [[wiki-content]].
- **Gedächtnis (workflow-memory)**: das gemeinsame Langzeitgedächtnis von Giovannis Claude-Assistenten; siehe [[workflow-memory]].
- **Mutationstest**: ein Programm absichtlich kaputt machen, um zu prüfen, ob die Tests es bemerken ([Mutation Testing](https://en.wikipedia.org/wiki/Mutation_testing)); siehe [[mutation-check]].
- **OAuth** (Open Authorization) und **OIDC** (OpenID Connect): die Standards, mit denen ein Dienst wie Google einer Website mitteilt, wer sich anmeldet ([OAuth](https://en.wikipedia.org/wiki/OAuth)); siehe [[wiki-sign-in]].
- **Offener Punkt**: ein unerledigtes Ziel oder bekanntes Problem, das Giovanni vor Augen gehalten wird, bis es erledigt ist; siehe [[mem-task]].
- **OTP** (Open Telecom Platform): die Standardbibliotheken und Laufzeit von Erlang, auf denen Elixir läuft ([erlang.org](https://www.erlang.org/)).
- **PICO** (Population, Intervention, Vergleich, Endpunkt): die vier Teile einer gut gebildeten klinischen Frage.
- **Pipeline**: eine Kette von Schritten, in der jeder Schritt das Ergebnis des vorigen übernimmt; in diesem Wiki auch die Kette der Seiten, die einander speisen.
- **Plugin**: ein Zusatzpaket für Claude Code; siehe [[claude-plugins]].
- **Produktionscode**: der Code, der im fertigen Programm wirklich läuft, im Gegensatz zum Testcode.
- **Promote / befördern**: eine getestete Beta-Version in den stabilen Kanal heben, was Giovannis Entscheidung ist; siehe [[publish-apk]].
- **Pull / Push**: die neueste Version eines Repositorys herunterladen und eigene Änderungen dorthin hochladen.
- **Pull Request**: ein Vorschlag, eine Änderung in die Hauptlinie eines Repositorys zu übernehmen.
- **Reine Funktion**: eine Funktion, deren Ergebnis nur von ihrer Eingabe abhängt und die sonst nichts ändert ([reine Funktion](https://en.wikipedia.org/wiki/Pure_function)).
- **PWA** (Progressive Web App): eine Webseite, die sich wie eine App auf dem Handy installieren lässt und offline funktioniert ([PWA](https://en.wikipedia.org/wiki/Progressive_web_app)); siehe [[quizweb]].
- **Repository**: ein Projektordner samt der vollständigen Geschichte seiner Änderungen, mit Git gespeichert ([Repository](https://en.wikipedia.org/wiki/Repository_%28version_control%29)).
- **Anforderung**: ein prüfbares Versprechen eines Programms; siehe [[wiki-requirements]].
- **Remote Control**: die Funktion von Claude Code, mit der Giovanni aus der Claude-App mit einer Sitzung auf dem Laptop spricht; siehe [[claude-assistant]].
- **SDK** (Software Development Kit): die Bibliotheken und Werkzeuge zur Entwicklung von Software für eine Plattform; siehe [[android-toolchain]].
- **Dienst (systemd)**: ein Programm, das im Hintergrund läuft und vom Betriebssystem gestartet und überwacht wird ([systemd](https://en.wikipedia.org/wiki/Systemd)); siehe [[wiki-service]].
- **Service Worker**: ein Skript, das ein Browser im Hintergrund für eine Webseite ausführt und das Offline-Nutzung ermöglicht ([Dokumentation](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)); siehe [[quizweb-service-worker]].
- **SHA-256** (Secure Hash Algorithm 256): eine Art, den Fingerabdruck einer Datei zu berechnen ([SHA-2](https://en.wikipedia.org/wiki/SHA-2)).
- **Skill**: ein gepacktes Set von Anweisungen, das Claude lädt, wenn eine Aufgabe dieser Art ansteht; siehe [[skills]].
- **SM-2** (SuperMemo 2): ein früher Spaced-Repetition-Algorithmus ([SuperMemo](https://en.wikipedia.org/wiki/SuperMemo)); siehe [[spaced-repetition-scheduler]].
- **Spaced Repetition**: eine Lernmethode, bei der Gewusstes nach immer längeren Pausen wiederkommt ([Spaced Repetition](https://en.wikipedia.org/wiki/Spaced_repetition)).
- **SSH** (Secure Shell): eine verschlüsselte Art, sich auf einem anderen Computer anzumelden ([SSH](https://en.wikipedia.org/wiki/Secure_Shell)); siehe [[remote-terminal]].
- **Stale / veraltet**: nicht mehr aktuell. Eine Seite mit Quellen ist veraltet, wenn sich eine davon nach dem `reviewed`-Zeitpunkt der Seite geändert hat; eine Seite ohne Quellen wird 30 Tage nach diesem Zeitpunkt als „kann veraltet sein“ angezeigt. Siehe [[wiki-stale]].
- **Statuszeile**: die einzelne Zeile am unteren Rand des Claude-Code-Terminals; siehe [[pbar]].
- **sudo**: der Befehl, der einen anderen Befehl mit Administratorrechten ausführt.
- **SVG** (Scalable Vector Graphics): ein Format für aus Formen gebaute Zeichnungen, von der Karte benutzt ([SVG](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics)).
- **Tailnet**: das private Netzwerk, das Tailscale zwischen deinen Geräten aufbaut; siehe [[tailscale]].
- **Terminal**: das Textfenster, in dem Befehle getippt werden.
- **tmux**: ein Programm, das eine Terminalsitzung weiterlaufen lässt, wenn man die Verbindung trennt ([tmux](https://github.com/tmux/tmux/wiki)).
- **Token**: ein kleines Textstück, etwa drei Viertel eines Wortes, in dem die Nutzung eines KI-Modells gemessen wird; auch ein geheimer Code, der eine Identität belegt.
- **TLS** (Transport Layer Security): die Verschlüsselung, die HTTPS nutzt ([TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security)).
- **Rückverfolgbarkeit**: jede Anforderung bis zu dem Test verfolgen können, der sie prüft; siehe [[check-traceability]].
- **TSV** (tab-separated values, durch Tabulatoren getrennte Werte): eine Klartext-Tabelle, deren Spalten durch Tabulatorzeichen getrennt sind ([TSV](https://en.wikipedia.org/wiki/Tab-separated_values)).
- **UI** (User Interface, Benutzeroberfläche): was der Nutzer auf dem Bildschirm sieht und berührt.
- **URL** (Uniform Resource Locator): eine Webadresse.
- **User-Space**: in den eigenen Ordnern eines Benutzers installiert, sodass keine Administratorrechte nötig sind; siehe [[user-space-tools]].
- **ViewModel**: der Teil einer Android-App, der Daten für die Bildschirme aufbereitet und Bildschirmdrehungen übersteht ([Dokumentation](https://developer.android.com/topic/libraries/architecture/viewmodel)); siehe [[study-view-model]].
- **VPN** (Virtual Private Network, virtuelles privates Netzwerk): eine verschlüsselte Verbindung, durch die entfernte Geräte sich verhalten, als wären sie in einem lokalen Netz ([VPN](https://en.wikipedia.org/wiki/Virtual_private_network)).
- **Web-Zwilling**: die Webversion, die die Android-App spiegelt; siehe [[quizweb]].

- **Maschineneinrichtung wiederherstellen**: die Einrichtung eines Computers aufzeichnen, um sie nach einer Neuinstallation wieder aufzubauen; siehe [[machine-bootstrap]].
- **Codex-Aufgabenfortschritt**: feste Terminalzeile mit erledigten Schritten und geschätzter Restzeit; siehe [[codex-pbar]].
