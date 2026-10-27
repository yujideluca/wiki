---
id: skill-gerar-teste-automatizado
lang: pt-BR
source_hash: 0bf93f2deb37
title: Skill: gerar-teste-automatizado
---

## What it is
A skill "gerar-teste-automatizado" cria e, depois, atualiza a suíte de testes automatizados que caça bugs de verdade em um projeto de software. Sua descrição diz: usar no Claude Code para criar ou atualizar a suíte de testes automatizados caçadora de bugs de um projeto: diagnóstico completo do código, matriz de testes, testes que detectam defeitos reais, verificações de mutação e cobertura. É chamada pela [[skill-revisao-manutencao]] na primeira revisão de um projeto (criar) e nas revisões seguintes (atualizar), e também pode ser pedida diretamente. Não serve para corrigir um único teste que falha ou um bug ([[skill-systematic-debugging]]). Baseia-se em um prompt escrito pelo Giovanni.

## Flow
trigger t1: A primeira revisão de um projeto, uma revisão posterior, ou um pedido direto de suíte de testes caçadora de bugs | [[skill-revisao-manutencao]]
step s1: Decide o modo primeiro: criar ou atualizar
step s2: Analisa todo o código antes de escrever qualquer teste
step s3: Planeja a matriz de testes
step s4: Implementa testes capazes de achar defeitos reais
step s5: Verifica que os testes detectam defeitos, com checagens de mutação e cobertura | [[mutation-check]]
decide d1: Os testes pegam os defeitos injetados?
step s6: Reforça os testes fracos
step s7: Escreve docs/TESTES-AUTOMATIZADOS.md e relata
product p1: Testes nas pastas de teste do projeto
product p2: Um relatório de defeitos achados e riscos residuais, para o Giovanni | [[giovanni]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> d1
d1 -sim-> s7
d1 -não-> s6
s6 -> s7
s7 -> p1
s7 -> p2

## What it does
O objetivo são testes que encontrem erros reais, regressões, entradas inválidas, limites e falhas de integração, e não testes que confirmem o caminho fácil. Nunca edita o código de produção para fazer testes passarem e propõe qualquer correção necessária separadamente.

## How it does it
Um `SKILL.md` em `~/.claude/skills/gerar-teste-automatizado`. O registro `docs/TESTES-AUTOMATIZADOS.md` na raiz do projeto (ou na raiz de um componente com manifesto próprio, como o `tools/pipeline-check` do QuizApp) é a marca de que a suíte existe. Seu papel é "domínio": é dona da suíte de testes caçadora de bugs e do seu registro; remete ao framework de testes, ao catálogo de requisitos e ao CLAUDE.md do próprio projeto, à [[skill-systematic-debugging]] (corrigir um defeito achado) e à [[skill-verification-before-completion]]; é chamada pela [[skill-revisao-manutencao]].

## Where it sits in the pipeline
Chamada pela [[skill-revisao-manutencao]] no passo 4 de toda revisão.

## Who receives its output
O Giovanni (defeitos achados, riscos residuais) e as pastas de teste do projeto.

## Steps
Agir como um engenheiro sênior em testes automatizados e detecção de defeitos.
0. **Decidir o modo primeiro.** *Criar*: `docs/TESTES-AUTOMATIZADOS.md` ainda não existe; fazer diagnóstico completo e depois montar a suíte. *Atualizar*: ele existe; ler o registro e a suíte, achar o que mudou no código, nos requisitos e nas ADRs (architecture decision records) desde o commit "Last reviewed" citado no arquivo e atualizar a matriz e os testes: comportamentos novos ganham casos, os removidos os perdem (com motivo), mutantes que sobreviveram da última vez são retentados; não reescrever o que ainda vale. Usar a linguagem e o framework que o projeto já usa; se não houver, perguntar ao Giovanni. Nunca executar operações destrutivas em bancos de dados ou sistemas externos; nenhum segredo ou dado pessoal em testes ou relatórios.
1. **Analisar antes de escrever qualquer teste.** A estrutura, linguagem, dependências, arquitetura, módulos relevantes e ferramentas de teste já instaladas; os requisitos explícitos, regras de negócio, contratos de funções e formatos de entrada e saída (primeiro o `docs/REQUIREMENTS.md` do projeto); os componentes críticos, dependências externas e principais modos de falha; os testes existentes e as lacunas de cobertura; requisitos ambíguos ou ausentes (não inventar regras: registrar a incerteza e seguir apenas com hipóteses declaradas e justificadas). Manter a arquitetura e os padrões do projeto, salvo razão técnica documentada.
2. **Planejar a matriz de testes.** Ligar cada requisito ou comportamento a casos, escolhidos por risco e poder de achar defeitos, e não por quantidade. Considerar, onde aplicável: cenários normais; classes de equivalência de entradas válidas e inválidas; valores-limite; dados nulos, ausentes, de tipo errado e malformados; casos extremos e combinações; exceções, falha de rede, dependências indisponíveis; estados inválidos e transições proibidas; duplicatas e violações de integridade; regressões; concorrência, idempotência, desempenho e segurança quando no escopo. Sem casos redundantes.
3. **Implementar.** Preferir os frameworks do projeto. Cada teste tem um propósito específico e um nome que descreve o comportamento; monta suas próprias entradas; age; compara com um resultado esperado definido de forma independente do código testado (calculado à mão, a partir do requisito); verifica efeitos colaterais relevantes; e falha com mensagem clara (preparar–agir–verificar). Não chamar código sem verificar o resultado. Não transformar o comportamento atual em oráculo: confrontá-lo com os requisitos. Etiquetar os testes com a convenção do projeto (QuizApp: um comentário `REQ <ID>`). Escolher níveis conforme a necessidade (unitário, integração, ponta a ponta, baseado em propriedades, regressão) e justificar lacunas. Qualidades: determinístico, reproduzível, isolado, baixo acoplamento, manutenível; serviços externos simulados em testes unitários e reais só em testes de integração; sem esperas arbitrárias, dependência de ordem, chamadas à internet ou tempo descontrolado.
4. **Verificar que os testes conseguem detectar defeitos.** Executar os testes novos e investigar toda falha (nunca mudar uma expectativa só para passar). Executar de novo depois de correções reais e rodar a suíte existente em busca de regressões. Quando viável, fazer teste de mutação: plantar falhas controladas e verificar que os testes as pegam, classificando cada sobrevivente como mutante equivalente, irrelevante ou lacuna real. Repetir execuções para confirmar independência e resultados estáveis. Medir cobertura de linhas e de ramos se houver ferramenta; cobertura não é prova de correção.
5. **Restrições.** Não alterar o código de produção para fazer testes passarem; não editar requisitos, dados de referência ou resultados esperados sem motivo verificável; não apagar testes, desativar validações nem enfraquecer verificações para ficar verde. Uma correção de produção necessária é proposta separadamente (defeito, evidência, mudança proposta) e implementada só dentro do escopo autorizado. Nunca afirmar que um teste passou sem executá-lo; declarar toda limitação (ferramenta ausente, ambiente).
6. **Entregar: escrever `docs/TESTES-AUTOMATIZADOS.md` e relatar.** O registro guarda: o resumo da análise e a estratégia; a matriz de testes (requisito, cenário, resultado esperado, prioridade); os arquivos e seus propósitos; os comandos de execução; os resultados reais (executados, passaram, falharam, ignorados); cobertura com a ferramenta e lacunas; defeitos achados (descrição, evidência, impacto, reprodução); limitações e riscos residuais; recomendações; e a linha de cabeçalho `Last reviewed: <sha do commit> <data>` que o modo atualizar lê. Marcar com clareza o que foi observado, o que é inferido e o que é hipótese. Só está pronto quando os testes estão implementados e organizados, os resultados esperados têm base identificável, os comandos de execução estão documentados, os testes foram executados (ou os limites registrados), as falhas foram investigadas e classificadas e os riscos e lacunas estão documentados. Não parar em plano ou exemplos de código. Terminar com "Verified by:".

## Notes

O Codex agora usa a versão mantida separadamente em [[codex-skills]]. A fonte completa abaixo contém as regras de execução do Codex; o procedimento Claude acima continua sendo a versão Claude. Navegador, memória e conexões podem funcionar de formas diferentes.

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/gerar-teste-automatizado/SKILL.md`

```skill-source home:.claude/skills/gerar-teste-automatizado/SKILL.md 5ef692eacb4e55d231aba1007926f683002fd53247ef6043d6be0d73d9ca077e
---
name: gerar-teste-automatizado
description: "Use in Claude Code to create or update the automated bug-finding test suite of a software project: full diagnosis of the code, test matrix, tests that detect real defects, mutation and coverage checks (criar testes automatizados, suíte de testes, buscar bugs). Called by revisao-manutencao on the first review of a project (create) and on later reviews (update); can also be asked for directly. Not for fixing a single failing test or a bug (systematic-debugging)."
---

# Automated bug-finding tests (gerar-teste-automatizado)

Lineage: origin=code; base=none

Interop: role = domain; owns = the bug-finding test suite and its record `docs/TESTES-AUTOMATIZADOS.md`; defers to = the project's existing test framework, requirements catalogue and CLAUDE.md (REQ tags, gate), systematic-debugging (fixing a defect found), verification-before-completion; called by = revisao-manutencao; honors = reply-language rule, work.ask-language, work.test-yourself.

Act as a senior engineer in automated testing and defect detection. The aim is tests that **find real errors, regressions, invalid inputs, boundaries and integration failures**, not tests that confirm the easy path.

## Mode (decide first)
- **Create**: `docs/TESTES-AUTOMATIZADOS.md` does not exist in the project. Full diagnosis, then build the suite. That file is the marker that the suite exists. The record lives at the root of the project; for a component with its own manifest (for example QuizApp's `tools/pipeline-check`) it lives at that component's root, `tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`, and the review checks each component that has one.
- **Update**: it exists. Read it and the suite, find what changed in the code, requirements and ADRs since the "Last reviewed" commit in the file, and bring the matrix and tests up to date: new behaviours get cases, removed ones lose them (with a reason), mutants that survived last time are retried. Do not rewrite what still holds.
Programming language and framework: use what the project already uses; if there is none, ask Giovanni (work.ask-language). Never run destructive operations on databases or external systems; no secrets or personal data in tests or reports.

## 1. Analyse before writing any test
1. Structure, language, dependencies, architecture, relevant modules, test tools already installed.
2. Explicit requirements, business rules, function contracts, input and output formats (the project's `docs/REQUIREMENTS.md` first).
3. Critical components, external dependencies, main failure modes.
4. Existing tests and the gaps in their coverage.
5. Ambiguous or missing requirements: do not invent rules. Record the uncertainty and proceed only on stated, justified hypotheses.
Keep the project's architecture and patterns unless there is a documented technical reason.

## 2. Plan: the test matrix
Map each requirement or behaviour to cases, chosen by risk and defect-finding power, not by count. Consider where applicable: normal scenarios; equivalence classes of valid and invalid input; boundary values; null, missing, wrong-typed and malformed data; extreme cases and combinations; exceptions, network failure, unavailable dependencies; invalid states and forbidden transitions; duplicates and integrity violations; regressions; concurrency, idempotency, performance, security when in scope. No redundant cases.

## 3. Implement
Prefer the project's frameworks. Each test: a specific purpose and a name that describes the behaviour; builds its own inputs; acts; compares with an expected result **defined independently of the code under test** (hand-computed, from the requirement); checks relevant side effects; fails with a clear message. Arrange-Act-Assert. Do not call code without asserting on the result. Do not turn current behaviour into the oracle: confront it with the requirements. Tag tests with the project's convention (QuizApp: `REQ <ID>` comment). Choose levels as needed (unit, integration, end-to-end, property-based, regression) and justify gaps; do not force every level.

Qualities: deterministic, reproducible, isolated, low coupling (public behaviour and contracts), maintainable, external services faked in unit tests and real only in integration tests; no arbitrary waits, order dependence, internet calls, or uncontrolled time.

## 4. Verify the tests can detect defects
1. Run the new tests; investigate every failure. Never change an expectation just to pass.
2. Run again after real fixes; run the existing suite for regressions.
3. When viable, mutation testing: plant controlled faults and check the tests catch them. Classify each survivor: equivalent mutant, irrelevant, or a real gap.
4. Repeat runs to confirm independence and stable results.
5. Measure line and branch coverage if a tool exists. Coverage is not proof of correctness.

## 5. Restrictions
Do not change production code to make tests pass; do not edit requirements, reference data or expected results without a verifiable reason; do not delete tests, disable validations or weaken checks to get green. A needed production fix is **proposed separately** (defect, evidence, proposed change) and implemented only if inside the authorised scope. Never claim a test passed without running it; state every limitation (missing tool, environment).

## 6. Deliver: write `docs/TESTES-AUTOMATIZADOS.md` and report
The record keeps, in the project: analysis summary and strategy; the test matrix (requirement, scenario, expected result, priority); files and purposes; run commands; real results (run, passed, failed, ignored); coverage with tool and gaps; defects found (description, evidence, impact, reproduction); limitations and residual risks; recommendations; and the header line `Last reviewed: <commit sha> <date>` that Update mode reads. Mark clearly what was observed, what is inferred, and what is a hypothesis.

Done only when: tests implemented and organised; expected results have an identifiable basis; run commands documented; tests executed (or limits recorded); failures investigated and classified; risks and gaps documented. Do not stop at a plan or code samples. End with `Verified by:`.
```


#### Codex: `home:.agents/skills/gerar-teste-automatizado/SKILL.md`

````skill-source home:.agents/skills/gerar-teste-automatizado/SKILL.md ad3648f66cccf231e6b3a3d522a6704e48238928825846a4bce7324502efd6b2
---
name: gerar-teste-automatizado
description: "Use in Codex to create or update the automated bug-finding test suite of a software project: full diagnosis of the code, test matrix, tests that detect real defects, mutation and coverage checks (criar testes automatizados, suíte de testes, buscar bugs). Called by revisao-manutencao on the first review of a project (create) and on later reviews (update); can also be asked for directly. Not for fixing a single failing test or a bug (systematic-debugging)."
---

# Automated bug-finding tests (gerar-teste-automatizado)

Lineage: origin=claude; base=sha256:5ef692eacb4e55d231aba1007926f683002fd53247ef6043d6be0d73d9ca077e; adaptation=codex

Interop: role = domain; owns = the bug-finding test suite and its record `docs/TESTES-AUTOMATIZADOS.md`; defers to = the project's existing test framework, requirements catalogue and CLAUDE.md (REQ tags, gate), systematic-debugging (fixing a defect found), verification-before-completion; called by = revisao-manutencao; honors = reply-language rule, work.ask-language, work.test-yourself.

Act as a senior engineer in automated testing and defect detection. The aim is tests that **find real errors, regressions, invalid inputs, boundaries and integration failures**, not tests that confirm the easy path.

## Mode (decide first)
- **Create**: `docs/TESTES-AUTOMATIZADOS.md` does not exist in the project. Full diagnosis, then build the suite. That file is the marker that the suite exists. The record lives at the root of the project; for a component with its own manifest (for example QuizApp's `tools/pipeline-check`) it lives at that component's root, `tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`, and the review checks each component that has one.
- **Update**: it exists. Read it and the suite, find what changed in the code, requirements and ADRs since the "Last reviewed" commit in the file, and bring the matrix and tests up to date: new behaviours get cases, removed ones lose them (with a reason), mutants that survived last time are retried. Do not rewrite what still holds.
Programming language and framework: use what the project already uses; if there is none, ask Giovanni (work.ask-language). Never run destructive operations on databases or external systems; no secrets or personal data in tests or reports.

## 1. Analyse before writing any test
1. Structure, language, dependencies, architecture, relevant modules, test tools already installed.
2. Explicit requirements, business rules, function contracts, input and output formats (the project's `docs/REQUIREMENTS.md` first).
3. Critical components, external dependencies, main failure modes.
4. Existing tests and the gaps in their coverage.
5. Ambiguous or missing requirements: do not invent rules. Record the uncertainty and proceed only on stated, justified hypotheses.
Keep the project's architecture and patterns unless there is a documented technical reason.

## 2. Plan: the test matrix
Map each requirement or behaviour to cases, chosen by risk and defect-finding power, not by count. Consider where applicable: normal scenarios; equivalence classes of valid and invalid input; boundary values; null, missing, wrong-typed and malformed data; extreme cases and combinations; exceptions, network failure, unavailable dependencies; invalid states and forbidden transitions; duplicates and integrity violations; regressions; concurrency, idempotency, performance, security when in scope. No redundant cases.

## 3. Implement
Prefer the project's frameworks. Each test: a specific purpose and a name that describes the behaviour; builds its own inputs; acts; compares with an expected result **defined independently of the code under test** (hand-computed, from the requirement); checks relevant side effects; fails with a clear message. Arrange-Act-Assert. Do not call code without asserting on the result. Do not turn current behaviour into the oracle: confront it with the requirements. Tag tests with the project's convention (QuizApp: `REQ <ID>` comment). Choose levels as needed (unit, integration, end-to-end, property-based, regression) and justify gaps; do not force every level.

Qualities: deterministic, reproducible, isolated, low coupling (public behaviour and contracts), maintainable, external services faked in unit tests and real only in integration tests; no arbitrary waits, order dependence, internet calls, or uncontrolled time.

## 4. Verify the tests can detect defects
1. Run the new tests; investigate every failure. Never change an expectation just to pass.
2. Run again after real fixes; run the existing suite for regressions.
3. When viable, mutation testing: plant controlled faults and check the tests catch them. Classify each survivor: equivalent mutant, irrelevant, or a real gap.
4. Repeat runs to confirm independence and stable results.
5. Measure line and branch coverage if a tool exists. Coverage is not proof of correctness.

## 5. Restrictions
Do not change production code to make tests pass; do not edit requirements, reference data or expected results without a verifiable reason; do not delete tests, disable validations or weaken checks to get green. A needed production fix is **proposed separately** (defect, evidence, proposed change) and implemented only if inside the authorised scope. Never claim a test passed without running it; state every limitation (missing tool, environment).

## 6. Deliver: write `docs/TESTES-AUTOMATIZADOS.md` and report
The record keeps, in the project: analysis summary and strategy; the test matrix (requirement, scenario, expected result, priority); files and purposes; run commands; real results (run, passed, failed, ignored); coverage with tool and gaps; defects found (description, evidence, impact, reproduction); limitations and residual risks; recommendations; and the header line `Last reviewed: <commit sha> <date>` that Update mode reads. Mark clearly what was observed, what is inferred, and what is a hypothesis.

Done only when: tests implemented and organised; expected results have an identifiable basis; run commands documented; tests executed (or limits recorded); failures investigated and classified; risks and gaps documented. Do not stop at a plan or code samples. End with `Verified by:`.


## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
