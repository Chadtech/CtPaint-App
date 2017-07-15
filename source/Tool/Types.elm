module Tool.Types exposing (..)

import Mouse exposing (Position)


type Tool
    = Hand (Maybe ( Position, Position ))
    | Pencil (Maybe Position)
    | ZoomIn
    | ZoomOut



-- PUBLIC HELPERS --


all : List Tool
all =
    [ ZoomIn
    , ZoomOut
    , Hand Nothing
    , Pencil Nothing
    ]


icon : Tool -> String
icon tool =
    case tool of
        Hand _ ->
            "\xEA0A"

        Pencil _ ->
            "\xEA02"

        ZoomIn ->
            "\xEA17"

        ZoomOut ->
            "\xEA18"


name : Tool -> String
name tool =
    case tool of
        Hand _ ->
            "hand"

        Pencil _ ->
            "pencil"

        ZoomIn ->
            "zoom-in"

        ZoomOut ->
            "zoom-out"
