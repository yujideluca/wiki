---
id: wiki-hook-stop
lang: pt-BR
source_hash: 18a701a63983
title: Hook Stop do wiki (rede de segurança)
---

## What it is
Um "hook Stop" é um pequeno programa que um assistente executa automaticamente ao terminar uma resposta ([hooks explicados](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Tanto [[claude-code]] quanto [[codex]] chamam `wiki hook-stop` pelos hooks instalados. Ele identifica atualizações esquecidas na mesma sessão, enquanto o assistente ainda sabe o que alterou.

## What it does
Ao terminar uma rodada, o assistente verifica os repositórios sob `~/dev` citados como fontes por páginas da wiki. Mudanças de fonte sem revisão ou arquivos novos sem página bloqueiam o término (código de saída 2) e identificam o trabalho a revisar. Uma marca de publicação inválida sempre gera diagnóstico uma vez por sessão. Sem marca de publicação, o hook deriva as pendências das páginas ainda atrasadas em relação às fontes; só fica em silêncio quando nenhuma está atrasada. Não bloqueia repositórios não cobertos, duas vezes por sessão pelas mesmas mudanças nem quando um hook Stop já está ativo. Uma conversa sem alterações em código coberto não cria um gatilho próprio; mudanças anteriores ainda não publicadas podem gerar o lembrete.

## How it does it
Usa git somente de leitura e guarda seu estado em `~/.local/state/wiki/` (o momento da última publicação e as sessões já bloqueadas). Pastas de dados que mudam o tempo todo (eventos e visões da memória, backups do quiz, o feed de lançamentos) estão listadas em `content/_ignore.txt` e não são vigiadas arquivo a arquivo. A mensagem que ele imprime diz ao assistente para registrar uma página que conferiu e achou certa definindo o `reviewed` dela (registrar o horário somente após comparar as fontes, veja [[wiki-stale]]), e para rodar `wiki publish -m "review: no page change"` só quando o que mudou não é descrito por nenhuma página, por exemplo um arquivo de dados. Também diz à sessão para acrescentar `--co-author "Name <email>"` ao `wiki publish` com a linha de atribuição que essa sessão recebeu, e omiti-lo quando não houver ([[wiki-cli]]).

## Where it sits in the pipeline
Roda no fim de cada rodada, ao lado do [[hook-stop]] da memória.

## Who receives its output
[[claude-code]] ou [[codex]], conforme quem chamou o hook, recebe a mensagem.

## Notes
Desde 2026-11-01 (ADR-0009, um registro de decisão de arquitetura) a marca de tempo com que este hook compara é compartilhada por todas as sessões; ela só avança depois de um publish quando nenhuma página ainda está atrás de uma mudança e nenhum arquivo novo ficou sem cobertura desde a marca anterior. Assim o publish de uma sessão não esconde mais o trabalho sem revisão de outra. O hook também só nomeia uma página quando ela realmente está atrás das fontes, encontra os repositórios pelo próprio git (worktrees vinculados contam) e inclui mudanças feitas no mesmo segundo da marca. Se o arquivo da marca nunca foi gravado, o hook lista as páginas que estão atrás das fontes e só fica em silêncio quando não há nenhuma. Uma marca vazia, cortada, não numérica, zero, negativa ou no futuro (mesmo um minuto à frente) é sempre avisada uma vez por sessão, junto com essa lista; um publish nunca sobrescreve uma marca ausente ou quebrada enquanto uma página estiver atrás de uma fonte, só um estado comprovadamente limpo grava uma nova. Os dois arquivos de estado são gravados por renomeação, e um arquivo de estado que não pode ser gravado nunca esconde a mensagem (requisito UP-7).

O `wiki stale` verifica cada página independentemente de publicações. O hook verifica mudanças desde a marca de publicação, filtra páginas nomeadas pelas mesmas regras de desatualização e também detecta arquivos novos sem página. Não aponta uma página apenas porque houve mudança dentro do minuto coberto pela revisão. A detecção no mesmo segundo refere-se à marca de publicação, não a um relógio de revisão mais rigoroso. Comparar histórico da fonte e texto da página antes de registrar nova revisão. Antes de 2026-10-24 a comparação usava commits da fonte e da página, permitindo que reescritas escondessem mudanças anteriores; o campo `reviewed` substituiu esse comportamento ([[wiki-stale]]).

O lembrete encaminha explicitamente páginas de skills para a regra de fontes completas: localizar e ler o `SKILL.md` inteiro, incluir sua descrição completa e todas as instruções com uma impressão digital (um valor calculado do texto completo para detectar mudanças) na página em inglês e nas duas traduções e rodar `wiki check --local`. Ele aponta para `AGENTS.md` e [[skill-wiki-page-writer]]. O hook lembra quem escreve; não gera o texto da página sozinho.

Configuração: `home:` nomeia arquivos da pasta pessoal; outros nomes de repositório normalmente apontam para pastas sob `~/dev`, com substituição por `WIKI_DEV_ROOT`. `WIKI_ROOT` seleciona a pasta da wiki e suas fontes `wiki:`; o padrão é `~/dev/wiki`. Claude Code chama o comando por `~/.claude/settings.json`; Codex por `~/.codex/hooks.json`. `content/_ignore.txt` exclui caminhos de dados da busca de arquivos alterados, não da revisão manual das fontes. O requisito `UP-7` nomeia a promessa testada de preservar pendências entre publicações; seu texto completo está em `docs/REQUIREMENTS.md`.
