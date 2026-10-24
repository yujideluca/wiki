---
id: maintenance-policy
lang: de
source_hash: a13b2e481871
title: Wartungsrichtlinie (technische Schulden)
---

## What it is
Das ist das Regelwerk, damit jedes Projekt gesund bleibt, während es sich über die Zeit ändert (`docs/MAINTENANCE.md` in [[project-template]]). Es stützt sich auf vier bekannte Ideen: die Wartungsarten der Norm ISO/IEC/IEEE 14764 (korrektiv = Fehler beheben, adaptiv = an eine veränderte Umgebung anpassen, perfektiv = verbessern, präventiv = gegen künftige Probleme vorsorgen; siehe [Softwarewartung](https://en.wikipedia.org/wiki/Software_maintenance)); die [Lehmanschen Gesetze](https://en.wikipedia.org/wiki/Lehman%27s_laws_of_software_evolution) der Softwareevolution (Software, die benutzt wird, muss sich ständig ändern und wird komplexer, wenn man nichts dagegen tut); Fitnessfunktionen (automatische Prüfungen von Entwurfseigenschaften, siehe [[fitness-check]]); und DORA-Lieferkennzahlen (DevOps Research and Assessment), etwa wie oft und wie schnell Änderungen veröffentlicht werden ([dora.dev](https://dora.dev/)).

## What it does
Sie definiert technische Schulden: alles, was heute funktioniert, die nächste Änderung aber langsamer oder riskanter macht ([technische Schulden](https://en.wikipedia.org/wiki/Technical_debt)). Schulden werden zu einem GitHub Issue (einer verfolgten Aufgabe) mit dem Label `debt` und einer Priorität von P1 (am dringendsten) bis P3; neue Funktionsideen nutzen das Label `idea`. Etwa eine von fünf Arbeitssitzungen gilt Schulden oder Vorsorge: Drehten sich die letzten vier Sitzungen nur um Funktionen, sagt Claude das und schlägt das wichtigste Schulden-Issue vor, und Giovanni entscheidet.

## How it does it
Eine bei der Arbeit gefundene Einschränkung wird in derselben Sitzung zu einem Issue, und der Monats-Review prüft die Liste.

## Where it sits in the pipeline
Teil der Vorlage, in jedes Projekt kopiert.

## Who receives its output
Der [[monthly-architecture-review]] und jede Claude-Sitzung (über die CLAUDE.md des jeweiligen Projekts).
