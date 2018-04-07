module Keys exposing (..)

import Canvas exposing (Canvas, DrawOp)
import Clipboard
import Data.Keys as Key exposing (Cmd(..))
import Data.Minimap exposing (State(..))
import Data.Selection as Selection
import Data.Tool as Tool exposing (Tool(..))
import Draw
import Helpers.Color
import Helpers.Drawing
import Helpers.History as History
import Helpers.Menu
import Helpers.Zoom as Zoom
import Menu
import Minimap
import Model exposing (Model)
import Platform.Cmd as Platform
import Ports exposing (JsMsg(..))
import Return2 as R2
import Zoom


exec : Key.Cmd -> Model -> ( Model, Platform.Cmd msg )
exec keyCmd model =
    case keyCmd of
        NoCmd ->
            model |> R2.withNoCmd

        SetToolToPencil ->
            { model | tool = Pencil Nothing } |> R2.withNoCmd

        SetToolToHand ->
            { model | tool = Hand Nothing } |> R2.withNoCmd

        SetToolToSelect ->
            { model | tool = Select Nothing } |> R2.withNoCmd

        SetToolToFill ->
            { model | tool = Fill } |> R2.withNoCmd

        SetToolToEraser ->
            { model | tool = Eraser Nothing } |> R2.withNoCmd

        SetToolToSample ->
            { model | tool = Sample } |> R2.withNoCmd

        SetToolToLine ->
            { model | tool = Line Nothing } |> R2.withNoCmd

        SetToolToRectangle ->
            { model | tool = Rectangle Nothing } |> R2.withNoCmd

        SetToolToRectangleFilled ->
            { model | tool = RectangleFilled Nothing } |> R2.withNoCmd

        SwatchesTurnLeft ->
            swatchesTurnLeft model |> R2.withNoCmd

        SwatchesTurnRight ->
            swatchesTurnRight model |> R2.withNoCmd

        SwatchesQuickTurnLeft ->
            if model.color.swatches.keyIsDown then
                model |> R2.withNoCmd
            else
                model
                    |> swatchesTurnLeft
                    |> setKeyAsDown
                    |> R2.withNoCmd

        RevertQuickTurnLeft ->
            swatchesTurnRight (setKeyAsUp model)
                |> R2.withNoCmd

        SwatchesQuickTurnRight ->
            if model.color.swatches.keyIsDown then
                model |> R2.withNoCmd
            else
                model
                    |> swatchesTurnRight
                    |> setKeyAsDown
                    |> R2.withNoCmd

        RevertQuickTurnRight ->
            swatchesTurnLeft (setKeyAsUp model)
                |> R2.withNoCmd

        SwatchesQuickTurnDown ->
            if model.color.swatches.keyIsDown then
                model |> R2.withNoCmd
            else
                model
                    |> swatchesTurnLeft
                    |> swatchesTurnLeft
                    |> setKeyAsDown
                    |> R2.withNoCmd

        RevertQuickTurnDown ->
            model
                |> swatchesTurnLeft
                |> swatchesTurnLeft
                |> setKeyAsUp
                |> R2.withNoCmd

        Undo ->
            History.undo model |> R2.withNoCmd

        Redo ->
            History.redo model |> R2.withNoCmd

        Copy ->
            Clipboard.copy model |> R2.withNoCmd

        Cut ->
            Clipboard.cut model |> R2.withNoCmd

        Paste ->
            Clipboard.paste model |> R2.withNoCmd

        SelectAll ->
            { model
                | selection =
                    { position = { x = 0, y = 0 }
                    , canvas = model.canvas
                    , origin = Selection.Other
                    }
                        |> Just
                , canvas =
                    Canvas.getSize model.canvas
                        |> Canvas.initialize
                        |> Canvas.draw (clearAllOp model)
            }
                |> R2.withNoCmd

        Key.ZoomIn ->
            let
                newZoom =
                    Zoom.next model.zoom
            in
            if model.zoom == newZoom then
                model |> R2.withNoCmd
            else
                Zoom.set newZoom model |> R2.withNoCmd

        Key.ZoomOut ->
            let
                newZoom =
                    Zoom.prev model.zoom
            in
            if model.zoom == newZoom then
                model |> R2.withNoCmd
            else
                Zoom.set newZoom model |> R2.withNoCmd

        ToggleMinimap ->
            case model.minimap of
                Opened minimapModel ->
                    { model
                        | minimap =
                            minimapModel.externalPosition
                                |> Closed
                    }
                        |> R2.withNoCmd

                Closed position ->
                    { model
                        | minimap =
                            model.windowSize
                                |> Minimap.init (Just position)
                                |> Opened
                    }
                        |> R2.withNoCmd

                NotInitialized ->
                    { model
                        | minimap =
                            model.windowSize
                                |> Minimap.init Nothing
                                |> Opened
                    }
                        |> R2.withNoCmd

        SwitchGalleryView ->
            { model
                | galleryView = not model.galleryView
            }
                |> R2.withNoCmd

        InitImport ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initImport
                        |> Just
            }
                |> R2.withCmd Ports.stealFocus

        InitDownload ->
            { model
                | menu =
                    Menu.initDownload
                        { name = model.drawingName
                        , nameIsGenerated =
                            model.drawingNameIsGenerated
                        }
                        model.windowSize
                        |> Just
            }
                |> R2.withCmd Ports.stealFocus

        InitText ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initText
                        |> Just
            }
                |> R2.withCmd Ports.stealFocus

        InitScale ->
            { model
                | menu =
                    Menu.initScale
                        (Canvas.getSize (initScaleCanvas model))
                        model.windowSize
                        |> Just
            }
                |> R2.withCmd Ports.stealFocus

        InitReplaceColor ->
            Helpers.Menu.initReplaceColor model

        ToggleColorPicker ->
            { model
                | color =
                    Helpers.Color.toggleColorPicker model.color
            }
                |> R2.withNoCmd

        Delete ->
            case model.selection of
                Just _ ->
                    { model
                        | selection = Nothing
                    }
                        |> R2.withNoCmd

                Nothing ->
                    model |> R2.withNoCmd

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

        Key.Save ->
            Helpers.Drawing.save model

        SetTransparency ->
            case model.selection of
                Nothing ->
                    model |> R2.withNoCmd

                Just selection ->
                    { model
                        | selection =
                            Selection.updateCanvas
                                (Canvas.transparentColor model.color.swatches.bottom)
                                selection
                                |> Just
                    }
                        |> R2.withNoCmd

        InitUpload ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initUpload
                        |> Just
            }
                |> R2.withCmd (Ports.send OpenUpFileUpload)

        InitResize ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initResize
                            (Canvas.getSize model.canvas)
                        |> Just
            }
                |> R2.withCmd Ports.stealFocus



-- PRIVATE HELPERS --


clearAllOp : Model -> DrawOp
clearAllOp model =
    Draw.filledRectangle
        model.color.swatches.bottom
        (Canvas.getSize model.canvas)
        { x = 0, y = 0 }


initScaleCanvas : Model -> Canvas
initScaleCanvas model =
    case model.selection of
        Just { canvas } ->
            canvas

        Nothing ->
            model.canvas


transform : (Canvas -> Canvas) -> Model -> ( Model, Platform.Cmd msg )
transform transformation model =
    case model.selection of
        Just selection ->
            { model
                | selection =
                    Selection.updateCanvas
                        transformation
                        selection
                        |> Just
            }
                |> R2.withNoCmd

        Nothing ->
            model
                |> History.canvas
                |> Model.updateCanvas transformation
                |> R2.withNoCmd


swatchesTurnLeft : Model -> Model
swatchesTurnLeft model =
    { model
        | color =
            Helpers.Color.swatchesTurnLeft model.color
    }


swatchesTurnRight : Model -> Model
swatchesTurnRight model =
    { model
        | color =
            Helpers.Color.swatchesTurnRight model.color
    }


setKeyAsUp : Model -> Model
setKeyAsUp model =
    { model
        | color = Helpers.Color.setKeyAsUp model.color
    }


setKeyAsDown : Model -> Model
setKeyAsDown model =
    { model
        | color = Helpers.Color.setKeyAsDown model.color
    }
