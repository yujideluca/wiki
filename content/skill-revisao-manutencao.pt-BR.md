---
id: skill-revisao-manutencao
lang: pt-BR
source_hash: 9b811c76642d
title: Skill: revisao-manutencao
---

## What it is
A skill "revisao-manutencao" ("revisão de manutenção") é a metade que julga da [[maintenance-pipeline]]: lê o que o [[pipeline-check]] mediu e propõe o que fazer a respeito. Sua descrição diz: usar no Claude Code para a revisão mensal de arquitetura dos projetos de software do Giovanni (uma pendência na memória) e ao fim de uma tarefa em um projeto de software (revisão mensal, revisão de manutenção, dívida técnica, debt, pipeline-check, report.json); executa o pipeline-check, lê o `report.json` dele, propõe issues de dívida P1–P3 e uma linha Preventiva no registro de decisões; não serve para escrever código, para um único bug nem para trabalho fora de software. Seu princípio: o programa mede, a skill julga (decisão ADR-0013; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). Ela propõe e nunca decide.

## What it does
Executa `tools/pipeline-check.sh`, lê o `report.json` e nunca mede de novo. Para cada aviso ou falha propõe uma issue `debt` com prioridade. Depois verifica o que uma máquina não vê, acrescenta uma linha Preventiva ao registro de decisões de cada projeto revisado, chama a [[skill-gerar-teste-automatizado]] (criar na primeira revisão, atualizar depois) e termina com `mem use`, `wiki publish` e "Verified by:". Nunca fecha issues, muda um limite, promove uma versão nem altera a proteção de branch, e não cria issues sem o ok do Giovanni.

## How it does it
Um `SKILL.md` em `~/.claude/skills/revisao-manutencao`. É disparada pela pendência da revisão mensal no workflow-memory e ao fim de uma tarefa em um projeto de software. Seu papel é "processo"; remete ao `pipeline-check` para toda medição, à [[skill-gerar-teste-automatizado]], à [[skill-verification-before-completion]] e ao checklist `~/dev/project-template/docs/MAINTENANCE.md`.

## Where it sits in the pipeline
Executa a [[monthly-architecture-review]] e a revisão de fim de tarefa de todo projeto de software.

## Who receives its output
O Giovanni (propostas e decisões) e o registro de decisões de cada projeto.

## Steps
Nunca medir à mão: nada de `wc`, de contar com `git log`, nem de reexecutar o portão para ver um número. Se um número faltar no `report.json`, dizer isso e propor uma verificação para o `pipeline-check.toml`. Sem a palavra explícita do Giovanni, não fechar issues, mudar um limite, promover uma versão, criar ou editar proteção de branch nem criar issues (a proposta é uma lista; criá-las depois do ok). Por projeto (na revisão mensal: todo projeto em `~/dev` e o repositório do programa `pipeline-check` em si):
1. **Executar e ler.** Executar `tools/pipeline-check.sh` no projeto (modo local), depois ler `build/pipeline-check/report.json` e citar o modo que rodou. Uma verificação marcada `pulado` (ignorada) é um buraco na evidência: listá-la em "não foi possível verificar", nunca tratá-la como ok. Projeto sem `pipeline-check.toml`: dizer isso, propor acrescentá-lo a partir do modelo e parar nesse projeto. Verificar também os padrões que nenhuma ferramenta mede (olhar, não contar): toda pasta de projeto é um repositório git com remoto no GitHub (uma pasta sem isso é uma proposta P2 "colocar sob controle de versão"); `git config core.hooksPath` é `tools/hooks` onde existe um hook pre-push (o substituto local da proteção de branch); o `pipeline-check.version` fixado é a tag mais nova de `yujideluca/pipeline-check` (atrás = P3 "atualizar depois que o portão passar"); e nenhum script é copiado entre projetos (o mesmo nome de arquivo em dois projetos é um P2 "mover para repositório próprio e consumir por versão").
2. **Uma proposta por `aviso` (alerta) ou `falha`.** Título, evidência (id da verificação, valor, limite, nota), rótulo `debt` e uma prioridade. **P1**: risco de perda de dados ou resultados errados (portão ou verificação de arquitetura reprovados que protegem dados ou agendamento, CI (integração contínua) vermelha, branch sem proteção). **P2**: atrasa toda mudança ou engana o usuário (um aviso em 90 % do limite ou mais, incluindo a verificação de tempo do portão). **P3**: desejável (um aviso entre a parcela de aviso e 90 % do limite, cosmético). Uma `falha` nunca fica abaixo de P2. Uma verificação ignorada cujo assunto seria P1 se falhasse (CI, proteção de branch, portão) não é uma falha, mas propor um item P2 "tornar esta evidência disponível" (por exemplo instalar ou fazer login no `gh`, a ferramenta de linha de comando do GitHub). Conferir unidades por id: `gate` é em segundos, sem limite; o limite de tempo está em `gate-segundos`. Verificar antes as issues existentes (`gh issue list --label debt`) para não propor a mesma dívida duas vezes; se o `gh` não estiver disponível, dizer que duplicatas não puderam ser verificadas. Um P1 com mais de um mês é agendado agora. Apresentar uma tabela: título da issue | prioridade | evidência | correção proposta.
3. **O que a máquina não vê** (ler, não medir): os diagramas do DESIGN.md e as ADRs correspondem ao código (nomear cada divergência com arquivo e seção)? Toda mudança estrutural desde a última revisão tem uma ADR (comparar linhas do registro de decisões e assuntos do git log desde a última linha Preventiva "Monthly architecture review")? O mesmo problema foi resolvido duas vezes em projetos diferentes (então propor levar a melhor solução para `~/dev/project-template`)? O bloco de métricas de entrega (DORA, DevOps Research and Assessment): retrabalho crescente, ou parcela preventiva muito abaixo de 20 %, é motivo para agendar a principal dívida; dizer isso, não agir.
4. **Teste caçador de bugs.** Procurar `docs/TESTES-AUTOMATIZADOS.md` no projeto. Ausente → é a primeira revisão: fazer um diagnóstico completo e chamar a [[skill-gerar-teste-automatizado]] no modo criar. Presente → chamá-la no modo atualizar. Isso escreve arquivos de teste, então avisar o Giovanni antes e dar o plano.
5. **Registro de decisões.** Acrescentar uma linha Preventiva "Monthly architecture review" (ou "Maintenance review" no fim de uma tarefa) ao registro de decisões do DESIGN.md de cada projeto revisado, a mais nova primeiro, com a data de hoje, a data e o modo do relatório, as contagens (falhas, avisos, ignoradas, propostas) e onde estão as propostas (números das issues, depois de criadas; senão "propostas listadas na resposta da revisão, ainda não criadas"). Escrever a linha depois de o Giovanni ver as propostas; usar as colunas do projeto Data | Tipo | Decisão | Por quê; atualizar "Last updated"; nenhuma outra edição do DESIGN.md sem a concordância do Giovanni.
6. **Encerrar.** `mem use REF --note "como"` para as entradas que influenciaram a revisão (a pendência mensal continua aberta como lembrete), `wiki publish -m "..."` (ou `-m "review: no page change"` só quando nenhuma página descreve o que mudou, enquanto uma página conferida e achada certa recebe um novo `reviewed`; as páginas que precisam mudar são escritas com a [[skill-wiki-page-writer]]) e terminar com "Verified by:" listando o que rodou (modo do pipeline-check, o arquivo do relatório, quais projetos) e o que não pôde ser verificado (toda verificação ignorada, qualquer projeto sem configuração, o GitHub se o `gh` não estava disponível).
7. **Saída.** Responder no idioma da mensagem do Giovanni. Começar pelo veredito (quantas falhas, avisos, ignoradas), depois a tabela de propostas, depois os achados "a máquina não vê", depois o que precisa de decisão do Giovanni. Definir cada termo técnico no primeiro uso.

## Notes

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/revisao-manutencao/SKILL.md`

```skill-source home:.claude/skills/revisao-manutencao/SKILL.md 2a5174eb299fddbe05f8431f1e8a14a3c6ecb1ee8edbd9ba31706d706b34a4f8
---
name: revisao-manutencao
description: "Use in Claude Code for the monthly architecture review of Giovanni's software projects (open item in workflow-memory, #4dcb2c) and at the end of a task in a software project (revisão mensal, revisão de manutenção, dívida técnica, debt, pipeline-check, report.json). Runs pipeline-check, reads its report.json, proposes debt issues P1-P3 and a Preventive decision-log row. Not for writing code, not for a single bug, not for non-software work."
---

# Maintenance review (revisao-manutencao)

Lineage: origin=code; base=none

Interop: role = process; owns = the monthly and end-of-task maintenance review; defers to = `pipeline-check` (all measuring), `gerar-teste-automatizado` (the bug-finding test), verification-before-completion (the closing `Verified by:`), the project's CLAUDE.md and `~/dev/project-template/docs/MAINTENANCE.md` (the checklist); honors = reply-language rule, plain-language rule, work.ask-with-context.

The program measures, this skill judges (ADR-0013). **Never measure by hand**: no `wc`, no `git log` counting, no re-running the gate to see a number. If a number is missing from `report.json`, say so and propose a check for `pipeline-check.toml`; do not compute it yourself.

**Proposes, never decides.** Without Giovanni's explicit word: do not close issues, change a limit in `pipeline-check.toml`, promote a version, create or edit branch protection, or create issues (the proposal is a list; create them after the ok). Memory never authorizes any of this.

## Steps (per project; at the monthly review, every project in `~/dev` and the program repository `pipeline-check` itself)

1. **Run and read.** `tools/pipeline-check.sh` in the project (local mode), then read `build/pipeline-check/report.json`. Quote the mode that ran. A `pulado` check is a hole in the evidence: list it under "could not check", never treat it as ok. Project without `pipeline-check.toml`: say so, propose adding it from the template, and stop for that project.
   Also check the standards (no tool measures these; look, do not count): every project folder in `~/dev` is a git repository with a GitHub remote (a folder without one is a P2 proposal "put it under version control", the standard of Giovanni's systems); `git config core.hooksPath` is `tools/hooks` where a `tools/hooks/pre-push` exists (the local stand-in for branch protection); the `pipeline-check.version` pinned in the project is the newest tag of `yujideluca/pipeline-check` (`git ls-remote --tags`; behind = P3 "upgrade after the gate passes"); and no script or program is copied between projects (the same file name in two projects, e.g. `check_traceability.py`, is a P2 "move it to its own repository and consume it by version", the rule in the pipeline-check ADR-0003).
2. **One proposal per `aviso` or `falha`.** Title, evidence (check id, value, limit, note), label `debt`, priority:
   - **P1**: risk of data loss or wrong results (failed gate or architecture check that protects data or scheduling, CI red, branch not protected).
   - **P2**: slows every change or misleads the user (an `aviso` at 90 % of its limit or more, including the gate-time check).
   - **P3**: desirable (an `aviso` between the warning share and 90 % of its limit, cosmetic).
   A `falha` is never below P2. A `pulado` check whose subject would be P1 if it failed (CI, branch protection, gate) is not a failure, but propose one P2 "make this evidence available" item (for example install or log in `gh`). Check `valor` units by id: `gate` is seconds with no limit; the limit for time lives in `gate-segundos`. Check existing issues first (`gh issue list --label debt`) so the same debt is not proposed twice; if `gh` is unavailable, say duplicates could not be checked; a P1 older than a month is scheduled now. Format the list as a table: issue title | priority | evidence | proposed fix.
3. **What the machine cannot see** (read, do not measure):
   - Do `DESIGN.md` diagrams and the ADRs match the code? Name each mismatch with file and section.
   - Does every structural change since the last review have an ADR? Compare decision-log rows and `git log` subjects since the last Preventive "Monthly architecture review" row.
   - Was the same problem solved twice in different projects? If so, propose moving the better solution into `~/dev/project-template`.
   - The DORA block: rising `retrabalho`, or `parcela_preventiva` far below 20 %, is a reason to schedule top debt; say it, do not act on it.
4. **Bug-finding test.** Look for `docs/TESTES-AUTOMATIZADOS.md` in the project. (The program `pipeline-check` is its own repository and is reviewed as its own project, with its own record, in update mode.) Missing: this is the first review, so do a full diagnosis of the code and call the skill `gerar-teste-automatizado` in **create** mode. Present: call it in **update** mode (it checks the test against what was implemented since). This writes test files, so tell Giovanni first and give the plan.
5. **Decision log.** Add a Preventive row "Monthly architecture review" (or "Maintenance review" at end of task) to each reviewed project's `DESIGN.md` decision log, newest first, with **today's date** (not the report's), the report's date and mode, the counts (falhas, avisos, pulados, proposals) and where the proposals live (issue numbers once Giovanni has had them created, otherwise "proposals listed in the review reply, not yet created"). Write the row after Giovanni has seen the proposals; use the columns Date | Type | Decision | Why of the project's table. Bump "Last updated". Only that row; no other `DESIGN.md` edits unless Giovanni agrees.
6. **Close.** `mem use REF --note "how"` for the entries that shaped the review (the monthly item stays open as the reminder), `wiki publish -m "..."` as the global CLAUDE.md requires (when pages need changing, write them with the skill `wiki-page-writer`, which also guards against publishing someone else's uncommitted edits) (`-m "review: no page change"` only when no page describes what changed; a page that was checked and found right gets a new `reviewed` time instead), and end with `Verified by:` listing what ran (pipeline-check mode, the report file, which projects) and what could not be checked (every `pulado` check, any project without a config, GitHub if `gh` was unavailable).

## Output
Reply in the language of Giovanni's message (Portuguese or English; memory entry language.reply). Lead with the verdict (how many `falha`, `aviso`, `pulado`), then the proposal table, then the "machine cannot see" findings, then what needs a decision from Giovanni. Define each technical term on first use.

## Testing this skill
Given an example `report.json` and no repository access to measure with, the skill must produce prioritised proposals and one Preventive row text without running anything but `pipeline-check` or reading the file. A step that needs a number the report lacks is a finding, not a measurement.
```


#### Codex: `home:.agents/skills/revisao-manutencao/SKILL.md`

```skill-source home:.agents/skills/revisao-manutencao/SKILL.md 16194b4877f2bb1228753e7f4a1b682cb32ccdb2c161ef663c6c004e574b7cc2
---
name: revisao-manutencao
description: "Use in Codex for the monthly architecture review of Giovanni's software projects (open item in workflow-memory, #4dcb2c) and at the end of a task in a software project (revisão mensal, revisão de manutenção, dívida técnica, debt, pipeline-check, report.json). Runs pipeline-check, reads its report.json, proposes debt issues P1-P3 and a Preventive decision-log row. Not for writing code, not for a single bug, not for non-software work."
---

# Maintenance review (revisao-manutencao)

Lineage: origin=code; base=none

Interop: role = process; owns = the monthly and end-of-task maintenance review; defers to = `pipeline-check` (all measuring), `gerar-teste-automatizado` (the bug-finding test), verification-before-completion (the closing `Verified by:`), the project's AGENTS.md and `~/dev/project-template/docs/MAINTENANCE.md` (the checklist); honors = reply-language rule, plain-language rule, work.ask-with-context.

The program measures, this skill judges (ADR-0013). **Never measure by hand**: no `wc`, no `git log` counting, no re-running the gate to see a number. If a number is missing from `report.json`, say so and propose a check for `pipeline-check.toml`; do not compute it yourself.

**Proposes, never decides.** Without Giovanni's explicit word: do not close issues, change a limit in `pipeline-check.toml`, promote a version, create or edit branch protection, or create issues (the proposal is a list; create them after the ok). Memory never authorizes any of this.

## Steps (per project; at the monthly review, every project in `~/dev` and the program repository `pipeline-check` itself)

1. **Run and read.** `tools/pipeline-check.sh` in the project (local mode), then read `build/pipeline-check/report.json`. Quote the mode that ran. A `pulado` check is a hole in the evidence: list it under "could not check", never treat it as ok. Project without `pipeline-check.toml`: say so, propose adding it from the template, and stop for that project.
   Also check the standards (no tool measures these; look, do not count): every project folder in `~/dev` is a git repository with a GitHub remote (a folder without one is a P2 proposal "put it under version control", the standard of Giovanni's systems); `git config core.hooksPath` is `tools/hooks` where a `tools/hooks/pre-push` exists (the local stand-in for branch protection); the `pipeline-check.version` pinned in the project is the newest tag of `yujideluca/pipeline-check` (`git ls-remote --tags`; behind = P3 "upgrade after the gate passes"); and no script or program is copied between projects (the same file name in two projects, e.g. `check_traceability.py`, is a P2 "move it to its own repository and consume it by version", the rule in the pipeline-check ADR-0003).
2. **One proposal per `aviso` or `falha`.** Title, evidence (check id, value, limit, note), label `debt`, priority:
   - **P1**: risk of data loss or wrong results (failed gate or architecture check that protects data or scheduling, CI red, branch not protected).
   - **P2**: slows every change or misleads the user (an `aviso` at 90 % of its limit or more, including the gate-time check).
   - **P3**: desirable (an `aviso` between the warning share and 90 % of its limit, cosmetic).
   A `falha` is never below P2. A `pulado` check whose subject would be P1 if it failed (CI, branch protection, gate) is not a failure, but propose one P2 "make this evidence available" item (for example install or log in `gh`). Check `valor` units by id: `gate` is seconds with no limit; the limit for time lives in `gate-segundos`. Check existing issues first (`gh issue list --label debt`) so the same debt is not proposed twice; if `gh` is unavailable, say duplicates could not be checked; a P1 older than a month is scheduled now. Format the list as a table: issue title | priority | evidence | proposed fix.
3. **What the machine cannot see** (read, do not measure):
   - Do `DESIGN.md` diagrams and the ADRs match the code? Name each mismatch with file and section.
   - Does every structural change since the last review have an ADR? Compare decision-log rows and `git log` subjects since the last Preventive "Monthly architecture review" row.
   - Was the same problem solved twice in different projects? If so, propose moving the better solution into `~/dev/project-template`.
   - The DORA block: rising `retrabalho`, or `parcela_preventiva` far below 20 %, is a reason to schedule top debt; say it, do not act on it.
4. **Bug-finding test.** Look for `docs/TESTES-AUTOMATIZADOS.md` in the project. (The program `pipeline-check` is its own repository and is reviewed as its own project, with its own record, in update mode.) Missing: this is the first review, so do a full diagnosis of the code and call the skill `gerar-teste-automatizado` in **create** mode. Present: call it in **update** mode (it checks the test against what was implemented since). This writes test files, so tell Giovanni first and give the plan.
5. **Decision log.** Add a Preventive row "Monthly architecture review" (or "Maintenance review" at end of task) to each reviewed project's `DESIGN.md` decision log, newest first, with **today's date** (not the report's), the report's date and mode, the counts (falhas, avisos, pulados, proposals) and where the proposals live (issue numbers once Giovanni has had them created, otherwise "proposals listed in the review reply, not yet created"). Write the row after Giovanni has seen the proposals; use the columns Date | Type | Decision | Why of the project's table. Bump "Last updated". Only that row; no other `DESIGN.md` edits unless Giovanni agrees.
6. **Close.** `mem use REF --note "how"` for the entries that shaped the review (the monthly item stays open as the reminder), `wiki publish -m "..."` as the global AGENTS.md requires (when pages need changing, write them with the skill `wiki-page-writer`, which also guards against publishing someone else's uncommitted edits) (`-m "review: no page change"` only when no page describes what changed; a page that was checked and found right gets a new `reviewed` time instead), and end with `Verified by:` listing what ran (pipeline-check mode, the report file, which projects) and what could not be checked (every `pulado` check, any project without a config, GitHub if `gh` was unavailable).

## Output
Reply in the language of Giovanni's message (Portuguese or English; memory entry language.reply). Lead with the verdict (how many `falha`, `aviso`, `pulado`), then the proposal table, then the "machine cannot see" findings, then what needs a decision from Giovanni. Define each technical term on first use.

## Testing this skill
Given an example `report.json` and no repository access to measure with, the skill must produce prioritised proposals and one Preventive row text without running anything but `pipeline-check` or reading the file. A step that needs a number the report lacks is a finding, not a measurement.
```
