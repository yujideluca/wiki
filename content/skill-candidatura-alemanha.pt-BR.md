---
id: skill-candidatura-alemanha
lang: pt-BR
source_hash: 4ea0c03da932
title: Skill: candidatura-alemanha (candidaturas na Alemanha)
---

## What it is
A skill "candidatura-alemanha" apoia as candidaturas do Giovanni a vagas médicas na Alemanha (formação de especialista em radiologia, Hospitation = visita de observação em hospital, e vaga de Assistenzarzt = médico residente) e o processo de reconhecimento (Approbation, a licença para exercer a medicina, e Anerkennung, reconhecimento de qualificações) para um médico formado fora da UE. É escrita em português. Sua descrição diz: usar sempre que ele pedir Lebenslauf (currículo), Anschreiben (carta de apresentação), Bewerbung (candidatura), e-mail para hospital ou chefe, Bestätigung über beabsichtigte Beschäftigung (confirmação de intenção de contratação), checklist de documentos, escolha de estado (Bundesland), Kenntnisprüfung (prova de conhecimentos), FSP (Fachsprachprüfung, a prova de linguagem médica) ou dúvidas sobre prazos e órgãos de reconhecimento.

## What it does
Prepara currículos e cartas em alemão, checklists de documentos sob medida para o estado e conselho sobre estados e hospitais. O perfil do Giovanni de que parte: médico brasileiro com experiência em atendimento pré-hospitalar e medicina aeroportuária, visando a formação em radiologia, com Goethe B2 em novembro de 2026, depois Approbation e mudança prevista para o primeiro semestre de 2027. A skill é do tipo "domínio": é dona do CV mestre, das cartas e do checklist de Approbation; remete à [[skill-alemao-goethe-fsp]] para corrigir textos que ele mesmo escreveu; e respeita o idioma da mensagem (documentos para hospitais são em alemão) e as flags de profundidade `!!`, `***` e `...`.

## How it does it
Um `SKILL.md` em `~/.claude/skills/candidatura-alemanha` (com fatos legais datados em `references/approbation.md`); o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
Estudo e carreira do Giovanni, fora dos projetos de código.

## Who receives its output
O Giovanni (rascunhos para ele enviar pessoalmente; o Claude não envia nada).

## Steps
1. **Regras legais: sempre conferir a data.** Antes de afirmar algo sobre prazos, taxas, validade de documentos ou procedimento, reabrir a fonte oficial do estado (o formulário atual do órgão responsável) e escrever "consultado em DD/MM/AAAA" ao lado de cada fonte. Usar o formulário para formados fora da UE: o formulário geral de Approbation tem regras diferentes (por exemplo validade de 1 mês versus 3 meses). Quando uma fonte secundária e a oficial divergirem, seguir a oficial e mostrar a divergência. Fato destacado: uma lei aprovada em 2026 (Bundestag 26 de março, Bundesrat 8 de maio), com vigência prevista para 1º de novembro de 2026, torna a Kenntnisprüfung direta o padrão para formados fora da UE e a análise documental de equivalência opcional, a pedido; as exigências materiais da Approbation não mudam; isso afeta o calendário do Giovanni. Idioma: B2 geral mais C1 de linguagem técnica (a FSP na câmara médica do estado).
2. **Lebenslauf (padrão alemão para médico).** Em tabela, cronologia reversa, períodos MM/AAAA sem lacunas (algumas autoridades exigem currículo assinado e sem lacunas). Blocos: dados pessoais (foto opcional, não exigida pela lei antidiscriminação) → experiência profissional → formação → Approbation/reconhecimento (status honesto, como "pedido de Approbation planejado após Goethe B2 (11/2026)" ou "solicitado em …") → idiomas (nível do QECR + certificado e data) → cursos e certificados → publicações → informática/interesses (curto) → local, data, assinatura. Explicar entre parênteses instituições brasileiras que não forem óbvias. Nunca inventar datas, cargos, notas ou certificados; marcar [preencher] onde faltar dado.
3. **Um CV mestre.** Existe um CV mestre, `Lebenslauf_MASTER.md` (na pasta conectada ou no projeto ativo). Um fato novo vai primeiro para o mestre, no lugar certo, mais uma linha no bloco final `Änderungen` (`AAAA-MM-DD | o que mudou`). Versões são derivadas do mestre e chamadas `Lebenslauf_<destino>_<AAAA-MM-DD>`; nunca editar uma versão sem atualizar o mestre. Fidelidade: nada que não esteja no mestre entra numa versão, nem no resumo de perfil (sem adjetivos novos nem interesses inventados); faltou dado → [preencher] visível. Cronologia reversa dentro de cada bloco. Por destino: uma candidatura a vagas de especialista ou residente inclui experiência clínica, radiologia e Hospitationen, idiomas, certificados e publicação, e corta detalhes escolares (no máximo 2 páginas); um CV para Approbation/órgão inclui tudo, sem lacunas (lacunas acima de 3 meses explicadas) e sem texto de marketing; um CV para Hospitation tem uma página com radiologia, idiomas e disponibilidade. Base: o princípio de fonte única e o checklist do guia de candidatura da Agência Federal de Emprego.
4. **Anschreiben / e-mail ao chefe.** Uma página, cerca de 250–350 palavras. Estrutura: referência (a vaga ou iniciativa, como conheceu o serviço) → por que este hospital e a radiologia (específico: linhas de pesquisa, imagem musculoesquelética, modalidades) → o que o Giovanni traz (emergência, tomada de decisão, imagem no trauma) → status da Approbation e do idioma com datas realistas → um pedido concreto (Hospitation, conversa, confirmação de intenção de contratação) → fórmula de despedida. Registro: a forma formal "Sie", "Sehr geehrte/r Frau/Herr Prof. Dr. …", "Mit freundlichen Grüßen". Alemão claro de nível B2.1–B2.2 (ele prefere não soar acima do nível real; a entrevista vai revelar). Quando ele mesmo escreveu o texto, revisar com a regra de correção da [[skill-alemao-goethe-fsp]].
5. **Checklist de documentos, sob medida para o estado.** Uma tabela numerada como o formulário oficial, com as colunas: documento | quem emite | forma (cópia simples / autenticada / apostila / tradução) | validade máxima | quando providenciar (documentos de 3 meses por último) | status. Marcar como inferência o que não estiver no formulário (por exemplo qual órgão brasileiro emite). Terminar com "próximos 3 passos", com datas relativas ao Goethe B2.
6. **Pedido de confirmação de contratação (Stellenzusage).** Em Baden-Württemberg a declaração do empregador corresponde ao formulário "Anlage 3", assinado pelo empregador; é obrigatória só para uma autorização provisória de exercício (Berufserlaubnis) ou se outro estado pedir. Ao pedir ao chefe: ser cortês, sem pressão, anexar ou mencionar o formulário, oferecer uma alternativa (uma carta informal de intenção) e explicar em uma frase para que serve.
7. **Pedido vago** (por exemplo "escreve um e-mail pra radiologia"): não perguntar de volta se houver contexto suficiente. Escolher o objetivo mais provável pelo histórico, dizer a suposição na primeira linha, entregar o e-mail pronto e uma variante curta para o outro objetivo plausível (primeiro contato).
8. **Estratégia.** Quando pedirem opinião sobre estado ou hospital, comparar tempo de processamento relatado, exigências de idioma, oferta de vagas em radiologia e custo de vida; deixar claro o que é dado oficial e o que é inferência; citar fonte e data.

## Notes

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

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

```skill-source home:.agents/skills/candidatura-alemanha/SKILL.md f7aaf2906135d142f47757791a3f19151d096d2319ed3be349ec3d27e4e7e774
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
