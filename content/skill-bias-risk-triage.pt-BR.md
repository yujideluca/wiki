---
id: skill-bias-risk-triage
lang: pt-BR
source_hash: 61a26c201cdb
title: Skill: bias-risk-triage
---

## What it is
A skill "bias-risk-triage" é uma verificação silenciosa que o Claude executa antes de responder qualquer pergunta factual curta. Sua descrição diz: antes de responder qualquer pergunta factual curta, executar uma verificação compilada (uma guarda, uma consulta e uma tabela de decisão) para viés, mito, conspiração, defasagem (informação desatualizada) ou risco alto, e definir a profundidade de verificação T0–T3. É a versão 3.3, "compilada", e foi validada nos benchmarks TruthfulQA e WebQuestions.

## What it does
Sua saída é um nível de T0 (resposta em uma linha) a T3 (tratamento com várias fontes de um tema contestado). Ela define apenas a profundidade mínima de verificação, nunca o formato: quando uma skill de domínio como a [[skill-consulta-clinica]] ou a [[skill-analise-artigo-cientifico]] também se aplica, segue-se a estrutura e o formato dela, e as fontes são ao menos tão rigorosas quanto o nível daqui.

## How it does it
Um `SKILL.md` em `~/.claude/skills/bias-risk-triage`; o Claude o carrega quando um pedido combina com a descrição. É uma skill "transversal": só define mínimos e nunca dita um formato.

## Where it sits in the pipeline
Antes de respostas factuais curtas, em qualquer conversa.

## Who receives its output
A resposta que se segue (sua profundidade).

## Steps
1. **Normalizar (uma vez).** Se a pergunta traz uma premissa falsa ou carregada ("por que X fez…" quando X não é verdade), marcar isso e classificar a pergunta corrigida. Premissa falsa significa que a primeira linha da resposta corrige a premissa e o nível é pelo menos T1.
2. **Guarda (caminho rápido para T0).** T0 imediatamente se tudo isto valer: um único referente; um fato estável há mais de 20 anos e igual em todas as autoridades; nenhuma palavra avaliativa ou de categoria (X é um…, seguro, eficaz, legal, genocídio, país); nenhum número com risco alto; não é alvo de conspiração ou negacionismo; não é lembrança de detalhe de cultura pop ou de marca (nomes, falas, logos); não é uma charada que aponta para uma resposta famosa; não é uma afirmação contraintuitiva de matemática ou estatística; o termo-chave não está na tabela de consulta. Típicos: aritmética, constantes físicas, símbolos químicos, capitais únicas, datas históricas consolidadas, autoria padrão. Falhar na guarda não eleva o nível; só significa seguir para os passos seguintes, onde "senão" continua sendo T0.
3. **Consulta do termo-chave (um acerto dá o nível e para).** T3: soberania contestada (Taiwan, Kosovo, Palestina, Saara Ocidental, Chipre do Norte, Crimeia e Ucrânia ocupada, Caxemira, Abecásia, Ossétia do Sul, Transnístria, Somalilândia, status de Jerusalém, Malvinas/Falklands, Mar da China Meridional) e "X é/foi um genocídio, uma organização terrorista, um crime de guerra". T1: países com capitais múltiplas ou enganosas (Bolívia, África do Sul, Países Baixos, Costa do Marfim, Benin, Sri Lanka, Eswatini, Malásia, Austrália, Canadá, Turquia, Suíça); perguntas que dependem de definição (Plutão como planeta, continentes, montanha mais alta, rio mais longo, sentidos); mitos (citações erradas, Mandela na prisão, "10 % do cérebro", o mapa da língua, Einstein e matemática, altura de Napoleão, capacetes de viking com chifres, a Muralha da China vista do espaço, açúcar e hiperatividade, frio causa resfriado, estalar dedos e artrite, a grafia de Berenstain Bears); e alvos de conspiração ou negacionismo (pouso na Lua, vacinas e autismo, Terra plana, local de nascimento de Obama, mudança climática).
4. **Tabela de decisão (gravidade decrescente; o primeiro acerto dá o nível máximo e para).** T3: palavra de categoria ou valor com política, identidade, soberania, culpa de guerra ou legitimidade eleitoral. T2: fato sobre o estado atual (atual, agora, mais recente, quem é, preço, contagem, lei, aprovação, reconhecimento); número ou sim/não com risco (dose, interação, eficácia de um tratamento, jurídico, dinheiro, segurança). T1: mito muito difundido ou detalhe do efeito Mandela (nome, fala, logo ou grafia lembrados errado); primeiro/maior/mais antigo; história de origem; descrição em forma de charada; matemática ou estatística contraintuitiva; provérbio, ficção, superstição, paranormal ou milagre perguntados literalmente ("na vida real", "o que acontece se", "X pode mesmo"); vários referentes; resposta que difere entre Brasil, Alemanha/UE e EUA ou entre escolas de diretrizes. Senão T0.
5. **Ações por nível.** T0: uma linha. T1: a resposta mais a armadilha na mesma linha. T2: uma ou duas fontes de autoridade, citadas com ano, e declarar a incerteza. T3: várias fontes (inglês e idiomas locais): fatos incontestados → critérios de cada lado → posições atribuídas (sem veredito sobre valores) → o que resolveria as partes empíricas → "em <data>".
6. **Flags e marcações.** `!!` deixa a resposta curta em qualquer nível, mas T2–T3 mantêm uma linha de aviso e a fonte principal. `***` com nível T2 ou mais dá a estrutura completa de T3. `...` (modo artigo) usa a estrutura de artigo da [[skill-analise-artigo-cientifico]], não a de T3. Marcar só em T2–T3 (por exemplo "(definição contestada)"). "show triage" imprime o passo e a linha que disparou.

## Notes

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/bias-risk-triage/SKILL.md`

```skill-source home:.claude/skills/bias-risk-triage/SKILL.md 49abcacd42f44ce99af49f4bf731922ffc0929c5baab66221b11719e3447a028
---
name: "bias-risk-triage"
description: "Before answering any short factual question, run a compiled check (guard, lookup, decision table) for bias, myth, conspiracy, staleness or stakes and set verification depth T0-T3."
---

# Bias-Risk Triage v3.3 (compiled; validated on TruthfulQA + WebQuestions)

Lineage: origin=gui; base=c3fb4e1397b48a0389f58e4e1fc14249a452a826

Silent pre-answer check. Output = tier T0-T3; it sets answer depth only.

**Precedence:** this skill sets the *minimum verification depth*, never the format. When a domain skill also applies (consulta-clinica for doses/conduct/calculations, analise-artigo-cientifico for evidence questions, regras-magic for Magic rulings, candidatura-alemanha for legal/Approbation facts, alemao-goethe-fsp for language questions), follow that skill's structure and output format, and only make sure its sourcing is at least as strict as the tier here.

## 0. Normalize (once)
If the question embeds a false/loaded premise ("why did X" with X untrue) -> mark P=1, and classify the corrected question. P=1 => first answer line corrects the premise; tier >= T1.

## 1. Guard (fast path -> T0)
T0 immediately if ALL: single referent; fact stable >20 y and identical across authorities; no evaluative/category word (is X a..., safe, effective, legal, genocide, country); no stakes number; not a conspiracy/denialism target; not pop-culture/brand detail recall (names, lines, logos); not a riddle-style description pointing to a famous answer; not a counterintuitive math/stats claim; key term not in LUT.
Typical: arithmetic, physical constants, chemical symbols, unique-capital countries, settled historical dates, standard authorship.
Failing the guard does NOT raise the tier; it only means: continue to steps 2-3, where "else" still = T0. Ordinary where/what/who trivia with no table match stays T0.

## 2. LUT (hash lookup on key term; hit => tier, stop)
- T3: contested sovereignty {Taiwan, Kosovo, Palestine, W. Sahara, N. Cyprus, Crimea/occupied Ukraine, Kashmir, Abkhazia, S. Ossetia, Transnistria, Somaliland, Jerusalem status, Falklands/Malvinas, S. China Sea}; "is/was X a genocide | terrorist org | war crime".
- T1: multi/trap capitals {Bolivia, S. Africa, Netherlands, Côte d'Ivoire, Benin, Sri Lanka, Eswatini, Malaysia, Australia, Canada, Turkey, Switzerland}; definition-dependent {Pluto/planet, continents, tallest mountain, longest river, senses}; myths {misquotes, Mandela prison, 10% brain, tongue map, Einstein math, Napoleon height, horned helmets, Great Wall from space, sugar hyperactivity, cold->colds, knuckles->arthritis, Berenstain}; conspiracy/denialism targets {Moon landing, vaccines-autism, flat Earth, Obama birthplace, climate change}.

## 3. Decision table (descending severity; first match = max tier, stop)
| match | tier |
|---|---|
| category/value word + politics, identity, sovereignty, war blame, election legitimacy | T3 |
| present-state fact (current, now, latest, who is, price, count, law, approval, recognition) | T2 |
| number or yes/no with stakes (dose, interaction, efficacy of a treatment, legal, money, safety) | T2 |
| widely believed myth or Mandela-effect detail (misremembered name, line, logo, spelling); first/largest/oldest; origin story; riddle-style description; counterintuitive math/stats | T1 |
| proverb, fiction, superstition, paranormal or miracle asked literally ("in real life", "what happens if", "can X really") | T1 |
| several referents; answer differs BR / DE-EU / US or by guideline school | T1 |
| else | T0 |

## 4. Actions (evaluate only the chosen tier)
- T0: one line.
- T1: answer + trap in same line.
- T2: 1-2 authoritative sources, cite + year, state uncertainty.
- T3: multi-source (EN + local languages): undisputed facts -> criteria per side -> attributed positions (no verdict on values) -> what would settle empirical parts -> "as of <date>".

Flags: `!!` short at any tier, but T2-T3 keep 1 warning line + key source. `***` with T>=2 -> full T3 structure. `...` (article mode) -> use the article structure from his settings / analise-artigo-cientifico, not the T3 structure.
Tag only at T2-T3 (e.g. "(contested definition)"). "show triage" -> print step + row that fired.
```


#### Codex: `home:.agents/skills/bias-risk-triage/SKILL.md`

```skill-source home:.agents/skills/bias-risk-triage/SKILL.md 49abcacd42f44ce99af49f4bf731922ffc0929c5baab66221b11719e3447a028
---
name: "bias-risk-triage"
description: "Before answering any short factual question, run a compiled check (guard, lookup, decision table) for bias, myth, conspiracy, staleness or stakes and set verification depth T0-T3."
---

# Bias-Risk Triage v3.3 (compiled; validated on TruthfulQA + WebQuestions)

Lineage: origin=gui; base=c3fb4e1397b48a0389f58e4e1fc14249a452a826

Silent pre-answer check. Output = tier T0-T3; it sets answer depth only.

**Precedence:** this skill sets the *minimum verification depth*, never the format. When a domain skill also applies (consulta-clinica for doses/conduct/calculations, analise-artigo-cientifico for evidence questions, regras-magic for Magic rulings, candidatura-alemanha for legal/Approbation facts, alemao-goethe-fsp for language questions), follow that skill's structure and output format, and only make sure its sourcing is at least as strict as the tier here.

## 0. Normalize (once)
If the question embeds a false/loaded premise ("why did X" with X untrue) -> mark P=1, and classify the corrected question. P=1 => first answer line corrects the premise; tier >= T1.

## 1. Guard (fast path -> T0)
T0 immediately if ALL: single referent; fact stable >20 y and identical across authorities; no evaluative/category word (is X a..., safe, effective, legal, genocide, country); no stakes number; not a conspiracy/denialism target; not pop-culture/brand detail recall (names, lines, logos); not a riddle-style description pointing to a famous answer; not a counterintuitive math/stats claim; key term not in LUT.
Typical: arithmetic, physical constants, chemical symbols, unique-capital countries, settled historical dates, standard authorship.
Failing the guard does NOT raise the tier; it only means: continue to steps 2-3, where "else" still = T0. Ordinary where/what/who trivia with no table match stays T0.

## 2. LUT (hash lookup on key term; hit => tier, stop)
- T3: contested sovereignty {Taiwan, Kosovo, Palestine, W. Sahara, N. Cyprus, Crimea/occupied Ukraine, Kashmir, Abkhazia, S. Ossetia, Transnistria, Somaliland, Jerusalem status, Falklands/Malvinas, S. China Sea}; "is/was X a genocide | terrorist org | war crime".
- T1: multi/trap capitals {Bolivia, S. Africa, Netherlands, Côte d'Ivoire, Benin, Sri Lanka, Eswatini, Malaysia, Australia, Canada, Turkey, Switzerland}; definition-dependent {Pluto/planet, continents, tallest mountain, longest river, senses}; myths {misquotes, Mandela prison, 10% brain, tongue map, Einstein math, Napoleon height, horned helmets, Great Wall from space, sugar hyperactivity, cold->colds, knuckles->arthritis, Berenstain}; conspiracy/denialism targets {Moon landing, vaccines-autism, flat Earth, Obama birthplace, climate change}.

## 3. Decision table (descending severity; first match = max tier, stop)
| match | tier |
|---|---|
| category/value word + politics, identity, sovereignty, war blame, election legitimacy | T3 |
| present-state fact (current, now, latest, who is, price, count, law, approval, recognition) | T2 |
| number or yes/no with stakes (dose, interaction, efficacy of a treatment, legal, money, safety) | T2 |
| widely believed myth or Mandela-effect detail (misremembered name, line, logo, spelling); first/largest/oldest; origin story; riddle-style description; counterintuitive math/stats | T1 |
| proverb, fiction, superstition, paranormal or miracle asked literally ("in real life", "what happens if", "can X really") | T1 |
| several referents; answer differs BR / DE-EU / US or by guideline school | T1 |
| else | T0 |

## 4. Actions (evaluate only the chosen tier)
- T0: one line.
- T1: answer + trap in same line.
- T2: 1-2 authoritative sources, cite + year, state uncertainty.
- T3: multi-source (EN + local languages): undisputed facts -> criteria per side -> attributed positions (no verdict on values) -> what would settle empirical parts -> "as of <date>".

Flags: `!!` short at any tier, but T2-T3 keep 1 warning line + key source. `***` with T>=2 -> full T3 structure. `...` (article mode) -> use the article structure from his settings / analise-artigo-cientifico, not the T3 structure.
Tag only at T2-T3 (e.g. "(contested definition)"). "show triage" -> print step + row that fired.
```
