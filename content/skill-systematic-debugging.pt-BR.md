---
id: skill-systematic-debugging
lang: pt-BR
source_hash: dc8e53a458be
title: Skill: systematic-debugging
---

## What it is
A skill "systematic-debugging" é a disciplina que o Claude segue em qualquer bug, teste que falha, travamento ou comportamento inesperado (em código, scripts, no pipeline de sincronização ou em um app no celular), antes de propor uma correção: achar primeiro a causa raiz, mudar uma coisa de cada vez e parar depois de três correções que falharam. A descrição diz que não serve para consertar o desktop Kubuntu ([[skill-reparo-kubuntu]]). Foi adaptada das skills de código aberto "superpowers" (versão 7.0.0, licença MIT), sem o hook de inicialização sempre ativo delas. Seu papel é "processo"; remete à [[skill-reparo-kubuntu]] para problemas de sistema, ao [[workflow-memory]] para registrar uma correção duradoura e ao CLAUDE.md do projeto.

## What it does
Proíbe adivinhar. Seu princípio central: sempre achar a causa raiz antes de tentar correções; correções de sintoma são fracasso. Sob pressão de tempo, quando uma correção "parece óbvia" ou depois que uma primeira falhou, o processo é o que mais importa.

## How it does it
Um `SKILL.md` em `~/.claude/skills/systematic-debugging` (com notas de apoio sobre rastreamento de causa raiz, defesa em profundidade e espera baseada em condição); o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
Parte do processo de desenvolvimento no Claude Code, usada em todo projeto.

## Who receives its output
O Claude, enquanto corrige; a correção passa então pela [[skill-verification-before-completion]].

## Steps
A lei de ferro: nenhuma correção sem antes investigar a causa raiz. Quatro fases, cada uma concluída antes da próxima.
1. **Fase 1, causa raiz.** Ler mensagens de erro e stack traces por inteiro (anotar números de linha, caminhos de arquivo, códigos de erro). Reproduzir o problema de forma consistente: passos exatos, toda vez; se não reproduz, juntar mais dados em vez de adivinhar. Conferir mudanças recentes (git diff, novas dependências, configuração, ambiente). Num sistema com vários componentes (por exemplo integração contínua (CI) → build → assinatura), acrescentar saídas de diagnóstico em cada fronteira, executar uma vez e ver onde os dados se corrompem antes de investigar esse componente. Rastrear valores ruins de trás para frente na cadeia de chamadas até a origem e corrigir na origem.
2. **Fase 2, padrão.** Achar código parecido que funciona na mesma base de código; ler por inteiro qualquer implementação de referência; listar toda diferença entre o que funciona e o que quebra, por menor que seja; entender dependências, configurações e suposições.
3. **Fase 3, hipótese.** Formular uma hipótese ("acho que X é a causa raiz porque Y"), escrevê-la, testá-la com a menor mudança possível, uma variável por vez. Se funcionou, seguir; se não, formar uma nova hipótese e não empilhar mais correções. Quando algo não for entendido, dizer.
4. **Fase 4, implementação.** Primeiro escrever um teste que falha e reproduz o bug (um teste automatizado no setup do próprio projeto ou um script avulso). Fazer uma única correção para a causa raiz, sem melhorias "já que estou aqui". Verificar: o teste passa, nada mais quebrou, o problema foi mesmo resolvido (usando a [[skill-verification-before-completion]]).
5. **Três correções que falharam significa parar.** Contar as tentativas. Abaixo de três, voltar à fase 1 com a nova informação. Com três ou mais, questionar a arquitetura: cada correção revela novo acoplamento em outro lugar, exige refatoração enorme ou cria novos sintomas? Conversar com o Giovanni antes de uma quarta tentativa.
6. **Sinais de alerta que significam "voltar à fase 1".** "Correção rápida agora, investigo depois"; "só tente mudar X"; várias mudanças de uma vez; pular o teste; propor correções antes de rastrear os dados; "mais uma tentativa" depois de duas falhas. Sinais do Giovanni de que está errado: "Is that not happening?" (assumiu sem verificar), "Stop guessing", "We're stuck?".
7. **Quando de fato não há causa raiz** (ambiente, tempo, externo): documentar o que foi investigado, implementar um tratamento como nova tentativa, tempo limite ou mensagem de erro clara e acrescentar registro para o futuro. Mas 95 % dos casos de "sem causa raiz" são investigações incompletas.
