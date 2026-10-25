---
id: skill-skill-forge
lang: pt-BR
source_hash: aff6e9fbdcb8
title: Skill: skill-forge
---

## What it is
A skill "skill-forge" é o pipeline completo para criar ou refazer uma skill para o Giovanni. Sua descrição diz: três versões concorrentes, testes, verificações de compatibilidade com as outras skills dele e depois validação e empacotamento pelo skill-creator; usar quando ele pedir para criar, refazer, otimizar ou "forjar" uma skill, transformar uma regra ou fluxo em uma nova skill, ou quiser versões testadas ou comparadas; para pequenas mudanças em uma skill (corrigir uma linha, renomear, mudar a descrição, acrescentar um exemplo) ou só empacotar um arquivo de skill, o skill-creator sozinho basta. Sua filosofia: uma skill é conhecimento especializado codificado, então entender o domínio e o usuário a fundo, projetar uma arquitetura explícita e depois avaliar o resultado contra os requisitos (construir → avaliar → refinar, como na pesquisa em design science).

## What it does
Produz uma skill testada que não colide com as outras skills, configurações ou tarefas agendadas do Giovanni, e propõe atualizações para toda skill que ela afeta.

## How it does it
Um `SKILL.md` em `~/.claude/skills/skill-forge`; o Claude o carrega quando um pedido combina com a descrição. A skill pronta é salva em `~/.claude/skills/<nome>/`, com a página do wiki [[skills]] atualizada como registro.

## Where it sits in the pipeline
É como toda skill nova ou refeita é feita.

## Who receives its output
A pasta [[skills]] (e as cópias do app Claude, [[claude-ai-skills]]).

## Steps
0. **Escolher o modo primeiro.** Uma skill nova, uma refação, "otimizar", "forjar", "testar ou comparar versões" ou uma mudança que altera gatilhos ou a interação com outras skills → o *pipeline completo* (aqui os passos 1–6, depois o skill-creator para validação e empacotamento). Uma pequena edição em uma skill (uma linha, um exemplo, redação, renomear), "só escreva" ou empacotar um SKILL.md existente → *só o skill-creator*, inalterado, seguido de uma mini-verificação de compatibilidade (reler o cabeçalho de interop; executar os passos 3 e 6 da camada de compatibilidade só se a edição tocar gatilhos, formato ou referências cruzadas). A formulação explícita do Giovanni vence ("full forge" ou "quick"); se houver dúvida, declarar o modo assumido em uma linha e seguir.
1. **Análise de requisitos.** Propósito, usuário, situações de gatilho, entradas, saídas e os modos de falha que mais importam (ordenados pelo custo do erro). Ativos existentes: as preferências salvas do usuário, notas da memória, skills sobrepostas (evitar duplicatas; decidir o que pertence às configurações e o que pertence a uma skill). Conhecimento do domínio: o procedimento do especialista como lista de passos, as decisões nele e os fatos ou tabelas de que precisa.
2. **Arquitetura.** Escolher a estrutura conforme o tipo de conhecimento: procedimento com passos frágeis → passos exatos ou um script; julgamento → uma tabela de decisão ou um checklist ordenado; conhecimento de referência → uma tabela de consulta compacta; estilo ou formato → um modelo mais um exemplo. Escrever uma nota de design curta: módulos, ordem, o que vai no SKILL.md e o que vai em referências.
3. **Três versões.** V1 e V2 são duas filosofias de design diferentes e relevantes ao problema (declarar cada uma e por que serve). V3 é uma revisão da literatura do domínio e do design de skills e prompts, escrita como a versão baseada em evidências, incluindo qualquer otimização matemática ou algorítmica de sua lógica (ordem das verificações, curto-circuito, estruturas de consulta, uso mínimo de tokens).
4. **Duas avaliações.** Uma própria: um conjunto de cenários cobrindo os requisitos e os modos de falha ordenados, pontuado com uma rubrica (correção, aderência aos passos, formato de saída, custo em tokens). E uma preexistente: achar por pesquisa um benchmark publicado ou checklist padrão adequado ao propósito e aplicá-lo sem alterações.
5. **Resultados irreproduzíveis (resolução de lacunas).** Quando uma saída discorda de uma resposta esperada, rótulo, verificador ou exemplo do próprio Giovanni e não se consegue explicar o porquê, não registrar ainda como "lacuna conhecida". (i) Fixar a lacuna: dizer exatamente o que difere e listar 2–3 hipóteses para a informação que falta. (ii) Fazer ao usuário perguntas dirigidas, uma rodada de no máximo 3, oferecendo as hipóteses como opções; perguntar só o que ele pode plausivelmente saber. (iii) Pesquisar em paralelo a fonte da resposta esperada e tentar reproduzi-la. (iv) Resolver: codificar a explicação que reproduz o resultado, rotulada com sua fonte ("segundo o usuário", "segundo <documento, ano>" ou "reproduz uma peculiaridade ou bug em <referência>"); se a explicação dele conflita com a evidência, mostrar as duas e deixá-lo decidir. (v) Se continuar sem solução, manter o comportamento mais defensável, sinalizar a lacuna na skill e no relatório e listar a pergunta em aberto para ele.
6. **Camada de compatibilidade (na versão vencedora, antes da entrega).** (a) *Inventário*: ler a tabela de skills da página do wiki [[skills]], depois cada skill dele por inteiro, as preferências salvas e as tarefas agendadas que invocam uma skill; também trabalho ainda não ativo (pendências, propostas de skills esperando). Uma skill pendente conta como existente: estendê-la em vez de criar uma paralela. (b) *Cabeçalho de interop*: uma linha sob o título, `Interop: role = domain | cross-cutting; owns = <formato / fluxo / fatos>; defers to = <skills>; honors = language rule, flags !! *** ...`. Skills de domínio são donas do formato de suas respostas; skills transversais só definem mínimos ou regras de segurança. (c) *Matriz de conflitos* contra cada skill sobreposta em: sobreposição de gatilhos, idioma de resposta e de documentos, flags de profundidade e tamanho da resposta, formato de saída, profundidade de evidência e checagem de datas, ferramentas e ambiente, segurança e ações destrutivas, referências cruzadas (nomes de skills devem existir exatamente) e duplicação de regras sempre ativas que pertencem às configurações. (d) *Resolver por precedência, não copiando regras*: skill de domínio vence skill transversal no formato; a regra mais estrita vence em segurança e fontes; a flag ou mensagem explícita do usuário vence qualquer padrão de skill. (e) *Regressão de roteamento*: refazer uma verificação de roteamento com a lista completa e atual de skills, inclusive as embutidas: cerca de 10 prompts que devem acionar a nova skill, 10 que devem acionar vizinhas, 5 que não devem acionar nenhuma; ajustar descrições até cada prompt cair em exatamente uma skill pretendida. (f) *Propostas de impacto*: para cada skill existente afetada pela mudança, preparar um SKILL.md atualizado completo (lendo antes o arquivo atual inteiro), entregar as mais críticas primeiro e listar as demais como pendentes, escrevendo cada uma em `~/.claude/skills/<nome>/SKILL.md`; as skills sob `~/.claude/skills/synced/` vêm do app Claude e nunca são editadas aqui; skills embutidas não podem ser editadas, então acrescentar a linha de precedência à skill própria dele ou dar-lhe um texto de configuração de uma linha para colar; mudanças em configurações ou prompts de tarefas agendadas são sugeridas como texto exato, nunca aplicadas em silêncio. (g) *Registro*: atualizar a tabela de skills na página do wiki [[skills]] (e suas traduções): uma linha por skill com nome, papel, dona de, remete a, resumo dos gatilhos, última alteração e conflitos conhecidos resolvidos.
7. **Síntese.** Comparar as versões por requisito, escolher a melhor, incorporar elementos claramente superiores das outras se não conflitarem, reverificar a versão combinada contra os cenários próprios e depois executar a camada de compatibilidade.
8. **Entregar (passagem ao skill-creator).** Validar: se o skill-creator estiver disponível, copiar cada pasta de skill final para um caminho temporário e executar sua validação rápida, corrigindo todo erro, e manter o nome original da skill nas atualizações. Salvar (o caminho do Claude Code): escrever o SKILL.md completo em `~/.claude/skills/<nome>/` (mais as atualizações de impacto), depois executar `wiki publish` e `mem use`; a página da skill na wiki é escrita ou atualizada com a [[skill-wiki-page-writer]]; o Claude Code não consegue salvar os cartões de skill do app Claude. Registros: guardar uma nota de design, os resultados das avaliações e o relatório de compatibilidade na página do wiki da skill, listando limitações, lacunas em aberto e propostas de impacto pendentes. Opcionalmente executar o otimizador de descrição do skill-creator na descrição final depois de o Giovanni aprovar a skill, mas só isolado, ou o resultado é inválido: em uma cópia ajustada dos scripts dele, com a sessão `claude -p` aninhada limitada às ferramentas `Skill` e `Read` e às configurações do próprio projeto (para que não possa editar, publicar nem disparar os hooks do Giovanni), com a skill testada não instalada nesse projeto (a cópia instalada seria chamada no lugar do comando temporário) e as outras skills dele copiadas para lá, contando como acionamento a chamada de qualquer comando temporário dessa skill (trabalhadores em paralelo criam comandos idênticos e o modelo escolhe um ao acaso), e comparando a descrição antiga e a nova em perguntas novas quando as notas reservadas empatam.

## Notes

O Codex agora usa a versão mantida separadamente em [[codex-skills]]. A fonte completa abaixo contém as regras de execução do Codex; o procedimento Claude acima continua sendo a versão Claude. Navegador, memória e conexões podem funcionar de formas diferentes.

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/skill-forge/SKILL.md`

```skill-source home:.claude/skills/skill-forge/SKILL.md 7b21118be3e20f1e006bb4b541ab0d8a165e853b80e2ec75da804faf665ed5b0
---
name: "skill-forge"
description: "Full skill pipeline for Giovanni: three competing versions, tests, compatibility checks with his other skills, then validation and packaging through skill-creator. Use when he asks to create, rebuild, optimize or forge a skill, turn a rule or workflow into a new skill, or wants tested or compared versions. For small changes to one skill (fix a line, rename, change the description, add an example) or just packaging a skill file, skill-creator alone is enough."
---


# Skill Forge (knowledge engineering / design science)

Philosophy: a skill is codified expert knowledge. Understand the domain and the user deeply, design an explicit architecture, then evaluate the artifact against requirements (build -> evaluate -> refine, as in design-science research).

## 0. Mode (pick before anything else)
| Request | Mode |
|---|---|
| New skill, rebuild, "optimize", "forge", "test/compare versions", a change that alters triggers or interop with other skills | **Full pipeline:** steps 1-6 here, then skill-creator for validation and packaging (step 6) |
| Small edit to one skill (a line, an example, wording, rename), "just write it", packaging an existing SKILL.md | **skill-creator only**, unchanged; then the compatibility mini-check: re-read the interop header and run 4c steps 3 and 6 only if the edit touches triggers, format or cross-references |
His explicit wording wins ("full forge" or "quick" decides). If unsure, state the assumed mode in one line and proceed.

## 1. Requirements analysis
- Purpose, user, trigger situations, inputs, outputs, failure modes that matter most (rank by cost of error).
- Existing assets: the user's saved preferences, memory notes, other skills that overlap (avoid duplicates; decide what belongs in settings vs skill).
- Domain knowledge: the expert procedure as a step list; the decisions in it; the facts or tables it needs.

## 2. Architecture
Choose the structure from the knowledge type:
- procedure with fragile steps -> exact steps or script;
- judgment -> decision table or ordered checklist;
- reference knowledge -> compact lookup table;
- style/format -> template plus one example.
Write a short design note: modules, order, what is in SKILL.md vs references.

## 3. Three versions
- **V1, V2:** two different design philosophies relevant to this problem (state each and why it fits).
- **V3:** literature review of the domain and of skill/prompt design; write the evidence-based version, including any mathematical or algorithmic optimization of its logic (ordering of checks, short-circuiting, lookup structures, minimal token use).

## 4. Two evaluations
- **Self-built:** a scenario set covering the requirements and the ranked failure modes, scored with a rubric (correctness, adherence to steps, output format, token cost).
- **Pre-existing:** find through research a published benchmark or standard checklist that fits the purpose; apply it unchanged.

## 4b. Unreproducible results (gap resolution)
When an output disagrees with an expected answer, label, verifier or the user's own example and you cannot explain why, do not record it as a "known gap" yet:
1. **Pin the gap:** state exactly what differs (your value vs expected, which case, which step) and list 2-3 hypotheses for the missing information (a definition, filter, convention, data source, version, or an error in the reference).
2. **Ask for complementary explanations:** ask the user targeted questions with AskUserQuestion, one round, at most 3 questions, offering your hypotheses as options (e.g. "Is 'stock' meant to exclude ADRs and class B shares?"; "Where did the expected value come from?"; "Which guideline or version defines this?"). Ask only what the user can plausibly know; never ask him to do the research for you.
3. **Research in parallel:** while waiting, search for the source of the expected answer (reference code, dataset documentation, guideline text, benchmark repository) and try to reproduce it.
4. **Resolve:** encode the explanation that reproduces the result, labelled with its source ("per user", "per <doc, year>", or "reproduces a quirk/bug in <reference>"). If the user's explanation conflicts with the evidence, show both and let him decide.
5. **If still unresolved** (or the session is unattended): keep the most defensible behavior, flag the gap explicitly in the skill and the report, and list the open question for him.

## 4c. Compatibility layer (run on the winning version, before delivery)
Goal: a new or changed skill must not collide with his other skills, settings or scheduled tasks, and every affected skill gets an update proposal.

1. **Inventory.** Read the skills table in the wiki page `skills` (`~/dev/wiki/content/skills.md`). Then read every one of his skills in full (`~/.claude/skills/<name>/SKILL.md`), his saved preferences/settings rules, and scheduled tasks that invoke a skill (CronList, `crontab -l`, `systemctl --user list-timers`). Also read work that is not live yet: open items (`mem search skill`) and skill proposals waiting under `~/.claude/`. A pending skill or a project instruction set counts as existing: extend it instead of building a parallel one.
2. **Interop header.** Give the new skill one line under its title: `Interop: role = domain | cross-cutting; owns = <format / workflow / facts>; defers to = <skills>; honors = language rule, flags !! *** ...`. Domain skills own the format of their answers; cross-cutting skills (e.g. bias-risk-triage, browser-automacao-segura) only set minimums or safety rules and never dictate format.
3. **Conflict matrix.** Compare the new skill against each overlapping skill on these axes and record any clash:
   - trigger overlap (would both load for the same prompt?);
   - reply language and document language;
   - depth flags `!!` `***` `...` and answer length;
   - output format and structure;
   - evidence/sourcing depth and date-checking;
   - tools and environment (built-in browser vs Claude in Chrome, connectors, file locations);
   - safety and destructive actions;
   - cross-references (skills named inside other skills must exist with the exact name);
   - duplication of always-on rules that belong in settings.
4. **Resolve by precedence, not by copying rules:** domain skill > cross-cutting skill for format; stricter rule wins for safety and sourcing; the user's explicit flag or message beats any skill default. Write the precedence line into whichever skill needs it.
5. **Routing regression.** Re-run a routing check with the full, current skill list (including Anthropic's built-in skills such as skill-creator, docs, pdf): about 10 prompts that should trigger the new skill, 10 that should trigger neighbours, 5 that should trigger none. Fix descriptions until each prompt lands on exactly one intended skill.
6. **Impact proposals.** For every existing skill the change affects, prepare a complete updated SKILL.md (read the whole current file first). Deliver them the most critical first and list the rest as pending. Write each complete file to `~/.claude/skills/<name>/SKILL.md`. Skills under `~/.claude/skills/synced/` come from the claude.ai app and are never edited here. Built-in Anthropic skills cannot be edited: add the precedence line to his own skill instead, or give him a one-line settings text to paste. Changes to settings or scheduled-task prompts are suggested as exact text, never applied silently.
7. **Registry.** Update the skills table in the wiki page `skills` (and its `.de` and `.pt-BR` versions): one row per skill (name, role, owns, defers to, trigger summary, last changed, known conflicts resolved). The next forge run starts from it.

## 5. Synthesis
Compare versions per requirement. Pick the best; merge clearly superior elements from the others if they do not conflict. Re-check the merged version against the self-built scenarios, then run 4c.

## 6. Deliver (hand-off to skill-creator)
1. **Validate:** if skill-creator is available, copy each final skill folder to a scratch path and run its `scripts/quick_validate.py` on it; fix every error. Keep the original skill name for updates.
2. **Save (Claude Code route):** write the complete SKILL.md to `~/.claude/skills/<name>/` (plus the impact updates from 4c), then write or update the skill's wiki page with the skill `wiki-page-writer` (its `## Steps` section holds the skill's own rules; `wiki check` fails without it) and run `wiki publish` and `mem use`. Claude Code cannot save claude.ai skill cards.
3. **Records:** save a design note, the evaluation results and the compatibility report in the wiki page of the skill; list limitations, open gaps from 4b and pending impact proposals from 4c.
4. **Optional:** skill-creator's description optimizer (`run_loop.py`, needs `claude -p`) on the final description after he approves the skill. Run it only in isolation, or its score is invalid (found 2026-10-24): on a patched copy of the scripts (never edit the installed skill-creator), the nested `claude -p` runs with `--setting-sources project --tools Skill,Read --strict-mcp-config` so it cannot edit, publish or fire his hooks; the skill under test is NOT installed in that project (the installed copy would be called instead of the temporary command) while his other skills are copied in as project skills; a call to any `<name>-skill-*` command counts as a trigger (parallel workers plant identical commands side by side and the model picks one at random); and when the held-out scores tie, compare the old and the new description on fresh queries before installing either.
```


#### Codex: `home:.agents/skills/skill-forge/SKILL.md`

````skill-source home:.agents/skills/skill-forge/SKILL.md 873c7d2bf32e627ff666875ae577d69bd57e40aae7173c7854a488daeb5eb9da
---
name: "skill-forge"
description: "Full skill pipeline for Giovanni: three competing versions, tests, compatibility checks with his other skills, then validation and packaging through skill-creator. Use when he asks to create, rebuild, optimize or forge a skill, turn a rule or workflow into a new skill, or wants tested or compared versions. For small changes to one skill (fix a line, rename, change the description, add an example) or just packaging a skill file, skill-creator alone is enough."
---

Lineage: origin=claude; adaptation=codex; baseline recorded in manifest.json.



# Skill Forge (knowledge engineering / design science)

Philosophy: a skill is codified expert knowledge. Understand the domain and the user deeply, design an explicit architecture, then evaluate the artifact against requirements (build -> evaluate -> refine, as in design-science research).

## 0. Mode (pick before anything else)
| Request | Mode |
|---|---|
| New skill, rebuild, "optimize", "forge", "test/compare versions", a change that alters triggers or interop with other skills | **Full pipeline:** steps 1-6 here, then skill-creator for validation and packaging (step 6) |
| Small edit to one skill (a line, an example, wording, rename), "just write it", packaging an existing SKILL.md | **skill-creator only**, unchanged; then the compatibility mini-check: re-read the interop header and run 4c steps 3 and 6 only if the edit touches triggers, format or cross-references |
His explicit wording wins ("full forge" or "quick" decides). If unsure, state the assumed mode in one line and proceed.

## 1. Requirements analysis
- Purpose, user, trigger situations, inputs, outputs, failure modes that matter most (rank by cost of error).
- Existing assets: the user's saved preferences, memory notes, other skills that overlap (avoid duplicates; decide what belongs in settings vs skill).
- Domain knowledge: the expert procedure as a step list; the decisions in it; the facts or tables it needs.

## 2. Architecture
Choose the structure from the knowledge type:
- procedure with fragile steps -> exact steps or script;
- judgment -> decision table or ordered checklist;
- reference knowledge -> compact lookup table;
- style/format -> template plus one example.
Write a short design note: modules, order, what is in SKILL.md vs references.

## 3. Three versions
- **V1, V2:** two different design philosophies relevant to this problem (state each and why it fits).
- **V3:** literature review of the domain and of skill/prompt design; write the evidence-based version, including any mathematical or algorithmic optimization of its logic (ordering of checks, short-circuiting, lookup structures, minimal token use).

## 4. Two evaluations
- **Self-built:** a scenario set covering the requirements and the ranked failure modes, scored with a rubric (correctness, adherence to steps, output format, token cost).
- **Pre-existing:** find through research a published benchmark or standard checklist that fits the purpose; apply it unchanged.

## 4b. Unreproducible results (gap resolution)
When an output disagrees with an expected answer, label, verifier or the user's own example and you cannot explain why, do not record it as a "known gap" yet:
1. **Pin the gap:** state exactly what differs (your value vs expected, which case, which step) and list 2-3 hypotheses for the missing information (a definition, filter, convention, data source, version, or an error in the reference).
2. **Ask for complementary explanations:** ask the user targeted questions with the available user-input tool, one round, at most 3 questions, offering your hypotheses as options (e.g. "Is 'stock' meant to exclude ADRs and class B shares?"; "Where did the expected value come from?"; "Which guideline or version defines this?"). Ask only what the user can plausibly know; never ask him to do the research for you.
3. **Research in parallel:** while waiting, search for the source of the expected answer (reference code, dataset documentation, guideline text, benchmark repository) and try to reproduce it.
4. **Resolve:** encode the explanation that reproduces the result, labelled with its source ("per user", "per <doc, year>", or "reproduces a quirk/bug in <reference>"). If the user's explanation conflicts with the evidence, show both and let him decide.
5. **If still unresolved** (or the session is unattended): keep the most defensible behavior, flag the gap explicitly in the skill and the report, and list the open question for him.

## 4c. Compatibility layer (run on the winning version, before delivery)
Goal: a new or changed skill must not collide with his other skills, settings or scheduled tasks, and every affected skill gets an update proposal.

1. **Inventory.** Read the skills table in the wiki page `skills` (`~/dev/wiki/content/skills.md`). Then read every one of his skills in full (`~/.agents/skills/<name>/SKILL.md`), his saved preferences/settings rules, and scheduled tasks that invoke a skill (available scheduling tools, `crontab -l`, `systemctl --user list-timers`). Also read work that is not live yet: open items (`mem search skill`) and Codex skill proposals and the repository manifest. A pending skill or a project instruction set counts as existing: extend it instead of building a parallel one.
2. **Interop header.** Give the new skill one line under its title: `Interop: role = domain | cross-cutting; owns = <format / workflow / facts>; defers to = <skills>; honors = language rule, flags !! *** ...`. Domain skills own the format of their answers; cross-cutting skills (e.g. bias-risk-triage, browser-automacao-segura) only set minimums or safety rules and never dictate format.
3. **Conflict matrix.** Compare the new skill against each overlapping skill on these axes and record any clash:
   - trigger overlap (would both load for the same prompt?);
   - reply language and document language;
   - depth flags `!!` `***` `...` and answer length;
   - output format and structure;
   - evidence/sourcing depth and date-checking;
   - tools and environment (built-in browser vs the available browser tool, connectors, file locations);
   - safety and destructive actions;
   - cross-references (skills named inside other skills must exist with the exact name);
   - duplication of always-on rules that belong in settings.
4. **Resolve by precedence, not by copying rules:** domain skill > cross-cutting skill for format; stricter rule wins for safety and sourcing; the user's explicit flag or message beats any skill default. Write the precedence line into whichever skill needs it.
5. **Routing regression.** Re-run a routing check with the full, current skill list (including Anthropic's built-in skills such as skill-creator, docs, pdf): about 10 prompts that should trigger the new skill, 10 that should trigger neighbours, 5 that should trigger none. Fix descriptions until each prompt lands on exactly one intended skill.
6. **Impact proposals.** For every existing skill the change affects, prepare a complete updated SKILL.md (read the whole current file first). Deliver them the most critical first and list the rest as pending. Write complete managed files under `~/dev/codex-skills/skills/<name>/SKILL.md`; update a non-managed Codex skill only in its actual writable location. Skills under `~/.agents/skills/synced/` come from the claude.ai app and are never edited here. Built-in Anthropic skills cannot be edited: add the precedence line to his own skill instead, or give him a one-line settings text to paste. Changes to settings or scheduled-task prompts are suggested as exact text, never applied silently.
7. **Registry.** Update the skills table in the wiki page `skills` (and its `.de` and `.pt-BR` versions): one row per skill (name, role, owns, defers to, trigger summary, last changed, known conflicts resolved). The next forge run starts from it.

## 5. Synthesis
Compare versions per requirement. Pick the best; merge clearly superior elements from the others if they do not conflict. Re-check the merged version against the self-built scenarios, then run 4c.

## 6. Deliver (hand-off to skill-creator)
1. **Validate:** if skill-creator is available, copy each final skill folder to a scratch path and run its `scripts/quick_validate.py` on it; fix every error. Keep the original skill name for updates.
2. **Save (Codex route):** write the complete SKILL.md to its owned Codex repository folder (managed adaptations: `~/dev/codex-skills/skills/<name>/`) (plus the impact updates from 4c), then write or update the skill's wiki page with the skill `wiki-page-writer` (its `## Steps` section holds the skill's own rules; `wiki check` fails without it) and run `wiki publish` and `mem use`. Codex cannot save claude.ai skill cards.
3. **Records:** save a design note, the evaluation results and the compatibility report in the wiki page of the skill; list limitations, open gaps from 4b and pending impact proposals from 4c.
4. **Optional evaluation tooling:** use an actual supported runner only when requested and available. Do not translate Claude command names or flags into guessed Codex flags. Prefer an independent read-only subagent evaluation when available under the current delegation rules; give it the skill and realistic cases, not expected answers. Never install a skill into an evaluator that is meant to test a temporary version. Report routing results as manual or observed; structural validation is not a measured routing score.

## Codex ownership

Managed adaptations live in ~/dev/codex-skills/skills and are linked into ~/.agents/skills. Edit the repository source, validate, seal fingerprints and install through tools/skillsctl.py. Do not write through synced source copies or edit ~/.claude. Inspect the actual skill catalog (including bundled and plugin skills); do not assume Claude built-ins are present. Existing project guides named CLAUDE.md remain valid fallback references; prefer AGENTS.md where provided. For wiki updates, the tree guard takes precedence over registry or publication steps; stage a proposal in this project's docs/wiki if the target pages are occupied.
````
