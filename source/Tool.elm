module Tool exposing (..)

import Data.Tool exposing (Tool(..))
import Eraser
import Fill
import Hand
import Line
import Model exposing (Model)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Pencil
import Rectangle
import RectangleFilled
import Sample
import Select
import Zoom exposing (zoomInScreenMouseUp, zoomOutScreenMouseUp)


-- PUBLIC HELPERS --


handleScreenMouseUp : MouseEvent -> Model -> Model
handleScreenMouseUp { clientPos } model =
    case model.tool of
        Hand _ ->
            model

        Sample ->
            Sample.handleScreenMouseUp clientPos model

        Fill ->
            Fill.handleScreenMouseUp clientPos model

        Pencil _ ->
            model

        Line _ ->
            model

        ZoomIn ->
            zoomInScreenMouseUp clientPos model

        ZoomOut ->
            zoomOutScreenMouseUp clientPos model

        Rectangle _ ->
            model

        RectangleFilled _ ->
            model

        Select _ ->
            model

        Eraser _ ->
            model


handleScreenMouseDown : MouseEvent -> Model -> Model
handleScreenMouseDown { clientPos } model =
    case model.tool of
        Hand Nothing ->
            Hand.handleScreenMouseDown clientPos model

        Sample ->
            model

        Fill ->
            model

        Pencil Nothing ->
            Pencil.handleScreenMouseDown clientPos model

        Line Nothing ->
            Line.handleScreenMouseDown clientPos model

        ZoomIn ->
            model

        ZoomOut ->
            model

        Rectangle Nothing ->
            Rectangle.handleScreenMouseDown clientPos model

        RectangleFilled Nothing ->
            RectangleFilled.handleScreenMouseDown clientPos model

        Select Nothing ->
            Select.handleScreenMouseDown clientPos model

        Eraser Nothing ->
            Eraser.handleScreenMouseDown clientPos model

        _ ->
            model


handleClientMouseUp : Position -> Model -> Model
handleClientMouseUp position model =
    case model.tool of
        Hand _ ->
            { model | tool = Hand Nothing }

        Sample ->
            model

        Fill ->
            model

        Pencil _ ->
            { model | tool = Pencil Nothing }

        Line (Just priorPosition) ->
            Line.handleClientMouseUp position priorPosition model

        ZoomIn ->
            model

        ZoomOut ->
            model

        Rectangle (Just priorPosition) ->
            Rectangle.handleClientMouseUp position priorPosition model

        RectangleFilled (Just priorPosition) ->
            RectangleFilled.handleClientMouseUp position priorPosition model

        Select (Just priorPosition) ->
            Select.handleClientMouseUp position priorPosition model

        Eraser _ ->
            { model | tool = Eraser Nothing }

        _ ->
            model


handleClientMouseMovement : Position -> Model -> Model
handleClientMouseMovement newPosition model =
    case model.tool of
        Hand (Just subModel) ->
            Hand.handleClientMouseMovement newPosition subModel model

        Sample ->
            model

        Fill ->
            model

        Pencil (Just subModel) ->
            Pencil.handleClientMouseMovement newPosition subModel model

        Line (Just priorPosition) ->
            Line.handleClientMouseMovement newPosition priorPosition model

        ZoomIn ->
            model

        ZoomOut ->
            model

        Rectangle (Just priorPosition) ->
            Rectangle.handleClientMouseMovement newPosition priorPosition model

        RectangleFilled (Just priorPosition) ->
            RectangleFilled.handleClientMouseMovement newPosition priorPosition model

        Select (Just priorPosition) ->
            Select.handleClientMouseMovement newPosition priorPosition model

        Eraser (Just priorPosition) ->
            Eraser.handleClientMouseMovement newPosition priorPosition model

        _ ->
            model


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

        Eraser _ ->
            "\xEA1B"


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
