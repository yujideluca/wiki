---
id: skill-candidatura-alemanha
lang: de
source_hash: 1583a0720d1e
title: Skill: candidatura-alemanha (Bewerbungen in Deutschland)
---

## What it is
Die Skill „candidatura-alemanha“ unterstützt Giovannis Bewerbungen auf ärztliche Stellen in Deutschland (Facharztausbildung Radiologie, Hospitation, Assistenzarzt) und das Anerkennungsverfahren (Approbation, die Erlaubnis zur Ausübung des Arztberufs, und Anerkennung von Qualifikationen) für einen außerhalb der EU ausgebildeten Arzt. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: immer verwenden, wenn er einen Lebenslauf, ein Anschreiben, eine Bewerbung, eine E-Mail an ein Krankenhaus oder einen Chefarzt, eine Bestätigung über beabsichtigte Beschäftigung, eine Dokumenten-Checkliste, die Wahl des Bundeslands, die Kenntnisprüfung, die FSP (Fachsprachprüfung, die medizinische Sprachprüfung) oder Fragen zu Fristen und Anerkennungsbehörden verlangt.

## Flow
trigger t1: Giovanni bittet um Lebenslauf, Anschreiben, E-Mail an ein Krankenhaus, Unterlagenliste oder Rat zur Anerkennung | [[giovanni]]
step s1: Prüft das Datum: öffnet die offizielle Quelle neu und notiert den Abrufzeitpunkt
decide d1: Was wird gebraucht?
step s2: Lebenslauf: tabellarisch, neueste zuerst, MM/JJJJ, ohne Lücken; ein Master-Lebenslauf
step s3: Anschreiben oder E-Mail an den Chefarzt
step s4: Eine Unterlagenliste, maßgeschneidert für das Bundesland
step s5: Eine Bitte um Bestätigung der Beschäftigung, Stellenzusage
step s6: Übergibt den Entwurf an Giovanni; nichts wird von Claude gesendet
product p1: Entwürfe und Listen in Giovannis Hand, von ihm selbst zu senden

t1 -> s1
s1 -> d1
d1 -Lebenslauf-> s2
d1 -Anschreiben-> s3
d1 -Unterlagen-> s4
d1 -Beschäftigung-> s5
s2 -> s6
s3 -> s6
s4 -> s6
s5 -> s6
s6 -> p1

## What it does
Sie bereitet Lebensläufe und Briefe auf Deutsch vor, auf das Bundesland zugeschnittene Dokumenten-Checklisten und Beratung zu Ländern und Kliniken. Giovannis Profil, von dem sie ausgeht: ein brasilianischer Arzt mit Erfahrung in der präklinischen Notfallversorgung und Flughafenmedizin, Ziel Radiologie-Weiterbildung, mit Goethe B2 im November 2026, danach Approbation und einem geplanten Umzug im ersten Halbjahr 2027. Die Skill ist von der Art „Domäne“: Sie besitzt den Master-Lebenslauf, die Anschreiben und die Approbations-Checkliste; sie verweist für das Korrigieren selbst geschriebener Texte auf [[skill-alemao-goethe-fsp]]; und sie beachtet die Sprache der Nachricht (Dokumente für Kliniken sind auf Deutsch) und die Tiefe-Flags `!!`, `***` und `...`.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/candidatura-alemanha` (mit datierten Rechtsfakten in `references/approbation.md`); Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Giovannis Studium und Berufsweg, außerhalb der Code-Projekte.

## Who receives its output
Giovanni (Entwürfe, die er persönlich versendet; Claude sendet nichts).

## Steps
1. **Rechtsregeln: immer das Datum prüfen.** Bevor etwas über Fristen, Gebühren, Gültigkeit von Dokumenten oder Verfahren gesagt wird, die amtliche Quelle des Bundeslands (das aktuelle Formular der zuständigen Behörde) neu öffnen und neben jeder Quelle „abgerufen am TT.MM.JJJJ“ schreiben. Das Formular für Absolventen von außerhalb der EU verwenden: Das allgemeine Approbationsformular hat andere Regeln (zum Beispiel Gültigkeit 1 Monat gegenüber 3 Monaten). Weichen eine Sekundärquelle und die amtliche ab, der amtlichen folgen und die Abweichung zeigen. Hervorgehobene Tatsache: Ein 2026 beschlossenes Gesetz (Bundestag 26. März, Bundesrat 8. Mai), das voraussichtlich ab 1. November 2026 gilt, macht die direkte Kenntnisprüfung für Nicht-EU-Absolventen zum Standard und die Gleichwertigkeitsprüfung der Unterlagen auf Antrag optional; die materiellen Anforderungen an die Approbation ändern sich nicht; das betrifft Giovannis Zeitplan. Sprache: allgemein B2 plus C1-Fachsprache (die FSP bei der Landesärztekammer).
2. **Lebenslauf (deutscher Standard für Ärzte).** Tabellarisch, umgekehrt chronologisch, Zeiträume in MM/JJJJ ohne Lücken (manche Behörden verlangen einen unterschriebenen Lebenslauf ohne Lücken). Blöcke: persönliche Daten (Foto optional, vom Antidiskriminierungsgesetz nicht verlangt) → Berufserfahrung → Ausbildung/Studium → Approbation/Anerkennung (ehrlicher Status, etwa „Antrag auf Approbation geplant nach Goethe B2 (11/2026)“ oder „beantragt am …“) → Sprachkenntnisse (GER-Niveau + Zertifikat und Datum) → Fortbildungen/Zertifikate → Publikationen → EDV/Interessen (kurz) → Ort, Datum, Unterschrift. Brasilianische Einrichtungen in Klammern erklären, wenn nicht offensichtlich. Nie Daten, Stellen, Noten oder Zertifikate erfinden; wo Angaben fehlen [ausfüllen] markieren.
3. **Ein Master-Lebenslauf.** Es gibt einen Master-Lebenslauf, `Lebenslauf_MASTER.md` (im verbundenen Ordner oder im aktiven Projekt). Ein neuer Fakt kommt zuerst in den Master, an die richtige Stelle, plus eine Zeile im Schlussblock `Änderungen` (`JJJJ-MM-TT | was sich änderte`). Fassungen werden aus dem Master abgeleitet und `Lebenslauf_<Ziel>_<JJJJ-MM-TT>` genannt; nie eine Fassung ändern, ohne den Master zu aktualisieren. Treue: Nichts, was nicht im Master steht, kommt in eine Fassung, auch nicht in die Profilzusammenfassung (keine neuen Adjektive oder erfundenen Interessen); fehlende Angabe → gut sichtbares [ausfüllen]. Umgekehrte Chronologie in jedem Block. Nach Ziel: Eine Bewerbung auf Fach- oder Assistenzarztstellen enthält klinische Erfahrung, Radiologie und Hospitationen, Sprachen, Zertifikate und Publikation und lässt Schuldetails weg (höchstens 2 Seiten); ein Lebenslauf für Approbation/Behörde enthält alles, lückenlos (Lücken über 3 Monate erklärt) und ohne Werbetext; ein Lebenslauf für eine Hospitation hat eine Seite mit Radiologie, Sprachen und Verfügbarkeit. Grundlage: das Ein-Quellen-Prinzip und die Checkliste des Bewerbungskompasses der Bundesagentur für Arbeit.
4. **Anschreiben / E-Mail an den Chefarzt.** Eine Seite, etwa 250–350 Wörter. Aufbau: Bezug (die Stelle oder Initiative, wie man die Abteilung kennenlernte) → warum diese Klinik und Radiologie (konkret: Forschungslinien, muskuloskelettale Bildgebung, Modalitäten) → was Giovanni mitbringt (Notfallversorgung, Entscheidungsfindung, Traumabildgebung) → Stand von Approbation und Sprache mit realistischen Daten → eine konkrete Bitte (Hospitation, Gespräch, Bestätigung über beabsichtigte Beschäftigung) → Grußformel. Register: förmliche Sie-Form, „Sehr geehrte/r Frau/Herr Prof. Dr. …“, „Mit freundlichen Grüßen“. Klares Deutsch auf Niveau B2.1–B2.2 (er will nicht über seinem echten Niveau klingen; das Gespräch zeigt es). Hat er den Text selbst geschrieben, mit der Korrekturregel von [[skill-alemao-goethe-fsp]] prüfen.
5. **Dokumenten-Checkliste, maßgeschneidert fürs Bundesland.** Eine nummerierte Tabelle wie das amtliche Formular mit den Spalten: Dokument | Aussteller | Form (einfache Kopie / beglaubigt / Apostille / Übersetzung) | maximale Gültigkeit | wann besorgen (3-Monats-Dokumente zuletzt) | Status. Als Schlussfolgerung kennzeichnen, was nicht im Formular steht (zum Beispiel welche brasilianische Stelle ausstellt). Mit „die nächsten 3 Schritte“ enden, mit Daten relativ zu Goethe B2.
6. **Bitte um eine Beschäftigungsbestätigung (Stellenzusage).** In Baden-Württemberg entspricht die Erklärung des Arbeitgebers dem Formular „Anlage 3“, vom Arbeitgeber unterschrieben; sie ist nur für eine Berufserlaubnis oder auf Verlangen eines anderen Landes zwingend. Bei der Bitte an den Chefarzt: höflich ohne Druck, das Formular beifügen oder erwähnen, eine Alternative anbieten (ein formloses Absichtsschreiben) und in einem Satz erklären, wofür es ist.
7. **Vage Anfragen** (zum Beispiel „schreib eine E-Mail an die Radiologie“): nicht zurückfragen, wenn der Kontext reicht. Das wahrscheinlichste Ziel aus dem Verlauf wählen, die Annahme in der ersten Zeile nennen, die fertige E-Mail liefern und eine kurze Variante für das andere plausible Ziel (Erstkontakt).
8. **Strategie.** Bei der Frage nach einer Meinung zu Land oder Klinik berichtete Bearbeitungszeit, Sprachanforderungen, Radiologie-Stellen und Lebenshaltungskosten vergleichen; klar machen, was amtliche Angabe und was Schlussfolgerung ist; Quelle und Datum nennen.

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

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
