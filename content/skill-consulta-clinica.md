---
id: skill-consulta-clinica
title: Skill: consulta-clinica (clinical answers)
aliases: [consulta-clinica]
kind: skill
project: skills
status: active
location: home:.claude/skills/consulta-clinica
fed_by: []
feeds: []
sources: [home:.claude/skills/consulta-clinica/SKILL.md, home:.agents/skills/consulta-clinica/SKILL.md]
reviewed: 2026-10-25T14:46Z
---

## What it is
The skill "consulta-clinica" gives quick clinical answers and dose calculations for Giovanni's work in emergency and pre-hospital medicine. It is written in Portuguese. Its description says: quick clinical answers and dose calculations: conduct, dose, dilution, infusion, scores, calculators, interactions and supplements; not for appraising an article or study ([[skill-analise-artigo-cientifico]]). It never stores patient data.

## What it does
It answers in a fixed template so that the number Giovanni will use is always first, and always names the guideline with its year. It is a "domain" skill: it owns the format of clinical answers and calculations, defers to [[skill-analise-artigo-cientifico]] for articles and deep evidence requests and to [[skill-bias-risk-triage]] only for the minimum depth of verification, and honours the language of the message and the depth flags `!!`, `***` and `...`.

## How it does it
A `SKILL.md` in `~/.claude/skills/consulta-clinica`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Giovanni's study and career work, outside the code projects.

## Who receives its output
Giovanni, as support for clinical reasoning at work.

## Steps
1. **Use this template, always in this order.** *Conduct* (the action plus the dose or final result in 1–2 lines: the number he will use goes here); *Specialty / guideline* (the responsible specialty and the guideline of that specialty with edition and year; check the current one); *Dose* (drug, mg/kg or mg → total in mg, route, interval, maximum); *Calculation, checked twice* (formula → variables with units → the arithmetic); *Evidence* (class, level or GRADE certainty; GRADE = Grading of Recommendations Assessment, Development and Evaluation); *Brazil × Germany/Europe × USA* (any difference that changes the conduct); *Not verified* (what was not checked in the source). Omit only Dose and Calculation when there is no dose or arithmetic; Specialty/guideline (with year) and Evidence are mandatory. With `!!`: only Conduct + Dose + guideline in at most 5 lines, but the calculation is still double-checked.
2. **Sources by specialty.** Resuscitation → AHA (American Heart Association) and ERC (European Resuscitation Council); cardiology → AHA/ACC and ESC (European Society of Cardiology), SBC in Brazil; pre-hospital trauma → PHTLS (Prehospital Trauma Life Support); pre-hospital medical emergencies → AMLS (Advanced Medical Life Support); asthma → GINA (Global Initiative for Asthma); COPD → GOLD; sepsis → Surviving Sepsis Campaign; stroke → AHA/ASA and ESO; aorta (dissection, aneurysm) → ESC 2024 and ACC/AHA 2022; paediatrics → PALS (Pediatric Advanced Life Support) of the AHA, and ERC; general medicine → Harrison's, 22nd edition (2025), plus the most recent guideline.
3. **Doses and units.** Doses in mg or mcg; if no concentration is given, do not convert to mL; if converting, state the concentration used.
4. **Calculations and scores.** Write the formula or rule (and which variant, for example the QTc formula of Bazett versus Fridericia), build the table of variables with units, do the arithmetic in Python when a tool is available, and check the range (dose ≤ maximum; a result ten times outside the usual means redo it).
5. **Supplements and nutrition.** Give the level of evidence, the dosage and the nutritional values.
6. **Never invent a number.** Anything that was not checked goes under "Not verified".
7. **Annotated example.** Question: "Adrenaline in the cardiac arrest of a child of 18 kg?" Conduct: adrenaline 0.18 mg IV/IO as soon as possible, repeat every 3–5 minutes. Guideline: paediatric resuscitation, AHA PALS 2025 and ERC 2025 (check the current edition). Dose: 0.01 mg/kg → 0.18 mg IV/IO every 3–5 minutes (maximum 1 mg per dose). Calculation: 18 kg × 0.01 mg/kg = 0.18 mg; 0.18 ≤ 1 mg ✔ (no concentration given, so mg and no mL). Evidence: recommendation based on limited, observational evidence. Brazil × Europe × USA: no relevant difference in dose.

## Notes

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/consulta-clinica/SKILL.md`

```skill-source home:.claude/skills/consulta-clinica/SKILL.md 08fddc15e2ef4d1546cd0d986c0c5dcfb00045cc824e92f67615ee6a949d79b5
---
name: "consulta-clinica"
description: "Respostas clínicas rápidas e cálculos de dose para o Giovanni (médico de emergência/pré-hospitalar): conduta, dose, diluição, infusão, escores, calculadoras, interações e suplementos — não para análise de artigo ou estudo."
---

# Consulta clínica

Lineage: origin=gui; base=e84b0a76232ca638950f72dda47804287d84d56a

Interop: role = domain; owns = formato de respostas clínicas e de cálculo; defers to = analise-artigo-cientifico (artigo, estudo, "isso funciona?" com pedido de evidência aprofundada), bias-risk-triage (só profundidade mínima de verificação); honors = idioma da mensagem, flags !! *** ...

## Template (sempre nesta ordem)
**Conduta:** <ação + dose/resultado final em 1–2 linhas — o número que ele vai usar vem aqui>
**Especialidade / diretriz:** <especialidade responsável> — <diretriz da escola dessa especialidade, edição/ano; confira a vigente>
**Dose:** <fármaco> <mg/kg ou mg> → <total em mg> <via>, <intervalo>, máx <x>
**Cálculo (conferido 2×):** <fórmula → variáveis com unidade → conta>
**Evidência:** <classe/nível ou certeza GRADE>
**BR × DE/EU × EUA:** <diferença que muda a conduta, se houver>
**Não verificado:** <o que não foi conferido na fonte>

Omita só Dose/Cálculo quando não houver dose ou conta; Especialidade/diretriz (com ano) e Evidência são obrigatórias. `!!` → só Conduta + Dose + diretriz em ≤5 linhas, mas o cálculo continua sendo conferido.

## Regras
- Fontes por especialidade: ressuscitação → AHA/ERC; cardiologia → AHA/ACC, ESC (SBC no Brasil); trauma pré-hospitalar → PHTLS; emergências clínicas pré-hospitalares → AMLS; asma → GINA; DPOC → GOLD; sepse → Surviving Sepsis Campaign; AVC → AHA/ASA, ESO; aorta (dissecção, aneurisma) → ESC 2024 (doença arterial periférica e aórtica), ACC/AHA 2022; pediatria → AHA PALS, ERC; clínica geral → Harrison 22ª ed. (2025) + diretriz mais recente.
- Dose em mg/mcg; sem concentração informada, não converta para mL. Se converter, declare a concentração usada.
- Cálculos e escores: escreva a fórmula/regra (e qual variante, ex. QTc Bazett vs Fridericia), monte a tabela de variáveis com unidades, faça a conta em Python quando houver ferramenta, e cheque a faixa (dose ≤ máxima; resultado 10× fora do habitual = refazer).
- Suplementos/nutrição: nível de evidência, posologia e valores nutricionais.
- Nunca invente número; o que não foi conferido vai em "Não verificado".

## Exemplo anotado
Pergunta: "Adrenalina na PCR de criança de 18 kg?"
**Conduta:** adrenalina 0,18 mg IV/IO o quanto antes, repetir a cada 3–5 min.
**Especialidade / diretriz:** ressuscitação pediátrica — AHA PALS 2025 e ERC 2025 (conferir edição vigente).
**Dose:** 0,01 mg/kg → 0,18 mg IV/IO, a cada 3–5 min (máx 1 mg/dose).
**Cálculo (conferido 2×):** 18 kg × 0,01 mg/kg = 0,18 mg; 0,18 ≤ 1 mg ✔.
(Concentração não informada → dose em mg, sem mL.)
**Evidência:** recomendação baseada em evidência limitada (observacional).
**BR × DE/EU × EUA:** sem diferença relevante de dose.
```


#### Codex: `home:.agents/skills/consulta-clinica/SKILL.md`

```skill-source home:.agents/skills/consulta-clinica/SKILL.md 08fddc15e2ef4d1546cd0d986c0c5dcfb00045cc824e92f67615ee6a949d79b5
---
name: "consulta-clinica"
description: "Respostas clínicas rápidas e cálculos de dose para o Giovanni (médico de emergência/pré-hospitalar): conduta, dose, diluição, infusão, escores, calculadoras, interações e suplementos — não para análise de artigo ou estudo."
---

# Consulta clínica

Lineage: origin=gui; base=e84b0a76232ca638950f72dda47804287d84d56a

Interop: role = domain; owns = formato de respostas clínicas e de cálculo; defers to = analise-artigo-cientifico (artigo, estudo, "isso funciona?" com pedido de evidência aprofundada), bias-risk-triage (só profundidade mínima de verificação); honors = idioma da mensagem, flags !! *** ...

## Template (sempre nesta ordem)
**Conduta:** <ação + dose/resultado final em 1–2 linhas — o número que ele vai usar vem aqui>
**Especialidade / diretriz:** <especialidade responsável> — <diretriz da escola dessa especialidade, edição/ano; confira a vigente>
**Dose:** <fármaco> <mg/kg ou mg> → <total em mg> <via>, <intervalo>, máx <x>
**Cálculo (conferido 2×):** <fórmula → variáveis com unidade → conta>
**Evidência:** <classe/nível ou certeza GRADE>
**BR × DE/EU × EUA:** <diferença que muda a conduta, se houver>
**Não verificado:** <o que não foi conferido na fonte>

Omita só Dose/Cálculo quando não houver dose ou conta; Especialidade/diretriz (com ano) e Evidência são obrigatórias. `!!` → só Conduta + Dose + diretriz em ≤5 linhas, mas o cálculo continua sendo conferido.

## Regras
- Fontes por especialidade: ressuscitação → AHA/ERC; cardiologia → AHA/ACC, ESC (SBC no Brasil); trauma pré-hospitalar → PHTLS; emergências clínicas pré-hospitalares → AMLS; asma → GINA; DPOC → GOLD; sepse → Surviving Sepsis Campaign; AVC → AHA/ASA, ESO; aorta (dissecção, aneurisma) → ESC 2024 (doença arterial periférica e aórtica), ACC/AHA 2022; pediatria → AHA PALS, ERC; clínica geral → Harrison 22ª ed. (2025) + diretriz mais recente.
- Dose em mg/mcg; sem concentração informada, não converta para mL. Se converter, declare a concentração usada.
- Cálculos e escores: escreva a fórmula/regra (e qual variante, ex. QTc Bazett vs Fridericia), monte a tabela de variáveis com unidades, faça a conta em Python quando houver ferramenta, e cheque a faixa (dose ≤ máxima; resultado 10× fora do habitual = refazer).
- Suplementos/nutrição: nível de evidência, posologia e valores nutricionais.
- Nunca invente número; o que não foi conferido vai em "Não verificado".

## Exemplo anotado
Pergunta: "Adrenalina na PCR de criança de 18 kg?"
**Conduta:** adrenalina 0,18 mg IV/IO o quanto antes, repetir a cada 3–5 min.
**Especialidade / diretriz:** ressuscitação pediátrica — AHA PALS 2025 e ERC 2025 (conferir edição vigente).
**Dose:** 0,01 mg/kg → 0,18 mg IV/IO, a cada 3–5 min (máx 1 mg/dose).
**Cálculo (conferido 2×):** 18 kg × 0,01 mg/kg = 0,18 mg; 0,18 ≤ 1 mg ✔.
(Concentração não informada → dose em mg, sem mL.)
**Evidência:** recomendação baseada em evidência limitada (observacional).
**BR × DE/EU × EUA:** sem diferença relevante de dose.
```
