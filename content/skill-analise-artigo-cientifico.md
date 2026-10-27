---
id: skill-analise-artigo-cientifico
title: Skill: analise-artigo-cientifico (article appraisal)
aliases: [analise-artigo-cientifico]
kind: skill
project: skills
status: active
location: home:.claude/skills/analise-artigo-cientifico
fed_by: []
feeds: []
sources: [home:.claude/skills/analise-artigo-cientifico/SKILL.md, home:.agents/skills/analise-artigo-cientifico/SKILL.md]
reviewed: 2026-10-25T20:41Z
---

## What it is
The skill "analise-artigo-cientifico" is critical appraisal of scientific articles and of evidence-based clinical questions for Giovanni, a physician. It is written in Portuguese. Its description says: use it whenever Giovanni sends an article, PDF, DOI (the permanent identifier of a paper), PMID (the PubMed number of a paper) or study link, asks "analyse this study", asks whether a treatment, therapy or test "works", or asks for the level of evidence, GRADE (Grading of Recommendations Assessment, Development and Evaluation, a method to rate how certain the evidence is, [GRADE](https://www.gradeworkinggroup.org/)), a comparison of guidelines or a study summary, even without the words "critical analysis".

## Flow
trigger t1: Giovanni sends an article, PDF, DOI, PMID or link, or asks whether a treatment works | [[giovanni]]
step s1: Calibrates the depth: his flags win, otherwise the size of the question
decide d1: A quick question or a full article?
step s2: Short mode: verdict, small table, provisional GRADE, regional divergence, practical conduct
step s3: Reads the full text and verifies the source, including retractions
step s4: Never fills in missing data; follows the structure of a single-article analysis
step s5: Applies GRADE to the body of evidence, per outcome
step s6: Searches and compares guidelines: Brazil, Germany and Europe, USA
step s7: Keeps the source and the reasoning apart
product p1: A short verdict with its sources
product p2: A critical analysis: level of evidence, GRADE certainty, guideline comparison

t1 -> s1
s1 -> d1
d1 -quick-> s2
d1 -full-> s3
s2 -> p1
s3 -> s4
s4 -> s5
s5 -> s6
s6 -> s7
s7 -> p2

## What it does
It produces a critical reading that Giovanni can use in practice and train as reasoning, without inventing data: level of evidence, certainty by GRADE, comparison of guidelines (Brazil, Germany and Europe, USA), study summary. It is for postgraduate level, didactic, with mechanisms and effect sizes. Doses, dilutions and calculators are handled by [[skill-consulta-clinica]]; this skill handles articles, "does this work?" and the level of evidence.

## How it does it
A `SKILL.md` in `~/.claude/skills/analise-artigo-cientifico` (with tool details in `references/ferramentas.md`); Claude loads it when a request matches its description. If [[skill-bias-risk-triage]] also loads, it only sets the minimum depth of verification; the structure and format are this skill's.

## Where it sits in the pipeline
Giovanni's study and career work, outside the code projects.

## Who receives its output
Giovanni.

## Steps
1. **Calibrate depth.** Giovanni's flags win: `!!` → a direct verdict in at most 5 lines, one main source with year and the GRADE certainty in one line (offer the full analysis); `***` → the complete protocol below at doctoral level; `...` → the article structure of step 4. A quick or vague question ("is this study any good?") → short mode of about 300–600 words: the study assumed (if not said), a verdict in 1–2 sentences, a small table with relative effect, absolute difference and confidence interval of the main outcomes, provisional GRADE certainty per outcome, divergence between Brazil, Europe and the USA in 2–3 lines, the practical conduct, and sources; offer the full analysis instead of doing it. A submitted article, a request for depth, or contested evidence → the full protocol. Reply in Giovanni's language.
2. **Get and verify the source before analysing.** Read the full text when possible; if only the abstract is available, say so explicitly, because an abstract does not allow a safe judgement of risk of bias. Integrity check (record the result, even "nothing found"): retractions and expressions of concern (notes on PubMed and the journal's site, the Retraction Watch database); the journal (real indexing in MEDLINE/PubMed or DOAJ; signs of a predatory or hijacked journal; the "Think. Check. Submit." criteria); prospective registration (ClinicalTrials.gov, ReBEC, DRKS, WHO ICTRP: is the registered primary outcome the published one? switching outcomes is a red flag); conflicts of interest, funding and the sponsor's role; plausibility (an effect too large for the intervention, a tiny sample, early stopping for benefit, p-values clustered just below 0.05, "too beautiful" data).
3. **Never fill in missing data.** A number absent from the source is written "not reported". Tag each number: [primary] (full text or abstract of the article), [sec] (a third-party summary) or [calc] (calculated from published data). If two secondary sources disagree, show both or omit and say why. Guideline grades not read in the source are marked "not verified". If the full text will not open, say so at the start: the bias analysis is provisional.
4. **Structure of a single-article analysis** (concise bullets, acronyms spelled out at first use): (1) reference: authors, journal, year, DOI/PMID, design, registration; (2) motivation: the gap and the PICO (population, intervention, comparator, outcome) made explicit; (3) methods: design, allocation and masking, sample size and power calculation, the primary outcome (objective versus subjective or patient-reported), analysis (intention to treat versus per protocol), follow-up; (4) results: the effect on the primary outcome with its confidence interval, always translated into absolute effect (absolute risk reduction, number needed to treat or harm) when data exist; secondary outcomes and safety separately; separate objective outcomes (mortality, adjudicated events) from subjective ones (pain, quality of life) and say whether masking protects the subjective ones; (5) statistical strength: precision of the confidence interval against a clinically relevant threshold, multiplicity, fragility when applicable; (6) risk of bias with the right tool: RoB 2 for randomised trials, ROBINS-I (v2) for non-randomised intervention studies, QUADAS-2 for diagnostic accuracy, AMSTAR 2 for systematic reviews, PROBAST for prediction models; (7) methodological strengths and weaknesses; (8) certainty of evidence by GRADE for the main outcome; (9) context: what current guidelines say and whether this study changes anything; (10) a practical conclusion in 2–3 lines with the degree of uncertainty; (11) sources with year and link or DOI.
5. **Apply GRADE to the body of evidence, per outcome.** Start high for randomised trials and low for observational studies (or high if assessed with ROBINS-I, which already includes confounding). Downgrade 1 or 2 levels each for risk of bias, inconsistency, indirectness, imprecision and publication bias. Judge imprecision by the confidence interval relative to defined thresholds: if the interval crosses the threshold of importance, downgrade; if not but the effect is large with a small sample, check the optimal information size. Upgrade (mainly observational) for a large effect, a dose–response gradient, or residual confounding that would reduce the observed effect. State the reason for every downgrade and express the result as "high, moderate, low or very low certainty that the true effect is above or below [threshold]". For a single study, say that GRADE applies to the body of evidence and give a provisional assessment.
6. **Search and guidelines.** Hierarchy: current guidelines and systematic reviews, then randomised trials, then observational studies; prefer the newest source and give its year. Search in English and also in Portuguese and German when relevant sources exist (for example AWMF guidelines, the Deutsches Ärzteblatt, Brazilian societies, SciELO). When recommendations diverge between Brazil (Ministry of Health, CONITEC, societies), Germany and Europe (AWMF, ESC = European Society of Cardiology, ERC = European Resuscitation Council, EMA) and the USA (AHA = American Heart Association, ACR, USPSTF, FDA), show the divergence and its likely reason. News must be confirmed in a reliable outlet and in the primary source.
7. **Keep source and reasoning apart.** Mark what is data from the source and what is Claude's inference ("Interpretation:"). If the conclusion looks strange, reassess broadly before answering.
8. **Study summaries** (when Giovanni asks for a summary, not a full analysis): short bullets, acronyms spelled out, absolute effect with confidence interval and certainty, and one line for the main limitation.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/analise-artigo-cientifico/SKILL.md`

```skill-source home:.claude/skills/analise-artigo-cientifico/SKILL.md e2bf1d6b1361e036d652c9a24019e6b5c3a7673d203bc2aafabdeaa317fc415f
---
name: "analise-artigo-cientifico"
description: "Análise crítica de artigos científicos e de perguntas clínicas baseadas em evidência para o Giovanni (médico). Use sempre que ele enviar um artigo, PDF, DOI, PMID ou link de estudo, pedir \"analise este estudo\", perguntar se uma conduta/terapia/exame \"funciona\", pedir nível de evidência, GRADE, comparação de diretrizes, ou resumo de estudo — mesmo que não diga \"análise crítica\"."
---

# Análise de artigo científico / pergunta clínica

Lineage: origin=gui; base=bacc7b719b48640060f5b235d5c5cb43d9ea2c2d

Objetivo: entregar uma leitura crítica que ele possa usar na prática e treinar como raciocínio, sem inventar dados. Ele é médico (emergência/pré-hospitalar, futuro radiologista); escreva em nível de pós-graduação, didático, com mecanismos e tamanhos de efeito.

## 1. Calibrar profundidade
- **Flags dele têm prioridade** sobre a calibração automática abaixo: `!!` → veredito direto em até 5 linhas, 1 fonte principal com ano e a certeza GRADE em uma linha (ofereça a análise completa); `***` → protocolo completo das seções 2–6, nível doutorado; `...` → estrutura de artigo da seção 3 (motivação, métodos, resultados, força estatística, pontos fortes/fracos, sinais vermelhos).
- Pergunta rápida ou vaga (ex.: "esse estudo presta?") → modo curto, ~300–600 palavras sem contar a lista de fontes: (a) qual estudo assumiu, se não foi dito, em uma linha; (b) veredito em 1–2 frases; (c) tabela pequena com efeito relativo, diferença absoluta e intervalo de confiança dos desfechos principais; (d) certeza GRADE provisória por desfecho em uma linha cada; (e) divergência Brasil/Europa/EUA em 2–3 linhas; (f) conduta prática; (g) fontes. Ofereça a análise completa no final em vez de fazê-la.
- Artigo enviado, pedido de profundidade ou evidência contestada → protocolo completo abaixo.
- Responda no idioma em que ele escreveu.
- Se a skill bias-risk-triage também carregar, ela só define a profundidade mínima de verificação; a estrutura e o formato são os desta skill.
- Dose, diluição, infusão, escores/calculadoras e conduta prática sem pedido de avaliação de evidência → use consulta-clinica; esta skill cuida de artigos, "isso funciona?" e nível de evidência.

## 2. Obter e verificar a fonte (antes de analisar)
1. Leia o texto completo quando possível (PDF enviado, PubMed/PMC). Se só houver resumo, diga isso explicitamente: análise de resumo não permite julgar risco de viés com segurança.
2. Checagem de integridade (registre o resultado, mesmo que "nada encontrado"):
   - Retratação / expressão de preocupação: notas no PubMed ("Retracted Publication", "Retraction in", "Expression of Concern") e no site da revista; base Retraction Watch (integrada ao Crossref).
   - Revista: indexação real (MEDLINE/PubMed, DOAJ para acesso aberto), sinais de revista predatória ou sequestrada (prazos de revisão irreais, taxa agressiva, editor fora da área). Critérios: Think. Check. Submit.
   - Registro prospectivo (ClinicalTrials.gov, ReBEC, DRKS, WHO ICTRP): desfecho primário registrado = publicado? Troca de desfecho é sinal vermelho.
   - Conflitos de interesse e financiamento; papel do patrocinador na análise.
   - Plausibilidade: efeito grande demais para a intervenção, amostra muito pequena, interrupção precoce por benefício, p-valores agrupados logo abaixo de 0,05, dados "bonitos demais".
3. Nunca complete dados ausentes. Se um número não está na fonte, escreva "não reportado".
4. Rastreabilidade de números: marque [primária] (texto completo/resumo do artigo), [sec] (resumo de terceiros: blogs de journal club, revisões) ou [calc] (calculado por você a partir de dados publicados). Se duas fontes secundárias divergirem, não escolha uma: mostre as duas ou omita e diga por quê. Graus de recomendação de diretrizes que você não leu na fonte vão como "não verificado".
5. Se o texto completo não abrir, diga logo no início que a análise de risco de viés é provisória.

## 3. Estrutura da análise (artigo único)
Use tópicos concisos, siglas escritas por extenso na primeira vez (ex.: "razão de risco (hazard ratio, HR)").

1. **Referência**: autores, revista, ano, DOI/PMID, desenho, registro.
2. **Motivação**: lacuna que o estudo pretende responder; PICO (população, intervenção, comparador, desfecho) explícito.
3. **Métodos**: desenho, alocação/mascaramento, tamanho amostral e cálculo de poder, desfecho primário (objetivo vs subjetivo/relatado pelo paciente), análise (intenção de tratar vs por protocolo), seguimento.
4. **Resultados**: efeito no desfecho primário com intervalo de confiança; sempre traduzir para efeito absoluto (redução absoluta de risco, número necessário para tratar/causar dano) quando houver dados; secundários e segurança separados. Separe desfechos objetivos (mortalidade, eventos adjudicados) de subjetivos (dor, qualidade de vida) e diga se o mascaramento protege os subjetivos.
5. **Força estatística**: precisão do intervalo de confiança frente a um limiar clinicamente relevante; multiplicidade; fragilidade quando aplicável; análise bayesiana/sensibilidade se houver.
6. **Risco de viés** com a ferramenta certa (ver references/ferramentas.md): RoB 2 para ensaio randomizado, ROBINS-I (v2) para estudo não randomizado de intervenção, QUADAS-2 para acurácia diagnóstica, AMSTAR 2 para revisão sistemática, PROBAST para modelos de predição.
7. **Pontos fortes e fracos** metodológicos e de execução.
8. **Certeza da evidência (GRADE)** para o desfecho principal — ver seção 4.
9. **Contexto**: o que diretrizes atuais dizem (ver seção 5) e se este estudo muda algo.
10. **Conclusão prática** em 2–3 linhas, com o grau de incerteza.
11. **Fontes**: lista com ano e link/DOI.

## 4. GRADE (aplicar ao corpo de evidência por desfecho)
- Ponto de partida: ensaios randomizados = alta; observacionais = baixa (ou alta se avaliados com ROBINS-I, que já incorpora confusão).
- Rebaixar (1 ou 2 níveis cada): risco de viés, inconsistência, evidência indireta, imprecisão, viés de publicação.
- Imprecisão: use a abordagem por intervalo de confiança em relação a limiares definidos (GRADE 34, 2022; GRADE 41, 2025 — "limiares escolhidos" em vez de categorias de contextualização). Se o intervalo cruza o limiar de importância, rebaixe; se não cruza mas o efeito é grande com amostra pequena, cheque o tamanho ótimo de informação.
- Elevar (principalmente observacionais): efeito grande, gradiente dose-resposta, confundimento residual que reduziria o efeito observado.
- Diga o motivo de cada rebaixamento. Expresse o resultado como "certeza alta/moderada/baixa/muito baixa de que o efeito verdadeiro está acima/abaixo de [limiar]".
- Para um único estudo, diga que GRADE se aplica ao corpo de evidência e faça uma avaliação provisória.

## 5. Busca e diretrizes
- Hierarquia: diretrizes atuais e revisões sistemáticas → ensaios randomizados → observacionais. Prefira a fonte mais recente; informe o ano.
- Busque em inglês e também em português e alemão quando houver fontes relevantes (ex.: diretrizes AWMF, Deutsches Ärzteblatt, sociedades brasileiras, SciELO).
- Quando recomendações divergirem entre Brasil (Ministério da Saúde, CONITEC, sociedades), Alemanha/Europa (AWMF, ESC, ERC, EMA) e EUA (AHA, ACR, USPSTF, FDA), mostre a divergência e o motivo provável.
- Notícias: confirme em veículo confiável e na fonte primária antes de relatar.

## 6. Separar fonte de raciocínio
Marque o que é dado da fonte e o que é sua inferência ("Interpretação:"). Se a conclusão parecer estranha, reavalie de forma ampla antes de responder.

## 7. Formato para resumos de estudo
Quando ele pedir resumo (não análise completa): tópicos curtos, siglas por extenso, efeito absoluto + intervalo de confiança + certeza, uma linha de limitação principal.
```


#### Codex: `home:.agents/skills/analise-artigo-cientifico/SKILL.md`

````skill-source home:.agents/skills/analise-artigo-cientifico/SKILL.md d7e31843bedca642047d4f4f94a5b9efa8c3b10068445b956ed7f7eb44f7daac
---
name: "analise-artigo-cientifico"
description: "Análise crítica de artigos científicos e de perguntas clínicas baseadas em evidência para o Giovanni (médico). Use sempre que ele enviar um artigo, PDF, DOI, PMID ou link de estudo, pedir \"analise este estudo\", perguntar se uma conduta/terapia/exame \"funciona\", pedir nível de evidência, GRADE, comparação de diretrizes, ou resumo de estudo — mesmo que não diga \"análise crítica\"."
---

# Análise de artigo científico / pergunta clínica

Lineage: origin=claude; base=sha256:f50705aa5fe5e237660ff3e4ec96a73c3518bc8ec0f9151d77e1ea5097eccc64; adaptation=codex

Objetivo: entregar uma leitura crítica que ele possa usar na prática e treinar como raciocínio, sem inventar dados. Ele é médico (emergência/pré-hospitalar, futuro radiologista); escreva em nível de pós-graduação, didático, com mecanismos e tamanhos de efeito.

## 1. Calibrar profundidade
- **Flags dele têm prioridade** sobre a calibração automática abaixo: `!!` → veredito direto em até 5 linhas, 1 fonte principal com ano e a certeza GRADE em uma linha (ofereça a análise completa); `***` → protocolo completo das seções 2–6, nível doutorado; `...` → estrutura de artigo da seção 3 (motivação, métodos, resultados, força estatística, pontos fortes/fracos, sinais vermelhos).
- Pergunta rápida ou vaga (ex.: "esse estudo presta?") → modo curto, ~300–600 palavras sem contar a lista de fontes: (a) qual estudo assumiu, se não foi dito, em uma linha; (b) veredito em 1–2 frases; (c) tabela pequena com efeito relativo, diferença absoluta e intervalo de confiança dos desfechos principais; (d) certeza GRADE provisória por desfecho em uma linha cada; (e) divergência Brasil/Europa/EUA em 2–3 linhas; (f) conduta prática; (g) fontes. Ofereça a análise completa no final em vez de fazê-la.
- Artigo enviado, pedido de profundidade ou evidência contestada → protocolo completo abaixo.
- Responda no idioma em que ele escreveu.
- Se a skill bias-risk-triage também carregar, ela só define a profundidade mínima de verificação; a estrutura e o formato são os desta skill.
- Dose, diluição, infusão, escores/calculadoras e conduta prática sem pedido de avaliação de evidência → use consulta-clinica; esta skill cuida de artigos, "isso funciona?" e nível de evidência.

## 2. Obter e verificar a fonte (antes de analisar)
1. Leia o texto completo quando possível (PDF enviado, PubMed/PMC). Se só houver resumo, diga isso explicitamente: análise de resumo não permite julgar risco de viés com segurança.
2. Checagem de integridade (registre o resultado, mesmo que "nada encontrado"):
   - Retratação / expressão de preocupação: notas no PubMed ("Retracted Publication", "Retraction in", "Expression of Concern") e no site da revista; base Retraction Watch (integrada ao Crossref).
   - Revista: indexação real (MEDLINE/PubMed, DOAJ para acesso aberto), sinais de revista predatória ou sequestrada (prazos de revisão irreais, taxa agressiva, editor fora da área). Critérios: Think. Check. Submit.
   - Registro prospectivo (ClinicalTrials.gov, ReBEC, DRKS, WHO ICTRP): desfecho primário registrado = publicado? Troca de desfecho é sinal vermelho.
   - Conflitos de interesse e financiamento; papel do patrocinador na análise.
   - Plausibilidade: efeito grande demais para a intervenção, amostra muito pequena, interrupção precoce por benefício, p-valores agrupados logo abaixo de 0,05, dados "bonitos demais".
3. Nunca complete dados ausentes. Se um número não está na fonte, escreva "não reportado".
4. Rastreabilidade de números: marque [primária] (texto completo/resumo do artigo), [sec] (resumo de terceiros: blogs de journal club, revisões) ou [calc] (calculado por você a partir de dados publicados). Se duas fontes secundárias divergirem, não escolha uma: mostre as duas ou omita e diga por quê. Graus de recomendação de diretrizes que você não leu na fonte vão como "não verificado".
5. Se o texto completo não abrir, diga logo no início que a análise de risco de viés é provisória.

## 3. Estrutura da análise (artigo único)
Use tópicos concisos, siglas escritas por extenso na primeira vez (ex.: "razão de risco (hazard ratio, HR)").

1. **Referência**: autores, revista, ano, DOI/PMID, desenho, registro.
2. **Motivação**: lacuna que o estudo pretende responder; PICO (população, intervenção, comparador, desfecho) explícito.
3. **Métodos**: desenho, alocação/mascaramento, tamanho amostral e cálculo de poder, desfecho primário (objetivo vs subjetivo/relatado pelo paciente), análise (intenção de tratar vs por protocolo), seguimento.
4. **Resultados**: efeito no desfecho primário com intervalo de confiança; sempre traduzir para efeito absoluto (redução absoluta de risco, número necessário para tratar/causar dano) quando houver dados; secundários e segurança separados. Separe desfechos objetivos (mortalidade, eventos adjudicados) de subjetivos (dor, qualidade de vida) e diga se o mascaramento protege os subjetivos.
5. **Força estatística**: precisão do intervalo de confiança frente a um limiar clinicamente relevante; multiplicidade; fragilidade quando aplicável; análise bayesiana/sensibilidade se houver.
6. **Risco de viés** com a ferramenta certa (ver references/ferramentas.md): RoB 2 para ensaio randomizado, ROBINS-I (v2) para estudo não randomizado de intervenção, QUADAS-2 para acurácia diagnóstica, AMSTAR 2 para revisão sistemática, PROBAST para modelos de predição.
7. **Pontos fortes e fracos** metodológicos e de execução.
8. **Certeza da evidência (GRADE)** para o desfecho principal — ver seção 4.
9. **Contexto**: o que diretrizes atuais dizem (ver seção 5) e se este estudo muda algo.
10. **Conclusão prática** em 2–3 linhas, com o grau de incerteza.
11. **Fontes**: lista com ano e link/DOI.

## 4. GRADE (aplicar ao corpo de evidência por desfecho)
- Ponto de partida: ensaios randomizados = alta; observacionais = baixa (ou alta se avaliados com ROBINS-I, que já incorpora confusão).
- Rebaixar (1 ou 2 níveis cada): risco de viés, inconsistência, evidência indireta, imprecisão, viés de publicação.
- Imprecisão: use a abordagem por intervalo de confiança em relação a limiares definidos (GRADE 34, 2022; GRADE 41, 2025 — "limiares escolhidos" em vez de categorias de contextualização). Se o intervalo cruza o limiar de importância, rebaixe; se não cruza mas o efeito é grande com amostra pequena, cheque o tamanho ótimo de informação.
- Elevar (principalmente observacionais): efeito grande, gradiente dose-resposta, confundimento residual que reduziria o efeito observado.
- Diga o motivo de cada rebaixamento. Expresse o resultado como "certeza alta/moderada/baixa/muito baixa de que o efeito verdadeiro está acima/abaixo de [limiar]".
- Para um único estudo, diga que GRADE se aplica ao corpo de evidência e faça uma avaliação provisória.

## 5. Busca e diretrizes
- Hierarquia: diretrizes atuais e revisões sistemáticas → ensaios randomizados → observacionais. Prefira a fonte mais recente; informe o ano.
- Busque em inglês e também em português e alemão quando houver fontes relevantes (ex.: diretrizes AWMF, Deutsches Ärzteblatt, sociedades brasileiras, SciELO).
- Quando recomendações divergirem entre Brasil (Ministério da Saúde, CONITEC, sociedades), Alemanha/Europa (AWMF, ESC, ERC, EMA) e EUA (AHA, ACR, USPSTF, FDA), mostre a divergência e o motivo provável.
- Notícias: confirme em veículo confiável e na fonte primária antes de relatar.

## 6. Separar fonte de raciocínio
Marque o que é dado da fonte e o que é sua inferência ("Interpretação:"). Se a conclusão parecer estranha, reavalie de forma ampla antes de responder.

## 7. Formato para resumos de estudo
Quando ele pedir resumo (não análise completa): tópicos curtos, siglas por extenso, efeito absoluto + intervalo de confiança + certeza, uma linha de limitação principal.

## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
