module Tool exposing (..)

import Html exposing (Attribute)
import Html.Attributes as Attributes
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent, onMouseUp)
import Tool.Hand as Hand
import Tool.Line as Line
import Tool.Pencil as Pencil
import Tool.Rectangle as Rectangle
import Tool.RectangleFilled as RectangleFilled
import Tool.Select as Select


type Msg
    = HandMsg Hand.Msg
    | PencilMsg Pencil.Msg
    | LineMsg Line.Msg
    | ZoomInScreenMouseUp MouseEvent
    | ZoomOutScreenMouseUp MouseEvent
    | RectangleMsg Rectangle.Msg
    | RectangleFilledMsg RectangleFilled.Msg
    | SelectMsg Select.Msg
    | SampleAt MouseEvent
    | FillScreenMouseUp MouseEvent


type Tool
    = Hand (Maybe ( Position, Position ))
    | Sample
    | Fill
    | Select (Maybe Position)
    | ZoomIn
    | ZoomOut
    | Pencil (Maybe Position)
    | Line (Maybe Position)
    | Rectangle (Maybe Position)
    | RectangleFilled (Maybe Position)



-- INIT --


init : Tool
init =
    Hand Nothing



-- HTML ATTRIBUTES --


attributes : Tool -> List (Attribute Msg)
attributes tool =
    case tool of
        Hand _ ->
            List.map
                (Attributes.map HandMsg)
                Hand.attributes

        Sample ->
            [ onMouseUp SampleAt ]

        Fill ->
            [ onMouseUp FillScreenMouseUp ]

        Pencil _ ->
            List.map
                (Attributes.map PencilMsg)
                Pencil.attributes

        Line _ ->
            List.map
                (Attributes.map LineMsg)
                Line.attributes

        Rectangle _ ->
            List.map
                (Attributes.map RectangleMsg)
                Rectangle.attributes

        RectangleFilled _ ->
            List.map
                (Attributes.map RectangleFilledMsg)
                RectangleFilled.attributes

        Select _ ->
            List.map
                (Attributes.map SelectMsg)
                Select.attributes

        ZoomIn ->
            [ onMouseUp ZoomInScreenMouseUp ]

        ZoomOut ->
            [ onMouseUp ZoomOutScreenMouseUp ]



-- SUBSCRIPTIONS --


subscriptions : Tool -> Sub Msg
subscriptions tool =
    case tool of
        Hand _ ->
            Sub.map HandMsg Hand.subs

        Pencil _ ->
            Sub.map PencilMsg Pencil.subs

        Line _ ->
            Sub.map LineMsg Line.subs

        Rectangle _ ->
            Sub.map RectangleMsg Rectangle.subs

        RectangleFilled _ ->
            Sub.map RectangleFilledMsg RectangleFilled.subs

        Select _ ->
            Sub.map SelectMsg Select.subs

        Sample ->
            Sub.none

        ZoomIn ->
            Sub.none

        ZoomOut ->
            Sub.none

        Fill ->
            Sub.none



-- PUBLIC HELPERS --


all : List Tool
all =
    [ Select Nothing
    , ZoomIn
    , ZoomOut
    , Hand Nothing
    , Sample
    , Fill
    , Pencil Nothing
    , Line Nothing
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

        Fill ->
            "\xEA16"

        Pencil _ ->
            "\xEA02"

        Line _ ->
            "\xEA09"

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
