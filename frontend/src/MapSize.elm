module MapSize exposing (Sizes, boxesAbove, insets, isPhone, isWide, sizes)

{-| How tall the map is and how tall the four info boxes under it are (MP-5).

On a wide window that is tall enough, the boxes sit in one row at the height their text needs and the map takes
everything else: the page then fits the window exactly and hovering a node never makes it scroll. On a window too
short for that, or narrower than 1100 px where the boxes stack in several rows, nothing changes from before: the map
keeps 58 % of the height and the boxes size themselves to their text, so the map is never smaller than it was.

`isWide` matches the stylesheet's breakpoint: above 1100 px the boxes are four in a row. -}


type alias Sizes =
    { map : Float

    {- `Nothing` where the boxes size themselves (narrow windows). -}
    , box : Maybe Float
    }


isWide : Float -> Bool
isWide width =
    width > 1100


{-| A phone-width window (the stylesheet's breakpoint is 760 px): the map fills the whole screen and the node's
description opens as a balloon over it (MB-1, MB-2). -}
isPhone : Float -> Bool
isPhone width =
    width <= 760


{-| What is under the map apart from the boxes: its bottom border, the line with the page title (56) and the boxes'
padding (10 above, 28 below). -}
boxesAbove : Float
boxesAbove =
    1 + 56 + 10 + 28


{-| Height the boxes would like on a wide window: enough for the text of nine pages in ten (measured on the 149 pages
of the wiki: about 160 px of text beside the 66 px of heading and padding, at a text width of 429 px). Narrower windows
wrap the text more, so the boxes grow as the text column shrinks. -}
wantedBox : Float -> Float
wantedBox width =
    let
        -- 16 px page padding on each side, 12 px between the four boxes, 16 px padding and 1 px border inside each
        textWidth =
            (width - 68) / 4 - 34
    in
    clamp 200 340 (66 + 160 * 429 / textWidth)


sizes : Float -> Float -> Sizes
sizes width viewportHeight =
    let
        share =
            max 320 (viewportHeight * 0.58)

        room =
            viewportHeight - boxesAbove - wantedBox width
    in
    if isPhone width then
        { map = viewportHeight, box = Nothing }

    else if isWide width && room >= share then
        { map = room, box = Just (wantedBox width) }

    else
        { map = share, box = Nothing }


{-| Space at the top and bottom of the map that floating controls cover (the filter and timeline row under the top
bar, the legend), so the graph is centred in what is left. -}
insets : Float -> ( Float, Float )
insets width =
    if isPhone width then
        -- the search bar and the chip row float over the top of the map
        ( 116, 8 )

    else if isWide width then
        ( 112, 34 )

    else
        ( 0, 0 )
