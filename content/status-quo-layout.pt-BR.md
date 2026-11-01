---
id: status-quo-layout
lang: pt-BR
source_hash: a4f9b65399d4
title: Status Quo — esboço do layout em estilo de terminal
---

## What it is
Este é o layout proposto para [[status-quo-design]], um painel de desktop que mostra o uso dos assistentes e o trabalho atual. Todos os nomes, números, rótulos de tarefas e eventos abaixo são dados fictícios de demonstração. Não representam uma leitura atual da conta. Os diagramas são esboços em estilo de terminal: desenhos feitos com texto para mostrar disposição e comportamento antes de escrever o programa.

## What it does
A visão geral mantém o uso de cinco horas e semanal no topo, seguido por sessões, atividade dos repositórios e memória. Um painel estreito empilha os dois widgets de uso; um mais largo os coloca lado a lado. Widgets, componentes independentes de exibição, podem ser ocultados, redimensionados, destacados e reorganizados. Comandos de teclado para mover para cima e para baixo acompanham as alças de arrastar. A ilustração mostra a forma expandida; o modo compacto mantém cotas e estado das fontes enquanto recolhe os detalhes.

## How it does it
### Widgets independentes dentro da bandeja
A disposição visual aprovada continua sendo um esboço, não um agrupamento fixo de funcionalidades. Cada medidor de cota, gráfico de tokens, lista de sessões, feed do GitHub e feed da memória é um widget removível e substituível de forma independente. Um gráfico e um medidor desenhados próximos não se tornam um único componente. O catálogo de widgets da bandeja permite restaurar um widget removido ou substituí-lo por outro tipo compatível. Cada instância mantém suas próprias configurações. O layout em funcionamento deixará esses limites visíveis no modo de edição; o refinamento visual continuará depois que ele estiver rodando.

### Aba de visão geral — painel largo
```text
┌─ STATUS QUO ────────────────────────────────────────────────────────┐
│ [Visão geral] [Personalizar] [Fontes]       Editar layout: não  ─ × │
├────────────────────────────────┬───────────────────────────────────┤
│ :: CLAUDE           ↗ destacar │ :: CODEX                ↗ destacar│
│ 5h usado   ███████░░░  68%     │ 5h usado   ███░░░░░░░  32%       │
│ semanal    ████░░░░░░  41%     │ semanal    █████░░░░░  54%       │
│ reinicia em 02h14 / sex 18:00  │ reinicia em 03h02 / dom 12:00     │
│ [24h] [7d] [30d] [Intervalos ▾]│ [24h] [7d] [30d] [Intervalos ▾] │
│ tokens/hora                   │ tokens/hora                       │
│ 12k ┤       ╭╮                │ 12k ┤  ╭╮                         │
│  6k ┤ ╭╮ ╭──╯╰─╮              │  6k ┤╭─╯╰╮  ╭──╮                  │
│   0 └────────────────── tempo │   0 └─────────────────── tempo     │
│ entrada / saída / cache 14:32 │ entrada / saída / cache     14:32 │
├────────────────────────────────┴───────────────────────────────────┤
│ :: SESSÕES                        3 principais / 2 agentes filhos │
│ ▾ sample-project                                                  │
│   ▾ Claude · Criar intervalos do gráfico  EXECUTANDO 3/6 · há 4s  │
│     ├ filho · Conferir limites de tempo  EXECUTANDO       há 2s  │
│     └ filho · Revisar dados de teste     CONCLUÍDO       há 32s  │
│   ▸ Codex · Verificar importação         AGUARDANDO ENTRADA       │
│ ▸ another-project · Codex                OCIOSO                   │
├───────────────────────────────────────────────────────────────────┤
│ :: ATIVIDADE RECENTE             [Repositórios ▾] [Eventos ▾]     │
│ sample-project · commit · Corrigir limites dos intervalos há 6min │
│ sample-project · verificações passaram · revisão abc123  há 7min │
│ another-project · questão aberta · Melhorar carregamento há 25min│
├───────────────────────────────────────────────────────────────────┤
│ :: WORKFLOW MEMORY             [Ambos assistentes ▾] [Tipos ▾]    │
│ ▸ Decisão · Manter horário das fontes visível             há 9min │
│ ▸ Resolvido · Verificar recuperação após reiniciar      há 18min │
│ ▸ Preferência · Preferir exibição compacta              há 45min │
├───────────────────────────────────────────────────────────────────┤
│ KDE · atrás das janelas · navegação sim · fontes 5/5 atualizadas   │
└───────────────────────────────────────────────────────────────────┘
```

Os gráficos usam séries separadas com rótulos e legenda; o esboço usa uma linha só para não sugerir valores medidos. A inspeção por ponteiro ou teclado mostra intervalo exato, fuso horário e categorias dos contadores. Horário e cobertura da fonte continuam acessíveis mesmo no modo compacto. O controle de fechar oculta o painel; encerrar o coletor é uma ação explícita separada nas configurações.

### Aba de personalização
```text
┌─ STATUS QUO / PERSONALIZAR ────────────────────────────────────────┐
│ [Visão geral] [Personalizar] [Fontes]                              │
│ Estilo         [Terminal ▾]     Modo       [Escuro ▾]             │
│ Destaque       [#7DDE8A]        Texto      [14 px]                 │
│ Fundo          [#111816]        Cor texto  [#E0E8E2]               │
│ Opacidade do fundo  ────────●── 85%      Texto permanece legível  │
│ Aplicar a      [Todos widgets ▾] Densidade [Expandido ▾]          │
│ Camada         [Atrás das janelas ▾]                              │
│ [✓] Abrir links das fontes e navegação local                      │
│ [✓] Iniciar ao entrar          [ ] Travar layout                 │
│                                                                  │
│ Layout        [Editar disposição] [Layouts salvos ▾]            │
│ Predefinições [Salvar como…] [Importar…] [Exportar…]              │
│                                                                  │
│ Prévia        ┌─ CLAUDE ───────────────────────────────────────┐  │
│               │ 5h ███████░░░ 68%    semana ████░░░░░░ 41%    │  │
│               └───────────────────────────────────────────────┘  │
│                         [Restaurar padrão] [Cancelar] [Salvar]   │
└──────────────────────────────────────────────────────────────────┘
```

Alterar cores ou opacidade mostra uma prévia do resultado. Cancelar restaura os últimos valores salvos. O seletor de estilo lista estilos Rust instalados; não baixa extensões executáveis. Desligar a navegação desativa aberturas e links das fontes, mantendo a configuração e os controles locais da exibição. Tamanho da fonte e foco do teclado permanecem utilizáveis nos estilos claros e escuros.

### Aba de fontes e exemplo de falha
```text
┌─ FONTES ──────────────────────────────────────────────────────────┐
│ Claude     DESATUALIZADO · último sucesso 14:27 · tentar às 14:37  │
│            Exibindo limites anteriores, não uma nova medição      │
│ Codex      ATUALIZADO · último sucesso 14:32                      │
│ GitHub     OFFLINE · 3 repositórios · último sucesso 14:20         │
│ Memória    ATUALIZADA · somente leitura · ambos assistentes       │
│ Sessões    ATUALIZADAS · 1 sessão com estado desconhecido         │
│ Tokens     PARCIAL · 1 registro final incompleto · nova tentativa │
│ Desktop    KDE / Wayland · camada escolhida: atrás das janelas    │
│            Posicionamento verificado pelo invólucro do ambiente  │
└──────────────────────────────────────────────────────────────────┘
```

Cada widget mantém seu título e informa seu próprio estado: carregando, vazio, indisponível, desatualizado ou com erro. Uma falha nunca se transforma em um zero enganoso. A barra de saúde conta cinco grupos de fontes: Claude, Codex, GitHub, memória e sessões. Não conta linhas de sessões individuais; os detalhes identificam o adaptador com falha, a camada que traduz a fonte de dados. KDE Plasma é a interface do desktop que gerencia painéis e janelas; Wayland é o protocolo de exibição pelo qual os aplicativos mostram suas superfícies. Segredos e conteúdos completos das conversas nunca aparecem nos diagnósticos.

### Painel estreito e ambientes futuros
Em larguras pequenas, mantenha cada widget de uso completo em sua própria linha, seguido por sessões, atividade recente e memória. Listas que não cabem rolam dentro de uma altura configurável; o texto quebra linha ou abre uma visão local de detalhes. Não reduza as fontes automaticamente para caber. Um widget destacado usa o mesmo componente e valores de tema. Um ambiente de navegador usa os mesmos componentes com dados de exemplo e indica que posicionamento no desktop não é suportado.

## Where it sits in the pipeline
Este esboço acompanha a revisão de [[status-quo-design]]. Define ordem das informações e comportamento das interações, não medidas finais em pixels. As verificações visuais da implementação comparam capturas reais do desktop com estes layouts, incluindo larguras estreitas, modo claro, baixa opacidade, foco do teclado e fontes indisponíveis. [[project-template]] fornece as verificações de desenvolvimento usadas após a aprovação.

## Who receives its output
Giovanni revisa o layout junto com o desenho escrito. Quem desenvolve transforma o comportamento aprovado em requisitos e testes reais da interface. Estilos futuros preservam significados e capacidades enquanto substituem a apresentação.

## Notes
O esboço não contém atividade real de repositórios privados nem conteúdo de workflow-memory. Status Quo permanece em revisão do desenho; o painel de desktop em execução ainda não foi implementado.

![Status Quo — static English interface mockup; sample data](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDgwIiBoZWlnaHQ9IjExNjAiIHZpZXdCb3g9IjAgMCAxMDgwIDExNjAiPgo8cmVjdCB3aWR0aD0iMTA4MCIgaGVpZ2h0PSIxMTYwIiBmaWxsPSIjMGIxMDBmIi8+CjxnIGZvbnQtZmFtaWx5PSJEZWphVnUgU2FucyBNb25vLG1vbm9zcGFjZSIgZm9udC1zaXplPSIxNCIgZmlsbD0iI2RjZThkZiI+Cjx0ZXh0IHg9IjQwIiB5PSIzNiIgZmlsbD0iIzdkZGU4YSIgZm9udC1zaXplPSIyMiI+U1RBVFVTIFFVTyAvIERFU0lHTiBQUkVWSUVXPC90ZXh0Pgo8dGV4dCB4PSI0MCIgeT0iNjEiIGZpbGw9IiM5MmE3OWIiPkludmVudGVkIHNhbXBsZSBkYXRhIMK3IHRlcm1pbmFsIHN0eWxlIMK3IEtERSBkZXNrdG9wIHdyYXBwZXI8L3RleHQ+CjxyZWN0IHg9IjMyIiB5PSI4MiIgd2lkdGg9IjEwMTYiIGhlaWdodD0iNjcwIiByeD0iOCIgZmlsbD0iIzExMTgxNiIgc3Ryb2tlPSIjNDk2MjUzIi8+Cjx0ZXh0IHg9IjUyIiB5PSIxMTMiIGZpbGw9IiM3ZGRlOGEiIGZvbnQtc2l6ZT0iMTgiPiZndDtfIFNUQVRVUyBRVU88L3RleHQ+Cjx0ZXh0IHg9IjY3MCIgeT0iMTExIiBmaWxsPSIjOTJhNzliIj5iZWhpbmQgd2luZG93cyDCtyBsYXlvdXQgbG9ja2VkPC90ZXh0Pgo8cGF0aCBkPSJNMzIgMTMxIEgxMDQ4IiBzdHJva2U9IiM0OTYyNTMiLz4KPHJlY3QgeD0iNDkiIHk9IjE0NCIgd2lkdGg9IjExOCIgaGVpZ2h0PSIzMCIgZmlsbD0iIzI2M2QyZSIgcng9IjMiLz4KPHRleHQgeD0iNjMiIHk9IjE2NCIgZmlsbD0iIzdkZGU4YSI+T3ZlcnZpZXc8L3RleHQ+PHRleHQgeD0iMTkwIiB5PSIxNjQiPkN1c3RvbWl6ZTwvdGV4dD48dGV4dCB4PSIzMjUiIHk9IjE2NCI+U291cmNlczwvdGV4dD4KPHJlY3QgeD0iNTAiIHk9IjE5MCIgd2lkdGg9IjQ4MCIgaGVpZ2h0PSIyMjYiIGZpbGw9IiMxNjIxMWMiIHN0cm9rZT0iIzM1NGIzZSIvPgo8cmVjdCB4PSI1NDkiIHk9IjE5MCIgd2lkdGg9IjQ4MCIgaGVpZ2h0PSIyMjYiIGZpbGw9IiMxNjIxMWMiIHN0cm9rZT0iIzM1NGIzZSIvPgo8dGV4dCB4PSI2OCIgeT0iMjE4IiBmaWxsPSIjN2RkZThhIj46OiBDTEFVREU8L3RleHQ+PHRleHQgeD0iNTY3IiB5PSIyMTgiIGZpbGw9IiM3ZGRlOGEiPjo6IENPREVYPC90ZXh0Pgo8dGV4dCB4PSI2OCIgeT0iMjUwIj41aCB1c2VkPC90ZXh0Pjx0ZXh0IHg9IjQ1OSIgeT0iMjUwIiBmaWxsPSIjN2RkZThhIj42OCU8L3RleHQ+CjxyZWN0IHg9IjE2OCIgeT0iMjM3IiB3aWR0aD0iMjcwIiBoZWlnaHQ9IjE0IiBmaWxsPSIjMmMzYzMxIi8+PHJlY3QgeD0iMTY4IiB5PSIyMzciIHdpZHRoPSIxODQiIGhlaWdodD0iMTQiIGZpbGw9IiM3ZGRlOGEiLz4KPHRleHQgeD0iNjgiIHk9IjI3OCI+V2Vla2x5PC90ZXh0Pjx0ZXh0IHg9IjQ1OSIgeT0iMjc4IiBmaWxsPSIjN2RkZThhIj40MSU8L3RleHQ+CjxyZWN0IHg9IjE2OCIgeT0iMjY1IiB3aWR0aD0iMjcwIiBoZWlnaHQ9IjE0IiBmaWxsPSIjMmMzYzMxIi8+PHJlY3QgeD0iMTY4IiB5PSIyNjUiIHdpZHRoPSIxMTEiIGhlaWdodD0iMTQiIGZpbGw9IiM3ZGRlOGEiLz4KPHRleHQgeD0iNTY3IiB5PSIyNTAiPjVoIHVzZWQ8L3RleHQ+PHRleHQgeD0iOTU4IiB5PSIyNTAiIGZpbGw9IiM4MGM4ZDUiPjMyJTwvdGV4dD4KPHJlY3QgeD0iNjY3IiB5PSIyMzciIHdpZHRoPSIyNzAiIGhlaWdodD0iMTQiIGZpbGw9IiMyYzNjMzEiLz48cmVjdCB4PSI2NjciIHk9IjIzNyIgd2lkdGg9Ijg2IiBoZWlnaHQ9IjE0IiBmaWxsPSIjODBjOGQ1Ii8+Cjx0ZXh0IHg9IjU2NyIgeT0iMjc4Ij5XZWVrbHk8L3RleHQ+PHRleHQgeD0iOTU4IiB5PSIyNzgiIGZpbGw9IiM4MGM4ZDUiPjU0JTwvdGV4dD4KPHJlY3QgeD0iNjY3IiB5PSIyNjUiIHdpZHRoPSIyNzAiIGhlaWdodD0iMTQiIGZpbGw9IiMyYzNjMzEiLz48cmVjdCB4PSI2NjciIHk9IjI2NSIgd2lkdGg9IjE0NiIgaGVpZ2h0PSIxNCIgZmlsbD0iIzgwYzhkNSIvPgo8ZyBmaWxsPSIjOTJhNzliIiBmb250LXNpemU9IjEyIj48dGV4dCB4PSI2OCIgeT0iMzAxIj41aCByZXNldCBpbiAwMmggMTRtIMK3IHdlZWtseSBGcmkgMTg6MDA8L3RleHQ+PHRleHQgeD0iNTY3IiB5PSIzMDEiPjVoIHJlc2V0IGluIDAzaCAwMm0gwrcgd2Vla2x5IFN1biAxMjowMDwvdGV4dD48L2c+CjxwYXRoIGQ9Ik04MSAzMjAgVjM3NiBINTA1IE01ODAgMzIwIFYzNzYgSDEwMDQiIHN0cm9rZT0iIzQ5NjI1MyIgZmlsbD0ibm9uZSIvPgo8cGF0aCBkPSJNODIgMzY4IEwxMTAgMzY4IEwxMjUgMzUyIEwxNTAgMzU4IEwxNzMgMzQ1IEwyMDUgMzQ5IEwyMjggMzMwIEwyNTEgMzUxIEwyODMgMzU1IEwzMDYgMzQxIEwzMzAgMzQ4IEwzNTUgMzM1IEwzODAgMzUwIEw0MTUgMzUyIEw0NDAgMzYzIEw0NzggMzU4IEw1MDMgMzY5IiBzdHJva2U9IiM3ZGRlOGEiIGZpbGw9Im5vbmUiIHN0cm9rZS13aWR0aD0iMiIvPgo8cGF0aCBkPSJNNTgxIDM2NiBMNjExIDM1NSBMNjM3IDM2MCBMNjYwIDMyOSBMNjg1IDM0NCBMNzE0IDM1MCBMNzQwIDM2NyBMNzYyIDM2NCBMNzg4IDM0OSBMODE2IDM1MiBMODQzIDM0NSBMODcwIDM1NyBMODk5IDM1OSBMOTI0IDM2MyBMOTYwIDM1MyBMMTAwMyAzNjUiIHN0cm9rZT0iIzgwYzhkNSIgZmlsbD0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIyIi8+Cjx0ZXh0IHg9IjY4IiB5PSI0MDAiIGZpbGw9IiM5MmE3OWIiIGZvbnQtc2l6ZT0iMTIiPnRva2Vucy9ob3VyIMK3IFsyNGhdIDdkIDMwZCDCtyBpbnB1dC9vdXRwdXQvY2FjaGU8L3RleHQ+PHRleHQgeD0iNTY3IiB5PSI0MDAiIGZpbGw9IiM5MmE3OWIiIGZvbnQtc2l6ZT0iMTIiPnRva2Vucy9ob3VyIMK3IFsyNGhdIDdkIDMwZCDCtyBpbnB1dC9vdXRwdXQvY2FjaGU8L3RleHQ+CjxwYXRoIGQ9Ik01MCA0MzYgSDEwMjgiIHN0cm9rZT0iIzM1NGIzZSIvPjx0ZXh0IHg9IjY4IiB5PSI0NjMiIGZpbGw9IiM3ZGRlOGEiPjo6IFNFU1NJT05TIC8gc2FtcGxlLXByb2plY3Q8L3RleHQ+PHRleHQgeD0iNzYxIiB5PSI0NjMiIGZpbGw9IiM5MmE3OWIiPjMgbWFpbiDCtyAyIGNoaWxkcmVuPC90ZXh0Pgo8dGV4dCB4PSI4MiIgeT0iNDkwIj52IENsYXVkZSDCtyBJbXBsZW1lbnQgZ3JhcGggYnVja2V0czwvdGV4dD48dGV4dCB4PSI3MzQiIHk9IjQ5MCIgZmlsbD0iIzdkZGU4YSI+UlVOTklORyAgIDMvNjwvdGV4dD4KPHRleHQgeD0iMTEwIiB5PSI1MTQiIGZpbGw9IiM5MmE3OWIiPuKUnCBjaGlsZCDCtyBDaGVjayB0aW1lIGJvdW5kYXJpZXM8L3RleHQ+PHRleHQgeD0iNzM0IiB5PSI1MTQiIGZpbGw9IiM3ZGRlOGEiPlJVTk5JTkc8L3RleHQ+Cjx0ZXh0IHg9IjExMCIgeT0iNTM4IiBmaWxsPSIjOTJhNzliIj7ilJQgY2hpbGQgwrcgUmV2aWV3IGZpeHR1cmVzPC90ZXh0Pjx0ZXh0IHg9IjczNCIgeT0iNTM4IiBmaWxsPSIjOTJhNzliIj5DT01QTEVURUQ8L3RleHQ+Cjx0ZXh0IHg9IjgyIiB5PSI1NjIiPiZndDsgQ29kZXggwrcgVmVyaWZ5IGhpc3RvcnkgaW1wb3J0PC90ZXh0Pjx0ZXh0IHg9IjczNCIgeT0iNTYyIiBmaWxsPSIjZTZjNTc1Ij5XQUlUSU5HIEZPUiBJTlBVVDwvdGV4dD4KPHBhdGggZD0iTTUwIDU4MCBIMTAyOCIgc3Ryb2tlPSIjMzU0YjNlIi8+PHRleHQgeD0iNjgiIHk9IjYwNiIgZmlsbD0iIzdkZGU4YSI+OjogUkVDRU5UIEFDVElWSVRZPC90ZXh0Pjx0ZXh0IHg9IjY4IiB5PSI2MzAiPnNhbXBsZS1wcm9qZWN0IMK3IGNvbW1pdCDCtyBDb3JyZWN0IGJ1Y2tldCBib3VuZGFyaWVzPC90ZXh0Pjx0ZXh0IHg9Ijk0MCIgeT0iNjMwIiBmaWxsPSIjOTJhNzliIj42bTwvdGV4dD4KPHRleHQgeD0iNjgiIHk9IjY1NiIgZmlsbD0iIzdkZGU4YSI+OjogV09SS0ZMT1cgTUVNT1JZPC90ZXh0Pjx0ZXh0IHg9IjY4IiB5PSI2ODAiPiZndDsgRGVjaXNpb24gwrcgS2VlcCBzb3VyY2UgdGltZXN0YW1wcyB2aXNpYmxlPC90ZXh0Pjx0ZXh0IHg9Ijk0MCIgeT0iNjgwIiBmaWxsPSIjOTJhNzliIj45bTwvdGV4dD4KPHBhdGggZD0iTTMyIDcwNyBIMTA0OCIgc3Ryb2tlPSIjNDk2MjUzIi8+PHRleHQgeD0iNTIiIHk9IjczMyIgZmlsbD0iIzkyYTc5YiI+S0RFIC8gV2F5bGFuZCDCtyBuYXZpZ2F0aW9uIG9uIMK3IHNvdXJjZXMgNS81IGZyZXNoIMK3IHVwZGF0ZWQgMTQ6MzI8L3RleHQ+CjxyZWN0IHg9IjMyIiB5PSI3ODAiIHdpZHRoPSIxMDE2IiBoZWlnaHQ9IjMzNSIgcng9IjgiIGZpbGw9IiMxMTE4MTYiIHN0cm9rZT0iIzQ5NjI1MyIvPgo8dGV4dCB4PSI1MiIgeT0iODEzIiBmaWxsPSIjN2RkZThhIiBmb250LXNpemU9IjE4Ij5DVVNUT01JWkUgLyBsaXZlIHByZXZpZXcgYmVmb3JlIHNhdmluZzwvdGV4dD4KPHRleHQgeD0iNTIiIHk9Ijg1MCI+U3R5bGUgIFtUZXJtaW5hbCB2XTwvdGV4dD48dGV4dCB4PSI1NTAiIHk9Ijg1MCI+TW9kZSAgW0Rhcmsgdl08L3RleHQ+Cjx0ZXh0IHg9IjUyIiB5PSI4ODQiPkFjY2VudCBbIzdEREU4QV08L3RleHQ+PHJlY3QgeD0iMjIzIiB5PSI4NjYiIHdpZHRoPSIyOCIgaGVpZ2h0PSIyMiIgZmlsbD0iIzdkZGU4YSIvPgo8dGV4dCB4PSI1NTAiIHk9Ijg4NCI+VGV4dCBzaXplICBbMTQgcHhdPC90ZXh0Pgo8dGV4dCB4PSI1MiIgeT0iOTE4Ij5CYWNrZ3JvdW5kIG9wYWNpdHk8L3RleHQ+PHBhdGggZD0iTTI1NSA5MTMgSDQ3MiIgc3Ryb2tlPSIjNDk2MjUzIiBzdHJva2Utd2lkdGg9IjQiLz48Y2lyY2xlIGN4PSI0NDAiIGN5PSI5MTMiIHI9IjciIGZpbGw9IiM3ZGRlOGEiLz48dGV4dCB4PSI0ODciIHk9IjkxOCI+ODUlPC90ZXh0Pgo8dGV4dCB4PSI1NTAiIHk9IjkxOCI+TGF5ZXIgW0JlaGluZCB3aW5kb3dzIHZdPC90ZXh0Pgo8dGV4dCB4PSI1MiIgeT0iOTUyIj5beF0gTmF2aWdhdGlvbiAgIFt4XSBTdGFydCBhdCBsb2dpbjwvdGV4dD48dGV4dCB4PSI1NTAiIHk9Ijk1MiI+QXBwbHkgdG8gW0FsbCB3aWRnZXRzIHZdPC90ZXh0Pgo8dGV4dCB4PSI1MiIgeT0iOTg2IiBmaWxsPSIjOTJhNzliIj5bRWRpdCBhcnJhbmdlbWVudF0gW1ByZXNldHNdIFtJbXBvcnRdIFtFeHBvcnRdPC90ZXh0Pgo8cGF0aCBkPSJNNTIgMTAwNSBIMTAyOCIgc3Ryb2tlPSIjMzU0YjNlIi8+PHRleHQgeD0iNTIiIHk9IjEwMzMiIGZpbGw9IiM5MmE3OWIiPlBlci13aWRnZXQgY29sb3JzIMK3IGZvbnQgc2l6ZXMgwrcgY29tcGFjdCBtb2RlIMK3IHNhdmVkIGxheW91dHM8L3RleHQ+Cjx0ZXh0IHg9IjUyIiB5PSIxMDgwIj5bUmVzdG9yZSBkZWZhdWx0c108L3RleHQ+PHRleHQgeD0iNzYwIiB5PSIxMDgwIj5bQ2FuY2VsXTwvdGV4dD48cmVjdCB4PSI5MDAiIHk9IjEwNTciIHdpZHRoPSIxMTUiIGhlaWdodD0iMzUiIHJ4PSIzIiBmaWxsPSIjMjYzZDJlIi8+PHRleHQgeD0iOTI5IiB5PSIxMDgwIiBmaWxsPSIjN2RkZThhIj5TYXZlPC90ZXh0Pgo8dGV4dCB4PSI0MCIgeT0iMTE0NCIgZmlsbD0iIzkyYTc5YiIgZm9udC1zaXplPSIxMiI+U3RhdGljIG1vY2t1cCBvbmx5LiBHcmFwaHMgYW5kIGV2ZW50cyBhcmUgc2FtcGxlIGRhdGE7IGNvbnRyb2xzIGFyZSBpbGx1c3RyYXRpdmUuPC90ZXh0Pgo8L2c+PC9zdmc+Cg==)
