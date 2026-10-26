---
id: machine-bootstrap
lang: pt-BR
source_hash: 14fbba7251ed
title: machine-bootstrap (reconstruir a configuração do notebook)
---

## What it is
`machine-bootstrap` registra a configuração do notebook do Giovanni ([[acer-nitro]]) para reconstruí-la após reinstalar o sistema operacional ou mudar de computador. Usa a biblioteca padrão do Python e um script inicial em Bash. Seu repositório local fica em `~/dev/machine-bootstrap`; atualmente não tem commits nem repositório remoto. Comece por `docs/RESTORE.md`; `docs/MANUAL.md` contém as instruções extensas e os casos de falha.

## What it does
O comando `python3 -m mb` tem oito subcomandos. `capture` registra pacotes, repositórios e configurações permitidas em `state/`. `status` informa mudanças desde esse registro. `install-timer` ativa uma verificação semanal em segundo plano. `restore` mostra um plano e só o aplica com `--apply`. `secrets-backup` criptografa chaves e logins; `secrets-restore` restaura um arquivo. `data-backup` copia pastas pessoais. `scan` procura segredos nas configurações registradas.

## How it does it
O arquivo de configuração `mb.toml` lista os arquivos permitidos no registro e as receitas de instalação de ferramentas. Uma receita tem um comando de verificação e outro de instalação. A captura recusa arquivos identificados pelo verificador de segredos. A restauração instala primeiro as fontes de pacotes, depois pacotes, receitas iniciais, aplicativos, repositórios e receitas de ferramentas, e grava as configurações por último. Configurações existentes diferentes recebem uma cópia `.mb-bak` datada. Pacotes do carregador de inicialização, que determinam como o computador inicia, são excluídos. `--profile new` também exclui drivers e configurações específicos do hardware. `bootstrap.sh` instala pré-requisitos ausentes antes de iniciar a restauração.

Arquivos de segredos usam GnuPG, o programa de criptografia chamado como `gpg`. O Giovanni digita uma senha-frase, que nunca é salva nem colocada em argumento de comando. O backup grava um arquivo criptografado, descriptografa-o para comparar com os originais e depois envia e verifica a cópia no Google Drive pelo rclone, uma ferramenta de cópia de arquivos. O disco externo é encontrado pelo identificador do sistema de arquivos. O backup de arquivos pessoais recusa um destino não montado ou espaço insuficiente, preserva versões antigas dos arquivos sobrescritos e nunca apaga arquivos do destino. `--verify` compara somas de verificação; `--bulk` inclui pastas grandes substituíveis.

## Where it sits in the pipeline
Registra o [[laptop-setup]] e o reconstrói após reinstalar. Os requisitos `MB-1` a `MB-16` são as promessas verificáveis em `docs/REQUIREMENTS.md`. O portão de qualidade, as verificações que decidem se o projeto passa, é `tools/quality_gate.sh`: testes unitários, verificações de shell, procura de segredos, vínculos entre requisitos e testes e limites de tamanho. O [[pipeline-check]] o executa. O registro de decisões da fonte documenta uma execução em máquina virtual limpa com Ubuntu 26.04 e 27 verificações aprovadas em 2026-10-25; esta revisão leu esse registro e o script de teste, mas não repetiu a restauração completa. Clonar repositórios privados e o arquivo real com senha-frase ficaram fora daquela prova registrada.

## Who receives its output
O Giovanni e o assistente que ajuda a restaurar o computador. A ordem documentada é: obter a ferramenta, restaurar chaves, restaurar programas e configurações e copiar os arquivos pessoais de volta.

## Notes
Perfis de navegador, instalações de jogos e as configurações próprias do celular ficam fora da restauração. A configuração atual de captura inclui `.codex/skills`, mas omite `.agents/skills`; portanto, a restauração dos links dos skills gerenciados do Codex não está estabelecida. Essa lacuna está documentada na auditoria de fluxo do [[codex-skills]]. Receitas de download dependem de endereços externos, então uma restauração anterior bem-sucedida não comprova que uma futura terá sucesso. Esta revisão não criou um arquivo real de segredos nem testou uma restauração em computador novo.

Execute `python3 -m mb` em `~/dev/machine-bootstrap`. Configurações permitidas incluem `.bashrc` e arquivos de configuração da área de trabalho. Receitas iniciais preparam lojas de aplicativos antes dos aplicativos; receitas posteriores instalam ferramentas após clonar os repositórios. O identificador do disco fica em `[data].ssd_uuid` e o destino na nuvem em `[secrets].gdrive_path`, no `mb.toml`. Arquivos criptografados ficam em `machine-bootstrap/secrets/` no disco e arquivos pessoais em `machine-bootstrap/home/`. Uma etapa que falha aparece como `[FAIL]`; a restauração continua, salvo com `--stop-on-error`. Corrija a causa e execute novamente: etapas concluídas são puladas. Links de skills são referências do sistema de arquivos pelas quais o Codex encontra as pastas de instruções gerenciadas por [[codex-skillsctl]].
