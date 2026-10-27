---
id: codex-skills
title: Codex skills
lang: pt-BR
source_hash: eb3b95269d69
---

## What it is
Um repositório privado com versões próprias do Codex baseadas nas skills Claude de Giovanni. Uma skill é uma receita salva que o assistente lê quando a descrição corresponde à tarefa. O projeto preserva os originais Claude e mantém instruções próprias para o Codex.

## Flow
trigger t1: Uma skill do Claude muda | [[skills]]
step s1: O codex-skillsctl compara a fonte com a impressão digital guardada | [[codex-skillsctl]]
decide d1: A fonte mudou?
step s2: Informa a mudança sem sobrescrever a adaptação do Codex
step s3: A adaptação e sua base são atualizadas à mão
step s4: O quality gate roda a cada push no GitHub
step s5: O codex-skillsctl instala as adaptações, de forma reversível
trigger t2: Giovanni pede ao Codex uma tarefa que combina com a descrição de uma skill
step s6: O Codex lê a adaptação instalada
product p1: Nada a fazer: as adaptações ficam como estão
product p2: Adaptações atualizadas com impressões digitais novas
product p3: O resultado da tarefa, ou um relato de capacidade ausente

t1 -> s1
s1 -> d1
d1 -sim-> s2
d1 -não-> p1
s2 -> s3
s3 -> s4
s4 -> s5
s4 -> p2
s5 -> s6
t2 -> s6
s6 -> p3

## What it does
Mantém 26 adaptações, fontes originais completas e impressões digitais dos arquivos. Uma impressão digital é um valor calculado para detectar mudanças. Informa mudanças nas fontes sem sobrescrever as adaptações. Skills de documentos de fornecedores continuam sob os responsáveis anteriores.

## How it does it
Repositório: `yujideluca/codex-skills`; pasta: `~/dev/codex-skills`. Python verifica e instala com possibilidade de reversão por [[codex-skillsctl]]. A verificação de qualidade, um comando que decide se a mudança passa, é `tools/quality_gate.sh`; o GitHub a executa a cada envio. Comece por README.md e AGENTS.md.

## Where it sits in the pipeline
As fontes Claude passam por revisão manual e as pastas Codex seguem para o instalador. [[skills]] lista as instruções adaptadas.

## Who receives its output
O Codex lê as skills instaladas. A pessoa usuária recebe resultados e informações sobre capacidades ausentes.

## Notes

Os comandos e a reversão estão no README.md. Os recibos de instalação ficam fora do controle de versões. Capacidades ausentes de navegador, Google ou agendamento continuam sendo limitações explícitas.

[[skill-adb-android-control]], [[skill-alemao-goethe-fsp]], [[skill-analise-artigo-cientifico]], [[skill-bias-risk-triage]], [[skill-brainstorming]], [[skill-browser-automacao-segura]], [[skill-candidatura-alemanha]], [[skill-click-protocol]], [[skill-consulta-clinica]], [[skill-deutsch-gespraech-memory]], [[skill-gerar-teste-automatizado]], [[skill-google-workspace]], [[skill-gui-code-protocol]], [[skill-import-memory]], [[skill-ligamagic-listas]], [[skill-ligamagic-replicar-carrinho-nas-lojas]], [[skill-minimize-site-approvals]], [[skill-morning]], [[skill-regras-magic]], [[skill-reparo-kubuntu]], [[skill-revisao-manutencao]], [[skill-setup-writing-style]], [[skill-skill-forge]], [[skill-systematic-debugging]], [[skill-verification-before-completion]], [[skill-wiki-page-writer]]


O comando somente de leitura `doctor` verifica os vínculos instalados, nomes duplicados e mudanças nas fontes. Um nome duplicado significa que dois pacotes disponíveis de instruções têm o mesmo nome. Uma mudança na fonte significa que os arquivos Claude atuais diferem da origem registrada. A configuração explícita `prefer_bundled` escolhe o skill-creator fornecido com o Codex e preserva a cópia concorrente do lado Codex em um backup de reversão, somente após confirmar que o substituto existe. A auditoria e as propostas restantes de restauração e documentos estão em `codex-skills:docs/WORKFLOW-AUDIT.md`.
