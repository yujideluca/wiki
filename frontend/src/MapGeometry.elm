module MapGeometry exposing (Dot, EdgeRow, GeoKey, Geometry, Item, StaticKey, Statics, build, buildStatics, dotAt, emptyGeometry, emptyStatics, hitAt)

{-| Everything about the map that does not change while the dots spring about (the cache behind the map's speed), in two layers.

`Statics` is what only a new layout, graph or filter changes: which dots there are, their titles and colours, their
unit vectors on the sphere, and which edge joins which two (as positions in an array, so that a frame never looks a dot up by
its name). `Geometry` is what a turn or a zoom of the globe changes: one camera, built once, and for every dot the matrix
product with it. A dot on the far side is dropped right there, before its shape is computed, and costs a compare and a
shared constant. While the dots spring about neither layer changes and the view evaluates only the dots that are displaced. -}

import Array exposing (Array)
import Data exposing (Graph, Node)
import Dict exposing (Dict)
import Filter
import Globe exposing (Cam, Spot)
import Set


{-| How much a dot needs to get a label (LN-2): the zoom times the square of how much it is foreshortened, where the foreshortening
is the dot's area scale divided by the zoom (the scale in the middle grows about one for one with the zoom, so the zoom is counted
once). At the first view only the projects (always labelled) have a label; the labels of the others come as you zoom in, the dots
in the middle first and the ones towards the rim later. The earlier threshold, which counted the zoom three times, labelled 59 of
126 dots at the first view (the earlier lens: 14 of 202, the projects) and nearly all of them after two wheel notches, which
overlapped on a phone. -}
labelThreshold : Float
labelThreshold =
    1.4


{-| One visible dot, as the view draws it. [spot] is its place and the matrix that flattens it; the rest is its detail there. -}
type alias Dot =
    { node : Node
    , title : String
    , colour : String
    , spot : Spot
    , radiusScale : Float
    , labelSize : Float
    , labelled : Bool
    }


type alias Item =
    { vec : Globe.Node
    , hidden : Dot -- the dot as it is when it is not seen: made once, shared by every frame
    }


type alias StaticEdge =
    { from : String, to : String, a : Int, b : Int, feeds : Bool }


type alias StaticKey =
    { graph : Graph
    , sphere : Dict String Globe.Node
    , project : Maybe String
    , month : Maybe String
    }


type alias Statics =
    { key : Maybe StaticKey
    , items : Array Item
    , byId : Dict String Int
    , edges : List StaticEdge
    }


type alias GeoKey =
    { lam : Float, beta : Float, z : Float, cx : Float, cy : Float, rho : Float }


{-| One line between two dots that are both seen at rest. The dashed "mentions" line is left out where it is [coarse]. -}
type alias EdgeRow =
    { from : String
    , to : String
    , feeds : Bool
    , coarse : Bool
    , ends : ( Spot, Spot )
    }


type alias Geometry =
    { key : Maybe GeoKey
    , cam : Cam
    , z : Float
    , rz : Float -- what the zoom adds to the dot size, once per frame: the dot's matrix already grows with the globe's scale (about z), so rz brings the whole growth to z^0.6, at most 2.2 times, and with the area factor (at most 1.6) 3.5 times in all (DY-11)
    , ls : Float -- and of the label size
    , dots : Array Dot -- by position in `Statics.items`
    , visible : List Dot -- the dots that are seen, in the order they are drawn in
    , edges : List EdgeRow
    }


emptyStatics : Statics
emptyStatics =
    { key = Nothing, items = Array.empty, byId = Dict.empty, edges = [] }


emptyGeometry : Geometry
emptyGeometry =
    { key = Nothing
    , cam = Globe.camera { cx = 0, cy = 0, rho = 1 } { lam = 0, beta = 0, z = 1 }
    , z = 1
    , rz = 1
    , ls = 1
    , dots = Array.empty
    , visible = []
    , edges = []
    }


buildStatics : StaticKey -> Statics
buildStatics key =
    let
        visibleIds =
            Filter.visible key.project key.month key.graph

        itemOf n =
            case Dict.get n.id key.sphere of
                Just vec ->
                    [ { vec = vec
                      , hidden =
                            { node = n
                            , title = Data.title n
                            , colour = Data.kindColour key.graph n.kind
                            , spot = Globe.hiddenSpot
                            , radiusScale = 0
                            , labelSize = 0
                            , labelled = False
                            }
                      }
                    ]

                Nothing ->
                    []

        items =
            key.graph.nodes |> List.filter (\n -> Set.member n.id visibleIds) |> List.concatMap itemOf |> Array.fromList

        byId =
            items |> Array.toList |> List.indexedMap (\i it -> ( it.hidden.node.id, i )) |> Dict.fromList

        edgeOf e =
            case ( Dict.get e.from byId, Dict.get e.to byId ) of
                ( Just a, Just b ) ->
                    [ { from = e.from, to = e.to, a = a, b = b, feeds = e.edgeType == Data.Feeds } ]

                _ ->
                    []
    in
    { key = Just key, items = items, byId = byId, edges = List.concatMap edgeOf key.graph.edges }


{-| The dot [item] at the unit vector `(x, y, z)`: culled before the shape is computed when it is on the far side. -}
dotAt : Geometry -> Item -> Float -> Float -> Float -> Dot
dotAt geo it x y z =
    let
        sp =
            Globe.place geo.cam x y z
    in
    if sp.visible then
        let
            h =
                it.hidden

            s =
                sp.scale
        in
        { node = h.node
        , title = h.title
        , colour = h.colour
        , spot = sp
        , radiusScale = clamp 0.4 1.6 (s * sqrt s) * geo.rz
        , labelSize = 11 * clamp 0.85 1.25 s * geo.ls
        , labelled = s * s / geo.z >= labelThreshold
        }

    else
        it.hidden


build : GeoKey -> Cam -> Statics -> Geometry
build key cam statics =
    let
        base =
            { key = Just key
            , cam = cam
            , z = cam.z
            , rz = clamp 0.7 2.2 (cam.z ^ 0.6) / max 1 cam.z
            , ls = clamp 1 1.6 (sqrt cam.z)
            , dots = Array.empty
            , visible = []
            , edges = []
            }

        dots =
            Array.map (\it -> dotAt base it it.vec.x it.vec.y it.vec.z) statics.items

        edgeOf e =
            case ( Array.get e.a dots, Array.get e.b dots ) of
                ( Just a, Just b ) ->
                    if a.spot.visible && b.spot.visible then
                        [ { from = e.from
                          , to = e.to
                          , feeds = e.feeds
                          , coarse = not e.feeds && min a.spot.scale b.spot.scale < 0.86
                          , ends = ( a.spot, b.spot )
                          }
                        ]

                    else
                        []

                _ ->
                    []
    in
    { base
        | dots = dots
        , visible = Array.foldr (\d acc -> if d.spot.visible then d :: acc else acc) [] dots
        , edges = List.concatMap edgeOf statics.edges
    }


{-| The dot under the pointer at window position [x], [y], or none: the nearest (by fraction of its own reach) of the dots that are
seen. A dot answers within its drawn radius (the ellipse is drawn `radiusScale` times the base radius, times the globe's scale at the dot) plus 6 pixels. The dots are taken at their resting places. -}
hitAt : Geometry -> Float -> Float -> Maybe String
hitAt geometry x y =
    geometry.visible
        |> List.foldl
            (\dot best ->
                let
                    reach =
                        (if dot.node.kind == "project" then
                            11

                         else
                            6
                        )
                            * dot.radiusScale
                            * max 1 dot.spot.scale
                            + 6

                    dx =
                        x - dot.spot.x

                    dy =
                        y - dot.spot.y

                    frac =
                        (dx * dx + dy * dy) / (reach * reach)
                in
                if frac <= 1 then
                    case best of
                        Just ( _, f ) ->
                            if frac <= f then
                                Just ( dot.node.id, frac )

                            else
                                best

                        Nothing ->
                            Just ( dot.node.id, frac )

                else
                    best
            )
            Nothing
        |> Maybe.map Tuple.first
