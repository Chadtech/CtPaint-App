module Hfnss exposing (..)


type Pixel
    = Gray
    | Black


get : Char -> List (List Pixel)
get char =
    case char of
        'A' ->
            aUpper

        'B' ->
            bUpper

        'C' ->
            cUpper

        'D' ->
            dUpper

        'E' ->
            eUpper

        'F' ->
            fUpper

        'G' ->
            gUpper

        'H' ->
            hUpper

        'I' ->
            iUpper

        'J' ->
            jUpper

        'K' ->
            kUpper

        'L' ->
            lUpper

        'M' ->
            mUpper

        'N' ->
            nUpper

        'O' ->
            oUpper

        'P' ->
            pUpper

        'Q' ->
            qUpper

        'R' ->
            rUpper

        'S' ->
            sUpper

        'T' ->
            tUpper

        'U' ->
            uUpper

        'V' ->
            vUpper

        'W' ->
            wUpper

        'X' ->
            xUpper

        'Y' ->
            yUpper

        'Z' ->
            zUpper

        'a' ->
            aLower

        'b' ->
            bLower

        'c' ->
            cLower

        'd' ->
            dLower

        'e' ->
            eLower

        'f' ->
            fLower

        'g' ->
            gLower

        'h' ->
            hLower

        'i' ->
            iLower

        'j' ->
            jLower

        'k' ->
            kLower

        'l' ->
            lLower

        'm' ->
            mLower

        'n' ->
            nLower

        'o' ->
            oLower

        'p' ->
            pLower

        'q' ->
            qLower

        'r' ->
            rLower

        's' ->
            sLower

        't' ->
            tLower

        'u' ->
            uLower

        'v' ->
            vLower

        'w' ->
            wLower

        'x' ->
            xLower

        'y' ->
            yLower

        'z' ->
            zLower

        ' ' ->
            space

        _ ->
            questionMark


aUpper : List (List Pixel)
aUpper =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


bUpper : List (List Pixel)
bUpper =
    [ [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


cUpper : List (List Pixel)
cUpper =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


dUpper : List (List Pixel)
dUpper =
    [ [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


eUpper : List (List Pixel)
eUpper =
    [ [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


fUpper : List (List Pixel)
fUpper =
    [ [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


gUpper : List (List Pixel)
gUpper =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


hUpper : List (List Pixel)
hUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


iUpper : List (List Pixel)
iUpper =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


jUpper : List (List Pixel)
jUpper =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


kUpper : List (List Pixel)
kUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


lUpper : List (List Pixel)
lUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


mUpper : List (List Pixel)
mUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


nUpper : List (List Pixel)
nUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


oUpper : List (List Pixel)
oUpper =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


pUpper : List (List Pixel)
pUpper =
    [ [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


qUpper : List (List Pixel)
qUpper =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


rUpper : List (List Pixel)
rUpper =
    [ [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


sUpper : List (List Pixel)
sUpper =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


tUpper : List (List Pixel)
tUpper =
    [ [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


uUpper : List (List Pixel)
uUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


vUpper : List (List Pixel)
vUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


wUpper : List (List Pixel)
wUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


xUpper : List (List Pixel)
xUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


yUpper : List (List Pixel)
yUpper =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


zUpper : List (List Pixel)
zUpper =
    [ [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


aLower : List (List Pixel)
aLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


bLower : List (List Pixel)
bLower =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


cLower : List (List Pixel)
cLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


dLower : List (List Pixel)
dLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


eLower : List (List Pixel)
eLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


fLower : List (List Pixel)
fLower =
    [ [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


gLower : List (List Pixel)
gLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    ]


hLower : List (List Pixel)
hLower =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


iLower : List (List Pixel)
iLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


jLower : List (List Pixel)
jLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    ]


kLower : List (List Pixel)
kLower =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


lLower : List (List Pixel)
lLower =
    [ [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


mLower : List (List Pixel)
mLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


nLower : List (List Pixel)
nLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


oLower : List (List Pixel)
oLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


pLower : List (List Pixel)
pLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


qLower : List (List Pixel)
qLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    ]


rLower : List (List Pixel)
rLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


sLower : List (List Pixel)
sLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


tLower : List (List Pixel)
tLower =
    [ [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


uLower : List (List Pixel)
uLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


vLower : List (List Pixel)
vLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


wLower : List (List Pixel)
wLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


xLower : List (List Pixel)
xLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


yLower : List (List Pixel)
yLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    ]


zLower : List (List Pixel)
zLower =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


space : List (List Pixel)
space =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number0 : List (List Pixel)
number0 =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Gray, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number1 : List (List Pixel)
number1 =
    [ [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number2 : List (List Pixel)
number2 =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number3 : List (List Pixel)
number3 =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number4 : List (List Pixel)
number4 =
    [ [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number5 : List (List Pixel)
number5 =
    [ [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number6 : List (List Pixel)
number6 =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number7 : List (List Pixel)
number7 =
    [ [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number8 : List (List Pixel)
number8 =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


number9 : List (List Pixel)
number9 =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


period : List (List Pixel)
period =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


comma : List (List Pixel)
comma =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


doubleQuote : List (List Pixel)
doubleQuote =
    [ [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


singleQuote : List (List Pixel)
singleQuote =
    [ [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


questionMark : List (List Pixel)
questionMark =
    [ [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


exclaimationMark : List (List Pixel)
exclaimationMark =
    [ [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


at : List (List Pixel)
at =
    [ [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Gray, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Gray ]
    , [ Gray, Gray, Black, Black, Gray, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Gray, Gray, Black, Gray, Gray, Gray, Gray, Gray, Black, Gray, Gray ]
    , [ Gray, Gray, Black, Gray, Gray, Black, Gray, Gray, Black, Gray, Gray ]
    , [ Gray, Gray, Black, Gray, Gray, Black, Gray, Gray, Black, Gray, Gray ]
    , [ Gray, Gray, Black, Gray, Gray, Black, Gray, Gray, Black, Gray, Gray ]
    , [ Gray, Gray, Black, Gray, Gray, Black, Gray, Gray, Black, Gray, Gray ]
    , [ Gray, Gray, Black, Gray, Gray, Black, Gray, Gray, Gray, Gray, Gray ]
    , [ Gray, Gray, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Gray, Gray, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


underscore : List (List Pixel)
underscore =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


asterisk : List (List Pixel)
asterisk =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Black, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


hash : List (List Pixel)
hash =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Black, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


dollar : List (List Pixel)
dollar =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Black, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Black, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Black, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Black, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Gray, Black, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Gray, Black, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Black, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Black, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


percent : List (List Pixel)
percent =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


ampersand : List (List Pixel)
ampersand =
    [ [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Gray, Gray ]
    , [ Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


openParenthesis : List (List Pixel)
openParenthesis =
    [ [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


closeParenthesis : List (List Pixel)
closeParenthesis =
    [ [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


plus : List (List Pixel)
plus =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


minus : List (List Pixel)
minus =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


forwardSlash : List (List Pixel)
forwardSlash =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


colon : List (List Pixel)
colon =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


semiColon : List (List Pixel)
semiColon =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


leftArrow : List (List Pixel)
leftArrow =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


equals : List (List Pixel)
equals =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


rightArrow : List (List Pixel)
rightArrow =
    [ [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


openBracket : List (List Pixel)
openBracket =
    [ [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


backSlash : List (List Pixel)
backSlash =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


closeBracket : List (List Pixel)
closeBracket =
    [ [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Gray, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


caret : List (List Pixel)
caret =
    [ [ Black, Black, Black, Black, Black, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Black, Black, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


graveQuote : List (List Pixel)
graveQuote =
    [ [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


openCurlyBrace : List (List Pixel)
openCurlyBrace =
    [ [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Gray, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


line : List (List Pixel)
line =
    [ [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


closeCurlyBrace : List (List Pixel)
closeCurlyBrace =
    [ [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black ]
    , [ Black, Gray, Gray, Gray, Gray, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]


negation : List (List Pixel)
negation =
    [ [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Gray, Gray, Gray, Black, Black, Black, Gray, Gray ]
    , [ Black, Black, Gray, Gray, Black, Gray, Gray, Black, Gray, Gray, Black ]
    , [ Black, Gray, Gray, Black, Black, Black, Gray, Gray, Gray, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    , [ Black, Black, Black, Black, Black, Black, Black, Black, Black, Black, Black ]
    ]
