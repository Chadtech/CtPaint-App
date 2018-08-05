module Tool.Data
    exposing
        ( Tool(..)
        , all
        , icon
        , init
        , name
        )

import Char
import Mouse exposing (Position)
import Mouse.Extra exposing (Button)
import Tool.Hand.Model as Hand
import Tool.Line.Model as Line
import Tool.Pencil.Model as Pencil
import Tool.Rectangle.Model as Rectangle
import Tool.RectangleFilled.Model as RectangleFilled


type Tool
    = Hand (Maybe Hand.Model)
    | Sample
    | Fill
    | Select (Maybe Position)
    | ZoomIn
    | ZoomOut
    | Pencil (Maybe Pencil.Model)
    | Line (Maybe Line.Model)
    | Rectangle (Maybe Rectangle.Model)
    | RectangleFilled (Maybe RectangleFilled.Model)
    | Eraser (Maybe ( Position, Button ))


init : Tool
init =
    Pencil Nothing



-- HELPERS --


all : List Tool
all =
    [ Select Nothing
    , ZoomIn
    , ZoomOut
    , Hand Nothing
    , Sample
    , Fill
    , Eraser Nothing
    , Pencil Nothing
    , Line Nothing
    , Rectangle Nothing
    , RectangleFilled Nothing
    ]


icon : Tool -> String
icon =
    iconHelper >> Char.fromCode >> String.fromChar


iconHelper : Tool -> Int
iconHelper tool =
    case tool of
        Hand _ ->
            --"\xEA0A"
            59914

        Sample ->
            --"\xEA08"
            59912

        Fill ->
            --"\xEA16"
            59926

        Pencil _ ->
            --"\xEA02"
            59906

        Line _ ->
            --"\xEA09"
            59913

        Rectangle _ ->
            --"\xEA03"
            59907

        RectangleFilled _ ->
            --"\xEA04"
            59908

        Select _ ->
            --"\xEA07"
            59911

        ZoomIn ->
            --"\xEA17"
            59927

        ZoomOut ->
            --"\xEA18"
            59928

        Eraser _ ->
            --"\xEA1B"
            59931


name : Tool -> String
name tool =
    case tool of
        Hand _ ->
            "hand"

        Sample ->
            "sample"

        Fill ->
            "fill"

        Pencil _ ->
            "pencil"

        Line _ ->
            "line"

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

        Eraser _ ->
            "eraser"
