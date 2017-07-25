module Tool.Types exposing (..)

import Mouse exposing (Position)


type Tool
    = Hand (Maybe ( Position, Position ))
    | ZoomIn
    | ZoomOut
    | Pencil (Maybe Position)
    | Rectangle (Maybe Position)
    | RectangleFilled (Maybe Position)



-- PUBLIC HELPERS --


all : List Tool
all =
    [ ZoomIn
    , ZoomOut
    , Hand Nothing
    , Pencil Nothing
    , Rectangle Nothing
    , RectangleFilled Nothing
    ]


icon : Tool -> String
icon tool =
    case tool of
        Hand _ ->
            "\xEA0A"

        Pencil _ ->
            "\xEA02"

        Rectangle _ ->
            "\xEA03"

        RectangleFilled _ ->
            "\xEA04"

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

        Rectangle _ ->
            "rectangle"

        RectangleFilled _ ->
            "rectangle-filled"

        ZoomIn ->
            "zoom-in"

        ZoomOut ->
            "zoom-out"
