---
id: skill-verification-before-completion
lang: pt-BR
source_hash: af65dd9e3ccb
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
