module Tool.Types exposing (..)

import Mouse exposing (Position)


type Tool
    = Hand (Maybe ( Position, Position ))
    | Pencil (Maybe Position)



-- PUBLIC HELPERS --


all : List Tool
all =
    [ Hand Nothing
    , Pencil Nothing
    ]


icon : Tool -> String
icon tool =
    case tool of
        Hand _ ->
            "\xEA0A"

        Pencil _ ->
            "\xEA02"


name : Tool -> String
name tool =
    case tool of
        Hand _ ->
            "hand"

        Pencil _ ->
            "pencil"
