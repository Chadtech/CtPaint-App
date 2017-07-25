module History.Update exposing (..)

import Main.Model exposing (Model)
import History.Types exposing (HistoryOp(..))
import Color exposing (Color)
import Array


-- HISTORY --


add : HistoryOp -> Model -> Model
add historyOp model =
    { model
        | future = []
    }
        |> passToHistory historyOp


addCanvas : Model -> Model
addCanvas model =
    add (CanvasChange model.canvas) model


addColor : Int -> Color -> Model -> Model
addColor index color model =
    add (ColorChange index color) model



-- REDO --


redo : Model -> Model
redo model =
    case model.future of
        f :: rest ->
            case f of
                CanvasChange canvas ->
                    { model
                        | canvas = canvas
                        , future = rest
                    }
                        |> passToHistory (CanvasChange model.canvas)

                ColorChange index color ->
                    case Array.get index model.palette of
                        Just existingColor ->
                            handleColor index color model
                                |> passToHistory (ColorChange index existingColor)
                                |> setFuture rest

                        Nothing ->
                            model

        [] ->
            model



-- UNDO --


undo : Model -> Model
undo model =
    case model.history of
        h :: rest ->
            case h of
                CanvasChange canvas ->
                    { model
                        | canvas = canvas
                        , history = rest
                    }
                        |> passToFuture (CanvasChange model.canvas)

                ColorChange index color ->
                    case Array.get index model.palette of
                        Just existingColor ->
                            handleColor index color model
                                |> passToFuture (ColorChange index existingColor)
                                |> setHistory rest

                        Nothing ->
                            model

        [] ->
            model



-- HISTORY --


setHistory : List HistoryOp -> Model -> Model
setHistory historyOps model =
    { model
        | history = historyOps
    }


passToHistory : HistoryOp -> Model -> Model
passToHistory historyOp model =
    { model
        | history =
            List.take 15 (historyOp :: model.history)
    }



-- FUTURE --


setFuture : List HistoryOp -> Model -> Model
setFuture historyOps model =
    { model
        | future = historyOps
    }


passToFuture : HistoryOp -> Model -> Model
passToFuture historyOp model =
    { model
        | future =
            List.take 15 (historyOp :: model.future)
    }



-- COLOR HELPER --


handleColor : Int -> Color -> Model -> Model
handleColor index color ({ colorPicker, palette } as model) =
    { model
        | palette =
            Array.set index color palette
        , colorPicker =
            if colorPicker.index == index then
                { colorPicker
                    | color = color
                }
            else
                colorPicker
    }
