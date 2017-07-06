module Tool.Types exposing (..)

import ElementRelativeMouseEvents exposing (Point)


type Tool
    = Hand (Maybe ( Point, Point ))
    | Pencil



-- PUBLIC HELPERS --


all : List Tool
all =
    [ Hand Nothing
    , Pencil
    ]


icon : Tool -> String
icon tool =
    case tool of
        Hand _ ->
            "\xEA0A"

        Pencil ->
            "\xEA02"


name : Tool -> String
name tool =
    case tool of
        Hand _ ->
            "hand"

        Pencil ->
            "pencil"
