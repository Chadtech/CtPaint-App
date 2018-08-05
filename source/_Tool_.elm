module Tool exposing (..)

import Model exposing (Model)
import Mouse exposing (Position)
import Mouse.Extra as Mouse
import MouseEvents exposing (MouseEvent)
import Tool.Data exposing (Tool(..))
import Tool.Eraser as Eraser
import Tool.Fill as Fill
import Tool.Hand as Hand
import Tool.Line as Line
import Tool.Pencil as Pencil
import Tool.Rectangle as Rectangle
import Tool.RectangleFilled as RectangleFilled
import Tool.Sample as Sample
import Tool.Select as Select
import Tool.Zoom as Zoom exposing (zoomInScreenMouseUp, zoomOutScreenMouseUp)


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


handleScreenMouseDown : Mouse.Button -> MouseEvent -> Model -> Model
handleScreenMouseDown button { clientPos } model =
    case model.tool of
        Hand Nothing ->
            Hand.handleScreenMouseDown clientPos model

        Sample ->
            model

        Fill ->
            model

        Pencil Nothing ->
            Pencil.handleScreenMouseDown clientPos button model

        Line Nothing ->
            Line.handleScreenMouseDown clientPos button model

        ZoomIn ->
            model

        ZoomOut ->
            model

        Rectangle Nothing ->
            Rectangle.handleScreenMouseDown clientPos button model

        RectangleFilled Nothing ->
            RectangleFilled.handleScreenMouseDown clientPos button model

        Select Nothing ->
            Select.handleScreenMouseDown clientPos model

        Eraser Nothing ->
            Eraser.handleScreenMouseDown clientPos button model

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

        Rectangle (Just subModel) ->
            Rectangle.handleClientMouseUp position subModel model

        RectangleFilled (Just subModel) ->
            RectangleFilled.handleClientMouseUp position subModel model

        Select (Just subModel) ->
            Select.handleClientMouseUp position subModel model

        Eraser (Just subModel) ->
            Eraser.handleClientMouseUp position subModel model

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
