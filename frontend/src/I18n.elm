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
    , logout : String
    , notTranslated : String
    , legend : String
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
            , logout = "Log out"
            , notTranslated = "This page has no translation yet; showing English."
            , legend = "Kinds"
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
            , logout = "Abmelden"
            , notTranslated = "Diese Seite ist noch nicht übersetzt; Anzeige auf Englisch."
            , legend = "Arten"
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
            , logout = "Sair"
            , notTranslated = "Esta página ainda não foi traduzida; exibindo em inglês."
            , legend = "Tipos"
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

        ( PtBr, "steps" ) ->
            "Passos"

        ( PtBr, "functions" ) ->
            "Funções"

        ( PtBr, "notes" ) ->
            "Observações"

        ( _, other ) ->
            other
