---
id: security-layers
lang: pt-BR
source_hash: 02ba3cf24ef8
title: Camadas de segurança do pipeline de código
---

## What it is
Os sistemas do Giovanni guardam chaves, tokens e anotações privadas, e alguns repositórios são públicos. Não existe um único produto de segurança; em vez disso, várias camadas pequenas barram, cada uma, um tipo de vazamento ou de erro. Esta página lista as camadas que existem nos arquivos, para que ninguém suponha uma proteção que não está lá.

## Flow
trigger t1: Chega um texto, um arquivo ou uma tentativa de login | [[code-security-pipeline]]
step s1: Um visitante pede uma página da wiki; sem sessão Google verificada a resposta é uma isca | [[wiki-sign-in]], [[decoy-page]]
step s2: O conteúdo é conferido com os padrões de privacidade compartilhados antes de ser publicado ou guardado | [[wiki-check]], [[mem-validator]]
step s3: O scanner do machine-bootstrap recusa arquivos que parecem segredos | [[machine-bootstrap]]
step s4: Segredos que precisam ser guardados viajam só em um arquivo criptografado | [[machine-bootstrap]]
step s5: Alterações de código passam pelo gate, pelo lint de shell e pela verificação de dependências declaradas | [[quality-gate-explained]]
step s6: A proteção de branch ou o hook de pre-push impede que uma alteração com falha chegue à main | [[branch-protection-explained]]
decide d1: Alguma camada achou um problema?
product p1: Uma recusa que diz o tipo de problema, nunca o valor do segredo
product p2: Conteúdo seguro para guardar, publicar ou servir

t1 -> s1
t1 -> s2
t1 -> s3
s3 -> s4
t1 -> s5
s5 -> s6
s1 -> d1
s2 -> d1
s4 -> d1
s6 -> d1
d1 -yes-> p1
d1 -no-> p2

## What it does
As camadas, da mais específica à mais geral:
1. **Negar por padrão na web** ([[wiki-router]]). Sem uma sessão da conta Google verificada do Giovanni, todo caminho de página responde com uma isca e os caminhos de dados respondem 404 (requisitos AU-1 a AU-6, DC-1). Toda resposta é marcada para não ser guardada em cache e leva cabeçalhos de segurança; a política de segurança de conteúdo da isca proíbe requisições de rede. No OAuth (Open Authorization, o padrão por trás do "entrar com o Google"), state e nonce são conferidos, e o cliente Google admite apenas um usuário de teste.
2. **Uma lista de padrões de privacidade**. `mem/privacy-patterns.tsv` no [[workflow-memory]] lista 12 formatos de segredo (bloco de chave privada, chaves do GitHub, GitLab, Slack, Telegram, Google e AWS, bearer tokens, atribuições de senha), 2 formatos de telefone e 1 formato de CPF brasileiro (Cadastro de Pessoas Físicas, o número de contribuinte). A memória move um evento que combina para `quarantine/`, com o motivo ([[mem-validator]]); a wiki usa a mesma lista no `wiki check` e se recusa a publicar uma página que combine (CO-4), e recusa também qualquer endereço de e-mail exceto o do Giovanni e o endereço no-reply da Anthropic. A wiki guarda uma cópia, e seu gate falha no laptop se os dois arquivos diferirem.
3. **Captura por lista de permissão e um scanner no machine-bootstrap**. Só os arquivos nomeados em `mb.toml` são lidos; cada um é escaneado em busca de sete formatos de segredo, e um arquivo marcado é recusado pelo nome, nunca pelo conteúdo; o gate escaneia `state/` de novo (`python3 -m mb scan`). Segredos de verdade viajam só em um arquivo protegido por senha, feito com `gpg` e guardado em dois lugares ([[checks-machine-bootstrap]]).
4. **Arquivos de segredo ficam fora do git**. A wiki lê suas chaves de `~/.config/wiki/oauth.env` e `secret.env` (modo 600, legíveis só pelo dono), e a regra é nunca imprimi-los nem commitá-los.
5. **Memória só de acréscimo**. O job de CI `append-only` no [[workflow-memory]] falha quando um arquivo de evento é editado no lugar, de modo que o histórico do que o Giovanni decidiu não pode ser reescrito em silêncio.
6. **Dependências declaradas**. [[checks-radiology-crawler]] faz o gate falhar quando um import de terceiros não está declarado ou quando a CI instala algo que não seja `requirements.txt`.
7. **Lint de shell e o gate**: ShellCheck em todo script de shell ([[checker-catalog]]), depois a proteção de branch ou o hook de pre-push ([[branch-protection-explained]]). "Nunca force-push" é uma preferência fixa na memória.

Não encontrado em nenhum arquivo de repositório: verificação automática de vulnerabilidades em dependências, configuração de varredura de segredos do GitHub e workflows de varredura de código. Se o GitHub tem algo disso ligado nas suas configurações, não foi verificado.

## How it does it
Cada camada informa o tipo de problema e o lugar (um número de linha ou um nome de arquivo), nunca o valor, de modo que o próprio log não vaza um segredo. Os scanners são redes de proteção, não garantias: as regras de trabalho continuam dizendo que o Claude não deve escrever esses dados desde o início ([[wiki-check]]).

## Where it sits in the pipeline
Roda dentro dos passos 4 e 5 de [[code-security-pipeline]].

## Who receives its output
O autor da alteração (uma recusa ou um aviso) e [[giovanni]], que decide sobre qualquer exceção.

## Steps
1. Um texto ou arquivo está prestes a ser guardado ou publicado. Ator: a ferramenta daquele projeto ([[mem-validator]], [[wiki-check]] ou o scanner do machine-bootstrap). Saída: aprovado, ou uma recusa que nomeia o tipo de segredo.
2. Um visitante chega à wiki. Ator: [[wiki-router]]. Saída: a página real para o Giovanni, a isca para todo o resto.
3. O código é alterado. Ator: o gate do projeto. Saída: aprovado ou a primeira verificação que falhou, incluindo ShellCheck e as verificações de dependências onde o projeto as tem.
4. Um push chega à `main`. Ator: a proteção de branch ou o hook de pre-push. Saída: aceito, ou barrado com a verificação que falhou.
