---
id: skill-ligamagic-replicar-carrinho-nas-lojas
lang: de
source_hash: fa2516bd4da8
title: Skill: ligamagic-replicar-carrinho-nas-lojas
---

## What it is
Die Skill „ligamagic-replicar-carrinho-nas-lojas“ baut den Warenkorb pro Shop von LigaMagic auf der eigenen Website jedes Shops nach und gleicht beide vor dem Bezahlen ab. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: Sie baut den Warenkorb pro Shop von LigaMagic auf der eigenen Seite jedes Shops nach (dieselbe Karte, Edition, Sprache, Zustand, Extras und Menge) und gleicht beide vor dem Checkout ab; verwenden, wenn Giovanni bittet, die LigaMagic-Warenkörbe zu prüfen und auf den Seiten der Shops aufzubauen oder zu prüfen, ohne die Links von LigaMagic zu benutzen. Sie stammt aus einer Aufgabe vom 12. Oktober 2026 (5 Shops, 90 Positionen) und verhindert die damals gefundenen Fehler: eine beim Lesen übersprungene Foil- oder Promo-Position, Lagerbestand als Menge gelesen, eine doppelte Kopie durch wiederholten Klick, eine ähnliche statt der richtigen Edition und eine Prüfung nur nach der Positionszahl.

## What it does
Sie kopiert dieselbe Karte, Edition, Sprache, Zustand, Extras und Menge in den Warenkorb jedes Shops, ohne die Links von LigaMagic zu benutzen; die Käufe selbst brauchen Giovannis Freigabe. Ihre Rolle ist „Domäne“: Sie besitzt den Ablauf von LigaMagic zum Shop, die Skripte zum Lesen des Warenkorbs pro Shop und der Produktseite, den Abgleich und den Abschlussbericht; sie verweist auf [[skill-ligamagic-listas]], auf [[skill-browser-automacao-segura]] (Warnungen, Schleifen, zerstörerische Aktionen: diese gilt vorrangig), auf [[skill-click-protocol]] (Klickmechanik) und auf [[skill-minimize-site-approvals]] (Domains).

## How it does it
Eine `SKILL.md` in `~/.claude/skills/ligamagic-replicar-carrinho-nas-lojas`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Giovannis Hobby Magic: The Gathering.

## Who receives its output
Giovanni, vor dem Bezahlen.

## Steps
Feste Regeln:
1. LigaMagic ist nur lesbar. Nie `.btn-circle.remove` klicken (es entfernt die Position oder einen ganzen Shop).
2. Im Shop: suchen, KAUFEN (der Knopf „COMPRAR“ des Produkts) und die Menge korrigieren. Nie anmelden, ein Konto erstellen, bezahlen, Formulare ausfüllen oder den Knopf „COMPRAR“ des Warenkorbs (Checkout) drücken.
3. Positionen, die schon im Warenkorb des Shops lagen, bleiben (sein Standard: behalten und ergänzen). Nur fragen, wenn er es nicht gesagt hat.
4. Die Shops nicht über die Links von LigaMagic erreichen.
5. Vor dem Hinzufügen das Warnungsprotokoll einrichten (Regel 3 von [[skill-browser-automacao-segura]]). Eine Position nach der anderen; nie zwei Klicks ohne Prüfung dazwischen.
6. Eine kurze Fortschrittsmeldung alle 5 Positionen und bei jedem Shopwechsel.
7. `navigate` allein, außerhalb von Stapeln. Stapel aus höchstens 4 harmlosen Aktionen, mit einer Prüfung am Ende ([[skill-click-protocol]]).

Checkliste (kopieren und abhaken): S1 LigaMagic lesen (Skript A) → die erwartete Liste E pro Shop, die Domains auflisten und auf einmal um Zugriff bitten; S2 für jeden Shop R0 lesen (den Warenkorb vor dem Eingriff); S3 jede Position aus E hinzufügen (Skript B + Auswahlregel); S4 den Shop abgleichen, bis es besteht; S5 Bericht.

S1. **Der LigaMagic-Warenkorb** (`?view=mp/carrinho&open=1`). Skript A (am 12. Okt. 2026 getestet; 90 Zeilen, 5 Shops) liest für jeden Shop-Block: den Shopnamen, die Zahl der Positionen im Kopf, die Summe, und je Zeile den Kartennamen (der englische Name nach dem letzten „ / “), die Edition (aus dem Titel des Editionssymbols), Sprache, Zustand, Extras (Foil, Promo, Pre-release, Textless, Etched, signiert, verändert, Oversize), Menge (das Mengenfeld), Lagerbestand und Zwischensumme. Vor der Nutzung validieren: Die Zahl im Kopf entspricht der Zeilenzahl jedes Shops, und kein Feld für Edition, Sprache oder Zustand ist leer; scheitert das (die Seite hat sich geändert), Zeile für Zeile von der Seite lesen. Die Positionen in Scheiben lesen; das Werkzeug kappt lange Ausgaben und blockiert URLs. „N unids.“ ist LAGERBESTAND, nie Menge; die Menge ist der Wert des Eingabefelds. Ist eine Menge über 1, fragen, ob das Absicht ist, bevor man sie kopiert (einmal entstand irrtümlich eine zusätzliche Kopie). Die Einkaufsliste (eine Tabelle mit Auswahllisten) gehört zu [[skill-ligamagic-listas]]; nicht mit dem Warenkorb pro Shop verwechseln. Um die Website des Shops zu finden, auf den Shopnamen klicken; bestätigte Domains: primemtg.com.br und tavernagamehouse.com.br.

S2. **R0 des Shops.** `https://<Shop>/?view=ecom/carrinho` öffnen und den Seitentext lesen: die Zeilen, die Zwischensumme und die Felder `txt_qty_*` (Eingabefelder, deren Name so beginnt) festhalten. Ohne „Olá, <Name>“ oben ist der Warenkorb ein Gastkorb: am Ende darauf hinweisen.

S3. **Eine Position hinzufügen.** (a) Direkte Suche: `https://<Shop>/?view=ecom/itens&busca=<englischer Name>`; ein Ergebnis öffnet das Produkt; bei mehreren sind Art Cards, „mit Signatur“ und Token andere Produkte, also Kandidaten öffnen, bis die Edition gefunden ist. (b) Skript B (Produktseite; im Prime MTG getestet, derselben Plattform wie die anderen Shops) listet die kaufbaren Zeilen mit Edition, Sprache, Zustand, Extras, Bestand und Preis; werden keine Zeilen gefunden, mit der Maus über das Editionssymbol jeder Zeile fahren und zoomen. (c) Auswahlregel (beim ersten Filter anhalten, der 1 Zeile ergibt): Zeilen mit derselben Edition, Sprache, Zustand und Extras wie bei LigaMagic → diese kaufen; dazu gleicher Bestand und ein Endpreis gleich dem Stückpreis von LigaMagic entscheidet bei Gleichstand; 0 Zeilen → die Variante fehlt: nicht ersetzen, festhalten. Die Shops nutzen das System von LigaMagic, also kommen Edition, Sprache, Bestand und Preis mit demselben Text; ähnliche Editionen sind verschiedene Zeilen (zum Beispiel ist „FINAL FANTASY Commander (Extended Art)“ die richtige und „FINAL FANTASY Commander“ eine andere auf derselben Seite). (d) KAUFEN in Zeile i, nur ein Klick; bei der ersten Position der Sitzung den Klick per Skript testen, und steigt der Warenkorbzähler nicht, `find` nutzen (die Referenz des KAUFEN dieser Zeile) oder, wenn `find` scheitert, die Zeile in die Mitte scrollen, einen Screenshot machen und das KAUFEN der mittleren Zeile klicken; den Weg, der funktionierte, für den Rest des Shops nutzen. (e) Erwartete Änderung: Der Warenkorbzähler (die Zahl neben dem Warenkorbsymbol oben rechts) steigt um genau 1; jeder andere Wert → anhalten und den Warenkorb lesen, bevor wieder geklickt wird. Zwei Fehlschläge am selben Schritt → Screenshot, berichten, fragen.

S4. **Den Shop abgleichen** (vom billigsten zum teuersten; beim ersten Fehlschlag anhalten). (1) Zähler (zählt Stück) = Stück von R0 + Summe der Mengen von E. (2) Zwischensumme des Warenkorbs = Zwischensumme von R0 + Summe von LigaMagic. (3) Die `txt_qty_*` der neuen Positionen = die Mengen von E; eine Zeilenzwischensumme, die vom Stückpreis abweicht, verrät Menge 2. (4) Stimmt alles, ist der Shop fertig; sonst nach dem Schlüssel `Name | Edition | Sprache | Zustand | Extras` vergleichen (erwartet = R0 + E) und korrigieren: fehlt → S3; zusätzliche Menge aus dieser Sitzung → Dreifachklick ins Feld, den Wert eintippen, Tab, „Alterar“ klicken, neu laden und prüfen; eine in dieser Sitzung hinzugefügte falsche Zeile → vor dem Entfernen fragen. (5) Neu laden und wiederholen, bis es besteht; ohne Neuladen ist nicht geprüft.

S5. **Bericht** (in der Sprache von Giovannis Nachricht): eine Tabelle Shop | Positionen | LigaMagic-Summe | Zwischensumme im Shop; dann nur, was zutrifft: behaltene frühere Positionen (und ihr Wert), ein Gastkorb, fehlende Varianten, Mengen über 1 aus LigaMagic, eine erklärte Abweichung des Kopfes. Sagen, dass vor dem Checkout angehalten wurde. Mit `!!`: nur die Tabelle und die Vorbehalte. Mit `***`: den Abgleich nach Schlüssel für jeden Shop einschließen.
