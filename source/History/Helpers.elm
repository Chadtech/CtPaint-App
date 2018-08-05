module History.Helpers
    exposing
        ( canvas
        , color
        , redo
        , undo
        )

import Array
import Canvas.Model as Canvas
import Color exposing (Color)
import Color.Model as ColorModel
import History.Model as History exposing (Event(..))
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
            { model
                | canvas =
                    Canvas.setMain
                        canvas
                        model.canvas
            }
                |> passToFuture
                    (CanvasChange model.canvas.main)

        ColorChange index color ->
            case Array.get index model.color.palette of
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
            { model
                | canvas =
                    Canvas.setMain
                        canvas
                        model.canvas
            }
                |> passToPast
                    (CanvasChange model.canvas.main)

        ColorChange index color ->
            case Array.get index model.color.palette of
                Just existingColor ->
                    model
                        |> handleColor index color
                        |> passToPast
                            (ColorChange index existingColor)

                Nothing ->
                    model


canvas : Model -> Model
canvas model =
    addToHistory (CanvasChange model.canvas.main) model


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
handleColor index color model =
    { model
        | color =
            ColorModel.setPaletteColor index color model.color
    }
