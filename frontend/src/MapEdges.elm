module MapEdges exposing (Group, groups, paths)

{-| The lines between the dots, drawn as a few paths instead of one page element each (DY-12).

A page element per line costs the browser a paint item and a layout object each. On the real phone, hiding the lines took a swipe
frame from 12.8 to 10.1 ms (paint 2.6 to 0.7 ms), and drawing them as the paths below took it to 9.6 ms (measured in
`~/dev/wiki-bench/globe/RESULTS.md`, round 11). The lit lines (those of the hovered dot) stay single elements in `MapView`: they carry
the arrowhead marker and are few.

The other lines are put in groups by kind (feeding or only mentioning) and by stroke width in steps of a quarter pixel. A group is
one `path` of its segments and, for a feeding one, a second `path` of its arrowheads as filled triangles. -}

import Dict
import Globe exposing (Spot)
import Svg exposing (Svg)
import Svg.Attributes as S
import Types exposing (Msg)


{-| One group: the stroke width, whether the lines feed (and so have arrowheads), the path data of the lines and that of the heads. -}
type alias Group =
    { feeds : Bool
    , width : Float
    , lines : String
    , heads : String
    }


{-| The stroke width of a line between two dots: thicker where the dots are nearer the camera, between half a pixel and two. -}
strokeOf : Spot -> Spot -> Float
strokeOf a b =
    clamp 0.5 2 (0.9 * (a.scale + b.scale) / 2)


{-| The groups, from lines given as (feeds, one end, the other end). The arrowhead sits near the second end, as the marker did: its
tip 6 stroke widths before the end, its base 11 before it, and 5 wide. -}
groups : List ( Bool, Spot, Spot ) -> List Group
groups segs =
    let
        add ( feeds, a, b ) acc =
            let
                step =
                    round ((strokeOf a b - 0.5) * 4)

                key =
                    step
                        * 2
                        + (if feeds then
                            1

                           else
                            0
                          )

                w =
                    stepWidth step

                dx =
                    b.x - a.x

                dy =
                    b.y - a.y

                len =
                    sqrt (dx * dx + dy * dy)

                line =
                    "M" ++ px a.x ++ " " ++ px a.y ++ "L" ++ px b.x ++ " " ++ px b.y

                head =
                    if feeds && len > 0 then
                        arrowhead b (dx / len) (dy / len) w

                    else
                        ""
            in
            Dict.update key
                (\old ->
                    case old of
                        Just ( l, h ) ->
                            Just ( line :: l, head :: h )

                        Nothing ->
                            Just ( [ line ], [ head ] )
                )
                acc
    in
    List.foldl add Dict.empty segs
        |> Dict.toList
        |> List.map
            (\( key, ( lines, heads ) ) ->
                { feeds = modBy 2 key == 1
                , width = stepWidth (key // 2)
                , lines = String.concat lines
                , heads = String.concat heads
                }
            )


stepWidth : Int -> Float
stepWidth step =
    0.5 + toFloat step / 4


{-| A triangle pointing along (ux, uy) with its tip 6 stroke widths before [b]. -}
arrowhead : Spot -> Float -> Float -> Float -> String
arrowhead b ux uy w =
    let
        cx =
            b.x - ux * 11 * w

        cy =
            b.y - uy * 11 * w
    in
    "M" ++ px (b.x - ux * 6 * w) ++ " " ++ px (b.y - uy * 6 * w)
        ++ "L" ++ px (cx - uy * 2.5 * w) ++ " " ++ px (cy + ux * 2.5 * w)
        ++ "L" ++ px (cx + uy * 2.5 * w) ++ " " ++ px (cy - ux * 2.5 * w)
        ++ "Z"


{-| The page elements of the groups: for each, its `path` of lines and, if it feeds, a `path` of the heads. -}
paths : List ( Bool, Spot, Spot ) -> List (Svg Msg)
paths segs =
    List.concatMap
        (\g ->
            Svg.path
                [ S.d g.lines
                , S.strokeWidth (String.fromFloat g.width)
                , S.class
                    (if g.feeds then
                        "edges feeds"

                     else
                        "edges mentions"
                    )
                ]
                []
                :: (if g.feeds then
                        [ Svg.path [ S.d g.heads, S.class "heads" ] [] ]

                    else
                        []
                   )
        )
        (groups segs)


px : Float -> String
px v =
    String.fromFloat (toFloat (round (v * 10)) / 10)
