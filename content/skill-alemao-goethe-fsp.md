---
id: skill-alemao-goethe-fsp
title: Skill: alemao-goethe-fsp (German training)
aliases: [alemao-goethe-fsp]
kind: skill
project: skills
status: active
location: home:.claude/skills/alemao-goethe-fsp
fed_by: []
feeds: []
sources: [home:.claude/skills/alemao-goethe-fsp/SKILL.md, home:.agents/skills/alemao-goethe-fsp/SKILL.md]
reviewed: 2026-10-25T20:41Z
---

## What it is
The skill "alemao-goethe-fsp" is Giovanni's German training, written in Portuguese, for the Goethe-Zertifikat B2 exam ([Goethe B2](https://www.goethe.de/en/spr/prf/gzb2.html), the general German exam at upper-intermediate level) and, after it, the FSP (Fachsprachprüfung, the German medical-language exam at level C1, "C1 Medizin"). Its description says: use it whenever Giovanni sends German sentences or texts to correct, asks for exercises, a mock exam (Schreiben = writing, Sprechen = speaking, Arzt-Patienten-Gespräch = doctor–patient conversation, Arztbrief = doctor's letter, Arzt-Arzt-Gespräch = doctor–doctor conversation), medical vocabulary Portuguese–German, grammar explanations, or heuristics for verbs with prepositions, cases and declension.

## Flow
trigger t1: Giovanni sends German to correct, or asks for exercises, an exam simulation, vocabulary or grammar | [[giovanni]]
step s1: Answers in the language Giovanni wrote in; the training material is German
decide d1: What does he want?
step s2: Corrects each sentence on its own, first
step s3: Explains each error: category, one-line rule and a heuristic
step s4: Only then offers alternatives, marked B2 or C1
step s5: Runs the exam format: Schreiben, Sprechen, patient or colleague talk, Arztbrief
step s6: Gives a Goethe-style estimate: criteria rated A to E, passing is 60 of 100
step s7: Answers with medical vocabulary PT–DE, grammar rules and heuristics
step s8: Keeps a register of recurring errors and revisits it with spaced repetition
product p1: A corrected text with an error profile
product p2: An exam-style assessment with exercises
product p3: An answer on vocabulary or grammar
product p4: Anki cards, on request

t1 -> s1
s1 -> d1
d1 -correct a text-> s2
d1 -exam-> s5
d1 -vocabulary or grammar-> s7
s2 -> s3
s3 -> s4
s4 -> p1
s4 -> s8
s5 -> s6
s6 -> p2
s6 -> s8
s7 -> p3
s8 -> p4

## What it does
It corrects German sentences and texts, gives exercises, simulates exam parts, provides medical vocabulary and grammar explanations, and keeps a register of recurring errors that it revisits in later sessions with spaced repetition. The student profile it assumes: Brazilian doctor, level B1+/B2 in progress, Goethe B2 in November 2026, then FSP and Kenntnisprüfung (the knowledge exam for foreign-trained doctors); recurring difficulties are cases, adjective endings, n-declension, prepositions, pronominal adverbs, verbs with prepositions, the zu-infinitive, subjunctive I/II, perfect versus simple past, and word order in subordinate clauses. Errors found in corrected texts also fed the "find the error" mode of [[quizapp]].

## How it does it
A `SKILL.md` in `~/.claude/skills/alemao-goethe-fsp` (with exam details in `references/provas.md`); Claude loads it when a request matches its description. Its role is "domain": it owns correcting German, exercises, simulations and the error register; it defers to [[skill-candidatura-alemanha]] for application documents; and it honours the language of Giovanni's message and the depth flags `!!`, `***` and `...`.

## Where it sits in the pipeline
Giovanni's study and career work, outside the code projects.

## Who receives its output
Giovanni.

## Steps
1. **Reply language.** Answer in the language Giovanni wrote in (explanations in Portuguese if he wrote Portuguese); the training material is German.
2. **Correcting a text, in a fixed order** (Giovanni wants to see the result before the theory). First, each sentence corrected on its own. Second, an explanation of each error: its category (case, adjective ending, word order, preposition, verb valency, vocabulary, register, spelling), the rule in one line and the heuristic that avoids the error. Third, alternatives and improvements only afterwards, marked B2 or C1; Giovanni prefers formal texts that sound naturally B2.1, short sentences and no vocabulary far above his real level. Do not "improve style" in the first step.
3. **At the end of long texts**, add: an error profile (count per category and the two most frequent patterns); for an exam task, a Goethe-style assessment (task fulfilment, coherence, vocabulary, structures, each rated A–E with one sentence, and an estimated score; passing is 60 of 100, and it must be said that it is an estimate); exercises proportional to the errors (one isolated sentence → 3 practice sentences; an exam text → 3–5 items per frequent pattern, 10–15 in total, mixing gap-fill, transformation and short free production, with an answer key at the end); and an update of the error register.
4. **Exam formats** (official sources). Goethe B2 Schreiben, 75 minutes: part 1 a forum post of about 150 words (opinion, arguments, proposal, with introduction and conclusion), part 2 a formal message of about 100 words (salutation and closing, request or proposal, suitable register). Goethe B2 Sprechen, about 15 minutes plus 15 minutes of preparation: part 1 a talk of about 4 minutes (introduction, main part with advantages and disadvantages, conclusion) plus questions; part 2 a discussion of about 5 minutes on a controversial topic. FSP (C1 Medizin, held by the state medical chamber, about 60 minutes): doctor–patient conversation 20 minutes (history in lay language, explaining suspicion and plan), documentation 20 minutes (history form or doctor's letter), doctor–doctor conversation 20 minutes (case presentation with correct terminology). The format varies by chamber: confirm with the chamber of the chosen state.
5. **Simulations.** Play one role at a time and wait for Giovanni's answer (patient, examiner, senior physician); never write both sides. In the doctor–patient conversation the patient speaks in lay language and reveals information only when asked; at the end assess the structure of the history (current history, previous illnesses, medication, allergies, noxae, family and social history, systems review), the use of lay language, empathy and language errors. In the doctor–doctor conversation demand a presentation in technical language and 5–10 pairs of technical term ↔ lay term. After each simulation: 3 strengths, 3 priority errors and corrected model sentences.
6. **Method (what research supports).** Direct, focused written corrective feedback improves grammatical accuracy in new writing (so: correct everything but highlight 2–3 patterns to practise); retrieval practice and spaced practice are the most useful techniques (so: generate production exercises, not only reading, and revisit old errors); explicit instruction plus meaningful practice beats implicit exposure. Own heuristics: verbs with prepositions are learned as a chunk "verb + preposition + case" with a medical anchor sentence (for example "Der Patient leidet an Diabetes"), and the pronominal adverb da-/wo- when the object is a thing or a clause; for adjectives ask "does the article already show case and gender?" (if yes the ending is -e/-en, if no the adjective takes the strong ending); two-way prepositions: wohin? → accusative, wo? → dative; in subordinate clauses the conjugated verb goes last, and when the subordinate clause comes first the main clause's verb follows immediately ("verb-comma-verb").
7. **Medical vocabulary.** A table: Portuguese – German technical term – German lay term – clinical example sentence; priority to emergency medicine, general medicine, radiology, history taking and doctor's letters.
8. **Error register between sessions.** One line per pattern (not per sentence) in a file `alemao-erros.jsonl` (in the active project, else the connected folder, else hand the block to Giovanni to save), with the pattern, category, examples, rule, heuristic, occurrences, box and next date. It uses the Leitner system with 4 boxes and intervals of 1, 3, 7 and 14 days: after correcting, each error either adds an example to its pattern (occurrences +1, box back to 1) or creates the pattern in box 1. At the start of a session, read the register first; the queue is the patterns whose date has come, ordered by occurrences ÷ box; take at most 3 and mix them into a warm-up of 3 sentences for Giovanni to produce without seeing the answer (after the correction when he sent a text). A correct answer moves up a box (maximum 4); an error goes back to box 1. Patterns in box 4 for more than 30 days are archived, not deleted.
9. **Export to Anki on request.** A UTF-8 `.txt` with the header lines `#separator:Tab`, `#html:true`, `#notetype:Cloze`, `#deck:Deutsch::Fehler`, `#tags column:2`; one line per pattern with the correct sentence containing the correction as a cloze (`Der Patient leidet {{c1::an}} Diabetes.`) plus the short rule, and tags `categoria::<category> padrao::<label>`; no duplicates and no tabs or line breaks inside fields.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/alemao-goethe-fsp/SKILL.md`

````skill-source home:.claude/skills/alemao-goethe-fsp/SKILL.md 84de375f6e9e74373449d5ef8ac3b5ef743e8d819d0b308a527a247f8465d647
---
name: "alemao-goethe-fsp"
description: "Treino de alemão do Giovanni para o Goethe-Zertifikat B2 e, depois, a Fachsprachprüfung (FSP, C1 Medizin). Use sempre que ele enviar frases ou textos em alemão para corrigir, pedir exercícios, simular prova (Schreiben, Sprechen, Arzt-Patienten-Gespräch, Arztbrief, Arzt-Arzt-Gespräch), pedir vocabulário médico PT–DE, explicação gramatical ou heurísticas para verbos com preposição, casos e declinação."
---

# Alemão: Goethe B2 → FSP

Lineage: origin=gui; base=05bc4383689271c40d28eeb798105d3c931c1552

Interop: role = domain; owns = correção de alemão, exercícios, simulações e o registro de erros/Anki; defers to = candidatura-alemanha (documentos de candidatura); honors = idioma da mensagem, flags !! *** ...

Contexto do aluno: brasileiro, médico, nível B1+/B2 em formação, prova Goethe B2 em novembro de 2026, depois FSP (C1 Medizin) e Kenntnisprüfung. Ele quer heurísticas treináveis, não decoreba. Dificuldades recorrentes: casos, terminação de adjetivos, n-Deklination, preposições, Pronominaladverbien, verbos com preposição, zu-Infinitiv, Konjunktiv I/II, Perfekt/Präteritum, ordem das palavras em orações subordinadas.

Responda no idioma em que ele escreveu (explicações em português se ele escreveu em português; o material de treino em alemão).

## 1. Correção de texto (regra fixa dele)
Ordem obrigatória, porque ele quer ver o resultado antes da teoria:
1. **Frase corrigida sozinha** (cada frase do texto).
2. **Explicação** de cada erro: categoria (Kasus, Adjektivendung, Wortstellung, Präposition, Verbvalenz, Lexik, Register, Orthografie) + a regra em uma linha + a heurística que evita o erro.
3. **Alternativas/melhorias** só depois, marcando o nível (B2 vs C1) — ele prefere textos formais que soem B2.1 natural, frases curtas, sem vocabulário muito acima do nível real.

Ao final de textos longos, inclua:
- **Perfil de erros**: contagem por categoria e os 2 padrões mais frequentes.
- **Avaliação estilo Goethe** quando for tarefa de prova: Aufgabenerfüllung, Kohärenz, Wortschatz, Strukturen, cada um A–E com uma frase de justificativa, e estimativa de pontos (aprovação = 60/100). Diga que é estimativa.
- **Exercícios proporcionais aos erros**: frase isolada → 3 frases de treino; texto de prova → 3–5 itens por padrão frequente (10–15 no total), misturando lacuna, transformação e produção livre curta, com gabarito separado no fim. A prática de recuperação só funciona com volume suficiente e correção imediata.
- **Revisão espaçada**: atualize o registro de erros (seção 6); as frases-âncora vêm dele.

Não corrija o que está certo só para "melhorar estilo" na etapa 1; isso vai na etapa 3.

## 2. Formato das provas (fontes oficiais)
Ver references/provas.md. Resumo:
- **Goethe B2 Schreiben (75 min)**: Teil 1 Forumsbeitrag ~150 palavras (~50 min, opinião + argumentos + proposta, com introdução e conclusão); Teil 2 mensagem formal ~100 palavras (~25 min, Anrede/Gruß, pedido/proposta, registro adequado).
- **Goethe B2 Sprechen (~15 min, 15 min preparo)**: Teil 1 Vortrag ~4 min (estrutura: Einleitung, Hauptteil com vantagens/desvantagens, Schluss) + perguntas; Teil 2 Diskussion ~5 min sobre tema controverso, reagir e concluir com posição.
- **FSP (C1 Medizin, Landesärztekammer, ~60 min)**: Arzt-Patienten-Gespräch 20 min (Anamnese em linguagem leiga, explicar suspeita/plano), Dokumentation 20 min (Anamnesebogen/Arztbrief), Arzt-Arzt-Gespräch 20 min (apresentação do caso com terminologia correta, discussão, termos técnicos ↔ leigos). Formato varia por Kammer: confirmar com a Kammer do estado escolhido.

## 3. Simulações
- Faça um papel de cada vez e espere a resposta dele (paciente, examinador, Oberarzt). Não escreva os dois lados.
- No Arzt-Patienten-Gespräch, o paciente fala em linguagem leiga e só revela informação quando perguntado; ao final, avalie: estrutura da anamnese (aktuelle Anamnese, Vorerkrankungen, Medikamente, Allergien, Noxen, Familien-/Sozialanamnese, vegetative Anamnese), uso de linguagem leiga, empatia, erros linguísticos.
- No Arzt-Arzt-Gespräch, exija apresentação em Fachsprache e peça 5–10 pares Fachbegriff ↔ laienverständlicher Begriff.
- Ao final de cada simulação: 3 pontos fortes, 3 erros prioritários, frases-modelo corrigidas.

## 4. Heurísticas e método (o que a pesquisa apoia)
- **Feedback corretivo escrito direto e focado** melhora a precisão gramatical em escrita nova (metanálise Kang & Han 2015, Modern Language Journal). Por isso: corrija tudo, mas destaque 2–3 padrões para treino.
- **Prática de recuperação e prática espaçada** são as técnicas de maior utilidade (Dunlosky et al. 2013, Psychological Science in the Public Interest). Por isso: gere exercícios de produção (não só leitura) e retome erros antigos em sessões futuras.
- **Instrução explícita + prática significativa** supera exposição implícita para estruturas gramaticais (Spada & Tomita 2010; Norris & Ortega 2000).
- Heurísticas próprias a priorizar:
  - Verbos com preposição: aprender como chunk "Verb + Präp + Kasus" com uma frase-âncora médica (ex.: *leiden an + D*: "Der Patient leidet an Diabetes"); Pronominaladverb da-/wo- quando o complemento é coisa/frase.
  - Adjetivos: perguntar "o artigo já mostra o caso/gênero?" → se sim, -e/-en; se não, o adjetivo assume a terminação forte.
  - Wechselpräpositionen: wohin? → Akk.; wo? → Dat.
  - Subordinadas: verbo conjugado no fim; Nebensatz antes → verbo do Hauptsatz logo no início ("Verb-Komma-Verb").

## 5. Vocabulário médico
Tabela PT – DE (Fachbegriff) – DE (laienverständlich) – frase-exemplo clínica. Priorize emergência, clínica geral, radiologia, anamnese, Arztbrief.

## 6. Registro de erros entre sessões e Anki
Base: prática de recuperação supera releitura (Roediger & Karpicke 2006); intervalos crescentes e ~10–20% do horizonte de retenção otimizam memória (Cepeda et al. 2008); feedback corretivo focado em poucos padrões funciona melhor (Kang & Han 2015). Até a prova (nov/2026), o horizonte é de semanas → intervalos 1, 3, 7, 14 dias.

**Armazenamento:** `alemao-erros.jsonl` — no projeto ativo (Projects `claude/alemao-erros.jsonl`), senão na pasta conectada, senão entregue o bloco para ele salvar. O ambiente pode indicar outro caminho. Uma linha por **padrão** (não por frase):
`{"padrao":"mit + Dativ","categoria":"Präposition","exemplos":[{"data":"AAAA-MM-DD","errado":"...","correto":"..."}],"regra":"...","heuristica":"...","ocorrencias":1,"caixa":1,"proxima":"AAAA-MM-DD"}`

**Algoritmo (Leitner, 4 caixas):**
1. Após corrigir: para cada erro, ache o padrão (mesmo rótulo); se existe, acrescente o exemplo, `ocorrencias += 1`, `caixa = 1`; se não, crie com `caixa = 1`. `proxima` = hoje + intervalo[caixa] com intervalo = {1:1, 2:3, 3:7, 4:14} dias.
2. Início de sessão: leia o registro antes de responder; fila = padrões com `proxima` ≤ hoje, ordenados por `ocorrencias × caixa⁻¹` (mais frequentes e menos consolidados primeiro); pegue no máximo 3 e intercale-os num aquecimento de 3 frases para ele produzir (sem mostrar a resposta antes). Posição: se ele mandou texto para corrigir, o aquecimento vem **depois** da correção (a regra dele: frase corrigida primeiro); sem texto, abre a sessão com ele. Se um erro de hoje repete um padrão do registro, diga isso na explicação.
3. Resultado do aquecimento: acerto → `caixa = min(caixa+1, 4)`; erro → `caixa = 1`. Recalcule `proxima`.
4. Mantenha o arquivo curto: padrões na caixa 4 há >30 dias vão para `arquivados` (não somem).

**Exportar para Anki (quando pedir):** `.txt` UTF-8 com cabeçalho (Anki ≥ 2.1.54):
```
#separator:Tab
#html:true
#notetype:Cloze
#deck:Deutsch::Fehler
#tags column:2
```
Linha por exemplo mais recente de cada padrão: campo 1 = frase correta com a correção em cloze (`Der Patient leidet {{c1::an}} Diabetes.`) + `<br>` + regra curta; campo 2 = tags `categoria::<cat> padrao::<rótulo sem espaços>`. Sem duplicatas, sem tab ou quebra de linha dentro dos campos.
````


#### Codex: `home:.agents/skills/alemao-goethe-fsp/SKILL.md`

````skill-source home:.agents/skills/alemao-goethe-fsp/SKILL.md 59dff242837abdd22d6d4a729d2c664e7105e2f124be01e5ac224d6ddd06d3cc
---
name: "alemao-goethe-fsp"
description: "Treino de alemão do Giovanni para o Goethe-Zertifikat B2 e, depois, a Fachsprachprüfung (FSP, C1 Medizin). Use sempre que ele enviar frases ou textos em alemão para corrigir, pedir exercícios, simular prova (Schreiben, Sprechen, Arzt-Patienten-Gespräch, Arztbrief, Arzt-Arzt-Gespräch), pedir vocabulário médico PT–DE, explicação gramatical ou heurísticas para verbos com preposição, casos e declinação."
---

# Alemão: Goethe B2 → FSP

Lineage: origin=claude; base=sha256:f00556785e9957a68d53eec0e693d04af9a394a02fd1272d47910b95a334db6f; adaptation=codex

Interop: role = domain; owns = correção de alemão, exercícios, simulações e o registro de erros/Anki; defers to = candidatura-alemanha (documentos de candidatura); honors = idioma da mensagem, flags !! *** ...

Contexto do aluno: brasileiro, médico, nível B1+/B2 em formação, prova Goethe B2 em novembro de 2026, depois FSP (C1 Medizin) e Kenntnisprüfung. Ele quer heurísticas treináveis, não decoreba. Dificuldades recorrentes: casos, terminação de adjetivos, n-Deklination, preposições, Pronominaladverbien, verbos com preposição, zu-Infinitiv, Konjunktiv I/II, Perfekt/Präteritum, ordem das palavras em orações subordinadas.

Responda no idioma em que ele escreveu (explicações em português se ele escreveu em português; o material de treino em alemão).

## 1. Correção de texto (regra fixa dele)
Ordem obrigatória, porque ele quer ver o resultado antes da teoria:
1. **Frase corrigida sozinha** (cada frase do texto).
2. **Explicação** de cada erro: categoria (Kasus, Adjektivendung, Wortstellung, Präposition, Verbvalenz, Lexik, Register, Orthografie) + a regra em uma linha + a heurística que evita o erro.
3. **Alternativas/melhorias** só depois, marcando o nível (B2 vs C1) — ele prefere textos formais que soem B2.1 natural, frases curtas, sem vocabulário muito acima do nível real.

Ao final de textos longos, inclua:
- **Perfil de erros**: contagem por categoria e os 2 padrões mais frequentes.
- **Avaliação estilo Goethe** quando for tarefa de prova: Aufgabenerfüllung, Kohärenz, Wortschatz, Strukturen, cada um A–E com uma frase de justificativa, e estimativa de pontos (aprovação = 60/100). Diga que é estimativa.
- **Exercícios proporcionais aos erros**: frase isolada → 3 frases de treino; texto de prova → 3–5 itens por padrão frequente (10–15 no total), misturando lacuna, transformação e produção livre curta, com gabarito separado no fim. A prática de recuperação só funciona com volume suficiente e correção imediata.
- **Revisão espaçada**: atualize o registro de erros (seção 6); as frases-âncora vêm dele.

Não corrija o que está certo só para "melhorar estilo" na etapa 1; isso vai na etapa 3.

## 2. Formato das provas (fontes oficiais)
Ver references/provas.md. Resumo:
- **Goethe B2 Schreiben (75 min)**: Teil 1 Forumsbeitrag ~150 palavras (~50 min, opinião + argumentos + proposta, com introdução e conclusão); Teil 2 mensagem formal ~100 palavras (~25 min, Anrede/Gruß, pedido/proposta, registro adequado).
- **Goethe B2 Sprechen (~15 min, 15 min preparo)**: Teil 1 Vortrag ~4 min (estrutura: Einleitung, Hauptteil com vantagens/desvantagens, Schluss) + perguntas; Teil 2 Diskussion ~5 min sobre tema controverso, reagir e concluir com posição.
- **FSP (C1 Medizin, Landesärztekammer, ~60 min)**: Arzt-Patienten-Gespräch 20 min (Anamnese em linguagem leiga, explicar suspeita/plano), Dokumentation 20 min (Anamnesebogen/Arztbrief), Arzt-Arzt-Gespräch 20 min (apresentação do caso com terminologia correta, discussão, termos técnicos ↔ leigos). Formato varia por Kammer: confirmar com a Kammer do estado escolhido.

## 3. Simulações
- Faça um papel de cada vez e espere a resposta dele (paciente, examinador, Oberarzt). Não escreva os dois lados.
- No Arzt-Patienten-Gespräch, o paciente fala em linguagem leiga e só revela informação quando perguntado; ao final, avalie: estrutura da anamnese (aktuelle Anamnese, Vorerkrankungen, Medikamente, Allergien, Noxen, Familien-/Sozialanamnese, vegetative Anamnese), uso de linguagem leiga, empatia, erros linguísticos.
- No Arzt-Arzt-Gespräch, exija apresentação em Fachsprache e peça 5–10 pares Fachbegriff ↔ laienverständlicher Begriff.
- Ao final de cada simulação: 3 pontos fortes, 3 erros prioritários, frases-modelo corrigidas.

## 4. Heurísticas e método (o que a pesquisa apoia)
- **Feedback corretivo escrito direto e focado** melhora a precisão gramatical em escrita nova (metanálise Kang & Han 2015, Modern Language Journal). Por isso: corrija tudo, mas destaque 2–3 padrões para treino.
- **Prática de recuperação e prática espaçada** são as técnicas de maior utilidade (Dunlosky et al. 2013, Psychological Science in the Public Interest). Por isso: gere exercícios de produção (não só leitura) e retome erros antigos em sessões futuras.
- **Instrução explícita + prática significativa** supera exposição implícita para estruturas gramaticais (Spada & Tomita 2010; Norris & Ortega 2000).
- Heurísticas próprias a priorizar:
  - Verbos com preposição: aprender como chunk "Verb + Präp + Kasus" com uma frase-âncora médica (ex.: *leiden an + D*: "Der Patient leidet an Diabetes"); Pronominaladverb da-/wo- quando o complemento é coisa/frase.
  - Adjetivos: perguntar "o artigo já mostra o caso/gênero?" → se sim, -e/-en; se não, o adjetivo assume a terminação forte.
  - Wechselpräpositionen: wohin? → Akk.; wo? → Dat.
  - Subordinadas: verbo conjugado no fim; Nebensatz antes → verbo do Hauptsatz logo no início ("Verb-Komma-Verb").

## 5. Vocabulário médico
Tabela PT – DE (Fachbegriff) – DE (laienverständlich) – frase-exemplo clínica. Priorize emergência, clínica geral, radiologia, anamnese, Arztbrief.

## 6. Registro de erros entre sessões e Anki
Base: prática de recuperação supera releitura (Roediger & Karpicke 2006); intervalos crescentes e ~10–20% do horizonte de retenção otimizam memória (Cepeda et al. 2008); feedback corretivo focado em poucos padrões funciona melhor (Kang & Han 2015). Até a prova (nov/2026), o horizonte é de semanas → intervalos 1, 3, 7, 14 dias.

**Armazenamento:** `alemao-erros.jsonl` — no projeto ativo (arquivo `alemao-erros.jsonl` na pasta de estudo existente), senão na pasta conectada, senão entregue o bloco para ele salvar. O ambiente pode indicar outro caminho. Uma linha por **padrão** (não por frase):
`{"padrao":"mit + Dativ","categoria":"Präposition","exemplos":[{"data":"AAAA-MM-DD","errado":"...","correto":"..."}],"regra":"...","heuristica":"...","ocorrencias":1,"caixa":1,"proxima":"AAAA-MM-DD"}`

**Algoritmo (Leitner, 4 caixas):**
1. Após corrigir: para cada erro, ache o padrão (mesmo rótulo); se existe, acrescente o exemplo, `ocorrencias += 1`, `caixa = 1`; se não, crie com `caixa = 1`. `proxima` = hoje + intervalo[caixa] com intervalo = {1:1, 2:3, 3:7, 4:14} dias.
2. Início de sessão: leia o registro antes de responder; fila = padrões com `proxima` ≤ hoje, ordenados por `ocorrencias × caixa⁻¹` (mais frequentes e menos consolidados primeiro); pegue no máximo 3 e intercale-os num aquecimento de 3 frases para ele produzir (sem mostrar a resposta antes). Posição: se ele mandou texto para corrigir, o aquecimento vem **depois** da correção (a regra dele: frase corrigida primeiro); sem texto, abre a sessão com ele. Se um erro de hoje repete um padrão do registro, diga isso na explicação.
3. Resultado do aquecimento: acerto → `caixa = min(caixa+1, 4)`; erro → `caixa = 1`. Recalcule `proxima`.
4. Mantenha o arquivo curto: padrões na caixa 4 há >30 dias vão para `arquivados` (não somem).

**Exportar para Anki (quando pedir):** `.txt` UTF-8 com cabeçalho (Anki ≥ 2.1.54):
```
#separator:Tab
#html:true
#notetype:Cloze
#deck:Deutsch::Fehler
#tags column:2
```
Linha por exemplo mais recente de cada padrão: campo 1 = frase correta com a correção em cloze (`Der Patient leidet {{c1::an}} Diabetes.`) + `<br>` + regra curta; campo 2 = tags `categoria::<cat> padrao::<rótulo sem espaços>`. Sem duplicatas, sem tab ou quebra de linha dentro dos campos.

## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
