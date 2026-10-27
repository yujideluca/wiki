---
id: wiki-server
lang: pt-BR
source_hash: 090ff5a714c5
title: Servidor do wiki (Elixir)
---

## What it is
O servidor é o back end do wiki: o programa que roda no notebook, responde às requisições do navegador e decide quem pode ver o quê. É escrito em [Elixir](https://elixir-lang.org/) (escolha do Giovanni) e é um único projeto Mix (Mix é a ferramenta de build do Elixir) que é ao mesmo tempo o servidor web e o comando `wiki`.

## Architecture
### Contexto
person g: Giovanni — entra com o Google | [[giovanni]]
external f: Tailscale Funnel — o endereço público | [[tailscale-funnel]]
system s: Servidor do wiki — portão de login, página falsa e ferramentas de conteúdo
external o: Login do Google — prova quem está pedindo | [[google-oauth-client]]
external w: Site gerado — os arquivos que ele entrega | [[wiki-site]]

g -abre o wiki pelo-> f
f -repassa os pedidos ao-> s
s -pergunta ao-> o
s -entrega o-> w

### Contêineres
external f: Tailscale Funnel | [[tailscale-funnel]]
container ht: Servidor HTTP — Bandit, escutando só em 127.0.0.1 porta 4180
container ro: Roteador — negar por padrão e login do Google | [[wiki-router]]
container de: Página falsa — o que todos os outros veem | [[decoy-page]]
container cl: O comando wiki — roda as ferramentas de conteúdo | [[wiki-cli]]
container ch: Verificação — as regras que uma página deve seguir | [[wiki-check]]
container bu: Geração — transforma páginas em arquivos de dados | [[wiki-build]]
container hk: Hook de parada — lembra de atualizar o wiki | [[wiki-hook-stop]]
store pg: Páginas — arquivos Markdown | [[wiki-content]]
store st: Site gerado — os arquivos que ele entrega | [[wiki-site]]
store se: Arquivos secretos — legíveis só pelo dono, nunca no git

f -repassa os pedidos ao-> ht
ht -entrega ao-> ro
ro -mostra aos outros a-> de
ro -entrega o-> st
ro -lê as chaves dos-> se
cl -roda a-> ch
cl -roda a-> bu
cl -roda o-> hk
ch -lê as-> pg
bu -lê as-> pg
bu -gera o-> st

## What it does
Serve o site atrás do login do Google ([[wiki-router]]) e contém as ferramentas de conteúdo ([[wiki-check]], [[wiki-build]], [[wiki-hook-stop]], [[wiki-cli]]).

## How it does it
Roda em Elixir 1.18 e Erlang/OTP 27 (OTP é a Open Telecom Platform, as bibliotecas padrão e o ambiente de execução do Erlang) sobre a BEAM (a máquina virtual do Erlang/OTP). Usa Plug e [Bandit](https://github.com/mtrudel/bandit) (o servidor HTTP) escutando só em 127.0.0.1 porta 4180, o que significa que só o próprio notebook o alcança diretamente; o mundo externo o alcança pelo [[tailscale-funnel]]. A biblioteca [Assent](https://hexdocs.pm/assent) cuida do Google OpenID Connect (o protocolo de login). Os segredos vêm dos arquivos `~/.config/wiki/*.env` (legíveis só pelo dono), nunca do git. Roda como release (um build empacotado autossuficiente) sob o [[wiki-service]] e é testado com ExUnit (`mix test`).

A distribuição do Erlang (o modo nativo de dois nós Erlang/OTP se encontrarem, por uma porta registrada no `epmd`, e executarem código um no outro depois que os dois apresentam o mesmo segredo compartilhado, o "cookie") está desligada, configurada em `server/rel/env.sh.eex` (`RELEASE_DISTRIBUTION=none`). Este servidor nunca forma cluster com outro nó e nunca é comandado por uma console remota, então a porta e o arquivo de cookie não tinham propósito; deixá-los ligados era uma abertura sem uso na rede do notebook, já que por padrão um release escuta a distribuição em qualquer interface, não só em 127.0.0.1. Sem ela, a BEAM não abre nenhuma porta além da 4180 do Bandit.

O Hex (o gerenciador de pacotes do Elixir) verifica as versões das dependências com `mix hex.audit`, que as compara com a lista pública de avisos de segurança; Bandit e plug_crypto (a biblioteca por trás dos cookies de sessão assinados e criptografados, [[wiki-router]]) são mantidos em versões sem aviso aberto.

## Where it sits in the pipeline
Entre o [[tailscale-funnel]] e o [[wiki-site]].

## Who receives its output
Navegadores, pelo [[tailscale-funnel]].
