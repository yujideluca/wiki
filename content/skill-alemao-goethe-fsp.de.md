---
id: skill-alemao-goethe-fsp
lang: de
source_hash: 6d77c3b47c91
title: Skill: alemao-goethe-fsp (Deutsch-Training)
---

## What it is
Die Skill „alemao-goethe-fsp“ ist Giovannis Deutsch-Training, auf Portugiesisch geschrieben, für die Prüfung Goethe-Zertifikat B2 ([Goethe B2](https://www.goethe.de/en/spr/prf/gzb2.html), die allgemeine Deutschprüfung auf gehobenem Mittelstufenniveau) und danach die FSP (Fachsprachprüfung, die deutsche medizinische Sprachprüfung auf Niveau C1, „C1 Medizin“). Ihre Beschreibung sagt: immer verwenden, wenn Giovanni deutsche Sätze oder Texte zum Korrigieren schickt, Übungen, eine Probeprüfung (Schreiben, Sprechen, Arzt-Patienten-Gespräch, Arztbrief, Arzt-Arzt-Gespräch), medizinisches Vokabular Portugiesisch–Deutsch, Grammatikerklärungen oder Heuristiken für Verben mit Präpositionen, Kasus und Deklination verlangt.

## What it does
Sie korrigiert deutsche Sätze und Texte, gibt Übungen, simuliert Prüfungsteile, liefert medizinisches Vokabular und Grammatikerklärungen und führt ein Register wiederkehrender Fehler, das sie in späteren Sitzungen mit Spaced Repetition wieder aufgreift. Das angenommene Lernerprofil: brasilianischer Arzt, Niveau B1+/B2 im Aufbau, Goethe B2 im November 2026, danach FSP und Kenntnisprüfung (die Wissensprüfung für im Ausland ausgebildete Ärzte); wiederkehrende Schwierigkeiten sind Kasus, Adjektivendungen, n-Deklination, Präpositionen, Pronominaladverbien, Verben mit Präpositionen, zu-Infinitiv, Konjunktiv I/II, Perfekt gegenüber Präteritum und Wortstellung in Nebensätzen. Fehler aus korrigierten Texten speisten auch den Modus „Fehler finden“ von [[quizapp]].

## How it does it
Eine `SKILL.md` in `~/.claude/skills/alemao-goethe-fsp` (mit Prüfungsdetails in `references/provas.md`); Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt. Ihre Rolle ist „Domäne“: Sie besitzt das Korrigieren von Deutsch, Übungen, Simulationen und das Fehlerregister; sie verweist für Bewerbungsunterlagen auf [[skill-candidatura-alemanha]]; und sie beachtet die Sprache von Giovannis Nachricht und die Tiefe-Flags `!!`, `***` und `...`.

## Where it sits in the pipeline
Giovannis Studium und Berufsweg, außerhalb der Code-Projekte.

## Who receives its output
Giovanni.

## Steps
1. **Antwortsprache.** In der Sprache antworten, in der Giovanni geschrieben hat (Erklärungen auf Portugiesisch, wenn er Portugiesisch schrieb); das Übungsmaterial ist Deutsch.
2. **Einen Text korrigieren, in fester Reihenfolge** (Giovanni will das Ergebnis vor der Theorie sehen). Erstens: jeder Satz für sich korrigiert. Zweitens: eine Erklärung jedes Fehlers: seine Kategorie (Kasus, Adjektivendung, Wortstellung, Präposition, Verbvalenz, Wortschatz, Register, Rechtschreibung), die Regel in einer Zeile und die Heuristik, die den Fehler vermeidet. Drittens: Alternativen und Verbesserungen erst danach, mit B2 oder C1 gekennzeichnet; Giovanni bevorzugt formelle Texte, die natürlich nach B2.1 klingen, kurze Sätze und keinen Wortschatz weit über seinem echten Niveau. Im ersten Schritt nicht „den Stil verbessern“.
3. **Am Ende langer Texte** ergänzen: ein Fehlerprofil (Zahl pro Kategorie und die zwei häufigsten Muster); bei einer Prüfungsaufgabe eine Bewertung im Goethe-Stil (Aufgabenerfüllung, Kohärenz, Wortschatz, Strukturen, jeweils A–E mit einem Satz und einer geschätzten Punktzahl; bestanden ist 60 von 100, und es muss gesagt werden, dass es eine Schätzung ist); fehlerproportionale Übungen (ein einzelner Satz → 3 Übungssätze; ein Prüfungstext → 3–5 Aufgaben pro häufigem Muster, insgesamt 10–15, gemischt aus Lückentext, Umformung und kurzer freier Produktion, mit Lösungsschlüssel am Ende); und die Aktualisierung des Fehlerregisters.
4. **Prüfungsformate** (offizielle Quellen). Goethe B2 Schreiben, 75 Minuten: Teil 1 ein Forumsbeitrag von etwa 150 Wörtern (Meinung, Argumente, Vorschlag, mit Einleitung und Schluss), Teil 2 eine formelle Nachricht von etwa 100 Wörtern (Anrede und Gruß, Bitte oder Vorschlag, passendes Register). Goethe B2 Sprechen, etwa 15 Minuten plus 15 Minuten Vorbereitung: Teil 1 ein Vortrag von etwa 4 Minuten (Einleitung, Hauptteil mit Vor- und Nachteilen, Schluss) plus Fragen; Teil 2 eine Diskussion von etwa 5 Minuten zu einem kontroversen Thema. FSP (C1 Medizin, von der Landesärztekammer, etwa 60 Minuten): Arzt-Patienten-Gespräch 20 Minuten (Anamnese in Laiensprache, Verdacht und Plan erklären), Dokumentation 20 Minuten (Anamnesebogen oder Arztbrief), Arzt-Arzt-Gespräch 20 Minuten (Fallvorstellung mit korrekter Terminologie). Das Format variiert je Kammer: bei der Kammer des gewählten Bundeslands bestätigen.
5. **Simulationen.** Eine Rolle nach der anderen spielen und auf Giovannis Antwort warten (Patient, Prüfer, Oberarzt); nie beide Seiten schreiben. Im Arzt-Patienten-Gespräch spricht der Patient in Laiensprache und gibt Informationen nur auf Nachfrage; am Ende bewerten: Struktur der Anamnese (aktuelle Anamnese, Vorerkrankungen, Medikamente, Allergien, Noxen, Familien- und Sozialanamnese, vegetative Anamnese), Gebrauch von Laiensprache, Empathie und Sprachfehler. Im Arzt-Arzt-Gespräch eine Präsentation in Fachsprache und 5–10 Paare Fachbegriff ↔ Laienbegriff verlangen. Nach jeder Simulation: 3 Stärken, 3 vorrangige Fehler und korrigierte Mustersätze.
6. **Methode (was die Forschung stützt).** Direktes, fokussiertes schriftliches Korrekturfeedback verbessert die grammatische Genauigkeit in neuen Texten (also: alles korrigieren, aber 2–3 Muster zum Üben hervorheben); Abrufübung und verteiltes Üben sind die nützlichsten Techniken (also: Produktionsübungen erzeugen, nicht nur Lesen, und alte Fehler wieder aufgreifen); explizite Instruktion plus sinnvolle Übung schlägt implizite Exposition. Eigene Heuristiken: Verben mit Präpositionen werden als Chunk „Verb + Präposition + Kasus“ mit einem medizinischen Ankersatz gelernt (zum Beispiel „Der Patient leidet an Diabetes“), und das Pronominaladverb da-/wo-, wenn das Objekt eine Sache oder ein Satz ist; bei Adjektiven fragen „zeigt der Artikel schon Kasus und Genus?“ (wenn ja, Endung -e/-en, wenn nein, bekommt das Adjektiv die starke Endung); Wechselpräpositionen: wohin? → Akkusativ, wo? → Dativ; im Nebensatz steht das konjugierte Verb am Ende, und steht der Nebensatz vorn, folgt das Verb des Hauptsatzes sofort („Verb-Komma-Verb“).
7. **Medizinisches Vokabular.** Eine Tabelle: Portugiesisch – deutscher Fachbegriff – deutscher Laienbegriff – klinischer Beispielsatz; Priorität: Notfallmedizin, Allgemeinmedizin, Radiologie, Anamnese und Arztbrief.
8. **Fehlerregister zwischen Sitzungen.** Eine Zeile pro Muster (nicht pro Satz) in einer Datei `alemao-erros.jsonl` (im aktiven Projekt, sonst im verbundenen Ordner, sonst den Block Giovanni zum Speichern geben), mit Muster, Kategorie, Beispielen, Regel, Heuristik, Häufigkeit, Fach und nächstem Datum. Es nutzt das Leitner-System mit 4 Fächern und Intervallen von 1, 3, 7 und 14 Tagen: Nach dem Korrigieren ergänzt jeder Fehler entweder ein Beispiel zu seinem Muster (Häufigkeit +1, Fach zurück auf 1) oder legt das Muster in Fach 1 an. Zu Beginn einer Sitzung zuerst das Register lesen; die Warteschlange sind die Muster, deren Datum erreicht ist, geordnet nach Häufigkeit ÷ Fach; höchstens 3 nehmen und in ein Aufwärmen aus 3 Sätzen mischen, die Giovanni ohne Sicht auf die Antwort selbst bilden soll (nach der Korrektur, wenn er einen Text schickte). Eine richtige Antwort rückt ein Fach vor (höchstens 4); ein Fehler geht zurück auf Fach 1. Muster, die länger als 30 Tage in Fach 4 sind, werden archiviert, nicht gelöscht.
9. **Export nach Anki auf Wunsch.** Eine UTF-8-`.txt` mit den Kopfzeilen `#separator:Tab`, `#html:true`, `#notetype:Cloze`, `#deck:Deutsch::Fehler`, `#tags column:2`; eine Zeile pro Muster mit dem richtigen Satz, der die Korrektur als Cloze enthält (`Der Patient leidet {{c1::an}} Diabetes.`), plus der kurzen Regel, und Tags `categoria::<Kategorie> padrao::<Bezeichnung>`; keine Duplikate und keine Tabs oder Zeilenumbrüche in Feldern.

## Notes

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

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

````skill-source home:.agents/skills/alemao-goethe-fsp/SKILL.md dc68a58e941d1bcfcd5c3b4f3d7acc4c3f3f94b4916ab355ac01f14eda6221b1
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

**Armazenamento:** `alemao-erros.jsonl` — no projeto ativo (Projects `Codex/alemao-erros.jsonl`), senão na pasta conectada, senão entregue o bloco para ele salvar. O ambiente pode indicar outro caminho. Uma linha por **padrão** (não por frase):
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
