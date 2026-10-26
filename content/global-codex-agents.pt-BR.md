---
id: global-codex-agents
lang: pt-BR
source_hash: 509ce5e8da10
title: AGENTS.md global do Codex
---

## What it is
`~/.codex/AGENTS.md` é o arquivo de texto simples com as instruções do Giovanni para o Codex, o assistente de programação. Descreve como o assistente trabalha no notebook, protege trabalho existente e comprova resultados. É separado das instruções globais do Claude em [[global-claude-md]].

## What it does
O arquivo conecta o Codex ao [[workflow-memory]], o registro compartilhado de preferências e tarefas pendentes, e ao processo de encerramento do wiki ([[end-of-task]]). A memória fornece padrões, nunca autorização. As instruções iniciais descrevem o registro de correções, o relato das entradas utilizadas e a proteção de informações privadas; pastas geradas da memória são administradas por comandos em vez de editadas à mão.

A seção `Terminal task progress` descreve o rodapé fixo do [[codex-pbar]]: o assistente registra etapas concluídas e estima o tempo restante. Só trabalho concluído avança o contador. Tarefas bloqueadas pausam a contagem, e acompanhamentos automáticos de documentação preservam o contador da tarefa original. A exibição nativa separada [[codex-status-line]] mostra cotas de uso (os limites restantes da conta) e tamanho do contexto (a quantidade de texto que o modelo pode usar de uma vez).

## How it does it
`Working standard` começa reservando a ajuda do Giovanni para acesso de administrador, credenciais e decisões cruciais de desenvolvimento. Três subseções organizam o restante do trabalho:

- `Mistakes you have made (do not repeat)` agrupa lições de falhas anteriores. As regras de evidência distinguem resultado real de configuração ou teste isolado, exigem o comando e ambiente de produção e cobrem o comportamento ao longo do tempo, como recarregamentos e escritas simultâneas. As regras de diagnóstico tratam bloqueios recorrentes pela causa em vez de registrar repetidamente o mesmo obstáculo. Um bloqueio real de acesso ou decisão recebe uma ação concreta, um comando de verificação e uma tarefa aberta. As regras de proteção preservam estado compartilhado, alterações de outras sessões, fontes de credenciais declaradas na documentação do projeto e a organização dos arquivos do usuário. As regras de decisão mantêm aprovações exigidas pelos skills, informam redução de escopo e alterações de dados, preferem um pequeno ajuste reversível quando autorizado e exigem uma verificação atual antes de afirmar que uma ferramenta ou arquivo existe. Um skill é um conjunto de instruções salvo para determinada tarefa; sua aprovação obrigatória continua valendo sem usuário presente.
- `Reporting` torna os resultados avaliáveis. O resultado vem primeiro, seguido de `Found along the way:` para achados inesperados e `Verified by:` para verificações relevantes e seus limites. Tarefas com dados prestam contas das entradas, saídas e de cada registro alterado, pulado ou mantido. Um problema inofensivo de ferramenta recebe, no máximo, uma nota curta no final.
- `Closing a task and asking questions` mantém cada repositório em um único ramo, `main`; um ramo só existe enquanto a integração contínua (CI, as verificações automáticas do GitHub) verifica um commit. Também distingue ambientes descartáveis de teste de alterações no sistema real. Mudanças reais incluem relato do uso da memória, trabalho no wiki em uma cópia de trabalho isolada e [[pipeline-check]], o programa que executa as verificações automáticas do projeto. A proteção de branches, regras do repositório que impedem alterações antes da aprovação das verificações obrigatórias, não é contornada. Perguntas apresentam contexto, opções e recomendação, nessa ordem.

## Where it sits in the pipeline
As instruções orientam tanto o trabalho quanto o relatório. As instruções iniciais do wiki exigem páginas em inglês e suas versões em alemão e português do Brasil antes de `wiki publish`. O assistente atualiza o horário de revisão de uma página depois de compará-la com suas fontes. O Stop hook, um comando executado automaticamente quando uma sessão termina, lembra o assistente da documentação pendente ([[wiki-hook-stop]]).

Uma passagem de trabalho causada por limites da sandbox ainda inclui o encerramento do wiki e da memória antes da mensagem final. Se a própria documentação não puder ser publicada, o Codex prepara as alterações em uma cópia isolada e registra e informa esse limite.

## Who receives its output
O Codex lê o arquivo; Giovanni recebe o trabalho, as evidências e as decisões que dependem de sua participação. Esta página explica os grupos da fonte em vez de duplicar suas regras numeradas. O arquivo instalado continua sendo a fonte das instruções exatas.
