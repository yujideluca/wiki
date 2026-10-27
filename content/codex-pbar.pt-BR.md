---
id: codex-pbar
lang: pt-BR
source_hash: b51165c50416
title: Progresso de tarefas no terminal do Codex
---

## What it is
Uma linha fixa no rodapé do terminal do Codex mostra o progresso da tarefa e o tempo restante estimado. O código Python fica em `~/dev/codex-pbar`. Comece pelo `README.md` do repositório. Esta exibição é separada da barra do terminal do Claude [[pbar]].

## Flow
trigger t1: Giovanni inicia o codex num terminal | [[global-codex-agents]]
step s1: O lançador do codex envolve a sessão em tmux
step s2: Um servidor codex-status dedicado reserva a última linha do terminal | [[codex-status-line]]
step s3: Cada terminal recebe um identificador próprio, ligando rodapé e estado da tarefa
trigger t2: O Codex inicia uma tarefa com vários passos
step s4: O agente roda codex-task-progress set com passos feitos, total, segundos restantes e rótulo
decide d1: Há um plano de tarefa ativo?
decide d2: A estimativa de tempo acabou?
product p1: Rodapé mostra porcentagem, tarefas feitas e tempo restante
product p2: Rodapé mostra over by e o tempo excedido
product p3: Rodapé diz No active task

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
t2 -> s4
s4 -> d1
d1 -sim-> d2
d1 -não-> p3
d2 -não-> p1
d2 -sim-> p2

## Architecture
### Contexto
person g: Giovanni — trabalha com o Codex em um terminal | [[giovanni]]
system p: codex-pbar — mostra o progresso da tarefa sob o terminal
external a: Instruções globais do Codex — mandam o Codex relatar marcos | [[global-codex-agents]]
external x: Codex — o assistente que faz o trabalho | [[codex]]
external t: Terminal tmux — tem a linha em que o rodapé é desenhado

a -instrui-> x
x -relata marcos para-> p
p -desenha o rodapé no-> t
g -lê o rodapé no-> t

### Contêineres
person g: Giovanni | [[giovanni]]
external x: Arquivos de sessão do Codex | [[codex]]
container rd: Leitor incremental — o único código que abre os arquivos de sessão
container co: Estado puro da sessão — não guarda texto de prompt nem de ferramenta
container ap: Janela de desktop — mantida, não ligada
container ft: Rodapé do terminal — tarefas concluídas/total e tempo restante
store ts: Estado privado da tarefa — escrito pelas atualizações de marco
store hs: Histórico privado de tempos — com hash

rd -lê-> x
rd -atualiza-> co
rd -acrescenta ao-> hs
co -alimenta a-> ap
ft -lê-> ts
g -vê-> ft

## What it does
A linha permanece visível enquanto o Codex trabalha ou espera. Usa o estilo compacto do Claude: rótulo Progress verde sobre o fundo normal do terminal, separadores por ponto central, porcentagem, tarefas concluídas e tempo restante estimado. Não desenha uma barra de blocos. Duas etapas concluídas de cinco aparecem como `Progress: [ 40%] 2/5 tasks`. O tempo passar não aumenta a porcentagem. Quando a estimativa vence, aparece `over by` e o tempo excedido. Sem um plano de tarefa, a linha mostra `No active task`. Uma conclusão explícita continua visível até começar a próxima tarefa.

## How it does it
O iniciador instalado `codex` abre sessões interativas no tmux, programa que mantém os programas do terminal ativos depois de uma desconexão (veja [[glossary]]). Um servidor próprio, `codex-status`, reserva a última linha fora da área desenhada pelo Codex. A configuração nativa `task-progress` continua selecionada, mas a linha fixa não depende da ferramenta de planejamento do modelo. Cada sessão do terminal possui uma identificação própria, para tarefas simultâneas não dividirem o contador.

O agente atualiza o comando local `codex-task-progress set --done 2 --total 5 --eta 300 --label 'Testing'`. `--eta` informa os segundos restantes; `--new` inicia uma nova tarefa. Instruções nos dois arquivos locais `AGENTS.md` atribuem a manutenção ao agente. O estado é salvo substituindo um arquivo privado completo em `~/.local/share/codex-pbar/tasks/`; uma escrita incompleta não substitui um estado válido. Os rótulos são descrições curtas da tarefa. Não há novas chamadas ao modelo nem serviço de rede.

O instalador guarda o caminho do executável original e substitui o atalho `~/.local/bin/codex` por um iniciador. Comandos não interativos, como `codex exec` e `codex --version`, mantêm os argumentos e o código de saída. O programa original, os hooks e as configurações de aprovação permanecem intactos. Execute o instalador novamente se uma instalação do Codex substituir o iniciador. `CODEX_PBAR_DISABLE=1 codex` pula a barra. Um terminal que já estava aberto não é envolvido retroativamente; uma nova interface com a barra pode retomar a mesma conversa sem iniciar uma nova tarefa.

## Where it sits in the pipeline
A barra funciona no terminal do notebook. O quality gate, conjunto de verificações automáticas exigidas antes da conclusão, executa testes e falhas introduzidas de propósito pelo [[pipeline-check]]. A verificação ao vivo abre uma conversa existente sem enviar mensagem, rejeita um diálogo de escolha de pasta como falso sucesso, verifica duas larguras e um período de espera e salva a captura do terminal em `build/`.

## Who receives its output
Giovanni lê a barra. O agente pode consultar `codex-task-progress show`. O programa de janela preservado não é ativado por esta instalação do terminal.

## Engineering practices
Como este projeto segue o caminho dourado do [[project-template]].

### Princípios
1. **Requisitos vêm antes das mudanças**: os testes levam `REQ PB-N`, e o passo de rastreabilidade do portão falha quando algum não tem.
2. **Módulos puros ficam livres de código de interface e de rede**: o estado e o leitor são testados com testes unitários comuns, com cobertura de ramos exigida.
3. **Nada privado é guardado**: nenhuma chamada de modelo ou de rede, nenhuma leitura de autenticação e nenhum argumento ou saída bruta de ferramenta no status ou histórico salvos.
4. **O portão decide**: `tools/quality_gate.sh` é a única definição de “passou”, e a integração contínua o executa.

### Decisões
Quatro registros de decisão de arquitetura (notas curtas que guardam os motivos de uma decisão) em `docs/adr/`: 0002 um acompanhante de desktop em Python que lê os arquivos de sessão; 0003 um programa mede e uma skill julga; 0004 o rodapé persistente do terminal em uma linha própria do tmux, ligada à sua sessão. O `DESIGN.md` guarda o diagrama e o registro de decisões.

### Requisitos
10 requisitos (prefixo PB) em `docs/REQUIREMENTS.md`. Cada um tem um teste marcado `REQ PB-N`, e a verificação de rastreabilidade ([[check-traceability]]) falha quando algum não tem.

### Portão de qualidade
O portão roda os testes unitários com pelo menos 85 % de cobertura de ramos nos módulos de estado e de leitura; uma checagem de mutação (falhas plantadas de propósito precisam ser pegas); um teste de fumaça da janela sem tela; a rastreabilidade dos requisitos; e as funções de aptidão.

### Integração contínua
Integração contínua (CI) significa verificações automáticas a cada push. O workflow `quality-gate.yml` roda o portão no GitHub a cada push, por meio do `pipeline-check` fixado em `pipeline-check.version`.

### Manutenção
A dívida técnica é registrada como issues do GitHub com o rótulo `debt` (P1 a P3), conforme a [[maintenance-policy]]. A [[monthly-architecture-review]] confere o projeto todo mês; a próxima vence em 2026-11-22.

## Notes
Instale a partir de `~/dev/codex-pbar` com `PYTHONPATH=src .venv/bin/python -m codex_pbar.terminal install`. Desconecte com `Ctrl-b d` e reconecte com `tmux -L codex-status attach`. O tempo é uma previsão do agente, não uma garantia medida. A mudança não acrescenta campos de tokens, contexto ou cotas.


Limites em falhas: a linha fixa precisa do iniciador instalado e do tmux. Um arquivo de estado ausente ou corrompido mostra valores desconhecidos. Se o tmux estiver ausente, o programa informa um erro. Só informar explicitamente todas as etapas como concluídas define 100%. Novos terminais recebem identificadores separados; duas interfaces da mesma conversa retomada compartilham intencionalmente o contador da tarefa. O código da janela permanece no repositório, mas este instalador não o inicia.


Arquivos do projeto: `AGENTS.md` encaminha colaboradores ao `CLAUDE.md`, que descreve a arquitetura Python, os limites de privacidade e as verificações exigidas. `DESIGN.md` registra o desenho atual do terminal e as decisões. `docs/2026-10-25-codex-pbar-design.md` preserva o desenho original da janela; a decisão mais recente do terminal fica em `docs/adr/0004-persistent-terminal-footer.md`. `docs/REQUIREMENTS.md` lista PB-1 a PB-10, cobrindo a janela preservada e as promessas do terminal. `docs/MAINTENANCE.md` descreve revisões mensais e tratamento de dívida técnica. `.github/workflows/quality-gate.yml` executa a verificação compartilhada nos envios e pedidos de revisão e guarda o relatório por quatorze dias. `.gitignore` exclui ambientes virtuais, caches Python, arquivos de cobertura e saídas de compilação, incluindo capturas privadas do terminal, do controle de versão.


Arquivos de validação: `docs/TESTES-AUTOMATIZADOS.md` descreve a estratégia de testes, as lacunas conhecidas e as verificações do terminal. `docs/TRACEABILITY.md` é gerado e liga PB-1 a PB-10 aos testes. `pipeline-check.toml` seleciona a verificação obrigatória, proíbe importações de bibliotecas de rede no diretório de código, define o limite de 1200 segundos e identifica a verificação do GitHub. `pipeline-check.version` fixa o verificador compartilhado em `v0.5.0`; `tools/pipeline-check.sh` usa essa versão em vez de copiar a implementação. `pyproject.toml` declara Python e as dependências fixadas de exibição e testes.

Arquivos de decisão: `docs/adr/README.md` explica os registros de decisão de arquitetura, arquivos curtos com os motivos de escolhas estruturais; `0000-template.md` fornece o formato. `0001-record-decisions.md` exige esses registros; `0002-python-transcript-companion.md` registra a arquitetura original da janela; `0003-program-measures-skill-judges.md` separa medição automática de julgamento de manutenção. A decisão do terminal fica em `0004-persistent-terminal-footer.md`. Os módulos em `src/codex_pbar/` preservam o leitor, estado e janela junto da entrada do terminal; `tests/` e `tools/` contêm verificações e instaladores. `upstream/` guarda o código Claude arquivado, que não é executado.


Tarefas do usuário bloqueadas pausam a contagem de tempo e mostram `Blocked`; o atraso não continua aumentando. `codex-task-progress clear` remove um contador antigo da sessão vinculada. Uma saudação não exige plano de tarefa. Hooks automáticos de documentação preservam o contador da tarefa principal em vez de substituí-lo por trabalho de documentação.

`task-progress` é uma entrada de `tui.status_line` em `~/.codex/config.toml`; [[codex-status-line]] descreve os outros campos nativos. Conversas novas recebem identificadores distintos. `codex resume <UUID da conversa>` usa o identificador daquela conversa; duas interfaces retomadas pelo mesmo identificador dividem o contador. Para pausar a estimativa, atualize a tarefa incompleta com um rótulo iniciado por `Blocked:`, por exemplo `codex-task-progress set --done 2 --total 5 --eta 300 --label 'Blocked: waiting for access'`.

O arquivo global de instruções [[global-codex-agents]] descreve como o assistente mantém o progresso da tarefa. Nesta revisão, `codex-pbar.service`, o serviço antigo da janela, está mascarado e inativo: seu arquivo de serviço aponta para `/dev/null`, impedindo sua inicialização. O rodapé ativo do terminal usa o iniciador.

O terminal pode ser verificado sem abrir outra interface do Codex: conecte um cliente somente de leitura à sessão tmux existente com `tmux -L codex-status attach-session -r -f ignore-size -t SESSION`. Substitua `SESSION` pela sessão cujo comando do rodapé contém a `CODEX_PBAR_SESSION` atual. Esse cliente não envia entradas, e `ignore-size` impede que seu redimensionamento altere o terminal de trabalho. Em 2026-10-26, esse método confirmou o rodapé em 116×53 e 70×35, durante inatividade e após redesenho. A visão larga também mostrou os percentuais restantes dos orçamentos de cinco horas e semanal, o contexto usado e sua capacidade. O antigo `tools/terminal_smoke.py` abre outra interface do Codex e atualmente para no bloqueio de propriedade da conversa; essa falha não demonstra ausência do rodapé no terminal existente.

Cada terminal interativo novo ativa o encaminhamento do mouse pelo tmux e configura as ações da roda antes da conexão. No Codex em tela cheia sem captura do mouse, cada passo envia eventos nativos de uma linha, somando um quarto da altura atual do painel, arredondado para baixo com mínimo de uma linha. O tmux recalcula a quantidade em cada passo; redimensionar ajusta automaticamente o deslocamento. Isso usa a velocidade padrão do Codex, de uma linha por evento nativo. Aplicativos que solicitam captura e o modo de cópia do tmux mantêm seus eventos normais. O desvio anterior por página inteira restaurou a rolagem, mas fazia cada passo saltar demais. Testes com eventos reais de terminal agora verificam os dois sentidos em alturas de 24, 18 e 3 linhas; falhas introduzidas de propósito alteram o divisor ou invertem um dos sentidos. Mantenha Shift pressionado ao arrastar para usar a seleção de texto do Konsole. O iniciador reaplica as ações em cada sessão nova; o servidor em uso é corrigido sem reiniciar o Codex.

O auxiliar `~/fixes/codex-touchpad-scroll.sh` reaplica as ações de roda mantidas pelo projeto ao servidor dedicado em uso. A opção `--undo` restaura as ações anteriores nesse servidor; novas inicializações continuam aplicando a correção. `~/fixes/LEIAME.md` registra a causa, os testes e os limites da reversão.

Giovanni confirmou que o deslocamento de um quarto de tela ficou adequado. Uma captura da sessão em uso mediu 13 linhas por passo em um painel de 52 linhas. Uma sessão nova pelo iniciador instalado moveu sete linhas em seu painel de 29 linhas, nos dois sentidos, sem pedido ao modelo. O fluxo de integração contínua instala tmux; o teste de regressão falha, em vez de ser ignorado, se ele estiver ausente. Não foi testada uma reinicialização física.
