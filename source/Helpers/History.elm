module Helpers.History exposing (canvas, color, redo, undo)

import Array
import Color exposing (Color)
import Data.History exposing (Event(..))
import History
import Model exposing (Model)


undo : Model -> Model
undo ({ history } as model) =
    case history.past of
        event :: rest ->
            { model
                | history =
                    History.setPast rest history
            }
                |> undoEvent event

        [] ->
            model


undoEvent : Event -> Model -> Model
undoEvent event model =
    case event of
        CanvasChange canvas ->
            { model | canvas = canvas }
                |> passToFuture (CanvasChange model.canvas)

        ColorChange index color ->
            case Array.get index model.palette of
                Just existingColor ->
                    model
                        |> handleColor index color
                        |> passToFuture
                            (ColorChange index existingColor)

                Nothing ->
                    model


redo : Model -> Model
redo ({ history } as model) =
    case history.future of
        event :: rest ->
            { model
                | history =
                    History.setFuture rest history
            }
                |> redoEvent event

        [] ->
            model


redoEvent : Event -> Model -> Model
redoEvent event model =
    case event of
        CanvasChange canvas ->
            { model | canvas = canvas }
                |> passToPast (CanvasChange model.canvas)

        ColorChange index color ->
            case Array.get index model.palette of
                Just existingColor ->
                    model
                        |> handleColor index color
                        |> passToPast
                            (ColorChange index existingColor)

                Nothing ->
                    model


canvas : Model -> Model
canvas model =
    addToHistory (CanvasChange model.canvas) model


color : Int -> Color -> Model -> Model
color index color =
    ColorChange index color |> addToHistory


passToFuture : Event -> Model -> Model
passToFuture event model =
    { model
        | history =
            History.passToFuture event model.history
    }


passToPast : Event -> Model -> Model
passToPast event model =
    { model
        | history =
            History.passToPast event model.history
    }


addToHistory : Event -> Model -> Model
addToHistory event model =
    { model
        | history =
            History.add event model.history
    }


handleColor : Int -> Color -> Model -> Model
handleColor index color ({ colorPicker, palette } as model) =
    { model
        | palette =
            Array.set index color palette
        , colorPicker =
            let
                { picker } =
                    colorPicker
            in
            if picker.index == index then
                { colorPicker
                    | picker =
                        { picker
                            | color = color
                        }
                }
            else
                colorPicker
    }
