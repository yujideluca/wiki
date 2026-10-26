---
id: glossary
lang: pt-BR
source_hash: a31fdfea6dac
title: Glossário
---

## What it is
Este é o dicionário do wiki: definições em linguagem simples das palavras técnicas e abreviações usadas em suas páginas, com um link para uma boa explicação externa quando existe. Se você encontrar uma palavra desconhecida, procure-a aqui; além disso, cada página explica um termo onde o usa pela primeira vez. Os verbetes que têm página própria neste wiki apontam para ela.

## What it does
Permite a um leitor sem conhecimento de software, deste sistema ou de medicina entender qualquer página sem sair do wiki por muito tempo. Os termos estão em ordem alfabética em Notes. Um termo escrito em outro idioma (nomes de exames alemães, por exemplo) também é explicado aqui.

## How it does it
Cada verbete traz o nome completo de uma abreviação, uma definição curta em palavras do dia a dia e, quando útil, um link. A página é do tipo "reference": pode apontar para qualquer página sem desenhar linhas no mapa (registrado como requisito BU-3). A barra superior de toda tela leva até ela.

## Where it sits in the pipeline
Ao lado das páginas que explica. Não pertence a nenhum projeto e não participa de nenhum pipeline.

## Who receives its output
Todo leitor do wiki, sobretudo o [[giovanni]] e quem é novo no sistema.

## Notes
- **Activity / Android Activity**: um componente de um app Android que hospeda uma tela ([documentação](https://developer.android.com/guide/components/activities/intro-activities)).
- **adb** (Android Debug Bridge): uma ferramenta que permite a um computador controlar um celular Android por cabo ([documentação](https://developer.android.com/tools/adb)); veja [[skill-adb-android-control]].
- **ADR** (architecture decision record): uma nota curta que registra uma decisão importante, por que foi tomada e quais eram as alternativas ([adr.github.io](https://adr.github.io/)); veja [[quizapp-adrs]] e [[memory-adrs]].
- **Anki**: um programa de flashcards que usa repetição espaçada ([apps.ankiweb.net](https://apps.ankiweb.net/)).
- **API** (application programming interface): a forma como um programa oferece suas funções a outros programas, em geral pela web.
- **APK** (Android Package): o arquivo que contém um app Android e é instalado no celular ([APK](https://en.wikipedia.org/wiki/Apk_%28file_format%29)).
- **Approbation**: na Alemanha, a licença para exercer a medicina. **Anerkennung** é o reconhecimento de uma qualificação estrangeira. Veja [[skill-candidatura-alemanha]].
- **Append-only (só acréscimo)**: um registro ao qual só se acrescentam itens novos, sem nunca editar ou apagar; veja [[events-log]].
- **Asset**: um arquivo embutido em um app que não é código, como dados ou imagens; veja [[vocab-assets]].
- **Bash**: a linguagem de comandos padrão do terminal do Linux; scripts escritos nela terminam em `.sh` ([Bash](https://www.gnu.org/software/bash/)).
- **Canal beta / estável**: dois fluxos de versões do app; o beta é testado primeiro, o estável é o que o usuário normalmente usa; veja [[release-channels]].
- **Branch**: uma linha de trabalho separada em um repositório git; `main` é a principal.
- **Brief**: o resumo curto da memória com que toda conversa começa; veja [[session-brief]].
- **CI** (integração contínua): verificações automáticas que rodam a cada mudança enviada, para um erro ser notado na hora ([CI](https://en.wikipedia.org/wiki/Continuous_integration)); veja [[quizapp-ci]].
- **CLAUDE.md**: um arquivo de texto com instruções permanentes que o Claude Code lê automaticamente no início de uma sessão; veja [[global-claude-md]].
- **CLI** (command-line interface, interface de linha de comando): um programa usado digitando comandos em um terminal ([CLI](https://en.wikipedia.org/wiki/Command-line_interface)).
- **Clone**: uma cópia local completa de um repositório.
- **Commit**: um passo salvo no histórico de um repositório git, com uma mensagem dizendo o que mudou.
- **Vetores de conformidade**: casos de teste compartilhados que duas implementações precisam passar; veja [[quizweb-conformance]].
- **Cookie**: um pequeno dado que um site pede ao navegador para guardar e devolver, usado para lembrar um login ([cookie](https://en.wikipedia.org/wiki/HTTP_cookie)); veja [[wiki-router]].
- **CPF** (Cadastro de Pessoas Físicas): o número brasileiro de contribuinte; a verificação de privacidade o bloqueia ([[mem-validator]]).
- **CSP** (Content Security Policy): uma regra que diz ao navegador o que uma página web pode carregar ([CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)).
- **Dívida técnica**: tudo o que funciona hoje, mas torna a próxima mudança mais lenta ou arriscada ([dívida técnica](https://en.wikipedia.org/wiki/Technical_debt)); veja [[maintenance-policy]].
- **Decoy / isca**: uma página que parece real mas esconde o real; veja [[decoy-page]].
- **DNS** (Domain Name System): a lista telefônica da internet, que converte nomes em endereços de rede ([DNS](https://en.wikipedia.org/wiki/Domain_Name_System)).
- **DOM** (Document Object Model): o modelo vivo do navegador para uma página web ([documentação](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)).
- **DORA** (DevOps Research and Assessment): um programa de pesquisa que definiu quatro medidas de quão bem o software é entregue, como a frequência e a rapidez com que mudanças são lançadas ([dora.dev](https://dora.dev/)); veja [[pipeline-check]].
- **Elixir**: a linguagem de programação do servidor do wiki ([elixir-lang.org](https://elixir-lang.org/)); veja [[wiki-server]].
- **Elm**: a linguagem de programação do front end do wiki ([elm-lang.org](https://elm-lang.org/)); veja [[wiki-frontend]].
- **Escript**: um programa Elixir empacotado em um único arquivo executável; veja [[wiki-cli]].
- **Evento (event)**: um registro de que algo aconteceu; na memória, um arquivo por evento; veja [[events-log]].
- **Código de saída (exit code)**: o número que um programa devolve ao terminar; 0 significa sucesso, qualquer outro um erro ([exit status](https://en.wikipedia.org/wiki/Exit_status)).
- **Função de aptidão (fitness function)**: uma verificação automática de que uma qualidade do design não se desviou ([fitness function](https://en.wikipedia.org/wiki/Fitness_function)); veja [[fitness-check]].
- **Fold / dobra**: combinar uma lista inteira de eventos em um estado atual; veja [[memory-fold]].
- **FSP** (Fachsprachprüfung): a prova alemã de linguagem médica no nível C1 que médicos estrangeiros fazem antes de serem licenciados; veja [[skill-alemao-goethe-fsp]].
- **Portão / portão de qualidade (gate)**: um script que define "aprovado" para um projeto; veja [[template-quality-gate]].
- **Git**: a ferramenta de controle de versão que registra toda mudança de um projeto ([git-scm.com](https://git-scm.com/)).
- **GitHub / GitHub Actions**: um site que guarda repositórios git; o Actions executa tarefas automáticas em seus computadores ([documentação](https://docs.github.com/en/actions)); veja [[github]].
- **Goethe B2**: o exame geral de alemão em nível intermediário-superior (nível B2 do quadro europeu de referência) ([Goethe-Zertifikat B2](https://www.goethe.de/en/spr/prf/gzb2.html)).
- **GRADE** (Grading of Recommendations Assessment, Development and Evaluation): um método para classificar quão certo é um conjunto de evidências médicas ([GRADE](https://www.gradeworkinggroup.org/)); veja [[skill-analise-artigo-cientifico]].
- **Gradle**: a ferramenta que compila e testa projetos Android ([gradle.org](https://gradle.org/)); veja [[android-toolchain]].
- **Hash**: uma impressão digital curta calculada a partir de um conteúdo; se o conteúdo muda, a impressão muda ([função hash](https://en.wikipedia.org/wiki/Hash_function)); veja **SHA-256** (Secure Hash Algorithm 256).
- **Hook**: um pequeno programa que o Claude Code executa automaticamente em um certo momento, como o início de uma conversa ([hooks explicados](https://docs.claude.com/en/docs/claude-code/hooks-guide)); veja [[hook-session-start]].
- **Hospitation**: na Alemanha, uma visita de observação em um setor de hospital.
- **HTML** (HyperText Markup Language): a linguagem em que as páginas web são escritas ([HTML](https://en.wikipedia.org/wiki/HTML)).
- **HTTPS** (Hypertext Transfer Protocol Secure): a forma criptografada como navegadores e sites conversam.
- **Idempotente**: fazer duas vezes dá o mesmo resultado que fazer uma ([idempotência](https://en.wikipedia.org/wiki/Idempotence)).
- **JSON** (JavaScript Object Notation): um formato de texto simples para dados estruturados ([JSON](https://en.wikipedia.org/wiki/JSON)).
- **Kenntnisprüfung**: a prova de conhecimentos médicos que médicos formados no exterior podem fazer na Alemanha no lugar de uma verificação de equivalência de documentos.
- **Kotlin / Jetpack Compose**: a linguagem de programação e o kit de telas do app Android ([Kotlin](https://kotlinlang.org/), [Compose](https://developer.android.com/compose)); veja [[quizapp]].
- **Linger**: uma configuração do Linux que deixa os serviços de fundo de um usuário rodarem sem ninguém logado; veja [[acer-nitro]].
- **localStorage**: um pequeno armazenamento chave-valor que todo navegador oferece a uma página web ([documentação](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage)).
- **logcat**: o log do sistema do Android, lido com o adb ([documentação](https://developer.android.com/tools/logcat)).
- **Manifesto**: uma lista que descreve os arquivos de um pacote e como verificá-los; veja [[content-manifest]].
- **Markdown**: um formato de texto com marcas simples para títulos, listas e links ([Markdown](https://en.wikipedia.org/wiki/Markdown)); veja [[wiki-content]].
- **Memória (workflow-memory)**: a memória compartilhada de longo prazo dos assistentes Claude do Giovanni; veja [[workflow-memory]].
- **Teste de mutação**: quebrar um programa de propósito para verificar se os testes percebem ([mutation testing](https://en.wikipedia.org/wiki/Mutation_testing)); veja [[mutation-check]].
- **OAuth** (Open Authorization) e **OIDC** (OpenID Connect): os padrões pelos quais um serviço como o Google informa a um site quem está entrando ([OAuth](https://en.wikipedia.org/wiki/OAuth)); veja [[wiki-sign-in]].
- **Pendência (open item)**: uma meta inacabada ou problema conhecido mantido diante do Giovanni até ser resolvido; veja [[mem-task]].
- **OTP** (Open Telecom Platform): as bibliotecas padrão e o ambiente de execução do Erlang, sobre o qual roda o Elixir ([erlang.org](https://www.erlang.org/)).
- **PICO** (população, intervenção, comparador, desfecho): as quatro partes de uma pergunta clínica bem formulada.
- **Pipeline**: uma cadeia de passos em que cada passo recebe o resultado do anterior; neste wiki também a cadeia de páginas que se alimentam.
- **Plugin**: um pacote complementar do Claude Code; veja [[claude-plugins]].
- **Código de produção**: o código que de fato roda no programa pronto, em oposição ao código de teste.
- **Promover (promote)**: levar uma versão beta testada ao canal estável, o que é decisão do Giovanni; veja [[publish-apk]].
- **Pull / push**: baixar a versão mais recente de um repositório e enviar suas próprias mudanças a ele.
- **Pull request**: uma proposta de incorporar uma mudança à linha principal de um repositório.
- **Função pura**: uma função cujo resultado depende só da entrada e que não altera mais nada ([função pura](https://en.wikipedia.org/wiki/Pure_function)).
- **PWA** (progressive web app): uma página web que pode ser instalada no celular como um app e funciona offline ([PWA](https://en.wikipedia.org/wiki/Progressive_web_app)); veja [[quizweb]].
- **Repositório**: uma pasta de projeto junto com o histórico completo de suas mudanças, guardada com git ([repositório](https://en.wikipedia.org/wiki/Repository_%28version_control%29)).
- **Requisito**: uma promessa testável de um programa; veja [[wiki-requirements]].
- **Remote Control**: o recurso do Claude Code que permite ao Giovanni falar com uma sessão do notebook pelo app Claude; veja [[claude-assistant]].
- **SDK** (software development kit): as bibliotecas e ferramentas para desenvolver software para uma plataforma; veja [[android-toolchain]].
- **Serviço (systemd)**: um programa que roda em segundo plano e é iniciado e vigiado pelo sistema operacional ([systemd](https://en.wikipedia.org/wiki/Systemd)); veja [[wiki-service]].
- **Service worker**: um script que o navegador executa em segundo plano para uma página web, que permite uso offline ([documentação](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)); veja [[quizweb-service-worker]].
- **SHA-256** (Secure Hash Algorithm 256): uma forma de calcular a impressão digital de um arquivo ([SHA-2](https://en.wikipedia.org/wiki/SHA-2)).
- **Skill**: um conjunto empacotado de instruções que o Claude carrega quando surge uma tarefa desse tipo; veja [[skills]].
- **SM-2** (SuperMemo 2): um algoritmo inicial de repetição espaçada ([SuperMemo](https://en.wikipedia.org/wiki/SuperMemo)); veja [[spaced-repetition-scheduler]].
- **Repetição espaçada**: um método de estudo em que o que você sabe volta após intervalos cada vez maiores ([repetição espaçada](https://en.wikipedia.org/wiki/Spaced_repetition)).
- **SSH** (Secure Shell): uma forma criptografada de entrar em outro computador ([SSH](https://en.wikipedia.org/wiki/Secure_Shell)); veja [[remote-terminal]].
- **Stale / desatualizado**: fora de data. Uma página com fontes está desatualizada quando uma delas mudou depois do `reviewed` da página; uma página sem fontes aparece como "pode estar desatualizada" 30 dias depois desse horário. Veja [[wiki-stale]].
- **Linha de status**: a linha única no rodapé do terminal do Claude Code; veja [[pbar]].
- **sudo**: o comando que executa outro comando com direitos de administrador.
- **SVG** (Scalable Vector Graphics): um formato para desenhos feitos de formas, usado pelo mapa ([SVG](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics)).
- **Tailnet**: a rede privada que o Tailscale constrói entre seus dispositivos; veja [[tailscale]].
- **Terminal**: a janela de texto onde se digitam comandos.
- **tmux**: um programa que mantém uma sessão de terminal rodando quando você se desconecta ([tmux](https://github.com/tmux/tmux/wiki)).
- **Token**: um pedacinho de texto, cerca de três quartos de uma palavra, em que se mede o uso de um modelo de IA; também um código secreto que prova identidade.
- **TLS** (Transport Layer Security): a criptografia usada pelo HTTPS ([TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security)).
- **Rastreabilidade**: poder seguir cada requisito até o teste que o verifica; veja [[check-traceability]].
- **TSV** (tab-separated values, valores separados por tabulação): uma tabela em texto simples com colunas separadas por tabulação ([TSV](https://en.wikipedia.org/wiki/Tab-separated_values)).
- **UI** (user interface, interface de usuário): o que o usuário vê e toca na tela.
- **URL** (Uniform Resource Locator): um endereço web.
- **Espaço de usuário (user space)**: instalado nas pastas do próprio usuário, de modo que não são necessários direitos de administrador; veja [[user-space-tools]].
- **ViewModel**: a parte de um app Android que prepara dados para as telas e sobrevive a rotações de tela ([documentação](https://developer.android.com/topic/libraries/architecture/viewmodel)); veja [[study-view-model]].
- **VPN** (virtual private network, rede privada virtual): um link criptografado que faz dispositivos distantes se comportarem como se estivessem em uma só rede local ([VPN](https://en.wikipedia.org/wiki/Virtual_private_network)).
- **Gêmeo web (web twin)**: a versão web que espelha o app Android; veja [[quizweb]].

- **Reconstrução da máquina**: registrar a configuração de um computador para reconstruí-la após reinstalar; veja [[machine-bootstrap]].
- **Progresso de tarefas do Codex**: linha fixa do terminal com etapas concluídas e tempo restante estimado; veja [[codex-pbar]].
