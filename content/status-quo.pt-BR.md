---
id: status-quo
lang: pt-BR
source_hash: a0f9dfbecf71
title: Bandeja de widgets de desktop Status Quo
---

## What it is
Status Quo é um ambiente de widgets de desktop escrito em Rust: pequenos painéis sempre visíveis no próprio desktop, sem moldura de janela, que mostram quanto dos limites de uso do Claude e do Codex de Giovanni já foi gasto, gráficos de tokens, as sessões que cada assistente está executando, a atividade recente no GitHub e as entradas recentes do workflow-memory. O código está em `~/dev/status-quo` e no repositório privado `yujideluca/status-quo` no GitHub. Comece pelo `README.md`. O escopo aprovado está em [[status-quo-design]] e o esboço do layout em [[status-quo-layout]]; esta página descreve o código como foi construído.

Cada exibição é um widget separado que pode ser removido, substituído ou levado para outro programa, e a bandeja que os organiza também é reutilizável. O KDE, o ambiente de desktop do laptop, é o primeiro host; nada portátil depende dele.

## Flow
trigger t1: Giovanni abre o painel, ou ele inicia no login
trigger t2: Uma sessão do Claude ou do Codex inicia, espera ou termina | [[claude-code]], [[codex]]
step s1: O painel inicia o coletor, um processo em segundo plano por usuário, se nenhum estiver rodando
step s2: O coletor lê o status das contas, as transcrições de sessão, o GitHub e a memória | [[workflow-memory]], [[github]]
step s3: Um hook do assistente registra o evento para o coletor
step s4: Os resultados vão para uma pasta privada que mantém o último valor bom de cada fonte
step s5: O painel pede ao coletor um instantâneo por um socket local
decide d1: Alguma fonte está indisponível ou desatualizada?
step s6: A bandeja desenha cada widget registrado no estilo de terminal escolhido
product p1: Os widgets mostram uso, gráficos, sessões, atividade e memória
product p2: O widget afetado diz o que falta e quão antigos são seus dados

t1 -> s1
t2 -> s3
s1 -> s2
s2 -> s4
s3 -> s4
s4 -> s5
s5 -> d1
d1 -no-> s6
d1 -yes-> p2
s6 -> p1

## Architecture
### Context
person g: Giovanni — lê uso, sessões e atividade no desktop | [[giovanni]]
system sq: Status Quo — o painel de widgets e seu coletor
external cc: Claude Code — suas transcrições e hooks | [[claude-code]]
external cx: Codex — suas transcrições e hooks | [[codex]]
external gh: GitHub — atividade de repositórios, lida pelo programa gh | [[github]]
external wm: workflow-memory — notas compartilhadas, somente leitura | [[workflow-memory]]

cc -sends session events and transcripts to-> sq
cx -sends session events and transcripts to-> sq
gh -supplies repository activity to-> sq
wm -supplies recent entries to-> sq
g -reads the panel of-> sq

### Containers
container co: Núcleo — configuração validada, livro de tokens e registros normalizados, sem entrada e saída
container ct: Contrato — registro de widgets e as mensagens versionadas entre host e coletor
container wd: Widgets — modelos de exibição que não podem ler arquivos nem iniciar programas
container sc: Fontes — adaptadores somente de leitura para contas, transcrições, GitHub e memória
container cl: Coletor — trabalhadores em segundo plano e o socket por usuário
container tr: Bandeja — layout e personalização em egui, com estilo de terminal
container dk: Invólucro de desktop — camada de compatibilidade que escolhe layer-shell, dicas do X11 ou uma janela comum; instalador e hooks
store st: Pasta privada de estado — configuração, instantâneo e eventos de ciclo de vida

wd -uses-> co
tr -draws models from-> wd
tr -registers widgets through-> ct
cl -fills records from-> sc
cl -serves snapshots through-> ct
cl -saves data in-> st
dk -hosts-> tr
dk -starts-> cl

## What it does
O painel tem cinco widgets iniciais, criados para cada assistente quando faz sentido, o que dá sete por padrão: uso das contas do Claude e do Codex, histórico de tokens do Claude e do Codex, sessões agrupadas por projeto, atividade recente no GitHub e entradas do workflow-memory. O uso mostra o percentual consumido dos limites de cinco horas e semanal, com os horários de reinício; nunca se deriva um percentual de contagens locais de tokens. Os gráficos de tokens alternam entre 24 horas, 7 dias e 30 dias, e entre visão por intervalo e acumulada. Valores ausentes aparecem como indisponíveis, nunca como zero.

A aba de personalização muda o modo claro, escuro ou do sistema, as cores de destaque, a opacidade do fundo, o tamanho do texto e a ordem e o tamanho dos widgets. As mudanças aparecem primeiro em prévia e podem ser canceladas. Widgets podem ser adicionados, removidos, ocultados ou destacados. Por padrão o painel fica atrás das janelas normais, ancorado no canto superior direito; no laptop ele ficou escondido atrás de um navegador maximizado e visível numa área de trabalho vazia.

## How it does it
O código é um workspace Rust de nove pacotes. `sq-core`, `sq-contract` e `sq-widgets` guardam a lógica portátil e não podem usar gráficos, arquivos, processos nem rede; `tools/rust_architecture.rs` verifica isso a cada execução do gate, porque o verificador compartilhado só entende Java e Kotlin. `sq-sources` lê dados externos, `sq-store` os grava de forma atômica, `sq-collector` executa os trabalhadores e serve um socket versionado e com limite de tamanho, `sq-tray` é a interface egui reutilizável (egui é uma biblioteca Rust para desenhar interfaces), `status-quo` é o invólucro para Linux e `sq-web` é uma demonstração no navegador com dados inventados.

**Coletor.** `crates/collector/src/lib.rs` contém o servidor de socket e o bloqueio de processo, de modo que só um coletor roda por usuário. `workers.rs` executa um trabalhador por fonte: status das contas, transcrições de sessão, GitHub e memória. Cada trabalhador mantém seus últimos dados válidos com estado de atualidade e de erro, então uma fonte quebrada nunca trava as demais. Os trabalhadores observam pastas em busca de mudanças e só recorrem à consulta a cada 2 segundos quando uma observação falha. O coletor cria sua própria pasta privada `events` antes de observá-la; antes dessa correção, uma pasta ausente forçava a consulta e triplicava o uso ocioso de CPU. `events.rs` grava, sob um bloqueio, um arquivo pequeno por evento de ciclo de vida da sessão e não guarda texto de prompt nem de ferramenta. Um evento Stop significa que a sessão está esperando, não que sua tarefa foi concluída.

**Widgets.** `crates/widgets/src/lib.rs` (pacote `sq-widgets`) registra, por `registry()`, os cinco tipos de widget embutidos: `quota`, `tokens`, `sessions`, `activity` e `memory`. Cada tipo transforma um instantâneo do coletor em uma visão, uma lista de nós simples (texto, linhas, avisos) que a bandeja desenha; o pacote não pode ler arquivos nem iniciar programas. Para atividade do GitHub e memória, uma visão mantém no máximo 100 entradas. Um widget também acrescenta um aviso quando sua fonte não está atualizada ou tem registros malformados ou adiados, e "Waiting for source status" enquanto não há status. O widget de sessões mostra sempre as sessões em execução, em espera e bloqueadas, as concluídas por uma hora e as demais por 24 horas, a menos que sua opção `history` seja `true`. `format_utc` escreve horários como `YYYY-MM-DD HH:MM UTC` sem ler um relógio. Os testes em `crates/widgets/tests/models.rs` (requisitos SQ-5, SQ-6, SQ-8, SQ-10, SQ-11) verificam, entre outras coisas, que uma cota ausente não aparece como zero, que projetos com o mesmo nome de pasta continuam separados, que agentes aninhados ficam sob o pai real e que datas extremas não estouram.

**Contrato.** `crates/contract` define como um host registra tipos de widget e como pedidos e instantâneos são enquadrados. Versões incompatíveis e quadros grandes demais são rejeitados, e um widget de exemplo sem relação com o projeto prova que o registro funciona sem alterar a bandeja (`tests/registry.rs`, `tests/transport.rs`).

**Hooks.** O instalador adiciona entradas do Status Quo em `~/.claude/settings.json` e `~/.codex/hooks.json` e mantém todos os hooks existentes. Ele foi executado em 2026-11-02.

**Camada de compatibilidade.** `crates/desktop/src/host/` é o único código que sabe como a bandeja é colocada em um desktop Linux específico, e ele escolhe em tempo de execução, de modo que um programa funciona em várias distribuições (decisão em `docs/adr/0004-host-compatibility-layer.md`). Layer-shell, um protocolo do Wayland que permite a um programa desenhar na camada do desktop, é usado quando o compositor o oferece (KDE Plasma, Hyprland, sway); a bandeja então não tem moldura, fica ancorada a uma borda ou canto (`STATUS_QUO_ANCHOR`, padrão canto superior direito) e só desenha quando algo muda. Numa sessão X11 usa uma janela sem moldura com dicas do gerenciador de janelas para ficar embaixo, fora da barra de tarefas e do pager; pedir todas as áreas de trabalho é só uma tentativa, porque a compatibilidade X11 do KDE a ignora. Em qualquer outro lugar, por exemplo GNOME no Wayland, volta para uma janela comum e avisa. `STATUS_QUO_HOST=layer-shell|x11|window` força uma escolha quando ela é possível. Nesses dois hosts a bandeja é nua: não tem fundo nem título próprio, só os widgets e os três botões pequenos Add widget, Edit tray e Customize ficam visíveis (o status de conexão aparece apenas quando desconectado), e as linhas de widgets são escaladas para preencher exatamente o espaço da bandeja, com espaços iguais. Personalização e capturas de tela usam a janela comum porque o host layer-shell ainda não tem entrada de teclado.

**Edit tray (requisito SQ-29, redesenhado em 2026-11-02, decisão em `docs/adr/0005-free-canvas-layout.md`).** O botão Edit tray transforma a bandeja num editor de tela livre que usa só o ponteiro. Cada widget pode levar um retângulo explícito em pixels (`x`, `y`, `width`, `height`, em `crates/core/src/config.rs`); largura 0 mantém o fluxo antigo de linhas, então configurações antigas carregam sem mudança, e o validador aceita larguras de 120 a 8000 e alturas de 60 a 8000. Ao apertar Edit tray, primeiro o que está na tela é congelado em retângulos, para nada pular (`freeze` em `crates/tray/src/layout.rs`). Depois, cada borda e canto de um widget o redimensiona nos dois eixos para qualquer tamanho, e arrastar o corpo o move para qualquer lugar (`drag_rect`, que mantém um tamanho mínimo e nunca cruza o canto da tela). O conteúdo do widget fica desligado durante a edição, para não tirar o ponteiro das alças. Todas as mudanças acontecem numa cópia de rascunho: Done leva a tela até o seu canto, grava a posição desse canto no desktop na geometria `tray` salva e salva pelo mesmo caminho validado de configuração do Customize; Cancel descarta o rascunho. Os widgets sabem de quanto espaço dispõem: gráficos ocupam cerca de 55 por cento da altura do widget, e os controles de tokens e o texto dos medidores quebram linha (`crates/tray/src/ui.rs`). Fora da edição, a bandeja informa o tamanho que quer (`desired_size`: a tela de `free_rects` e `canvas_size` mais o cabeçalho), e o host layer-shell ajusta sua superfície a ele (`Surface` em `crates/desktop/src/host/layer.rs`, escolhida por `LayerApp` em `crates/desktop/src/main.rs`): `Legacy` é o layout de canto da primeira execução, `Free` encaixa a superfície na posição salva do desktop e `Editing` cobre a saída inteira, transparente e acima das janelas, para que um widget possa ser arrastado para qualquer lugar. Os hosts de janela acompanham com um pedido de tamanho interno. Widgets sobrepostos são permitidos e só a primeira saída é usada (posicionamento por monitor não foi tratado). Verificado até agora: os testes conduzem eventos reais de ponteiro pela bandeja, e uma execução isolada num compositor real renderizou corretamente um layout livre encaixado (ambos conforme o ADR-0005, o registro de decisão de arquitetura (ADR) desta mudança; a execução em si não foi repetida aqui). Ainda não observado: um arraste com o ponteiro real no editor em tela cheia no desktop ao vivo. O efeito do redesenho sobre o uso de CPU em repouso não foi medido. A mudança está na árvore de trabalho e ainda não foi commitada.

## Where it sits in the pipeline
Roda no laptop ao lado de [[claude-code]] e [[codex]]. Suas verificações estão em [[checks-status-quo]], e ele segue [[project-template]] e [[pipeline-check]].

## Who receives its output
Giovanni lê o painel. Outros programas podem reutilizar a bandeja ou widgets isolados pelo contrato.

## Engineering practices
Como este projeto segue o caminho dourado de [[project-template]].

### Principles
1. **Requisitos vêm antes das mudanças**: os testes carregam um comentário isolado `// REQ SQ-n`, e a etapa de rastreabilidade ([[check-traceability]]) falha quando um requisito não tem nenhum.
2. **Pacotes portáteis ficam livres de entrada e saída**: núcleo, contrato e widgets, verificados por um detector próprio do projeto com autotestes de defeitos plantados.
3. **Tudo é um widget removível**: sem espaços fixos de provedor na bandeja.
4. **O gate decide**: `tools/quality_gate.sh` é a única definição de aprovado, e nenhum limite é reduzido para que ele passe.
5. **Nada privado é guardado**: sem credenciais, conversas ou conteúdo de memória em dados de teste, diagnósticos ou na demonstração no navegador.

### Decisions
O `DESIGN.md` contém o diagrama de arquitetura e um registro de decisões datado, com o tipo de cada decisão. Cinco ADRs (registros de decisão de arquitetura, notas curtas que guardam os motivos de uma decisão) estão em `docs/adr/`: 0001 registrar decisões, 0002 widgets Rust portáteis, 0003 o programa mede e a skill julga, 0004 a camada de compatibilidade de host, 0005 o layout de tela livre (2026-11-02, uma decisão corretiva de Giovanni: qualquer tamanho e posição de widget e uma superfície da bandeja que acompanha seus widgets; ela altera as linhas da bandeja do ADR-0002 e a superfície fixa do ADR-0004). O ADR-0005 está na árvore de trabalho e ainda não foi commitado; o `DESIGN.md` tem uma linha correspondente no registro de decisões. `docs/adr/0000-template.md` é o formulário em branco para o próximo (status, data, tipo, quem decidiu, contexto, decisão, alternativas, consequências) e `docs/adr/README.md` é o índice; um ADR decidido nunca é reescrito, um novo o substitui. O escopo aprovado fica em `docs/2026-11-01-status-quo-design.md`.

### Requirements
29 requisitos (prefixo SQ) em `docs/REQUIREMENTS.md`, todos cobertos por testes marcados em 2026-11-02 (SQ-29, cujo texto foi substituído em 2026-11-02 para a tela livre, está na árvore de trabalho, ainda não commitado, no momento desta revisão). `docs/TRACEABILITY.md` é a tabela que a etapa de rastreabilidade gera: cada requisito com os arquivos de teste que levam sua marca; não é editada à mão. Uma marca prova que existe um teste, não que o desktop real se comporta corretamente.

### Quality gate
Cinco etapas: formatação, diagnósticos do compilador sem avisos permitidos junto com todos os testes, a verificação de fronteiras Rust, rastreabilidade de requisitos e o limite de 1200 segundos para a duração do gate. `tools/resource_check.rs` mede os processos reais por cinco minutos. A primeira observação atendeu à meta de memória (115 MiB de 200 MiB) e não atendeu à de CPU ociosa (2,05% de um núcleo contra 1%).

### Continuous integration
Integração contínua (CI) significa verificações automáticas a cada push. O `quality-gate.yml` instala o Rust 1.87, executa `pipeline-check --mode ci` fixado em `pipeline-check.version` e compila a versão para navegador. Ele passou no primeiro commit.

### Maintenance
`docs/MAINTENANCE.md` descreve o método: dívida é uma issue do GitHub com o rótulo `debt` (P1 a P3), recursos novos usam `idea`, cerca de uma sessão em cinco vai para dívida ou prevenção, e uma revisão mensal de cada projeto registra uma linha do tipo Preventive no registro de decisões. Ele segue o arquivo do modelo e acrescenta que a verificação de CI exigida, `gate`, deve passar no commit exato antes da promoção para `main`. A dívida técnica vai para issues do GitHub com o rótulo `debt`, segundo a [[maintenance-policy]], e a [[monthly-architecture-review]] verifica o projeto. A proteção de branch não pode ser ativada em repositório privado no plano gratuito do GitHub.

## Notes
Compile com `cargo build --release --locked -p status-quo`; o instalador é `status-quo install`, e `status-quo uninstall` o desfaz. O estado fica em `~/.local/state/status-quo`; `STATUS_QUO_STATE_DIR` o redireciona para testes. No laptop, testes em 2026-11-02 mostraram o host layer-shell com dados reais, o coletor vendo sessões reais dos assistentes pelos hooks, um clique do mouse alterando um widget e uma medição ociosa de 60 segundos de 1,08% de um núcleo e 195 MB no total (as bibliotecas do driver gráfico explicam a maior parte dos 156 MB do painel). `docs/TESTES-AUTOMATIZADOS.md` (em português, como o nome diz) é o registro dos testes que buscam defeitos; veja [[checks-status-quo]]. Ainda não observado: início no login, o limite de 100 ms de interação, a execução completa de cinco minutos, entrada de teclado no host layer-shell, GNOME ou outro desktop além do KDE Plasma, e uma sessão X11 de verdade. A causa do uso ocioso de CPU restante está em aberto.
