module Command exposing (..)

import Array
import Canvas exposing (Canvas, DrawOp(Rotate))
import Clipboard
import Dict exposing (Dict)
import Draw
import History
import Menu exposing (Menu)
import Minimap
import Ports exposing (JsMsg(..))
import Tool exposing (Tool(..))
import Tool.Zoom as Zoom
import Tool.Zoom.Util as Zoom
import Types
    exposing
        ( Command(..)
        , Direction(..)
        , KeyPayload
        , MinimapState(..)
        , Model
        , Msg(..)
        , payloadToString
        )
import Util exposing ((&), origin)


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

        SwatchesTurnLeft ->
            swatchesTurnLeft model & Cmd.none

        SwatchesTurnRight ->
            swatchesTurnRight model & Cmd.none

        SwatchesQuickTurnLeft ->
            if model.swatches.keyIsDown then
                model & Cmd.none
            else
                model
                    |> swatchesTurnLeft
                    |> setKeyAsDown
                    & Cmd.none

        RevertQuickTurnLeft ->
            swatchesTurnRight (setKeyAsUp model)
                & Cmd.none

        SwatchesQuickTurnRight ->
            if model.swatches.keyIsDown then
                model & Cmd.none
            else
                model
                    |> swatchesTurnRight
                    |> setKeyAsDown
                    & Cmd.none

        RevertQuickTurnRight ->
            swatchesTurnLeft (setKeyAsUp model)
                & Cmd.none

        SwatchesQuickTurnDown ->
            if model.swatches.keyIsDown then
                model & Cmd.none
            else
                model
                    |> swatchesTurnLeft
                    |> swatchesTurnLeft
                    |> setKeyAsDown
                    & Cmd.none

        RevertQuickTurnDown ->
            model
                |> swatchesTurnLeft
                |> swatchesTurnLeft
                |> setKeyAsUp
                & Cmd.none

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
                | selection = Just ( origin, model.canvas )
                , canvas =
                    let
                        drawOp =
                            Draw.filledRectangle
                                model.swatches.second
                                (Canvas.getSize model.canvas)
                                origin
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

        ToggleMinimap ->
            case model.minimap of
                Minimap minimapModel ->
                    { model
                        | minimap =
                            minimapModel.externalPosition
                                |> Closed
                    }
                        & Cmd.none

                Closed position ->
                    { model
                        | minimap =
                            Minimap.init
                                (Just position)
                                model.windowSize
                                |> Minimap
                    }
                        & Cmd.none

                NoMinimap ->
                    { model
                        | minimap =
                            Minimap.init
                                Nothing
                                model.windowSize
                                |> Minimap
                    }
                        & Cmd.none

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
                & Ports.send StealFocus

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
                & Ports.send StealFocus

        InitText ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initText
                        |> Just
            }
                & Ports.send StealFocus

        InitScale ->
            let
                menu =
                    case model.selection of
                        Just ( pos, selection ) ->
                            Menu.initScale
                                (Canvas.getSize selection)
                                model.windowSize
                                |> Just

                        Nothing ->
                            Menu.initScale
                                (Canvas.getSize model.canvas)
                                model.windowSize
                                |> Just
            in
            { model | menu = menu }
                & Ports.send StealFocus

        InitAbout ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initAbout
                        |> Just
            }
                & Cmd.none

        InitReplaceColor ->
            { model
                | menu =
                    Menu.initReplaceColor
                        model.windowSize
                        model.swatches.primary
                        model.swatches.second
                        (Array.toList model.palette)
                        |> Just
            }
                & Cmd.none

        ToggleColorPicker ->
            let
                { colorPicker } =
                    model

                { window } =
                    colorPicker

                newWindow =
                    { window
                        | show = not window.show
                    }
            in
            { model
                | colorPicker =
                    { colorPicker
                        | window = newWindow
                    }
            }
                & Cmd.none

        Delete ->
            case model.selection of
                Just _ ->
                    { model
                        | selection = Nothing
                    }
                        & Cmd.none

                Nothing ->
                    model & Cmd.none

        FlipHorizontal ->
            transform Draw.flipHorizontal model

        FlipVertical ->
            transform Draw.flipVertical model

        Rotate90 ->
            transform Draw.rotate90 model

        Rotate180 ->
            transform Draw.rotate180 model

        Rotate270 ->
            transform Draw.rotate270 model

        InvertColors ->
            transform Draw.invert model

        Save ->
            let
                jsMsg =
                    SaveLocally
                        (Canvas.getSize model.canvas)
                        (Util.getImageDataString model.canvas)
            in
            model & Ports.send jsMsg


transform : (Canvas -> Canvas) -> Model -> ( Model, Cmd Msg )
transform transformation model =
    case model.selection of
        Just ( position, selection ) ->
            { model
                | selection =
                    ( position
                    , transformation selection
                    )
                        |> Just
            }
                & Cmd.none

        Nothing ->
            { model
                | canvas =
                    transformation model.canvas
            }
                & Cmd.none


swatchesTurnLeft : Model -> Model
swatchesTurnLeft ({ swatches } as model) =
    { model
        | swatches =
            { swatches
                | primary = model.swatches.first
                , first = model.swatches.second
                , second = model.swatches.third
                , third = model.swatches.primary
            }
    }


swatchesTurnRight : Model -> Model
swatchesTurnRight ({ swatches } as model) =
    { model
        | swatches =
            { swatches
                | primary = model.swatches.third
                , first = model.swatches.primary
                , second = model.swatches.first
                , third = model.swatches.second
            }
    }


setKeyAsUp : Model -> Model
setKeyAsUp ({ swatches } as model) =
    { model
        | swatches =
            { swatches | keyIsDown = False }
    }


setKeyAsDown : Model -> Model
setKeyAsDown ({ swatches } as model) =
    { model
        | swatches =
            { swatches | keyIsDown = True }
    }


fromKeyPayload : KeyPayload -> Model -> Command
fromKeyPayload payload { cmdKey, keyConfig } =
    case Dict.get (payloadToString cmdKey payload) keyConfig of
        Just command ->
            command

        Nothing ->
            NoCommand
