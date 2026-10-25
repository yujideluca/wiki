---
id: skill-consulta-clinica
lang: pt-BR
source_hash: 1313a859947a
title: Skill: consulta-clinica (respostas clínicas)
---

## What it is
A skill "consulta-clinica" dá respostas clínicas rápidas e cálculos de dose para o trabalho do Giovanni em emergência e atendimento pré-hospitalar. É escrita em português. Sua descrição diz: respostas clínicas rápidas e cálculos de dose: conduta, dose, diluição, infusão, escores, calculadoras, interações e suplementos; não serve para analisar artigo ou estudo ([[skill-analise-artigo-cientifico]]). Nunca guarda dados de pacientes.

## What it does
Responde em um modelo fixo para que o número que o Giovanni vai usar esteja sempre em primeiro e a diretriz sempre seja nomeada com o ano. É uma skill de "domínio": é dona do formato de respostas clínicas e cálculos, remete à [[skill-analise-artigo-cientifico]] para artigos e pedidos de evidência aprofundada e à [[skill-bias-risk-triage]] só para a profundidade mínima de verificação, e respeita o idioma da mensagem e as flags de profundidade `!!`, `***` e `...`.

## How it does it
Um `SKILL.md` em `~/.claude/skills/consulta-clinica`; o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
Estudo e carreira do Giovanni, fora dos projetos de código.

## Who receives its output
O Giovanni, como apoio ao raciocínio clínico no trabalho.

## Steps
1. **Usar este modelo, sempre nesta ordem.** *Conduta* (a ação mais a dose ou resultado final em 1–2 linhas: o número que ele vai usar vem aqui); *Especialidade / diretriz* (a especialidade responsável e a diretriz da escola dessa especialidade, com edição e ano; conferir a vigente); *Dose* (fármaco, mg/kg ou mg → total em mg, via, intervalo, máximo); *Cálculo, conferido 2×* (fórmula → variáveis com unidade → a conta); *Evidência* (classe, nível ou certeza GRADE; GRADE = Grading of Recommendations Assessment, Development and Evaluation); *Brasil × Alemanha/Europa × EUA* (a diferença que muda a conduta, se houver); *Não verificado* (o que não foi conferido na fonte). Omitir só Dose e Cálculo quando não houver dose ou conta; Especialidade/diretriz (com ano) e Evidência são obrigatórias. Com `!!`: só Conduta + Dose + diretriz em até 5 linhas, mas o cálculo continua sendo conferido duas vezes.
2. **Fontes por especialidade.** Ressuscitação → AHA (American Heart Association) e ERC (European Resuscitation Council); cardiologia → AHA/ACC e ESC (European Society of Cardiology), SBC no Brasil; trauma pré-hospitalar → PHTLS (Prehospital Trauma Life Support); emergências clínicas pré-hospitalares → AMLS (Advanced Medical Life Support); asma → GINA (Global Initiative for Asthma); DPOC → GOLD; sepse → Surviving Sepsis Campaign; AVC → AHA/ASA e ESO; aorta (dissecção, aneurisma) → ESC 2024 e ACC/AHA 2022; pediatria → PALS (Pediatric Advanced Life Support) da AHA e ERC; clínica geral → Harrison 22ª ed. (2025) mais a diretriz mais recente.
3. **Doses e unidades.** Doses em mg ou mcg; sem concentração informada, não converter para mL; se converter, declarar a concentração usada.
4. **Cálculos e escores.** Escrever a fórmula ou regra (e qual variante, por exemplo a fórmula do QTc de Bazett versus Fridericia), montar a tabela de variáveis com unidades, fazer a conta em Python quando houver ferramenta e conferir a faixa (dose ≤ máxima; resultado dez vezes fora do habitual significa refazer).
5. **Suplementos e nutrição.** Dar o nível de evidência, a posologia e os valores nutricionais.
6. **Nunca inventar número.** O que não foi conferido vai em "Não verificado".
7. **Exemplo anotado.** Pergunta: "Adrenalina na PCR de criança de 18 kg?" Conduta: adrenalina 0,18 mg IV/IO o quanto antes, repetir a cada 3–5 minutos. Diretriz: ressuscitação pediátrica, AHA PALS 2025 e ERC 2025 (conferir a edição vigente). Dose: 0,01 mg/kg → 0,18 mg IV/IO a cada 3–5 minutos (máximo 1 mg por dose). Cálculo: 18 kg × 0,01 mg/kg = 0,18 mg; 0,18 ≤ 1 mg ✔ (concentração não informada, então mg e sem mL). Evidência: recomendação baseada em evidência limitada, observacional. Brasil × Europa × EUA: sem diferença relevante de dose.

## Notes

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

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
