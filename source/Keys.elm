module Keys exposing (exec, getCmd)

import Canvas exposing (Canvas, DrawOp)
import Canvas.Draw as Draw
import Canvas.Model
import Color.Model as Color
import Data.Config exposing (Config)
import Data.Keys as Key exposing (Cmd(..))
import Dict
import History.Helpers as History
import Menu.Model as Menu
import Model exposing (Model)
import Platform.Cmd as Platform
import Ports exposing (JsMsg(..))
import Return2 as R2
import Selection.Model as Selection
import Tool.Data as Tool exposing (Tool(..))


exec : Key.Cmd -> Model -> ( Model, Platform.Cmd msg )
exec keyCmd model =
    case keyCmd of
        NoCmd ->
            model |> R2.withNoCmd

        SetToolToPencil ->
            { model | tool = Pencil Nothing }
                |> R2.withNoCmd

        SetToolToHand ->
            { model | tool = Hand Nothing }
                |> R2.withNoCmd

        SetToolToSelect ->
            { model | tool = Select Nothing }
                |> R2.withNoCmd

        SetToolToFill ->
            { model | tool = Fill }
                |> R2.withNoCmd

        SetToolToEraser ->
            { model | tool = Eraser Nothing }
                |> R2.withNoCmd

        SetToolToSample ->
            { model | tool = Sample }
                |> R2.withNoCmd

        SetToolToLine ->
            { model | tool = Line Nothing }
                |> R2.withNoCmd

        SetToolToRectangle ->
            { model | tool = Rectangle Nothing }
                |> R2.withNoCmd

        SetToolToRectangleFilled ->
            { model | tool = RectangleFilled Nothing }
                |> R2.withNoCmd

        SwatchesTurnLeft ->
            Model.swatchesTurnLeft model
                |> R2.withNoCmd

        SwatchesTurnRight ->
            Model.swatchesTurnRight model
                |> R2.withNoCmd

        SwatchesQuickTurnLeft ->
            if model.color.swatches.keyIsDown then
                model |> R2.withNoCmd

            else
                model
                    |> Model.swatchesTurnLeft
                    |> Model.setKeyAsDown
                    |> R2.withNoCmd

        RevertQuickTurnLeft ->
            model
                |> Model.setKeyAsUp
                |> Model.swatchesTurnRight
                |> R2.withNoCmd

        SwatchesQuickTurnRight ->
            if model.color.swatches.keyIsDown then
                model
                    |> R2.withNoCmd

            else
                model
                    |> Model.swatchesTurnRight
                    |> Model.setKeyAsDown
                    |> R2.withNoCmd

        RevertQuickTurnRight ->
            model
                |> Model.setKeyAsUp
                |> Model.swatchesTurnLeft
                |> R2.withNoCmd

        SwatchesQuickTurnDown ->
            if model.color.swatches.keyIsDown then
                model
                    |> R2.withNoCmd

            else
                model
                    |> Model.swatchesTurnLeft
                    |> Model.swatchesTurnLeft
                    |> Model.setKeyAsDown
                    |> R2.withNoCmd

        RevertQuickTurnDown ->
            model
                |> Model.swatchesTurnLeft
                |> Model.swatchesTurnLeft
                |> Model.setKeyAsUp
                |> R2.withNoCmd

        Undo ->
            History.undo model
                |> R2.withNoCmd

        Redo ->
            History.redo model
                |> R2.withNoCmd

        Copy ->
            Model.copy model
                |> R2.withNoCmd

        Cut ->
            Model.cut model
                |> R2.withNoCmd

        Paste ->
            Model.paste model
                |> R2.withNoCmd

        SelectAll ->
            { model
                | selection =
                    { position = { x = 0, y = 0 }
                    , canvas = model.canvas.main
                    , origin = Selection.Other
                    }
                        |> Just
                , canvas =
                    Canvas.getSize model.canvas.main
                        |> Canvas.initialize
                        |> Canvas.draw (clearAllOp model)
                        |> Canvas.Model.setMain
                        |> Canvas.Model.applyTo model.canvas
            }
                |> R2.withNoCmd

        Key.ZoomIn ->
            Model.zoomIn model
                |> R2.withNoCmd

        Key.ZoomOut ->
            Model.zoomOut model
                |> R2.withNoCmd

        ToggleMinimap ->
            Model.toggleMinimapOpen model
                |> R2.withNoCmd

        SwitchGalleryView ->
            { model
                | galleryView = not model.galleryView
            }
                |> R2.withNoCmd

        InitImport ->
            { model
                | menu =
                    model
                        |> Model.getWindowSize
                        |> Menu.initImport
                        |> Just
            }
                |> R2.withCmd Ports.stealFocus

        InitDownload ->
            Model.initDownload model

        InitText ->
            Model.initTextMenu model

        InitScale ->
            Model.initScaleMenu model

        InitReplaceColor ->
            Model.initReplaceColorMenu model

        ToggleColorPicker ->
            { model
                | color =
                    Color.toggleColorPicker model.color
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
            Model.saveDrawing model

        SetTransparency ->
            case model.selection of
                Nothing ->
                    model |> R2.withNoCmd

                Just selection ->
                    { model
                        | selection =
                            Selection.mapCanvas
                                (Canvas.transparentColor model.color.swatches.bottom)
                                selection
                                |> Just
                    }
                        |> R2.withNoCmd

        InitUpload ->
            model
                |> R2.withCmd
                    (Ports.send Ports.OpenUpFileUpload)

        InitResize ->
            Model.initResize model



-- PRIVATE HELPERS --


clearAllOp : Model -> DrawOp
clearAllOp model =
    Draw.filledRectangle
        model.color.swatches.bottom
        (Canvas.getSize model.canvas.main)
        { x = 0, y = 0 }


transform : (Canvas -> Canvas) -> Model -> ( Model, Platform.Cmd msg )
transform transformation model =
    case model.selection of
        Just selection ->
            { model
                | selection =
                    Selection.mapCanvas
                        transformation
                        selection
                        |> Just
            }
                |> R2.withNoCmd

        Nothing ->
            Model.mapMainCanvas
                transformation
                (History.canvas model)
                |> R2.withNoCmd



-- PUBLIC HELPERS --


getCmd : Config -> Key.Event -> Key.Cmd
getCmd { keyCmds, cmdKey } event =
    case Dict.get (eventToString cmdKey event) keyCmds of
        Just cmd ->
            cmd

        Nothing ->
            NoCmd


eventToString : (Key.Event -> Bool) -> Key.Event -> String
eventToString cmdKey payload =
    let
        direction =
            toString payload.direction

        code =
            toString payload.code

        shift =
            toString payload.shift

        cmd =
            toString (cmdKey payload)
    in
    shift ++ cmd ++ code ++ direction
