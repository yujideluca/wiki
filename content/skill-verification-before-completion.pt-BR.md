---
id: skill-verification-before-completion
lang: pt-BR
source_hash: 59d636710c18
title: Skill: verification-before-completion
---

## What it is
A skill "verification-before-completion" é a regra de que a evidência vem antes de qualquer afirmação de que o trabalho está pronto, corrigido ou passando. Sua descrição diz: usar antes de dizer que o trabalho está pronto, corrigido, passando ou completo, e antes de commitar: executar os comandos de verificação e ler a saída primeiro; evidência antes de afirmações. Ela alimenta a linha `Verified by:` que encerra todo relatório ao Giovanni. Foi adaptada das skills de código aberto "superpowers" (versão 7.0.0, licença MIT), sem o hook de inicialização sempre ativo delas. Seu papel é "processo"; remete ao CLAUDE.md do projeto para os passos de build, teste e aparelho e ao [[global-claude-md]] global para os passos finais (`mem use`, `wiki publish`).

## What it does
Antes de dizer "pronto" ou commitar, o Claude precisa executar o comando que prova a afirmação e ler a saída. A linha final "Verified by:" diz então o que foi executado e o que não pôde ser verificado.

## How it does it
Um `SKILL.md` em `~/.claude/skills/verification-before-completion`; o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
Parte do processo de desenvolvimento no Claude Code, usada em todo projeto; vem antes de [[end-of-task]].

## Who receives its output
O Giovanni (o relatório) e o commit.

## Steps
A lei de ferro: nenhuma afirmação de conclusão sem evidência de verificação recente. Se o comando de verificação não foi executado nesta mensagem, não se pode afirmar que passa.
1. **Identificar** qual comando prova a afirmação.
2. **Executar** o comando completo, novo e inteiro.
3. **Ler** a saída toda, conferir o código de saída, contar as falhas.
4. **Verificar** se a saída confirma a afirmação. Se não, dizer o estado real com a evidência; se sim, dizer a afirmação com a evidência.
5. **Só então** fazer a afirmação. Pular qualquer passo não é verificar.

O que conta como prova: "testes passam" exige a saída do comando de teste com 0 falhas (não uma execução anterior nem "deve passar"); "linter limpo" exige saída do linter com 0 erros; "build funciona" exige o código de saída 0 do comando de build (um linter aprovado não é um build); "bug corrigido" exige testar o sintoma original; um teste de regressão exige o ciclo vermelho-verde (escrever, executar e passar, reverter a correção, executar e ver falhar, restaurar, executar e passar); "agente terminou" exige olhar o diff do controle de versão, não o relato do agente; "requisitos atendidos" exige um checklist linha a linha, não apenas testes passando.

Sinais de alerta que significam parar: palavras como "deve", "provavelmente", "parece"; expressar satisfação ("Ótimo!", "Pronto!") antes de verificar; estar prestes a commitar, fazer push ou abrir um pull request sem verificação; confiar no relato de sucesso de um assistente auxiliar; apoiar-se em verificação parcial; "só desta vez"; estar cansado. Desculpas não mudam a regra: confiança não é evidência, um linter não é um compilador e outras palavras não escapam da regra. Vale antes de qualquer afirmação de sucesso, qualquer expressão de satisfação, commits, pull requests, passar à tarefa seguinte e delegar.

## Notes

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/verification-before-completion/SKILL.md`

````skill-source home:.claude/skills/verification-before-completion/SKILL.md e634cc29dba539d72868c7ff66d7e61d77ae7368defd016e34fc080c99ac9ae1
---
name: verification-before-completion
description: "Use in Claude Code before saying work is done, fixed, passing or complete, and before committing: run the verification commands and read their output first; evidence before assertions. Feeds the `Verified by:` line that every done report ends with."
---

# Verification Before Completion

Lineage: origin=code; base=none

Interop: role = process; owns = proof before any success claim; defers to = the project's CLAUDE.md (its build/test/device steps, e.g. QuizApp: adb install, launch, logcat), the global CLAUDE.md (closing steps: mem use, wiki publish); honors = reply-language rule, debug-after-coding.

Adapted from obra/superpowers 7.0.0 (commit bb92a77, MIT, LICENSE in this folder), without its always-on startup hook.

## Overview

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness
````


#### Codex: `home:.agents/skills/verification-before-completion/SKILL.md`

````skill-source home:.agents/skills/verification-before-completion/SKILL.md b32d0130264cd2d225a7832c22c35780a33b8b575f4cdaa794d6c7da9b1f9b27
---
name: verification-before-completion
description: "Use in Codex before saying work is done, fixed, passing or complete, and before committing: run the verification commands and read their output first; evidence before assertions. Feeds the `Verified by:` line that every done report ends with."
---

# Verification Before Completion

Lineage: origin=code; base=none

Interop: role = process; owns = proof before any success claim; defers to = the project's AGENTS.md (its build/test/device steps, e.g. QuizApp: adb install, launch, logcat), the global AGENTS.md (closing steps: mem use, wiki publish); honors = reply-language rule, debug-after-coding.

Adapted from obra/superpowers 7.0.0 (commit bb92a77, MIT, LICENSE in this folder), without its always-on startup hook.

## Overview

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness
````
