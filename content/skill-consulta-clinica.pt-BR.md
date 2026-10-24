---
id: skill-consulta-clinica
lang: pt-BR
source_hash: 648ca398d1ed
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
