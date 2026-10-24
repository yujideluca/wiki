---
id: skill-consulta-clinica
lang: de
source_hash: 648ca398d1ed
title: Skill: consulta-clinica (klinische Antworten)
---

## What it is
Die Skill „consulta-clinica“ gibt schnelle klinische Antworten und Dosisberechnungen für Giovannis Arbeit in der Notfall- und präklinischen Medizin. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: schnelle klinische Antworten und Dosisberechnungen: Vorgehen, Dosis, Verdünnung, Infusion, Scores, Rechner, Wechselwirkungen und Nahrungsergänzungsmittel; nicht für die Bewertung eines Artikels oder einer Studie ([[skill-analise-artigo-cientifico]]). Sie speichert nie Patientendaten.

## What it does
Sie antwortet in einer festen Vorlage, damit die Zahl, die Giovanni benutzen wird, immer zuerst steht und immer die Leitlinie mit Jahr genannt wird. Sie ist eine „Domänen“-Skill: Sie besitzt das Format klinischer Antworten und Berechnungen, verweist für Artikel und tiefe Evidenzfragen auf [[skill-analise-artigo-cientifico]] und auf [[skill-bias-risk-triage]] nur für die Mindesttiefe der Prüfung und beachtet die Sprache der Nachricht und die Tiefe-Flags `!!`, `***` und `...`.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/consulta-clinica`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Giovannis Studium und Berufsweg, außerhalb der Code-Projekte.

## Who receives its output
Giovanni, als Unterstützung des klinischen Denkens bei der Arbeit.

## Steps
1. **Diese Vorlage verwenden, immer in dieser Reihenfolge.** *Vorgehen* (die Handlung plus Dosis oder Endergebnis in 1–2 Zeilen: Die Zahl, die er benutzt, steht hier); *Fachgebiet / Leitlinie* (das zuständige Fachgebiet und die Leitlinie dieses Fachgebiets mit Auflage und Jahr; die aktuelle prüfen); *Dosis* (Wirkstoff, mg/kg oder mg → Gesamtmenge in mg, Applikationsweg, Intervall, Maximum); *Berechnung, zweimal geprüft* (Formel → Variablen mit Einheiten → die Rechnung); *Evidenz* (Klasse, Stufe oder GRADE-Sicherheit; GRADE = Grading of Recommendations Assessment, Development and Evaluation); *Brasilien × Deutschland/Europa × USA* (jeder Unterschied, der das Vorgehen ändert); *Nicht verifiziert* (was nicht in der Quelle geprüft wurde). Nur Dosis und Berechnung entfallen, wenn es keine Dosis oder Rechnung gibt; Fachgebiet/Leitlinie (mit Jahr) und Evidenz sind Pflicht. Mit `!!`: nur Vorgehen + Dosis + Leitlinie in höchstens 5 Zeilen, aber die Rechnung wird weiter doppelt geprüft.
2. **Quellen nach Fachgebiet.** Reanimation → AHA (American Heart Association) und ERC (European Resuscitation Council); Kardiologie → AHA/ACC und ESC (European Society of Cardiology), in Brasilien SBC; präklinisches Trauma → PHTLS (Prehospital Trauma Life Support); präklinische internistische Notfälle → AMLS (Advanced Medical Life Support); Asthma → GINA (Global Initiative for Asthma); COPD → GOLD; Sepsis → Surviving Sepsis Campaign; Schlaganfall → AHA/ASA und ESO; Aorta (Dissektion, Aneurysma) → ESC 2024 und ACC/AHA 2022; Pädiatrie → PALS (Pediatric Advanced Life Support) der AHA und ERC; Allgemeinmedizin → Harrison, 22. Auflage (2025), plus die jüngste Leitlinie.
3. **Dosen und Einheiten.** Dosen in mg oder mcg; ist keine Konzentration angegeben, nicht in mL umrechnen; wird umgerechnet, die verwendete Konzentration nennen.
4. **Berechnungen und Scores.** Die Formel oder Regel hinschreiben (und welche Variante, zum Beispiel die QTc-Formel nach Bazett oder Fridericia), die Tabelle der Variablen mit Einheiten aufbauen, die Rechnung mit Python machen, wenn ein Werkzeug da ist, und den Bereich prüfen (Dosis ≤ Maximum; ein um den Faktor zehn unübliches Ergebnis heißt neu rechnen).
5. **Nahrungsergänzung und Ernährung.** Evidenzniveau, Dosierung und Nährwerte angeben.
6. **Nie eine Zahl erfinden.** Alles, was nicht geprüft wurde, kommt unter „Nicht verifiziert“.
7. **Kommentiertes Beispiel.** Frage: „Adrenalin bei der Reanimation eines Kindes von 18 kg?“ Vorgehen: Adrenalin 0,18 mg i.v./i.o. so früh wie möglich, alle 3–5 Minuten wiederholen. Leitlinie: pädiatrische Reanimation, AHA PALS 2025 und ERC 2025 (aktuelle Auflage prüfen). Dosis: 0,01 mg/kg → 0,18 mg i.v./i.o. alle 3–5 Minuten (Maximum 1 mg pro Dosis). Berechnung: 18 kg × 0,01 mg/kg = 0,18 mg; 0,18 ≤ 1 mg ✔ (keine Konzentration genannt, also mg und kein mL). Evidenz: Empfehlung auf Grundlage begrenzter, beobachtender Evidenz. Brasilien × Europa × USA: kein relevanter Dosisunterschied.
