module Keyboard.Update exposing (update)

import Main.Model exposing (Model)
import Tool.Types exposing (Tool(..))
import Tool.Zoom as Zoom
import Keyboard exposing (KeyCode)
import History.Update as History
import List.Unique exposing (UniqueList)
import Dict
import Keyboard.Types
    exposing
        ( Message(..)
        , QuickKey(..)
        , Direction(..)
        , Config
        )


update : Message -> Model -> Model
update message model =
    case message of
        KeyEvent direction ->
            case direction of
                Up code ->
                    let
                        newModel =
                            handleKeyUp model
                    in
                        { newModel
                            | keysDown =
                                List.Unique.remove
                                    code
                                    model.keysDown
                        }

                Down code ->
                    handleKeyDown
                        { model
                            | keysDown =
                                List.Unique.cons
                                    code
                                    model.keysDown
                        }



-- KEY EVENTS --


getAction : UniqueList KeyCode -> Config -> QuickKey
getAction list config =
    case Dict.get (List.Unique.toList list) config of
        Nothing ->
            NoCommand

        Just cmd ->
            cmd


handleKeyDown : Model -> Model
handleKeyDown ({ keysDown, keyboardDownConfig } as model) =
    case getAction keysDown keyboardDownConfig of
        NoCommand ->
            model

        SwatchesOneTurn ->
            if not model.swatches.keyIsDown then
                { model
                    | swatches =
                        { primary = model.swatches.first
                        , first = model.swatches.second
                        , second = model.swatches.third
                        , third = model.swatches.primary
                        , keyIsDown = True
                        }
                }
            else
                model

        SwatchesTwoTurns ->
            if not model.swatches.keyIsDown then
                { model
                    | swatches =
                        { primary = model.swatches.second
                        , first = model.swatches.third
                        , second = model.swatches.primary
                        , third = model.swatches.first
                        , keyIsDown = True
                        }
                }
            else
                model

        SwatchesThreeTurns ->
            if not model.swatches.keyIsDown then
                { model
                    | swatches =
                        { primary = model.swatches.third
                        , first = model.swatches.primary
                        , second = model.swatches.first
                        , third = model.swatches.second
                        , keyIsDown = True
                        }
                }
            else
                model

        _ ->
            model


handleKeyUp : Model -> Model
handleKeyUp ({ keysDown, keyboardUpConfig } as model) =
    case getAction keysDown keyboardUpConfig of
        NoCommand ->
            model

        SetToolToPencil ->
            { model
                | tool = Pencil Nothing
            }

        SetToolToHand ->
            { model
                | tool = Hand Nothing
            }

        SetToolToSelect ->
            { model
                | tool = Tool.Types.Select Nothing
            }

        SwatchesOneTurn ->
            { model
                | swatches =
                    { primary = model.swatches.first
                    , first = model.swatches.second
                    , second = model.swatches.third
                    , third = model.swatches.primary
                    , keyIsDown = False
                    }
            }

        SwatchesThreeTurns ->
            { model
                | swatches =
                    { primary = model.swatches.third
                    , first = model.swatches.primary
                    , second = model.swatches.first
                    , third = model.swatches.second
                    , keyIsDown = False
                    }
            }

        SwatchesTwoTurns ->
            { model
                | swatches =
                    { primary = model.swatches.second
                    , first = model.swatches.third
                    , second = model.swatches.primary
                    , third = model.swatches.first
                    , keyIsDown = False
                    }
            }

        Undo ->
            History.undo model

        Redo ->
            History.redo model

        Keyboard.Types.ZoomIn ->
            let
                newZoom =
                    Zoom.next model.zoom
            in
                if model.zoom == newZoom then
                    model
                else
                    Zoom.set newZoom model

        Keyboard.Types.ZoomOut ->
            let
                newZoom =
                    Zoom.prev model.zoom
            in
                if model.zoom == newZoom then
                    model
                else
                    Zoom.set newZoom model
