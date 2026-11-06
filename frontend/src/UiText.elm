module UiText exposing (Strings, sectionHeading, strings)

{-| The interface text. The wiki is English only (LG-2). -}


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


strings : Strings
strings =
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


sectionHeading : String -> String
sectionHeading key =
    case key of
        "what" ->
            "What it is"

        "does" ->
            "What it does"

        "how" ->
            "How it does it"

        "where" ->
            "Where it sits in the pipeline"

        "receives" ->
            "Who receives its output"

        "architecture" ->
            "Architecture"

        "practices" ->
            "Engineering practices"

        "flow" ->
            "Flow chart"

        "steps" ->
            "Steps"

        "functions" ->
            "Functions"

        "notes" ->
            "Notes"

        other ->
            other
