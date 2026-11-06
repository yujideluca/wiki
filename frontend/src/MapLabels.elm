module MapLabels exposing (Candidate, Box, box, chosen, overlap)

{-| Which dots get a name written beside them (LB-1): no two names may overlap.

A dot is a candidate when it is near enough to the middle to deserve a label (`MapGeometry.labelThreshold`) or is a project. The
candidates are taken best first (projects, then the ones nearest the middle, ties by id so that the choice does not flicker) and a
name is written only if its box does not touch the box of a name already written. Names that do not fit wait for more zoom.
The box is an estimate (the page cannot be asked how wide a text is): 0.55 of the font size per character, one line high, below the
dot as `MapView.node` places it. -}

import Set exposing (Set)


type alias Candidate =
    { id : String
    , project : Bool
    , scale : Float
    , x : Float
    , y : Float
    , radius : Float
    , size : Float
    , title : String
    }


type alias Box =
    { x0 : Float, y0 : Float, x1 : Float, y1 : Float }


{-| Where a candidate's name would be, with a margin of 3 pixels all round (the text has a 3 pixel outline). -}
box : Candidate -> Box
box c =
    let
        half =
            0.275 * c.size * toFloat (String.length c.title) + 3
    in
    { x0 = c.x - half
    , x1 = c.x + half
    , y0 = c.y + c.radius + 2 - 3
    , y1 = c.y + c.radius + 2 + c.size * 1.3 + 3
    }


overlap : Box -> Box -> Bool
overlap a b =
    a.x0 < b.x1 && b.x0 < a.x1 && a.y0 < b.y1 && b.y0 < a.y1


{-| The ids that get a name: projects first, then by scale (largest first), then by id. -}
chosen : List Candidate -> Set String
chosen candidates =
    candidates
        |> List.sortWith
            (\a b ->
                case compare (boolRank b.project) (boolRank a.project) of
                    EQ ->
                        case compare b.scale a.scale of
                            EQ ->
                                compare a.id b.id

                            o ->
                                o

                    o ->
                        o
            )
        |> List.foldl
            (\c ( placed, ids ) ->
                let
                    b =
                        box c
                in
                if List.any (overlap b) placed then
                    ( placed, ids )

                else
                    ( b :: placed, Set.insert c.id ids )
            )
            ( [], Set.empty )
        |> Tuple.second


boolRank : Bool -> Int
boolRank b =
    if b then
        1

    else
        0
