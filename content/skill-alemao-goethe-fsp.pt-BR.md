---
id: skill-alemao-goethe-fsp
lang: pt-BR
source_hash: d76cfcb8ef6c
title: Skill: alemao-goethe-fsp (treino de alemão)
---

## What it is
A skill "alemao-goethe-fsp" é o treino de alemão do Giovanni, escrita em português, para o exame Goethe-Zertifikat B2 ([Goethe B2](https://www.goethe.de/en/spr/prf/gzb2.html), o exame geral de alemão em nível intermediário-superior) e, depois dele, a FSP (Fachsprachprüfung, a prova alemã de linguagem médica no nível C1, "C1 Medizin"). Sua descrição diz: usar sempre que o Giovanni enviar frases ou textos em alemão para corrigir, pedir exercícios, simular prova (Schreiben = escrita, Sprechen = fala, Arzt-Patienten-Gespräch = conversa médico-paciente, Arztbrief = carta médica, Arzt-Arzt-Gespräch = conversa médico-médico), vocabulário médico PT–DE, explicação gramatical ou heurísticas para verbos com preposição, casos e declinação.

## What it does
Corrige frases e textos em alemão, dá exercícios, simula partes da prova, fornece vocabulário médico e explicações gramaticais e mantém um registro de erros recorrentes que retoma em sessões futuras com repetição espaçada. O perfil de aluno que ela supõe: médico brasileiro, nível B1+/B2 em formação, Goethe B2 em novembro de 2026, depois FSP e Kenntnisprüfung (a prova de conhecimentos para médicos formados no exterior); dificuldades recorrentes são casos, terminações de adjetivos, declinação-n, preposições, advérbios pronominais, verbos com preposição, zu-Infinitiv, Konjunktiv I/II, Perfekt versus Präteritum e ordem das palavras em orações subordinadas. Erros achados em textos corrigidos também alimentaram o modo "achar o erro" do [[quizapp]].

## How it does it
Um `SKILL.md` em `~/.claude/skills/alemao-goethe-fsp` (com detalhes das provas em `references/provas.md`); o Claude o carrega quando um pedido combina com a descrição. Seu papel é "domínio": é dona da correção de alemão, dos exercícios, das simulações e do registro de erros; remete à [[skill-candidatura-alemanha]] para documentos de candidatura; e respeita o idioma da mensagem do Giovanni e as flags de profundidade `!!`, `***` e `...`.

## Where it sits in the pipeline
Estudo e carreira do Giovanni, fora dos projetos de código.

## Who receives its output
O Giovanni.

## Steps
1. **Idioma da resposta.** Responder no idioma em que o Giovanni escreveu (explicações em português se ele escreveu em português); o material de treino é em alemão.
2. **Corrigir um texto, em ordem fixa** (o Giovanni quer ver o resultado antes da teoria). Primeiro, cada frase corrigida sozinha. Segundo, uma explicação de cada erro: a categoria (caso, terminação de adjetivo, ordem das palavras, preposição, valência verbal, léxico, registro, ortografia), a regra em uma linha e a heurística que evita o erro. Terceiro, alternativas e melhorias só depois, marcadas B2 ou C1; o Giovanni prefere textos formais que soem naturalmente B2.1, frases curtas e nenhum vocabulário muito acima do nível real. Não "melhorar o estilo" no primeiro passo.
3. **No fim de textos longos**, acrescentar: um perfil de erros (contagem por categoria e os dois padrões mais frequentes); para tarefa de prova, uma avaliação no estilo Goethe (cumprimento da tarefa, coerência, vocabulário, estruturas, cada um de A a E com uma frase e uma pontuação estimada; aprovação é 60 de 100, e é preciso dizer que é uma estimativa); exercícios proporcionais aos erros (uma frase isolada → 3 frases de treino; um texto de prova → 3–5 itens por padrão frequente, 10–15 no total, misturando lacuna, transformação e produção livre curta, com gabarito no fim); e a atualização do registro de erros.
4. **Formatos de prova** (fontes oficiais). Goethe B2 Schreiben, 75 minutos: parte 1 um post de fórum de cerca de 150 palavras (opinião, argumentos, proposta, com introdução e conclusão), parte 2 uma mensagem formal de cerca de 100 palavras (saudação e despedida, pedido ou proposta, registro adequado). Goethe B2 Sprechen, cerca de 15 minutos mais 15 de preparo: parte 1 uma apresentação de cerca de 4 minutos (introdução, desenvolvimento com vantagens e desvantagens, conclusão) mais perguntas; parte 2 uma discussão de cerca de 5 minutos sobre tema controverso. FSP (C1 Medizin, aplicada pela câmara médica estadual, cerca de 60 minutos): conversa médico-paciente 20 minutos (anamnese em linguagem leiga, explicar suspeita e plano), documentação 20 minutos (ficha de anamnese ou carta médica), conversa médico-médico 20 minutos (apresentação do caso com terminologia correta). O formato varia por câmara: confirmar com a câmara do estado escolhido.
5. **Simulações.** Fazer um papel de cada vez e esperar a resposta do Giovanni (paciente, examinador, médico-chefe); nunca escrever os dois lados. Na conversa médico-paciente, o paciente fala em linguagem leiga e só revela informação quando perguntado; no fim, avaliar: estrutura da anamnese (anamnese atual, doenças prévias, medicamentos, alergias, noxas, anamnese familiar e social, anamnese vegetativa), uso de linguagem leiga, empatia e erros de língua. Na conversa médico-médico, exigir apresentação em linguagem técnica e 5–10 pares termo técnico ↔ termo leigo. Ao fim de cada simulação: 3 pontos fortes, 3 erros prioritários e frases-modelo corrigidas.
6. **Método (o que a pesquisa apoia).** Feedback corretivo escrito, direto e focado, melhora a precisão gramatical em escrita nova (então: corrigir tudo, mas destacar 2–3 padrões para treino); prática de recuperação e prática espaçada são as técnicas mais úteis (então: gerar exercícios de produção, não só leitura, e retomar erros antigos); instrução explícita mais prática significativa supera a exposição implícita. Heurísticas próprias: verbos com preposição são aprendidos como bloco "verbo + preposição + caso" com uma frase-âncora médica (por exemplo "Der Patient leidet an Diabetes"), e o advérbio pronominal da-/wo- quando o complemento é coisa ou oração; para adjetivos perguntar "o artigo já mostra caso e gênero?" (se sim a terminação é -e/-en, se não o adjetivo assume a terminação forte); preposições de dois casos: wohin? → acusativo, wo? → dativo; na subordinada o verbo conjugado vai no fim, e quando a subordinada vem antes o verbo da principal vem logo em seguida ("verbo-vírgula-verbo").
7. **Vocabulário médico.** Uma tabela: português – termo técnico alemão – termo leigo alemão – frase clínica de exemplo; prioridade para emergência, clínica geral, radiologia, anamnese e carta médica.
8. **Registro de erros entre sessões.** Uma linha por padrão (não por frase) em um arquivo `alemao-erros.jsonl` (no projeto ativo, senão na pasta conectada, senão entregar o bloco ao Giovanni para salvar), com padrão, categoria, exemplos, regra, heurística, ocorrências, caixa e próxima data. Usa o sistema Leitner com 4 caixas e intervalos de 1, 3, 7 e 14 dias: depois de corrigir, cada erro ou acrescenta um exemplo ao seu padrão (ocorrências +1, caixa volta a 1) ou cria o padrão na caixa 1. No início de uma sessão, ler primeiro o registro; a fila são os padrões cuja data chegou, ordenados por ocorrências ÷ caixa; pegar no máximo 3 e misturá-los num aquecimento de 3 frases para o Giovanni produzir sem ver a resposta (depois da correção, quando ele mandou um texto). Acerto sobe uma caixa (máximo 4); erro volta à caixa 1. Padrões na caixa 4 há mais de 30 dias são arquivados, não apagados.
9. **Exportar para o Anki quando pedido.** Um `.txt` UTF-8 com as linhas de cabeçalho `#separator:Tab`, `#html:true`, `#notetype:Cloze`, `#deck:Deutsch::Fehler`, `#tags column:2`; uma linha por padrão com a frase correta contendo a correção como cloze (`Der Patient leidet {{c1::an}} Diabetes.`) mais a regra curta, e tags `categoria::<categoria> padrao::<rótulo>`; sem duplicatas e sem tabulações ou quebras de linha dentro dos campos.

## Notes

O Codex agora usa a versão mantida separadamente em [[codex-skills]]. A fonte completa abaixo contém as regras de execução do Codex; o procedimento Claude acima continua sendo a versão Claude. Navegador, memória e conexões podem funcionar de formas diferentes.

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

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
