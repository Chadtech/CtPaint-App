module Keyboard.Update exposing (keyDown, keyUp, update)

import Canvas
import Clipboard.Update as Clipboard
import Dict
import Draw.Rectangle as Rectangle
import History.Update as History
import Keyboard exposing (KeyCode)
import Keyboard.Types
    exposing
        ( Command(..)
        , Config
        , Direction(..)
        , Message(..)
        )
import List.Unique exposing (UniqueList)
import Main.Model exposing (Model)
import Menu.Download.Types as Download
import Menu.Import.Types as Import
import Menu.Scale.Types as Scale
import Menu.Types as Menu exposing (Menu(..))
import Minimap.Types as Minimap
import Mouse exposing (Position)
import Tool.Types exposing (Tool(..))
import Tool.Zoom as Zoom


update : Message -> Model -> Model
update message model =
    case message of
        KeyEvent (Up code) ->
            let
                newModel =
                    model.keyboardUpConfig
                        |> getCmd model.keysDown
                        |> keyUp model
            in
            { newModel
                | keysDown =
                    List.Unique.remove
                        code
                        model.keysDown
            }

        KeyEvent (Down code) ->
            keyDown
                { model
                    | keysDown =
                        List.Unique.cons
                            code
                            model.keysDown
                }
                (getCmd model.keysDown model.keyboardDownConfig)



-- KEY EVENTS --


getCmd : UniqueList KeyCode -> Config -> Command
getCmd list config =
    case Dict.get (List.Unique.toList list) config of
        Nothing ->
            NoCommand

        Just cmd ->
            cmd


keyDown : Model -> Command -> Model
keyDown model quickKey =
    case quickKey of
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


keyUp : Model -> Command -> Model
keyUp model quickKey =
    case quickKey of
        NoCommand ->
            model

        SetToolToPencil ->
            { model | tool = Pencil Nothing }

        SetToolToHand ->
            { model | tool = Hand Nothing }

        SetToolToSelect ->
            { model | tool = Select Nothing }

        SetToolToFill ->
            { model | tool = Fill }

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

        Copy ->
            Clipboard.copy model

        Cut ->
            Clipboard.cut model

        Paste ->
            Clipboard.paste model

        SelectAll ->
            { model
                | selection = Just ( Position 0 0, model.canvas )
                , canvas =
                    let
                        drawOp =
                            Rectangle.fill
                                model.swatches.second
                                (Canvas.getSize model.canvas)
                                (Position 0 0)
                    in
                    Canvas.getSize model.canvas
                        |> Canvas.initialize
                        |> Canvas.draw drawOp
            }

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

        ShowMinimap ->
            case model.minimap of
                Nothing ->
                    { model
                        | minimap =
                            model.windowSize
                                |> Minimap.init
                                |> Just
                    }

                Just _ ->
                    { model | minimap = Nothing }

        Keyboard.Types.Download ->
            let
                ( downloadModel, seed ) =
                    Download.init
                        model.projectName
                        model.seed
                        model.windowSize
            in
            { model
                | seed = seed
                , menu = Menu.Download downloadModel
            }

        Keyboard.Types.Import ->
            { model
                | menu =
                    model.windowSize
                        |> Import.init
                        |> Menu.Import
            }

        Keyboard.Types.Scale ->
            { model
                | menu =
                    case model.selection of
                        Just ( position, canvas ) ->
                            Scale.init
                                model.windowSize
                                (Canvas.getSize canvas)
                                |> Menu.Scale

                        Nothing ->
                            Scale.init
                                model.windowSize
                                (Canvas.getSize model.canvas)
                                |> Menu.Scale
            }

        SwitchGalleryView ->
            { model | galleryView = not model.galleryView }
