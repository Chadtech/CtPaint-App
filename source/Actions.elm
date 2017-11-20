module Actions exposing (..)

import Array
import Color exposing (Color)
import Data.History exposing (Event(..))
import History
import Menu
import Types exposing (Model)


initReplaceColor : Model -> Model
initReplaceColor model =
    { model
        | menu =
            Menu.initReplaceColor
                model.swatches.primary
                model.swatches.second
                (Array.toList model.palette)
                model.windowSize
                |> Just
    }



-- REDO --


redo : Model -> Model
redo model =
    case model.history.future of
        f :: rest ->
            case f of
                CanvasChange canvas ->
                    { model
                        | canvas = canvas
                        , history =
                            History.setFuture rest model.history
                    }
                        |> passToPast (CanvasChange model.canvas)

                ColorChange index color ->
                    case Array.get index model.palette of
                        Just existingColor ->
                            handleColor index color model
                                |> passToPast (ColorChange index existingColor)
                                |> setFuture rest

                        Nothing ->
                            model

        [] ->
            model



-- UNDO --


undo : Model -> Model
undo model =
    case model.past of
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
                                |> setPast rest

                        Nothing ->
                            model

        [] ->
            model



-- COLOR HELPER --


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
