module MapEdgesTests exposing (suite)

{-| The lines of the map as a few paths (`MapEdges`, DY-12): few elements however many lines, every line present, the arrowhead where
the marker had it, no head on a mentions line, and no broken number for a line of length zero. -}

import Expect
import Globe exposing (Spot)
import MapEdges
import Test exposing (Test, describe, test)


spot : Float -> Float -> Float -> Spot
spot x y scale =
    let
        base =
            Globe.hiddenSpot
    in
    { base | visible = True, x = x, y = y, scale = scale }


{-| a stroke width of exactly 1 (0.9 * 1.111 = 1) -}
unit : Float
unit =
    1 / 0.9


count : String -> String -> Int
count needle hay =
    List.length (String.indices needle hay)


segments : List ( Bool, Spot, Spot )
segments =
    List.range 0 299
        |> List.map
            (\i ->
                let
                    f =
                        toFloat i
                in
                ( modBy 3 i == 0, spot f (f * 2) (0.6 + toFloat (modBy 17 i) / 8), spot (f + 40) (f * 2 - 30) (0.8 + toFloat (modBy 11 i) / 9) )
            )


suite : Test
suite =
    describe "MapEdges"
        -- REQ DY-12
        [ test "300 lines of many widths make at most 14 groups (two kinds, seven widths), not 300 elements" <|
            \_ ->
                let
                    gs =
                        MapEdges.groups segments
                in
                ( List.length gs <= 14, List.sum (List.map (\g -> count "M" g.lines) gs) )
                    |> Expect.equal ( True, 300 )
        -- REQ DY-12
        , test "every group's width is within an eighth of a pixel of the width of each line in it, between 0.5 and 2" <|
            \_ ->
                let
                    gs =
                        MapEdges.groups [ ( False, spot 0 0 0.1, spot 10 0 0.1 ), ( False, spot 0 0 1.4, spot 10 0 1.5 ), ( False, spot 0 0 9, spot 10 0 9 ) ]
                in
                List.map .width gs |> Expect.equal [ 0.5, 1.25, 2 ]
        -- REQ DY-12
        , test "a feeding line along the x axis has its arrowhead tip 6 widths before the end, its base 11 before, 5 wide" <|
            \_ ->
                MapEdges.groups [ ( True, spot 0 0 unit, spot 100 0 unit ) ]
                    |> Expect.equal [ { feeds = True, width = 1, lines = "M0 0L100 0", heads = "M94 0L89 2.5L89 -2.5Z" } ]
        -- REQ DY-12
        , test "the head follows the direction of the line (downwards: tip above the end)" <|
            \_ ->
                MapEdges.groups [ ( True, spot 0 0 unit, spot 0 100 unit ) ]
                    |> List.map .heads
                    |> Expect.equal [ "M0 94L-2.5 89L2.5 89Z" ]
        -- REQ DY-12
        , test "a mentions line has no head" <|
            \_ ->
                MapEdges.groups [ ( False, spot 0 0 unit, spot 100 0 unit ) ]
                    |> List.map (\g -> ( g.heads, g.feeds ))
                    |> Expect.equal [ ( "", False ) ]
        -- REQ DY-12
        , test "a feeding line of length zero draws no head and no NaN" <|
            \_ ->
                MapEdges.groups [ ( True, spot 5 5 unit, spot 5 5 unit ) ]
                    |> List.map (\g -> ( g.heads, String.contains "NaN" g.lines ))
                    |> Expect.equal [ ( "", False ) ]
        -- REQ DY-12
        , test "feeding and mentioning lines of the same width are separate groups" <|
            \_ ->
                MapEdges.groups [ ( True, spot 0 0 unit, spot 9 0 unit ), ( False, spot 0 0 unit, spot 9 0 unit ) ]
                    |> List.map .feeds
                    |> Expect.equal [ False, True ]
        ]
