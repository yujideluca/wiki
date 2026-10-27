module I18n exposing (Lang(..), Strings, all, code, fromCode, label, sectionHeading, strings)

{-| Interface text in the three languages. English is the default (D13). -}


type Lang
    = En
    | De
    | PtBr


all : List Lang
all =
    [ En, De, PtBr ]


code : Lang -> String
code lang =
    case lang of
        En ->
            "en"

        De ->
            "de"

        PtBr ->
            "pt-BR"


fromCode : String -> Lang
fromCode c =
    case c of
        "de" ->
            De

        "pt-BR" ->
            PtBr

        _ ->
            En


label : Lang -> String
label lang =
    case lang of
        En ->
            "English"

        De ->
            "Deutsch"

        PtBr ->
            "Português (BR)"


type alias Strings =
    { search : String
    , noResults : String
    , whatItIs : String
    , whatItDoes : String
    , fedBy : String
    , receives : String
    , nothing : String
    , hoverHint : String
    , openArticle : String
    , backToMap : String
    , allProjects : String
    , timeline : String
    , kind : String
    , project : String
    , status : String
    , location : String
    , since : String
    , until : String
    , sources : String
    , memory : String
    , history : String
    , mayBeStale : String
    , pipeline : String
    , neighbours : String
    , step : String
    , previous : String
    , next : String
    , loading : String
    , loadError : String
    , menu : String
    , close : String
    , tapHint : String
    , logout : String
    , glossary : String
    , notTranslated : String
    , legend : String
    , flowStart : String
    , flowStep : String
    , flowQuestion : String
    , flowEnd : String
    , flowHint : String
    , archContext : String
    , archContainers : String
    , archPerson : String
    , archSystem : String
    , archContainer : String
    , archStore : String
    , archExternal : String
    }


strings : Lang -> Strings
strings lang =
    case lang of
        En ->
            { search = "Search the system…"
            , noResults = "Nothing found"
            , whatItIs = "What it is"
            , whatItDoes = "What it does"
            , fedBy = "Fed by"
            , receives = "Who receives its output"
            , nothing = "—"
            , hoverHint = "Hover over a dot to see what it is. Click it to open its page."
            , openArticle = "Open page →"
            , backToMap = "← Map"
            , allProjects = "All projects"
            , timeline = "As of"
            , kind = "Kind"
            , project = "Project"
            , status = "Status"
            , location = "Lives in"
            , since = "Since"
            , until = "Until"
            , sources = "Sources"
            , memory = "Memory entries"
            , history = "History"
            , mayBeStale = "May be stale: last reviewed"
            , pipeline = "Where it sits in the pipeline"
            , neighbours = "Connected pages"
            , step = "Step"
            , previous = "← Previous"
            , next = "Next →"
            , loading = "Loading…"
            , loadError = "Could not load the wiki data."
            , menu = "Menu"
            , close = "Close"
            , tapHint = "Tap a dot to see what it is."
            , logout = "Log out"
            , glossary = "Glossary"
            , notTranslated = "This page has no translation yet; showing English."
            , legend = "Kinds"
            , flowStart = "What starts it"
            , flowStep = "A step"
            , flowQuestion = "A question"
            , flowEnd = "End product"
            , flowHint = "Click a page name to open it. A wide chart scrolls sideways."
            , archContext = "Level 1 of the C4 model: the system as one box, with the people and outside systems around it."
            , archContainers = "Level 2: the system opened into the parts that run or keep data."
            , archPerson = "A person"
            , archSystem = "This system"
            , archContainer = "A part that runs"
            , archStore = "A data store"
            , archExternal = "Outside system"
            }

        De ->
            { search = "Im System suchen…"
            , noResults = "Nichts gefunden"
            , whatItIs = "Was es ist"
            , whatItDoes = "Was es tut"
            , fedBy = "Gespeist von"
            , receives = "Wer seine Ausgabe erhält"
            , nothing = "—"
            , hoverHint = "Fahre über einen Punkt, um zu sehen, was er ist. Klicke, um seine Seite zu öffnen."
            , openArticle = "Seite öffnen →"
            , backToMap = "← Karte"
            , allProjects = "Alle Projekte"
            , timeline = "Stand"
            , kind = "Art"
            , project = "Projekt"
            , status = "Status"
            , location = "Ort"
            , since = "Seit"
            , until = "Bis"
            , sources = "Quellen"
            , memory = "Gedächtniseinträge"
            , history = "Verlauf"
            , mayBeStale = "Evtl. veraltet: zuletzt geprüft"
            , pipeline = "Wo es in der Pipeline steht"
            , neighbours = "Verbundene Seiten"
            , step = "Schritt"
            , previous = "← Zurück"
            , next = "Weiter →"
            , loading = "Wird geladen…"
            , loadError = "Die Wiki-Daten konnten nicht geladen werden."
            , menu = "Menü"
            , close = "Schließen"
            , tapHint = "Tippe auf einen Punkt, um zu sehen, was er ist."
            , logout = "Abmelden"
            , glossary = "Glossar"
            , notTranslated = "Diese Seite ist noch nicht übersetzt; Anzeige auf Englisch."
            , legend = "Arten"
            , flowStart = "Was es auslöst"
            , flowStep = "Ein Schritt"
            , flowQuestion = "Eine Frage"
            , flowEnd = "Endprodukt"
            , flowHint = "Auf einen Seitennamen klicken, um ihn zu öffnen. Ein breites Diagramm lässt sich seitlich scrollen."
            , archContext = "Ebene 1 des C4-Modells: das System als ein Kasten, umgeben von Personen und fremden Systemen."
            , archContainers = "Ebene 2: das System geöffnet in die Teile, die laufen oder Daten halten."
            , archPerson = "Eine Person"
            , archSystem = "Dieses System"
            , archContainer = "Ein laufender Teil"
            , archStore = "Ein Datenspeicher"
            , archExternal = "Fremdes System"
            }

        PtBr ->
            { search = "Buscar no sistema…"
            , noResults = "Nada encontrado"
            , whatItIs = "O que é"
            , whatItDoes = "O que faz"
            , fedBy = "Alimentado por"
            , receives = "Quem recebe o que produz"
            , nothing = "—"
            , hoverHint = "Passe o mouse sobre um ponto para ver o que é. Clique para abrir a página."
            , openArticle = "Abrir página →"
            , backToMap = "← Mapa"
            , allProjects = "Todos os projetos"
            , timeline = "Em"
            , kind = "Tipo"
            , project = "Projeto"
            , status = "Status"
            , location = "Onde fica"
            , since = "Desde"
            , until = "Até"
            , sources = "Fontes"
            , memory = "Entradas de memória"
            , history = "Histórico"
            , mayBeStale = "Pode estar desatualizado: revisado em"
            , pipeline = "Onde fica no fluxo"
            , neighbours = "Páginas conectadas"
            , step = "Passo"
            , previous = "← Anterior"
            , next = "Próximo →"
            , loading = "Carregando…"
            , loadError = "Não foi possível carregar os dados do wiki."
            , menu = "Menu"
            , close = "Fechar"
            , tapHint = "Toque em um ponto para ver o que é."
            , logout = "Sair"
            , glossary = "Glossário"
            , notTranslated = "Esta página ainda não foi traduzida; exibindo em inglês."
            , legend = "Tipos"
            , flowStart = "O que inicia"
            , flowStep = "Um passo"
            , flowQuestion = "Uma pergunta"
            , flowEnd = "Produto final"
            , flowHint = "Clique no nome de uma página para abri-la. Um diagrama largo rola para os lados."
            , archContext = "Nível 1 do modelo C4: o sistema como uma caixa só, com as pessoas e os sistemas de fora ao redor."
            , archContainers = "Nível 2: o sistema aberto nas partes que executam ou guardam dados."
            , archPerson = "Uma pessoa"
            , archSystem = "Este sistema"
            , archContainer = "Uma parte que executa"
            , archStore = "Um armazém de dados"
            , archExternal = "Sistema de fora"
            }


sectionHeading : Lang -> String -> String
sectionHeading lang key =
    case ( lang, key ) of
        ( En, "what" ) ->
            "What it is"

        ( En, "does" ) ->
            "What it does"

        ( En, "how" ) ->
            "How it does it"

        ( En, "where" ) ->
            "Where it sits in the pipeline"

        ( En, "receives" ) ->
            "Who receives its output"

        ( En, "architecture" ) ->
            "Architecture"

        ( En, "practices" ) ->
            "Engineering practices"

        ( En, "flow" ) ->
            "Flow chart"

        ( En, "steps" ) ->
            "Steps"

        ( En, "functions" ) ->
            "Functions"

        ( En, "notes" ) ->
            "Notes"

        ( De, "what" ) ->
            "Was es ist"

        ( De, "does" ) ->
            "Was es tut"

        ( De, "how" ) ->
            "Wie es das tut"

        ( De, "where" ) ->
            "Wo es in der Pipeline steht"

        ( De, "receives" ) ->
            "Wer seine Ausgabe erhält"

        ( De, "architecture" ) ->
            "Architektur"

        ( De, "practices" ) ->
            "Entwicklungspraktiken"

        ( De, "flow" ) ->
            "Flussdiagramm"

        ( De, "steps" ) ->
            "Schritte"

        ( De, "functions" ) ->
            "Funktionen"

        ( De, "notes" ) ->
            "Anmerkungen"

        ( PtBr, "what" ) ->
            "O que é"

        ( PtBr, "does" ) ->
            "O que faz"

        ( PtBr, "how" ) ->
            "Como faz"

        ( PtBr, "where" ) ->
            "Onde fica no fluxo"

        ( PtBr, "receives" ) ->
            "Quem recebe o que produz"

        ( PtBr, "architecture" ) ->
            "Arquitetura"

        ( PtBr, "practices" ) ->
            "Práticas de engenharia"

        ( PtBr, "flow" ) ->
            "Fluxograma"

        ( PtBr, "steps" ) ->
            "Passos"

        ( PtBr, "functions" ) ->
            "Funções"

        ( PtBr, "notes" ) ->
            "Observações"

        ( _, other ) ->
            other
