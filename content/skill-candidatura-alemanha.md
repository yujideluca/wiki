---
id: skill-candidatura-alemanha
title: Skill: candidatura-alemanha (applications in Germany)
aliases: [candidatura-alemanha]
kind: skill
project: skills
status: active
location: home:.claude/skills/candidatura-alemanha
fed_by: []
feeds: []
sources: [home:.claude/skills/candidatura-alemanha/SKILL.md, home:.agents/skills/candidatura-alemanha/SKILL.md]
reviewed: 2026-10-25T20:41Z
---

## What it is
The skill "candidatura-alemanha" supports Giovanni's applications for medical posts in Germany (specialist training in radiology, a Hospitation = a trial visit at a hospital, and a position as Assistenzarzt = resident doctor) and the recognition process (Approbation, the licence to practise medicine, and Anerkennung, recognition of qualifications) for a doctor trained outside the EU. It is written in Portuguese. Its description says: use it whenever he asks for a Lebenslauf (CV), Anschreiben (cover letter), Bewerbung (application), an e-mail to a hospital or chief physician, a Bestätigung über beabsichtigte Beschäftigung (confirmation of intended employment), a document checklist, the choice of federal state, the Kenntnisprüfung (knowledge exam), the FSP (Fachsprachprüfung, the medical-language exam) or questions about deadlines and recognition authorities.

## What it does
It prepares CVs and letters in German, document checklists tailored to the state, and advice on states and hospitals. Giovanni's profile it works from: a Brazilian doctor with experience in pre-hospital emergency care and airport medicine, aiming at radiology training, with Goethe B2 in November 2026, then Approbation and a move planned for the first half of 2027. The skill is of the "domain" kind: it owns the master CV, the cover letters and the Approbation checklist; it defers to [[skill-alemao-goethe-fsp]] for correcting texts Giovanni wrote himself; and it honours the language of the message (documents for hospitals are in German) and the depth flags `!!`, `***` and `...`.

## How it does it
A `SKILL.md` in `~/.claude/skills/candidatura-alemanha` (with dated legal facts in `references/approbation.md`); Claude loads it when a request matches its description.

## Where it sits in the pipeline
Giovanni's study and career work, outside the code projects.

## Who receives its output
Giovanni (drafts to send personally; nothing is sent by Claude).

## Steps
1. **Legal rules: always check the date.** Before stating anything about deadlines, fees, validity of documents or procedure, reopen the official source of the state (the current form of the responsible authority) and write "consulted on DD/MM/YYYY" beside each source. Use the form for graduates from outside the EU: the general Approbation form has different rules (for example validity of 1 month versus 3 months). If a secondary source and the official one disagree, follow the official one and show the divergence. Highlighted fact: a law passed in 2026 (Bundestag 26 March, Bundesrat 8 May), expected to apply from 1 November 2026, makes the direct Kenntnisprüfung the standard for non-EU graduates and the document equivalence analysis optional, on request; the material requirements for Approbation do not change; this affects Giovanni's calendar. Language: general B2 plus C1 technical language (the FSP at the state medical chamber).
2. **Lebenslauf (the German standard for doctors).** Tabular, reverse chronological, periods in MM/YYYY without gaps (some authorities require a signed CV without gaps). Blocks: personal data (photo optional, not required by the anti-discrimination law) → professional experience → education → Approbation/recognition (honest status, such as "application planned after Goethe B2 (11/2026)" or "filed on …") → languages (CEFR level + certificate and date) → training and certificates → publications → IT/interests (short) → place, date, signature. Explain Brazilian institutions in brackets when not obvious. Never invent dates, posts, grades or certificates; mark [fill in] where data is missing.
3. **One master CV.** There is one master CV, `Lebenslauf_MASTER.md` (in the connected folder or the active project). A new fact goes into the master first, in the right place, plus a line in the final block `Änderungen` (`YYYY-MM-DD | what changed`). Versions are derived from the master and named `Lebenslauf_<destination>_<YYYY-MM-DD>`; never edit a version without updating the master. Fidelity: nothing that is not in the master enters a version, not even the profile summary (no new adjectives or invented interests); missing data → a visible [fill in]. Reverse chronology inside each block. By destination: an application for specialist or resident posts includes clinical experience, radiology and Hospitationen, languages, certificates and publication, and cuts school details (at most 2 pages); an Approbation/authority CV includes everything, without gaps (gaps over 3 months explained) and no marketing text; a Hospitation CV is one page with radiology, languages and availability. Basis: the single-source principle and the checklist of the Federal Employment Agency's application guide.
4. **Anschreiben / e-mail to the chief physician.** One page, about 250–350 words. Structure: reference (the vacancy or initiative, how the service was found) → why this hospital and radiology (specific: research lines, musculoskeletal imaging, modalities) → what Giovanni brings (emergency care, decision-making, trauma imaging) → status of Approbation and language with realistic dates → a concrete request (Hospitation, interview, confirmation of intended employment) → closing formula. Register: the formal "Sie" form, "Sehr geehrte/r Frau/Herr Prof. Dr. …", "Mit freundlichen Grüßen". Clear German at B2.1–B2.2 level (he prefers not to sound above his real level; the interview will reveal it). When he wrote the text himself, review it with the correction rule of [[skill-alemao-goethe-fsp]].
5. **Document checklist, made to measure for the state.** A numbered table like the official form with the columns: document | issuer | form (simple copy / certified / apostille / translation) | maximum validity | when to get it (3-month documents last) | status. Mark as inference whatever is not on the form (for example which Brazilian body issues it). End with "the next 3 steps", with dates relative to Goethe B2.
6. **Request for a confirmation of employment (Stellenzusage).** In Baden-Württemberg the employer's declaration corresponds to the form "Anlage 3" signed by the employer; it is mandatory only for a temporary permit to practise (Berufserlaubnis) or if another state requests it. When asking the chief physician: be courteous without pressure, attach or mention the form, offer an alternative (an informal letter of intent) and explain in one sentence what it is for.
7. **Vague requests** (for example "write an e-mail to radiology"): do not ask back if there is enough context. Choose the most likely goal from the history, state the assumption in the first line, deliver the finished e-mail and a short variant for the other plausible goal (first contact).
8. **Strategy.** When asked for an opinion on a state or hospital, compare reported processing time, language requirements, radiology vacancies and cost of living; make clear what is official data and what is inference; cite the source and date.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/candidatura-alemanha/SKILL.md`

```skill-source home:.claude/skills/candidatura-alemanha/SKILL.md f7aaf2906135d142f47757791a3f19151d096d2319ed3be349ec3d27e4e7e774
---
name: "candidatura-alemanha"
description: "Candidatura do Giovanni a vagas médicas na Alemanha (Facharztausbildung Radiologie, Hospitation, Assistenzarzt) e processo de Approbation/Anerkennung como médico formado fora da UE. Use sempre que ele pedir Lebenslauf, Anschreiben, Bewerbung, e-mail para hospital/Chefarzt, Bestätigung über beabsichtigte Beschäftigung, checklist de documentos, escolha de estado (Bundesland), Kenntnisprüfung, FSP ou dúvidas sobre prazos e órgãos de reconhecimento."
---

# Candidatura e Approbation na Alemanha

Lineage: origin=gui; base=bf3031f254f4779b8af5fa407e346952e87b71b9

Interop: role = domain; owns = CV mestre e versões, Anschreiben, checklist de Approbation; defers to = alemao-goethe-fsp (correção de textos que ele mesmo escreveu); honors = idioma da mensagem (documentos em alemão), flags !! *** ...

Perfil: médico brasileiro (UFPR), experiência em SAMU/pré-hospitalar e medicina aeroportuária; objetivo Facharztausbildung Radiologie (preferência Universitätsklinikum Heidelberg; Saarland e Baden-Württemberg como alternativas); Goethe B2 em novembro de 2026, depois Approbation; mudança no 1º semestre de 2027. Hospitation em Heidelberg em discussão para 2027.

Responda no idioma da mensagem dele. Documentos para hospitais: alemão.

## 1. Regras legais — sempre conferir a data
Fatos com data (ver references/approbation.md). Antes de afirmar algo sobre prazos, taxas, validade de documentos ou procedimento, reabra a fonte oficial do estado (formulário atual do Regierungspräsidium/LAS) e escreva "consultado em DD/MM/AAAA" ao lado de cada fonte. Use o formulário específico para formados fora da UE (nonEU): o formulário geral de Approbation tem regras diferentes (ex.: 1 mês vs 3 meses de validade). Quando fonte secundária e oficial divergirem, siga a oficial e mostre a divergência. Destaque:
- Lei aprovada (Bundestag 26.03.2026; Bundesrat 08.05.2026), vigência prevista em **01.11.2026**: para formados fora da UE, a **Kenntnisprüfung direta passa a ser o padrão**; a análise documental de equivalência fica opcional, a pedido, em ~4 semanas após o início do processo. Exigências materiais da Approbation não mudam. Isso afeta diretamente o calendário dele (pedido após o B2).
- Idioma: B2 geral + C1 Fachsprache (FSP na Ärztekammer do estado).

## 2. Lebenslauf (padrão alemão para médico)
- Tabelado, cronologia reversa, períodos MM/AAAA sem lacunas (algumas autoridades exigem CV assinado e sem lacunas; o de candidatura também deve ser sem lacunas não explicadas).
- Blocos: Persönliche Daten (foto opcional; pela AGG não é exigida) → Berufserfahrung → Ausbildung/Studium → Approbation/Anerkennung (status honesto: "Antrag auf Approbation geplant nach Goethe B2 (11/2026)" ou "beantragt am …") → Sprachkenntnisse (nível GER + certificado e data) → Fortbildungen/Zertifikate (ACLS, PHTLS etc.) → Publikationen (ex.: simulador de drenagem torácica, Rev Col Bras Cir 2019) → EDV/Interessen (curto) → Ort, Datum, Unterschrift.
- Explicar instituições brasileiras entre parênteses quando não forem óbvias (ex.: "SAMU – staatlicher präklinischer Rettungsdienst").
- Nunca inventar datas, cargos, notas ou certificados; marcar [preencher] onde faltar dado.

## 2b. CV mestre (fonte única)
- Existe **um** CV mestre: `Lebenslauf_MASTER.md` (na pasta conectada dele, ou no projeto ativo; o ambiente pode indicar outro caminho). Se houver várias versões antigas, una num mestre uma vez e diga quais arquivos foram absorvidos.
- **Fato novo → primeiro o mestre:** atualize a estação certa e acrescente uma linha no bloco final `Änderungen` (`AAAA-MM-DD | o que mudou`). Confirme em uma linha o que mudou.
- **Versões** são derivadas do mestre, com nome `Lebenslauf_<destino>_<AAAA-MM-DD>`; nunca edite uma versão sem atualizar o mestre.
- **Fidelidade:** nada que não esteja no mestre entra numa versão — nem em perfil/resumo (use só fatos do mestre, sem adjetivos novos nem interesses inventados); falta dado → [preencher] visível.
- **Ordem:** cronologia reversa dentro de **cada** bloco (o mais recente primeiro), períodos MM/AAAA.

| Destino | Inclui | Corta | Extra |
|---|---|---|---|
| Bewerbung Facharzt/Assistenzarzt | experiência clínica, radiologia/hospitações, idioma, certificados, publicação; termos da vaga quando forem fatos do mestre | detalhes escolares, EDV pouco relevante | ≤2 páginas; Ort, Datum, Unterschrift |
| Approbation/Behörde | tudo, lückenlos (lacunas >3 meses explicadas ou [preencher]) | qualquer texto de marketing/perfil | Ort, Datum, Unterschrift |
| Hospitation | radiologia, idioma, disponibilidade | detalhes antigos | 1 página |

Base: princípio de fonte única (evita cópias divergentes); checklist do Bewerbungskompass da Bundesagentur für Arbeit (dados pessoais no topo, mais recente primeiro, MM/AAAA, lacunas explicadas, foto opcional, Ort/Datum/Unterschrift, sem barras/estrelas).

## 3. Anschreiben / e-mail ao Chefarzt
- 1 página / ~250–350 palavras. Estrutura: Bezug (vaga ou iniciativa, como conheceu o serviço) → por que este hospital/radiologia (específico: linhas de pesquisa, MSK, modalidades) → o que traz (emergência, tomada de decisão, imagem no trauma) → status Approbation/idioma com datas realistas → pedido concreto (Hospitation, Gespräch, Bestätigung über beabsichtigte Beschäftigung) → Grußformel.
- Registro: Sie-Form, "Sehr geehrte/r Frau/Herr Prof. Dr. …", "Mit freundlichen Grüßen". Alemão claro de nível B2.1–B2.2 (ele prefere não soar acima do nível real; a entrevista vai revelar o nível).
- Revisar com a regra de correção da skill alemao-goethe-fsp quando ele próprio escrever o texto.

## 4. Checklist de documentos (gerar sob medida para o estado)
Ver references/approbation.md. Tabela numerada como o formulário oficial, com colunas: documento | quem emite | forma (cópia simples / autenticada / apostila / tradução) | validade máxima | quando providenciar (documentos de 3 meses por último) | status. Marque como inferência o que não estiver no formulário (ex.: qual órgão brasileiro emite). Termine com "próximos 3 passos" com datas relativas ao Goethe B2.

## 4b. Pedido de Bestätigung/Stellenzusage
Em BW, a declaração do empregador corresponde ao formulário Anlage 3 (Stellenzusage), assinado pelo empregador; é obrigatória só para Berufserlaubnis ou se houver pedido em outro estado. Ao pedir ao Chefarzt: cortês, sem pressão, anexar/mencionar o formulário, oferecer alternativa (carta informal de intenção) e explicar em uma frase para que serve.

## 4c. Pedido vago (ex.: "escreve um e-mail pra radiologia")
Não pergunte de volta se houver contexto suficiente: escolha o objetivo mais provável pelo histórico (ex.: resposta à oferta de Hospitation), diga a suposição na primeira linha, entregue o e-mail pronto e uma variante curta para o outro objetivo plausível (primeiro contato).

## 5. Estratégia
Quando ele pedir opinião sobre estado/hospital: compare tempo de processamento relatado, exigências de idioma, oferta de vagas em radiologia, custo de vida; deixe claro o que é dado oficial e o que é inferência; cite fonte e data.
```


#### Codex: `home:.agents/skills/candidatura-alemanha/SKILL.md`

````skill-source home:.agents/skills/candidatura-alemanha/SKILL.md 064014469210d9cabcf118956146b4500e3769b0fe182e4dc811ceb4b2bc50bd
---
name: "candidatura-alemanha"
description: "Candidatura do Giovanni a vagas médicas na Alemanha (Facharztausbildung Radiologie, Hospitation, Assistenzarzt) e processo de Approbation/Anerkennung como médico formado fora da UE. Use sempre que ele pedir Lebenslauf, Anschreiben, Bewerbung, e-mail para hospital/Chefarzt, Bestätigung über beabsichtigte Beschäftigung, checklist de documentos, escolha de estado (Bundesland), Kenntnisprüfung, FSP ou dúvidas sobre prazos e órgãos de reconhecimento."
---

# Candidatura e Approbation na Alemanha

Lineage: origin=claude; base=sha256:353268065a7d927e96a566c2dd8c2e21412fcc92d506e41c60c17e12aa1f0804; adaptation=codex

Interop: role = domain; owns = CV mestre e versões, Anschreiben, checklist de Approbation; defers to = alemao-goethe-fsp (correção de textos que ele mesmo escreveu); honors = idioma da mensagem (documentos em alemão), flags !! *** ...

Perfil: médico brasileiro (UFPR), experiência em SAMU/pré-hospitalar e medicina aeroportuária; objetivo Facharztausbildung Radiologie (preferência Universitätsklinikum Heidelberg; Saarland e Baden-Württemberg como alternativas); Goethe B2 em novembro de 2026, depois Approbation; mudança no 1º semestre de 2027. Hospitation em Heidelberg em discussão para 2027.

Responda no idioma da mensagem dele. Documentos para hospitais: alemão.

## 1. Regras legais — sempre conferir a data
Fatos com data (ver references/approbation.md). Antes de afirmar algo sobre prazos, taxas, validade de documentos ou procedimento, reabra a fonte oficial do estado (formulário atual do Regierungspräsidium/LAS) e escreva "consultado em DD/MM/AAAA" ao lado de cada fonte. Use o formulário específico para formados fora da UE (nonEU): o formulário geral de Approbation tem regras diferentes (ex.: 1 mês vs 3 meses de validade). Quando fonte secundária e oficial divergirem, siga a oficial e mostre a divergência. Destaque:
- Lei aprovada (Bundestag 26.03.2026; Bundesrat 08.05.2026), vigência prevista em **01.11.2026**: para formados fora da UE, a **Kenntnisprüfung direta passa a ser o padrão**; a análise documental de equivalência fica opcional, a pedido, em ~4 semanas após o início do processo. Exigências materiais da Approbation não mudam. Isso afeta diretamente o calendário dele (pedido após o B2).
- Idioma: B2 geral + C1 Fachsprache (FSP na Ärztekammer do estado).

## 2. Lebenslauf (padrão alemão para médico)
- Tabelado, cronologia reversa, períodos MM/AAAA sem lacunas (algumas autoridades exigem CV assinado e sem lacunas; o de candidatura também deve ser sem lacunas não explicadas).
- Blocos: Persönliche Daten (foto opcional; pela AGG não é exigida) → Berufserfahrung → Ausbildung/Studium → Approbation/Anerkennung (status honesto: "Antrag auf Approbation geplant nach Goethe B2 (11/2026)" ou "beantragt am …") → Sprachkenntnisse (nível GER + certificado e data) → Fortbildungen/Zertifikate (ACLS, PHTLS etc.) → Publikationen (ex.: simulador de drenagem torácica, Rev Col Bras Cir 2019) → EDV/Interessen (curto) → Ort, Datum, Unterschrift.
- Explicar instituições brasileiras entre parênteses quando não forem óbvias (ex.: "SAMU – staatlicher präklinischer Rettungsdienst").
- Nunca inventar datas, cargos, notas ou certificados; marcar [preencher] onde faltar dado.

## 2b. CV mestre (fonte única)
- Existe **um** CV mestre: `Lebenslauf_MASTER.md` (na pasta conectada dele, ou no projeto ativo; o ambiente pode indicar outro caminho). Se houver várias versões antigas, una num mestre uma vez e diga quais arquivos foram absorvidos.
- **Fato novo → primeiro o mestre:** atualize a estação certa e acrescente uma linha no bloco final `Änderungen` (`AAAA-MM-DD | o que mudou`). Confirme em uma linha o que mudou.
- **Versões** são derivadas do mestre, com nome `Lebenslauf_<destino>_<AAAA-MM-DD>`; nunca edite uma versão sem atualizar o mestre.
- **Fidelidade:** nada que não esteja no mestre entra numa versão — nem em perfil/resumo (use só fatos do mestre, sem adjetivos novos nem interesses inventados); falta dado → [preencher] visível.
- **Ordem:** cronologia reversa dentro de **cada** bloco (o mais recente primeiro), períodos MM/AAAA.

| Destino | Inclui | Corta | Extra |
|---|---|---|---|
| Bewerbung Facharzt/Assistenzarzt | experiência clínica, radiologia/hospitações, idioma, certificados, publicação; termos da vaga quando forem fatos do mestre | detalhes escolares, EDV pouco relevante | ≤2 páginas; Ort, Datum, Unterschrift |
| Approbation/Behörde | tudo, lückenlos (lacunas >3 meses explicadas ou [preencher]) | qualquer texto de marketing/perfil | Ort, Datum, Unterschrift |
| Hospitation | radiologia, idioma, disponibilidade | detalhes antigos | 1 página |

Base: princípio de fonte única (evita cópias divergentes); checklist do Bewerbungskompass da Bundesagentur für Arbeit (dados pessoais no topo, mais recente primeiro, MM/AAAA, lacunas explicadas, foto opcional, Ort/Datum/Unterschrift, sem barras/estrelas).

## 3. Anschreiben / e-mail ao Chefarzt
- 1 página / ~250–350 palavras. Estrutura: Bezug (vaga ou iniciativa, como conheceu o serviço) → por que este hospital/radiologia (específico: linhas de pesquisa, MSK, modalidades) → o que traz (emergência, tomada de decisão, imagem no trauma) → status Approbation/idioma com datas realistas → pedido concreto (Hospitation, Gespräch, Bestätigung über beabsichtigte Beschäftigung) → Grußformel.
- Registro: Sie-Form, "Sehr geehrte/r Frau/Herr Prof. Dr. …", "Mit freundlichen Grüßen". Alemão claro de nível B2.1–B2.2 (ele prefere não soar acima do nível real; a entrevista vai revelar o nível).
- Revisar com a regra de correção da skill alemao-goethe-fsp quando ele próprio escrever o texto.

## 4. Checklist de documentos (gerar sob medida para o estado)
Ver references/approbation.md. Tabela numerada como o formulário oficial, com colunas: documento | quem emite | forma (cópia simples / autenticada / apostila / tradução) | validade máxima | quando providenciar (documentos de 3 meses por último) | status. Marque como inferência o que não estiver no formulário (ex.: qual órgão brasileiro emite). Termine com "próximos 3 passos" com datas relativas ao Goethe B2.

## 4b. Pedido de Bestätigung/Stellenzusage
Em BW, a declaração do empregador corresponde ao formulário Anlage 3 (Stellenzusage), assinado pelo empregador; é obrigatória só para Berufserlaubnis ou se houver pedido em outro estado. Ao pedir ao Chefarzt: cortês, sem pressão, anexar/mencionar o formulário, oferecer alternativa (carta informal de intenção) e explicar em uma frase para que serve.

## 4c. Pedido vago (ex.: "escreve um e-mail pra radiologia")
Não pergunte de volta se houver contexto suficiente: escolha o objetivo mais provável pelo histórico (ex.: resposta à oferta de Hospitation), diga a suposição na primeira linha, entregue o e-mail pronto e uma variante curta para o outro objetivo plausível (primeiro contato).

## 5. Estratégia
Quando ele pedir opinião sobre estado/hospital: compare tempo de processamento relatado, exigências de idioma, oferta de vagas em radiologia, custo de vida; deixe claro o que é dado oficial e o que é inferência; cite fonte e data.

## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
