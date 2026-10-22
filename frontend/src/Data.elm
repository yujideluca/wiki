module Data exposing
    ( Article
    , Edge
    , EdgeType(..)
    , Graph
    , Kind
    , Node
    , NodeText
    , Section
    , articleDecoder
    , graphDecoder
    , kindColour
    , nodeById
    , nodeText
    , title
    )

{-| The data `wiki build` writes: `data/graph.json` and `data/pages/<id>.<lang>.json`. -}

import Dict exposing (Dict)
import I18n exposing (Lang)
import Json.Decode as D exposing (Decoder)


type alias NodeText =
    { title : String
    , aliases : List String
    , what : String
    , does : String
    }


type alias Node =
    { id : String
    , kind : String
    , project : String
    , status : String
    , since : String
    , until : Maybe String
    , fedBy : List String
    , feeds : List String
    , functions : List String
    , process : Bool
    , text : Dict String NodeText
    }


type EdgeType
    = Feeds
    | Mentions


type alias Edge =
    { from : String
    , to : String
    , edgeType : EdgeType
    }


type alias Kind =
    { name : String
    , colour : String
    , description : String
    }


type alias Graph =
    { nodes : List Node
    , edges : List Edge
    , kinds : List Kind
    }


type alias Section =
    { key : String
    , markdown : String
    }


type alias Article =
    { id : String
    , lang : String
    , title : String
    , kind : String
    , project : String
    , status : String
    , location : Maybe String
    , since : String
    , until : Maybe String
    , reviewed : Maybe String
    , mayBeStale : Bool
    , fedBy : List String
    , feeds : List String
    , memory : List String
    , sources : List String
    , sections : List Section
    , history : List { date : String, subject : String }
    }


nodeText : Lang -> Node -> NodeText
nodeText lang node =
    case Dict.get (I18n.code lang) node.text of
        Just t ->
            t

        Nothing ->
            Dict.get "en" node.text
                |> Maybe.withDefault { title = node.id, aliases = [], what = "", does = "" }


title : Lang -> Node -> String
title lang node =
    (nodeText lang node).title


nodeById : Graph -> String -> Maybe Node
nodeById graph id =
    List.filter (\n -> n.id == id) graph.nodes |> List.head


kindColour : Graph -> String -> String
kindColour graph kind =
    List.filter (\k -> k.name == kind) graph.kinds
        |> List.head
        |> Maybe.map .colour
        |> Maybe.withDefault "#8a8f98"



-- DECODERS


strings : String -> Decoder (List String)
strings field =
    D.oneOf [ D.field field (D.list D.string), D.succeed [] ]


optionalString : String -> Decoder (Maybe String)
optionalString field =
    D.oneOf [ D.field field (D.nullable D.string), D.succeed Nothing ]


andMap : Decoder a -> Decoder (a -> b) -> Decoder b
andMap =
    D.map2 (|>)


nodeTextDecoder : Decoder NodeText
nodeTextDecoder =
    D.map4 NodeText
        (D.field "title" D.string)
        (strings "aliases")
        (D.oneOf [ D.field "what" D.string, D.succeed "" ])
        (D.oneOf [ D.field "does" D.string, D.succeed "" ])


nodeDecoder : Decoder Node
nodeDecoder =
    D.succeed Node
        |> andMap (D.field "id" D.string)
        |> andMap (D.field "kind" D.string)
        |> andMap (D.oneOf [ D.field "project" D.string, D.succeed "none" ])
        |> andMap (D.oneOf [ D.field "status" D.string, D.succeed "active" ])
        |> andMap (D.oneOf [ D.field "since" D.string, D.succeed "" ])
        |> andMap (optionalString "until")
        |> andMap (strings "fedBy")
        |> andMap (strings "feeds")
        |> andMap (strings "functions")
        |> andMap (D.oneOf [ D.field "process" D.bool, D.succeed False ])
        |> andMap (D.field "text" (D.dict nodeTextDecoder))


edgeDecoder : Decoder Edge
edgeDecoder =
    D.map3 Edge
        (D.field "from" D.string)
        (D.field "to" D.string)
        (D.field "type" D.string
            |> D.map
                (\t ->
                    if t == "feeds" then
                        Feeds

                    else
                        Mentions
                )
        )


kindDecoder : Decoder Kind
kindDecoder =
    D.map3 Kind
        (D.field "name" D.string)
        (D.oneOf [ D.field "colour" D.string, D.succeed "#8a8f98" ])
        (D.oneOf [ D.field "description" D.string, D.succeed "" ])


graphDecoder : Decoder Graph
graphDecoder =
    D.map3 Graph
        (D.field "nodes" (D.list nodeDecoder))
        (D.field "edges" (D.list edgeDecoder))
        (D.field "kinds" (D.list kindDecoder))


articleDecoder : Decoder Article
articleDecoder =
    D.succeed Article
        |> andMap (D.field "id" D.string)
        |> andMap (D.field "lang" D.string)
        |> andMap (D.field "title" D.string)
        |> andMap (D.field "kind" D.string)
        |> andMap (D.oneOf [ D.field "project" D.string, D.succeed "none" ])
        |> andMap (D.oneOf [ D.field "status" D.string, D.succeed "active" ])
        |> andMap (optionalString "location")
        |> andMap (D.oneOf [ D.field "since" D.string, D.succeed "" ])
        |> andMap (optionalString "until")
        |> andMap (optionalString "reviewed")
        |> andMap (D.oneOf [ D.field "mayBeStale" D.bool, D.succeed False ])
        |> andMap (strings "fedBy")
        |> andMap (strings "feeds")
        |> andMap (strings "memory")
        |> andMap (strings "sources")
        |> andMap (D.field "sections" (D.list (D.map2 Section (D.field "key" D.string) (D.field "markdown" D.string))))
        |> andMap
            (D.oneOf
                [ D.field "history"
                    (D.list (D.map2 (\d s -> { date = d, subject = s }) (D.field "date" D.string) (D.field "subject" D.string)))
                , D.succeed []
                ]
            )
