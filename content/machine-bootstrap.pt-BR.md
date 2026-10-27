---
id: machine-bootstrap
lang: pt-BR
source_hash: 3121f5ef9454
title: machine-bootstrap (reconstruir a configuração do notebook)
---

## What it is
`machine-bootstrap` registra a configuração do notebook do Giovanni ([[acer-nitro]]) para reconstruí-la após reinstalar o sistema operacional ou mudar de computador. Usa a biblioteca padrão do Python e um script inicial em Bash. Seu repositório local fica em `~/dev/machine-bootstrap`; o código público está em [yujideluca/machine-bootstrap](https://github.com/yujideluca/machine-bootstrap). Configurações capturadas e listas de pacotes são públicas; arquivos criptografados e credenciais ficam excluídos. Comece por `docs/RESTORE.md`; `docs/MANUAL.md` contém as instruções extensas e os casos de falha.

## Flow
trigger t1: Giovanni quer registrar ou refazer a configuração do notebook | [[acer-nitro]]
decide d1: Registrar ou refazer?
step s1: capture registra pacotes, repositórios e configurações permitidas; o detector recusa segredos
step s2: status e um timer semanal informam o que mudou desde o registro
step s3: restore imprime um plano
decide d2: O Giovanni acrescenta --apply?
step s4: Instala fontes, pacotes, ferramentas e repositórios; configurações por último, com cópias .mb-bak
step s5: Os segredos voltam do arquivo criptografado; as pastas pessoais são copiadas de volta
trigger t2: Giovanni faz backup de chaves, logins e pastas pessoais
step s6: secrets-backup criptografa chaves e logins; data-backup copia as pastas
product p1: Um registro público de pacotes e configurações, sem segredos
product p2: Só um plano: nada mudou no notebook
product p3: Um notebook refeito
product p4: Arquivos criptografados e pastas copiadas, fora do repositório público

t1 -> d1
d1 -registrar-> s1
d1 -refazer-> s3
s1 -> s2
s2 -> p1
s3 -> d2
d2 -não-> p2
d2 -sim-> s4
s4 -> s5
s5 -> p3
t2 -> s6
s6 -> p4

## Architecture
### Contexto
person g: Giovanni — captura e restaura | [[giovanni]]
system m: machine-bootstrap — reconstrói a configuração do notebook
external pc: O computador — pacotes, configurações, serviços | [[acer-nitro]]
external gh: GitHub — guarda o estado capturado | [[github]]
external ssd: Disco externo — chaves criptografadas e arquivos pessoais
external gd: Google Drive — uma segunda cópia das chaves criptografadas

g -captura e restaura com-> m
m -lê e reconstrói-> pc
m -guarda o estado no-> gh
m -salva chaves criptografadas no-> ssd
m -salva chaves criptografadas no-> gd

### Contêineres
person g: Giovanni | [[giovanni]]
container cl: Linha de comando — comandos e pedido da senha
container pl: Plano — montá-lo é puro, só execute muda algo
container cp: Captura — copia só o que a lista de permitidos nomeia
container sb: Backup de segredos — arquivo criptografado de chaves e logins
container db: Backup de dados — checagem prévia e depois cópia
container fa: Fatos — como a máquina é
container sc: Escâner de segredos — recusa tudo que parece segredo
store ss: state/ — o que a captura escreve, guardado no git
store cf: mb.toml — a lista de permitidos

g -executa-> cl
cl -planeja com-> pl
cl -captura com-> cp
cl -faz backup das chaves com-> sb
cl -faz backup dos arquivos com-> db
cl -lê a lista de-> cf
pl -pergunta a-> fa
pl -lê-> ss
cp -pergunta a-> fa
cp -confere com o-> sc
cp -grava em-> ss

## What it does
O comando `python3 -m mb` tem oito subcomandos. `capture` registra pacotes, repositórios e configurações permitidas em `state/`. `status` informa mudanças desde esse registro. `install-timer` ativa uma verificação semanal em segundo plano. `restore` mostra um plano e só o aplica com `--apply`. `secrets-backup` criptografa chaves e logins; `secrets-restore` restaura um arquivo. `data-backup` copia pastas pessoais. `scan` procura segredos nas configurações registradas.

## How it does it
O arquivo de configuração `mb.toml` lista os arquivos permitidos no registro e as receitas de instalação de ferramentas. Uma receita tem um comando de verificação e outro de instalação. A captura recusa arquivos identificados pelo verificador de segredos. A restauração instala primeiro as fontes de pacotes, depois pacotes, receitas iniciais, aplicativos, repositórios e receitas de ferramentas, e grava as configurações por último. Configurações existentes diferentes recebem uma cópia `.mb-bak` datada. Pacotes do carregador de inicialização, que determinam como o computador inicia, são excluídos. `--profile new` também exclui drivers e configurações específicos do hardware. `bootstrap.sh` instala pré-requisitos ausentes antes de iniciar a restauração.

Arquivos de segredos usam GnuPG, o programa de criptografia chamado como `gpg`. O Giovanni digita uma senha-frase, que nunca é salva nem colocada em argumento de comando. O backup grava um arquivo criptografado, descriptografa-o para comparar com os originais e depois envia e verifica a cópia no Google Drive pelo rclone, uma ferramenta de cópia de arquivos. O disco externo é encontrado pelo identificador do sistema de arquivos. O backup de arquivos pessoais recusa um destino não montado ou espaço insuficiente, preserva versões antigas dos arquivos sobrescritos e nunca apaga arquivos do destino. `--verify` compara somas de verificação; `--bulk` inclui pastas grandes substituíveis.

## Where it sits in the pipeline
Registra o [[laptop-setup]] e o reconstrói após reinstalar. Os requisitos `MB-1` a `MB-16` são as promessas verificáveis em `docs/REQUIREMENTS.md`. O portão de qualidade, as verificações que decidem se o projeto passa, é `tools/quality_gate.sh`: testes unitários, verificações de shell, procura de segredos, vínculos entre requisitos e testes e limites de tamanho. O [[pipeline-check]] o executa. O registro de decisões da fonte documenta uma execução em máquina virtual limpa com Ubuntu 26.04 e 27 verificações aprovadas em 2026-10-25; esta revisão leu esse registro e o script de teste, mas não repetiu a restauração completa. Clonar repositórios privados e o arquivo real com senha-frase ficaram fora daquela prova registrada.

## Who receives its output
O Giovanni e o assistente que ajuda a restaurar o computador. A ordem documentada é: obter a ferramenta, restaurar chaves, restaurar programas e configurações e copiar os arquivos pessoais de volta.

## Engineering practices
Como este projeto segue o caminho dourado do [[project-template]].

### Princípios
1. **Requisito, depois teste, depois código**: conferido pelo passo de rastreabilidade do portão.
2. **Planejar é puro, o sistema é tocado em um só lugar**: `build_plan` só lê; só `execute` muda algo, e o executor de comandos é um argumento obrigatório. Os testes passam um executor que faz o teste falhar se for chamado.
3. **Nada secreto no git**: a captura é uma lista de permitidos mais um escâner, e o portão varre `state/`. Segredos só passam pelo backup criptografado.
4. **O portão decide**: `tools/quality_gate.sh` é a única definição de “passou”, e a integração contínua o executa.
5. **Só a máquina virtual prova uma restauração**: depois de mudar uma receita, o plano ou o `bootstrap.sh`, roda `tools/vm-test.sh` e o resultado vai para o registro de decisões.
6. **Uma ferramenta usada por mais de um projeto existe uma só vez**, em repositório próprio, fixada por versão.
7. **As decisões ficam onde está o código**: registro de decisões e, para as estruturais, um registro de decisão de arquitetura.

### Decisões
Cinco registros de decisão de arquitetura (notas curtas que guardam os motivos de uma decisão) em `docs/adr/`: 0002 Python só com a biblioteca padrão, mais um pequeno inicializador em Bash; 0003 um programa mede e uma skill julga; 0004 captura por lista de permitidos, recusando tudo que o escâner de segredos apontar; 0005 chaves e logins em um arquivo criptografado por senha guardado em dois lugares. O `DESIGN.md` guarda os diagramas, inclusive a ordem de restauração, e o registro de decisões.

### Requisitos
16 requisitos (prefixo MB) em `docs/REQUIREMENTS.md`. Cada um tem um teste marcado `REQ MB-N`, e a verificação de rastreabilidade ([[check-traceability]]) falha quando algum não tem.

### Portão de qualidade
O portão tem três passos: os testes unitários, uma checagem de script de shell do `bootstrap.sh` e a varredura de segredos em `state/`; a rastreabilidade dos requisitos; e as funções de aptidão (limites em `pipeline-check.toml`, inclusive o tempo do portão).

### Integração contínua
Integração contínua (CI) significa verificações automáticas a cada push. O workflow `quality-gate.yml` roda o portão no GitHub a cada push, por meio do `pipeline-check` fixado em `pipeline-check.version`.

### Manutenção
A dívida técnica é registrada como issues do GitHub com o rótulo `debt` (P1 a P3), conforme a [[maintenance-policy]]. A [[monthly-architecture-review]] confere o projeto todo mês; a próxima vence em 2026-11-22.

## Notes
Perfis de navegador, instalações de jogos e as configurações próprias do celular ficam fora da restauração. A configuração atual de captura inclui `.codex/skills`, mas omite `.agents/skills`; portanto, a restauração dos links dos skills gerenciados do Codex não está estabelecida. Essa lacuna está documentada na auditoria de fluxo do [[codex-skills]]. Receitas de download dependem de endereços externos, então uma restauração anterior bem-sucedida não comprova que uma futura terá sucesso. Há no disco um arquivo de segredos de 2026-10-26; uma restauração com ele em computador novo não foi testada. O `DESIGN.md` registra que o ramo principal (main) do repositório público exige a verificação `gate` do GitHub Actions, vale também para administradores e proíbe push forçado e exclusão do ramo. O repositório também contém `docs/PRIVACY.md`, o aviso de privacidade de um aplicativo OAuth (Open Authorization, padrão para conceder acesso sem compartilhar a senha) do Google pessoal (a identidade que o [rclone](https://rclone.org/) usa para acessar o Google Drive) que substitui a compartilhada do rclone; ele informa que o aplicativo pode ver e gerenciar todos os arquivos da conta do Drive que o autoriza, que o fluxo envia arquivos criptografados e não apaga backups existentes no Drive, e que credenciais e tokens ficam na configuração privada do rclone. Um envio com ele não foi testado.

Execute `python3 -m mb` em `~/dev/machine-bootstrap`. Configurações permitidas incluem `.bashrc` e arquivos de configuração da área de trabalho. Receitas iniciais preparam lojas de aplicativos antes dos aplicativos; receitas posteriores instalam ferramentas após clonar os repositórios. O identificador do disco fica em `[data].ssd_uuid` e o destino na nuvem em `[secrets].gdrive_path`, no `mb.toml`. Arquivos criptografados ficam em `machine-bootstrap/secrets/` no disco e arquivos pessoais em `machine-bootstrap/home/`. Uma etapa que falha aparece como `[FAIL]`; a restauração continua, salvo com `--stop-on-error`. Corrija a causa e execute novamente: etapas concluídas são puladas. Links de skills são referências do sistema de arquivos pelas quais o Codex encontra as pastas de instruções gerenciadas por [[codex-skillsctl]].

O arquivo local `pipeline-check.toml` agora identifica `yujideluca/machine-bootstrap`, seu branch `main` e a verificação obrigatória `gate`. No modo local, a ferramenta verifica tanto o resultado mais recente dos testes no GitHub quanto a proteção ativa do branch; o relatório de 2026-10-26 mostra ambos como `ok` (aprovados).

Um aplicativo próprio de autorização do Google está registrado no projeto `rclone-personal-backup-512812`. O aplicativo está publicado no modo de produção. Seu cliente para computador identifica a instalação local do rclone ao solicitar acesso ao Google. A política de dados do usuário do Google foi aceita e a permissão de acesso completo ao Drive foi configurada com autorização do Giovanni. O aviso público de privacidade está em `docs/PRIVACY.md` no repositório do bootstrap. A conexão do rclone agora usa esse cliente para computador e um segredo substituto baixado em 2026-10-26. O Google aceitou o substituto em uma nova autenticação. A configuração privada fica em `~/.config/rclone/rclone.conf`, legível somente pelo proprietário. Giovanni autorizou acesso completo ao Drive, e uma nova autenticação no Google concedeu a permissão `drive`. O backup criptografado existente está acessível: seus metadados completos correspondem ao registro inicial salvo, e o download de seus 174220 bytes produz a mesma soma de verificação SHA-256 (Secure Hash Algorithm 256), um valor usado para detectar mudanças no conteúdo. A comparação encontrou um arquivo antes e um depois, sem alterações. Nenhum novo backup foi enviado nesta verificação. A revogação do segredo original não foi confirmada.
