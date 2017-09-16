module Tool exposing (..)

import Mouse exposing (Position)
import Tool.Fill.Mouse as Fill
import Tool.Fill.Types as Fill
import Tool.Hand.Mouse as Hand
import Tool.Hand.Types as Hand
import Tool.Line.Mouse as Line
import Tool.Line.Types as Line
import Tool.Pencil.Mouse as Pencil
import Tool.Pencil.Types as Pencil
import Tool.Rectangle.Mouse as Rectangle
import Tool.Rectangle.Types as Rectangle
import Tool.RectangleFilled.Mouse as RectangleFilled
import Tool.RectangleFilled.Types as RectangleFilled
import Tool.Sample.Mouse as Sample
import Tool.Sample.Types as Sample
import Tool.Select.Mouse as Select
import Tool.Select.Types as Select
import Tool.ZoomIn.Mouse as ZoomIn
import Tool.ZoomIn.Types as ZoomIn
import Tool.ZoomOut.Mouse as ZoomOut
import Tool.ZoomOut.Types as ZoomOut


type Msg
    = HandMsg Hand.Msg
    | PencilMsg Pencil.Msg
    | LineMsg Line.Msg
    | ZoomInMsg ZoomIn.Msg
    | ZoomOutMsg ZoomOut.Msg
    | RectangleMsg Rectangle.Msg
    | RectangleFilledMsg RectangleFilled.Msg
    | SelectMsg Select.Msg
    | SampleMsg Sample.Msg
    | FillMsg Fill.Msg


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



-- SUBSCRIPTIONS --


subscriptions : Tool -> List (Sub Msg)
subscriptions tool =
    case tool of
        Hand _ ->
            List.map (Sub.map HandMsg) Hand.subs

        Sample ->
            List.map (Sub.map SampleMsg) Sample.subs

        Fill ->
            List.map (Sub.map FillMsg) Fill.subs

        Pencil _ ->
            List.map (Sub.map PencilMsg) Pencil.subs

        Line _ ->
            List.map (Sub.map LineMsg) Line.subs

        Rectangle _ ->
            List.map (Sub.map RectangleMsg) Rectangle.subs

        RectangleFilled _ ->
            List.map
                (Sub.map RectangleFilledMsg)
                RectangleFilled.subs

        Select _ ->
            List.map (Sub.map SelectMsg) Select.subs

        ZoomIn ->
            List.map (Sub.map ZoomInMsg) ZoomIn.subs

        ZoomOut ->
            List.map (Sub.map ZoomOutMsg) ZoomOut.subs



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
