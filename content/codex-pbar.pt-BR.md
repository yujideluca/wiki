---
id: codex-pbar
lang: pt-BR
source_hash: bcee08701c85
title: Janela de status do Codex
---

## What it is
Codex Status é uma pequena janela que ajuda Giovanni a acompanhar o que o Codex faz e quanta capacidade de conversa e cota da conta ainda estão disponíveis. O código fica em `~/dev/codex-pbar`, com um [repositório no GitHub](https://github.com/yujideluca/codex-pbar). Ele adapta as funções de desenho da barra do Claude [[pbar]]. A instalação e os comandos estão no `README.md` do repositório.

## What it does
Mostra pasta do projeto, ramo do controle de versão (uma linha de desenvolvimento separada), modelo, chamadas de ferramentas ativas, ocupação aproximada do contexto (as informações da conversa enviadas na última solicitação ao modelo), períodos de uso da conta (os intervalos em que uma cota é medida) e horários de renovação. Mantém as sessões separadas. A barra de tempo usa pelo menos três chamadas anteriores bem-sucedidas com o mesmo projeto e argumentos transformados em hash; hash é uma impressão digital que evita guardar os argumentos originais. Estima a duração de uma chamada, não a conclusão da tarefa inteira. Valores desconhecidos continuam desconhecidos. Quinze minutos sem eventos tornam a sessão desatualizada.

## How it does it
Python lê os arquivos locais das sessões do Codex, um registro completo por vez. O formato depende da versão do Codex; o leitor foi testado com a versão 0.164.0. Ignora registros desconhecidos e conta registros inválidos ou grandes demais. Não abre credenciais nem faz solicitações ao modelo ou à rede. Arquivos locais privados em `~/.local/share/codex-pbar` guardam o estado da exibição e históricos de duração com hash, sem mensagens, argumentos originais ou saídas de ferramentas.

PySide6, uma biblioteca Python para janelas, desenha a exibição. Um serviço do usuário, um programa de fundo controlado pelo gerenciador de serviços Linux systemd, inicia com a sessão gráfica e reinicia após uma falha. A janela aparece quando um processo de fundo do Codex (o programa que executa a conversa) inicia ou começa uma nova rodada de conversa. Fechar apenas esconde; a entrada **Codex Status** do menu ou `codex-pbar --show` reabre. `codex-pbar --json` imprime dados locais de diagnóstico sem janela. O instalador preserva as configurações e regras de aprovação do Codex. O controle de qualidade, a verificação automática que decide se uma mudança passa, executa testes, cobertura, nove falhas inseridas de propósito (erros que os testes devem detectar), uma renderização da janela e a ligação entre requisitos e testes pelo [[pipeline-check]]. Não deduz espera por aprovação; um processo de comandos pode continuar depois da chamada da ferramenta que o iniciou.

## Where it sits in the pipeline
Roda ao lado do Codex no notebook como parte de [[laptop-setup]]. `systemctl --user status codex-pbar` verifica o serviço; `systemctl --user disable --now codex-pbar` encerra e desativa o início automático. Mantenha o clone no local instalado ou execute `tools/install.py` novamente após movê-lo.

## Who receives its output
Giovanni acompanha a janela. O Codex pode ler o comando local de diagnóstico ao investigar um problema. Dados das sessões não são enviados ao GitHub.
