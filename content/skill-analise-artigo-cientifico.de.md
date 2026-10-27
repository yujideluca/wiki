---
id: skill-analise-artigo-cientifico
lang: de
source_hash: 972d8aaa0eca
title: Skill: analise-artigo-cientifico (Artikelbewertung)
---

## What it is
Die Skill „analise-artigo-cientifico“ ist die kritische Bewertung wissenschaftlicher Artikel und evidenzbasierter klinischer Fragen für Giovanni, einen Arzt. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: immer verwenden, wenn Giovanni einen Artikel, ein PDF, eine DOI (die dauerhafte Kennung einer Veröffentlichung), PMID (die PubMed-Nummer einer Veröffentlichung) oder einen Studienlink schickt, „analysiere diese Studie“ sagt, fragt, ob eine Behandlung, Therapie oder Untersuchung „funktioniert“, oder nach Evidenzniveau, GRADE (Grading of Recommendations Assessment, Development and Evaluation, eine Methode, um die Sicherheit der Evidenz einzustufen, [GRADE](https://www.gradeworkinggroup.org/)), Leitlinienvergleich oder Studienzusammenfassung fragt, auch ohne die Worte „kritische Analyse“.

## Flow
trigger t1: Giovanni schickt Artikel, PDF, DOI, PMID oder Link, oder fragt, ob eine Behandlung wirkt | [[giovanni]]
step s1: Kalibriert die Tiefe: seine Kürzel gelten, sonst die Größe der Frage
decide d1: Eine schnelle Frage oder ein ganzer Artikel?
step s2: Kurzmodus: Urteil, kleine Tabelle, vorläufiges GRADE, regionale Unterschiede, praktisches Vorgehen
step s3: Liest den Volltext und prüft die Quelle, auch auf Rücknahmen
step s4: Füllt fehlende Daten nie auf; folgt dem Aufbau einer Einzelartikel-Analyse
step s5: Wendet GRADE auf die Evidenzlage an, je Endpunkt
step s6: Sucht und vergleicht Leitlinien: Brasilien, Deutschland und Europa, USA
step s7: Hält Quelle und Begründung getrennt
product p1: Ein kurzes Urteil mit Quellen
product p2: Eine kritische Analyse: Evidenzgrad, GRADE-Sicherheit, Leitlinienvergleich

t1 -> s1
s1 -> d1
d1 -schnell-> s2
d1 -ganz-> s3
s2 -> p1
s3 -> s4
s4 -> s5
s5 -> s6
s6 -> s7
s7 -> p2

## What it does
Sie liefert eine kritische Lektüre, die Giovanni praktisch nutzen und als Denkweise trainieren kann, ohne Daten zu erfinden: Evidenzniveau, Sicherheit nach GRADE, Leitlinienvergleich (Brasilien, Deutschland und Europa, USA), Studienzusammenfassung. Sie ist auf Postgraduierten-Niveau, didaktisch, mit Mechanismen und Effektgrößen. Dosen, Verdünnungen und Rechner übernimmt [[skill-consulta-clinica]]; diese Skill kümmert sich um Artikel, „funktioniert das?“ und das Evidenzniveau.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/analise-artigo-cientifico` (mit Werkzeugdetails in `references/ferramentas.md`); Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt. Lädt auch [[skill-bias-risk-triage]], legt sie nur die Mindesttiefe der Prüfung fest; Struktur und Format sind die dieser Skill.

## Where it sits in the pipeline
Giovannis Studium und Berufsweg, außerhalb der Code-Projekte.

## Who receives its output
Giovanni.

## Steps
1. **Tiefe kalibrieren.** Giovannis Flags gewinnen: `!!` → ein direktes Urteil in höchstens 5 Zeilen, eine Hauptquelle mit Jahr und die GRADE-Sicherheit in einer Zeile (die vollständige Analyse anbieten); `***` → das vollständige Protokoll unten auf Doktoratsniveau; `...` → die Artikelstruktur aus Schritt 4. Eine schnelle oder vage Frage („taugt die Studie?“) → Kurzmodus mit etwa 300–600 Wörtern: die angenommene Studie (falls nicht genannt), ein Urteil in 1–2 Sätzen, eine kleine Tabelle mit relativem Effekt, absoluter Differenz und Konfidenzintervall der Hauptergebnisse, vorläufige GRADE-Sicherheit je Endpunkt, Abweichung zwischen Brasilien, Europa und USA in 2–3 Zeilen, das praktische Vorgehen und Quellen; die vollständige Analyse anbieten statt sie zu machen. Ein eingereichter Artikel, der Wunsch nach Tiefe oder umstrittene Evidenz → das vollständige Protokoll. In Giovannis Sprache antworten.
2. **Quelle beschaffen und prüfen, bevor analysiert wird.** Wenn möglich den Volltext lesen; gibt es nur das Abstract, das ausdrücklich sagen, denn ein Abstract erlaubt keine sichere Beurteilung des Verzerrungsrisikos. Integritätsprüfung (das Ergebnis festhalten, auch „nichts gefunden“): Rückziehungen und Besorgnisvermerke (Hinweise auf PubMed und der Website der Zeitschrift, die Datenbank Retraction Watch); die Zeitschrift (echte Indexierung in MEDLINE/PubMed oder DOAJ; Anzeichen einer Raubverlags- oder gekaperten Zeitschrift; die Kriterien „Think. Check. Submit.“); prospektive Registrierung (ClinicalTrials.gov, ReBEC, DRKS, WHO ICTRP: ist der registrierte primäre Endpunkt der veröffentlichte? ein Wechsel der Endpunkte ist ein Warnsignal); Interessenkonflikte, Finanzierung und Rolle des Sponsors; Plausibilität (ein für die Intervention zu großer Effekt, winzige Stichprobe, frühes Abbrechen wegen Nutzens, p-Werte knapp unter 0,05, „zu schöne“ Daten).
3. **Fehlende Daten nie ergänzen.** Eine Zahl, die in der Quelle fehlt, wird „nicht berichtet“ geschrieben. Jede Zahl kennzeichnen: [primär] (Volltext oder Abstract des Artikels), [sek] (Zusammenfassung Dritter) oder [ber] (aus veröffentlichten Daten berechnet). Widersprechen sich zwei Sekundärquellen, beide zeigen oder weglassen und begründen. Nicht in der Quelle gelesene Leitlinien-Empfehlungsgrade werden „nicht verifiziert“ genannt. Lässt sich der Volltext nicht öffnen, gleich am Anfang sagen: Die Verzerrungsanalyse ist vorläufig.
4. **Struktur einer Einzelartikel-Analyse** (knappe Stichpunkte, Akronyme bei erster Verwendung ausgeschrieben): (1) Referenz: Autoren, Zeitschrift, Jahr, DOI/PMID, Design, Registrierung; (2) Motivation: die Lücke und das PICO (Population, Intervention, Vergleich, Endpunkt) ausdrücklich; (3) Methoden: Design, Zuteilung und Verblindung, Stichprobengröße und Power-Berechnung, primärer Endpunkt (objektiv oder subjektiv bzw. patientenberichtet), Analyse (Intention-to-treat oder per Protokoll), Nachbeobachtung; (4) Ergebnisse: der Effekt auf den primären Endpunkt mit Konfidenzintervall, wenn Daten vorliegen immer in absoluten Effekt übersetzt (absolute Risikoreduktion, Number needed to treat oder to harm); sekundäre Endpunkte und Sicherheit getrennt; objektive Endpunkte (Mortalität, adjudizierte Ereignisse) von subjektiven (Schmerz, Lebensqualität) trennen und sagen, ob die Verblindung die subjektiven schützt; (5) statistische Stärke: Genauigkeit des Konfidenzintervalls gegenüber einer klinisch relevanten Schwelle, Multiplizität, Fragilität, wo anwendbar; (6) Verzerrungsrisiko mit dem passenden Werkzeug: RoB 2 für randomisierte Studien, ROBINS-I (v2) für nicht randomisierte Interventionsstudien, QUADAS-2 für diagnostische Genauigkeit, AMSTAR 2 für systematische Übersichten, PROBAST für Vorhersagemodelle; (7) methodische Stärken und Schwächen; (8) Sicherheit der Evidenz nach GRADE für den Hauptendpunkt; (9) Kontext: was aktuelle Leitlinien sagen und ob diese Studie etwas ändert; (10) ein praktisches Fazit in 2–3 Zeilen mit dem Grad der Unsicherheit; (11) Quellen mit Jahr und Link oder DOI.
5. **GRADE auf die Gesamtheit der Evidenz anwenden, je Endpunkt.** Start hoch bei randomisierten Studien, niedrig bei Beobachtungsstudien (oder hoch, wenn mit ROBINS-I bewertet, das Confounding schon einbezieht). Je 1 oder 2 Stufen abwerten für Verzerrungsrisiko, Inkonsistenz, Indirektheit, Impräzision und Publikationsbias. Impräzision nach dem Konfidenzintervall gegenüber definierten Schwellen beurteilen: Kreuzt das Intervall die Wichtigkeitsschwelle, abwerten; wenn nicht, der Effekt aber groß bei kleiner Stichprobe ist, die optimale Informationsgröße prüfen. Aufwerten (vor allem Beobachtungsstudien) bei großem Effekt, Dosis-Wirkungs-Gradienten oder residualem Confounding, das den beobachteten Effekt verringern würde. Den Grund jeder Abwertung nennen und das Ergebnis ausdrücken als „hohe, moderate, niedrige oder sehr niedrige Sicherheit, dass der wahre Effekt über oder unter [Schwelle] liegt“. Bei einer einzelnen Studie sagen, dass GRADE für die Gesamtheit der Evidenz gilt, und eine vorläufige Einschätzung geben.
6. **Suche und Leitlinien.** Hierarchie: aktuelle Leitlinien und systematische Übersichten, dann randomisierte Studien, dann Beobachtungsstudien; die neueste Quelle bevorzugen und ihr Jahr nennen. Auf Englisch suchen und auch auf Portugiesisch und Deutsch, wenn es relevante Quellen gibt (zum Beispiel AWMF-Leitlinien, das Deutsche Ärzteblatt, brasilianische Fachgesellschaften, SciELO). Weichen Empfehlungen zwischen Brasilien (Gesundheitsministerium, CONITEC, Fachgesellschaften), Deutschland und Europa (AWMF, ESC = European Society of Cardiology, ERC = European Resuscitation Council, EMA) und den USA (AHA = American Heart Association, ACR, USPSTF, FDA) ab, die Abweichung und ihren wahrscheinlichen Grund zeigen. Nachrichten müssen in einem verlässlichen Medium und in der Primärquelle bestätigt werden.
7. **Quelle und Schlussfolgerung trennen.** Kennzeichnen, was Daten aus der Quelle und was Claudes Schluss ist („Interpretation:“). Wirkt die Schlussfolgerung seltsam, vor der Antwort breit neu bewerten.
8. **Studienzusammenfassungen** (wenn Giovanni eine Zusammenfassung will, keine volle Analyse): kurze Stichpunkte, Akronyme ausgeschrieben, absoluter Effekt mit Konfidenzintervall und Sicherheit, und eine Zeile für die Hauptlimitation.

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

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
