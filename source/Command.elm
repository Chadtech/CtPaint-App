module Command exposing (..)

import Canvas
import Clipboard
import Dict exposing (Dict)
import Draw
import History
import Menu exposing (Menu)
import Minimap.Types as Minimap
import Mouse exposing (Position)
import Ports
import Tool exposing (Tool(..))
import Tool.Zoom as Zoom
import Types
    exposing
        ( Command(..)
        , Direction(..)
        , KeyPayload
        , Model
        , Msg(..)
        , payloadToString
        )
import Util exposing ((&))


update : Command -> Model -> ( Model, Cmd Msg )
update cmd model =
    case cmd of
        NoCommand ->
            model & Cmd.none

        SetToolToPencil ->
            { model | tool = Pencil Nothing } & Cmd.none

        SetToolToHand ->
            { model | tool = Hand Nothing } & Cmd.none

        SetToolToSelect ->
            { model | tool = Select Nothing } & Cmd.none

        SetToolToFill ->
            { model | tool = Fill } & Cmd.none

        SetToolToSample ->
            { model | tool = Sample } & Cmd.none

        SetToolToLine ->
            { model | tool = Line Nothing } & Cmd.none

        SetToolToRectangle ->
            { model | tool = Rectangle Nothing } & Cmd.none

        SetToolToRectangleFilled ->
            { model | tool = RectangleFilled Nothing } & Cmd.none

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
                    & Cmd.none
            else
                model & Cmd.none

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
                    & Cmd.none
            else
                model & Cmd.none

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
                    & Cmd.none
            else
                model & Cmd.none

        Undo ->
            History.undo model & Cmd.none

        Redo ->
            History.redo model & Cmd.none

        Copy ->
            Clipboard.copy model & Cmd.none

        Cut ->
            Clipboard.cut model & Cmd.none

        Paste ->
            Clipboard.paste model & Cmd.none

        SelectAll ->
            { model
                | selection = Just ( Position 0 0, model.canvas )
                , canvas =
                    let
                        drawOp =
                            Draw.filledRectangle
                                model.swatches.second
                                (Canvas.getSize model.canvas)
                                (Position 0 0)
                    in
                    Canvas.getSize model.canvas
                        |> Canvas.initialize
                        |> Canvas.draw drawOp
            }
                & Cmd.none

        Types.ZoomIn ->
            let
                newZoom =
                    Zoom.next model.zoom
            in
            if model.zoom == newZoom then
                model & Cmd.none
            else
                Zoom.set newZoom model & Cmd.none

        Types.ZoomOut ->
            let
                newZoom =
                    Zoom.prev model.zoom
            in
            if model.zoom == newZoom then
                model & Cmd.none
            else
                Zoom.set newZoom model & Cmd.none

        ShowMinimap ->
            { model
                | minimap =
                    model.windowSize
                        |> Minimap.init
                        |> Just
            }
                & Cmd.none

        HideMinimap ->
            { model | minimap = Nothing } & Cmd.none

        SwitchGalleryView ->
            { model
                | galleryView = not model.galleryView
            }
                & Cmd.none

        InitImport ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initImport
                        |> Just
            }
                & Ports.stealFocus ()

        InitDownload ->
            let
                ( menuModel, seed ) =
                    Menu.initDownload
                        model.windowSize
                        model.projectName
                        model.seed
            in
            { model
                | menu = Just menuModel
                , seed = seed
            }
                & Cmd.none

        _ ->
            model & Cmd.none


fromKeyPayload : KeyPayload -> Model -> Command
fromKeyPayload payload { cmdKey, keyConfig } =
    case Dict.get (payloadToString cmdKey payload) keyConfig of
        Just command ->
            command

        Nothing ->
            NoCommand
