module Tool.Types exposing (..)

import Mouse exposing (Position)


type Tool
    = Hand (Maybe ( Position, Position ))
    | Sample
    | Select (Maybe Position)
    | ZoomIn
    | ZoomOut
    | Pencil (Maybe Position)
    | Rectangle (Maybe Position)
    | RectangleFilled (Maybe Position)



-- PUBLIC HELPERS --


all : List Tool
all =
    [ Select Nothing
    , ZoomIn
    , ZoomOut
    , Hand Nothing
    , Sample
    , Pencil Nothing
    , Rectangle Nothing
    , RectangleFilled Nothing
    ]


icon : Tool -> String
icon tool =
    case tool of
        Hand _ ->
            "\xEA0A"

        Sample ->
            "\xEA08"

        Pencil _ ->
            "\xEA02"

        Rectangle _ ->
            "\xEA03"

        RectangleFilled _ ->
            "\xEA04"

        Select _ ->
            "\xEA07"

        ZoomIn ->
            "\xEA17"

        ZoomOut ->
            "\xEA18"


name : Tool -> String
name tool =
    case tool of
        Hand _ ->
            "hand"

        Sample ->
            "sample"

        Pencil _ ->
            "pencil"

        Rectangle _ ->
            "rectangle"

        RectangleFilled _ ->
            "rectangle-filled"

        Select _ ->
            "select"

        ZoomIn ->
            "zoom-in"

        ZoomOut ->
            "zoom-out"
