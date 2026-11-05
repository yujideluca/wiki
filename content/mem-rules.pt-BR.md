---
id: mem-rules
lang: pt-BR
source_hash: c9cb39517fb5
title: mem rules e mem tag (regras por tipo de tarefa)
---

## What it is
Uma tag é uma palavra curta que diz para qual tipo de tarefa uma regra importa, por exemplo `deploy` (instalar ou mudar algo) ou `git`. `mem rules` imprime as regras completas que levam uma tag, e `mem tag` muda as tags de uma regra. Elas existem porque o texto que uma conversa recebe no início é cortado depois de 2 KB (quilobytes, uma medida do tamanho de um texto) e não cabe todas as regras: ele traz um índice das tags, e o Claude lê as regras de um tipo de tarefa quando começa uma tarefa desse tipo ([[session-brief]]).

## What it does
`mem rules deploy git` imprime toda regra ativa com a tag `deploy` ou `git`, cada uma uma vez, no texto completo atual. Uma linha tem este aspecto: `- [git.no-force-push] Never force-push. (#d6931b)`: a key, o texto e o `#code` curto que `mem use` e `mem feedback` aceitam. Só aparecem as regras do projeto atual e da ferramenta atual (uma regra de outro projeto, ou só do Codex, fica de fora), e uma regra marcada como errada também fica de fora. Uma tag desconhecida é recusada e as tags conhecidas são listadas.

`mem tag KEY deploy,git` troca as tags da regra com aquela key (`--scope` quando a mesma key existe em vários escopos, ou o `#code` no lugar da key); `mem tag KEY -` as remove. Escreve um novo evento que substitui o antigo, e assim o log guarda o histórico. `mem add --tags` define as tags de uma regra nova ([[mem-add]]).

## How it does it
As tags conhecidas e o texto "use when" de uma linha ficam em `mem/tags.toml` (TOML é um formato de texto simples de linhas `nome = "texto"`). O verificador ([[mem-validator]]) recusa um evento cuja tag não está nesse arquivo ou que tem mais de seis tags, e `mem check` imprime um aviso para cada regra escrita pelo Giovanni sem tag, porque nenhuma consulta por tag chegaria a essa regra. As tags fazem parte da regra no [[memory-fold]]: as mesmas palavras com outras tags substituem o evento mais antigo. A tag `always` marca as poucas regras que o brief de início imprime por inteiro. As mesmas listas são escritas em `views/rules/TAG.md` para conversas que não conseguem rodar comandos ([[memory-views]]).

## Where it sits in the pipeline
O Claude roda `mem rules TAG` antes de uma tarefa desse tipo; o brief de início manda fazer isso ([[hook-session-start]]). O Giovanni também pode rodá-lo.

## Who receives its output
O [[session-brief]] (o índice e as regras `always`) e a conversa que perguntou.

## Functions
- `mem rules TAG [TAG ...] [--project NAME]`: imprimir as regras completas com qualquer uma das tags
- `mem tag KEY|#code TAG[,TAG] [--scope S]`: definir as tags de uma regra; `-` as apaga
- `mem add ... --tags TAG[,TAG]`: marcar uma regra nova; uma regra que substitui outra mantém as tags dela, a não ser que `--tags` diga outra coisa
