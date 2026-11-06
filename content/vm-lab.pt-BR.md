---
id: vm-lab
lang: pt-BR
source_hash: 1b5f0133e5bb
title: vm-lab (máquinas de teste para Windows)
---

## What it is
`vm-lab` é um pequeno comando, `vmlab`, que mantém computadores Windows descartáveis no [[acer-nitro]] para que um programa possa ser testado num Windows de verdade sem ter uma segunda máquina. Uma máquina virtual (VM) é um computador inteiro simulado por um programa; aqui a simulação é o [QEMU](https://www.qemu.org/) com KVM, o recurso do Linux que a deixa quase tão rápida quanto o equipamento real. Não precisa de direitos de administrador. Foi criado para que o [[status-quo]] possa ser compilado e testado no Windows 10 e no Windows 11, mas qualquer teste que precise de um Windows limpo pode usá-lo: um instalador, um programa, um navegador.

## What it does
`vmlab fetch` baixa a imagem de disco (ISO) de avaliação gratuita da Microsoft do Windows 10 Enterprise LTSC 2021 ou do Windows 11 Enterprise 24H2. `vmlab create` instala sem ninguém clicar: um disco extra pequeno leva um arquivo de respostas (`autounattend.xml`) que diz ao instalador do Windows como particionar o disco, qual idioma usar e que crie um administrador local chamado `lab`; um script do primeiro login (`lab-setup.ps1`) liga então o servidor SSH (Secure Shell, um jeito de executar comandos de fora), coloca nele a chave do laboratório e desliga a suspensão. O Windows 11 normalmente recusa uma máquina sem chip de segurança, por isso o arquivo de respostas desliga essas verificações; a VM não tem nenhum. `vmlab provision NOME rust` instala o compilador Rust e as ferramentas de compilação C++ da Microsoft dentro da VM. `vmlab start`, `stop`, `ssh`, `ps` (executa código PowerShell exatamente como escrito), `push`, `pull`, `sync` (copia uma pasta de código para dentro, mantendo a pasta de compilação), `shot` (captura da tela da VM), `reset`, `seal`, `status` e `destroy` cuidam do resto. O convidado chega à internet pela rede privada do QEMU e só é acessível deste notebook (SSH na porta 2210 para o Windows 10, 2211 para o Windows 11).

## How it does it
É um único arquivo Python 3 sem pacotes extras. Tudo o que ele cria fica em `~/.local/share/vm-lab`: as imagens baixadas, uma pasta por VM com o disco e as configurações UEFI, e uma chave SSH feita só para esse fim. Depois que uma VM é instalada, seu disco é **selado** (`base.qcow2`, nunca mais escrito). `start` inicia um segundo disco fino (`work.qcow2`) que registra só as mudanças, então um teste não consegue danificar a imagem limpa: `reset` apaga o disco fino, `seal` o funde na imagem limpa (usado depois de instalar ferramentas). O Windows traz drivers para o disco virtual (NVMe) e a placa de rede (Intel e1000e), então não é preciso um disco de drivers. A tela fica na memória e `shot` pede ao QEMU que a salve como imagem. Cada VM recebe 6 GB de memória (`VMLAB_MEM` muda isso); neste notebook de 23 GB rode uma de cada vez.

## Where it sits in the pipeline
É uma ferramenta do [[acer-nitro]] usada pela parte Windows do [[status-quo]] (requisito SQ-36): o projeto é copiado para a VM com `sync`, compilado lá com `cargo` e seus testes rodam; falhas que só o Windows mostra são corrigidas no código. Exemplos achados assim: salvar um arquivo falhava porque o Windows não consegue descarregar uma pasta como se fosse um arquivo, um arquivo recriado mantinha a data de criação antiga e uma rotação de log passava despercebida, e o instalador rejeitava o próprio registro.

## Who receives its output
Giovanni e o Claude leem os logs de teste e as capturas de tela; os resultados orientam o suporte a Windows do [[status-quo]].

## Notes
As imagens são as edições de avaliação da Microsoft (90 dias). A imagem do Windows 10 mostra "license expired" na área de trabalho por causa da data embutida nessa versão; `vmlab create --force` cria uma nova. A VM não tem placa de vídeo, então o programa para Windows só consegue abrir sua janela lá com um driver OpenGL por software (Mesa) copiado ao lado dele e `GALLIUM_DRIVER=llvmpipe` definido; o Giovanni autorizou em 2026-11-06 e isso foi feito na VM do Windows 11 (veja o README do vm-lab). O Windows 11 foi instalado e sua configuração do Rust foi iniciada no mesmo dia.
