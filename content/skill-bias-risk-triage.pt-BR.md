---
id: skill-bias-risk-triage
lang: pt-BR
source_hash: 0230cc8947b7
title: Skill: bias-risk-triage
---

## What it is
A skill "bias-risk-triage" é uma verificação silenciosa que o Claude executa antes de responder qualquer pergunta factual curta. Sua descrição diz: antes de responder qualquer pergunta factual curta, executar uma verificação compilada (uma guarda, uma consulta e uma tabela de decisão) para viés, mito, conspiração, defasagem (informação desatualizada) ou risco alto, e definir a profundidade de verificação T0–T3. É a versão 3.3, "compilada", e foi validada nos benchmarks TruthfulQA e WebQuestions.

## What it does
Sua saída é um nível de T0 (resposta em uma linha) a T3 (tratamento com várias fontes de um tema contestado). Ela define apenas a profundidade mínima de verificação, nunca o formato: quando uma skill de domínio como a [[skill-consulta-clinica]] ou a [[skill-analise-artigo-cientifico]] também se aplica, segue-se a estrutura e o formato dela, e as fontes são ao menos tão rigorosas quanto o nível daqui.

## How it does it
Um `SKILL.md` em `~/.claude/skills/bias-risk-triage`; o Claude o carrega quando um pedido combina com a descrição. É uma skill "transversal": só define mínimos e nunca dita um formato.

## Where it sits in the pipeline
Antes de respostas factuais curtas, em qualquer conversa.

## Who receives its output
A resposta que se segue (sua profundidade).

## Steps
1. **Normalizar (uma vez).** Se a pergunta traz uma premissa falsa ou carregada ("por que X fez…" quando X não é verdade), marcar isso e classificar a pergunta corrigida. Premissa falsa significa que a primeira linha da resposta corrige a premissa e o nível é pelo menos T1.
2. **Guarda (caminho rápido para T0).** T0 imediatamente se tudo isto valer: um único referente; um fato estável há mais de 20 anos e igual em todas as autoridades; nenhuma palavra avaliativa ou de categoria (X é um…, seguro, eficaz, legal, genocídio, país); nenhum número com risco alto; não é alvo de conspiração ou negacionismo; não é lembrança de detalhe de cultura pop ou de marca (nomes, falas, logos); não é uma charada que aponta para uma resposta famosa; não é uma afirmação contraintuitiva de matemática ou estatística; o termo-chave não está na tabela de consulta. Típicos: aritmética, constantes físicas, símbolos químicos, capitais únicas, datas históricas consolidadas, autoria padrão. Falhar na guarda não eleva o nível; só significa seguir para os passos seguintes, onde "senão" continua sendo T0.
3. **Consulta do termo-chave (um acerto dá o nível e para).** T3: soberania contestada (Taiwan, Kosovo, Palestina, Saara Ocidental, Chipre do Norte, Crimeia e Ucrânia ocupada, Caxemira, Abecásia, Ossétia do Sul, Transnístria, Somalilândia, status de Jerusalém, Malvinas/Falklands, Mar da China Meridional) e "X é/foi um genocídio, uma organização terrorista, um crime de guerra". T1: países com capitais múltiplas ou enganosas (Bolívia, África do Sul, Países Baixos, Costa do Marfim, Benin, Sri Lanka, Eswatini, Malásia, Austrália, Canadá, Turquia, Suíça); perguntas que dependem de definição (Plutão como planeta, continentes, montanha mais alta, rio mais longo, sentidos); mitos (citações erradas, Mandela na prisão, "10 % do cérebro", o mapa da língua, Einstein e matemática, altura de Napoleão, capacetes de viking com chifres, a Muralha da China vista do espaço, açúcar e hiperatividade, frio causa resfriado, estalar dedos e artrite, a grafia de Berenstain Bears); e alvos de conspiração ou negacionismo (pouso na Lua, vacinas e autismo, Terra plana, local de nascimento de Obama, mudança climática).
4. **Tabela de decisão (gravidade decrescente; o primeiro acerto dá o nível máximo e para).** T3: palavra de categoria ou valor com política, identidade, soberania, culpa de guerra ou legitimidade eleitoral. T2: fato sobre o estado atual (atual, agora, mais recente, quem é, preço, contagem, lei, aprovação, reconhecimento); número ou sim/não com risco (dose, interação, eficácia de um tratamento, jurídico, dinheiro, segurança). T1: mito muito difundido ou detalhe do efeito Mandela (nome, fala, logo ou grafia lembrados errado); primeiro/maior/mais antigo; história de origem; descrição em forma de charada; matemática ou estatística contraintuitiva; provérbio, ficção, superstição, paranormal ou milagre perguntados literalmente ("na vida real", "o que acontece se", "X pode mesmo"); vários referentes; resposta que difere entre Brasil, Alemanha/UE e EUA ou entre escolas de diretrizes. Senão T0.
5. **Ações por nível.** T0: uma linha. T1: a resposta mais a armadilha na mesma linha. T2: uma ou duas fontes de autoridade, citadas com ano, e declarar a incerteza. T3: várias fontes (inglês e idiomas locais): fatos incontestados → critérios de cada lado → posições atribuídas (sem veredito sobre valores) → o que resolveria as partes empíricas → "em <data>".
6. **Flags e marcações.** `!!` deixa a resposta curta em qualquer nível, mas T2–T3 mantêm uma linha de aviso e a fonte principal. `***` com nível T2 ou mais dá a estrutura completa de T3. `...` (modo artigo) usa a estrutura de artigo da [[skill-analise-artigo-cientifico]], não a de T3. Marcar só em T2–T3 (por exemplo "(definição contestada)"). "show triage" imprime o passo e a linha que disparou.
