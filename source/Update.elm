module Update exposing (update)

import Array
import Canvas exposing (DrawOp(Batch))
import ColorPicker
import History
import Json.Decode as Decode
import Keyboard.Update as Keyboard
import List.Unique
import Menu
import Menu.Update as Menu
import Minimap.Incorporate as Minimap
import Minimap.Update as Minimap
import Palette.Update as Palette
import Taskbar.Update as Taskbar
import Tool.Update as Tool
import Types exposing (Model, Msg(..), keyPayloadDecoder)
import Util exposing ((&))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ToolMsg subMsg ->
            Tool.update subMsg model
                |> Tuple.mapSecond (Cmd.map ToolMsg)

        TaskbarMsg subMsg ->
            let
                ( newModel, cmd ) =
                    Taskbar.update subMsg model
            in
            ( newModel, Cmd.map TaskbarMsg cmd )

        MenuMsg subMsg ->
            Menu.update subMsg model
                |> Tuple.mapSecond (Cmd.map MenuMsg)

        PaletteMsg subMsg ->
            let
                ( newModel, cmd ) =
                    Palette.update subMsg model
            in
            ( newModel, Cmd.map PaletteMsg cmd )

        GetWindowSize size ->
            { model
                | windowSize = size
            }
                & Cmd.none

        SetTool tool ->
            { model
                | tool = tool
            }
                & Cmd.none

        KeyboardEvent direction json ->
            case Decode.decodeValue keyPayloadDecoder json of
                Ok payload ->
                    Keyboard.update direction payload model

                Err err ->
                    model & Cmd.none

        Tick dt ->
            case model.pendingDraw of
                Batch [] ->
                    model & Cmd.none

                _ ->
                    { model
                        | canvas =
                            Canvas.draw
                                model.pendingDraw
                                model.canvas
                        , pendingDraw =
                            Canvas.batch []
                    }
                        & Cmd.none

        ColorPickerMsg subMsg ->
            let
                colorPickerUpdate =
                    ColorPicker.update subMsg model.colorPicker
            in
            incorporateColorPicker colorPickerUpdate model

        MinimapMsg subMsg ->
            case model.minimap of
                Just minimap ->
                    let
                        minimapUpdate =
                            Minimap.update subMsg minimap
                    in
                    Minimap.incorporate minimapUpdate model & Cmd.none

                Nothing ->
                    model & Cmd.none

        ScreenMouseMove { targetPos, clientPos } ->
            let
                x =
                    clientPos.x - targetPos.x - model.canvasPosition.x

                y =
                    clientPos.y - targetPos.y - model.canvasPosition.y
            in
            { model
                | mousePosition =
                    { x = x // model.zoom
                    , y = y // model.zoom
                    }
                        |> Just
            }
                & Cmd.none

        ScreenMouseExit ->
            { model
                | mousePosition =
                    Nothing
            }
                & Cmd.none

        HandleWindowFocus focused ->
            if focused then
                { model
                    | keysDown = List.Unique.empty
                }
                    & Cmd.none
            else
                model & Cmd.none


incorporateColorPicker :
    ( ColorPicker.Model, ColorPicker.ExternalMsg )
    -> Model
    -> ( Model, Cmd Msg )
incorporateColorPicker ( colorPicker, maybeMsg ) model =
    case maybeMsg of
        ColorPicker.DoNothing ->
            { model
                | colorPicker = colorPicker
            }
                & Cmd.none

        ColorPicker.SetColor index color ->
            { model
                | colorPicker = colorPicker
                , palette =
                    Array.set
                        index
                        color
                        model.palette
            }
                & Cmd.none

        ColorPicker.UpdateHistory index color ->
            let
                newModel =
                    { model
                        | colorPicker = colorPicker
                    }
                        |> History.addColor index color
            in
            newModel & Cmd.none

        ColorPicker.StealFocus ->
            model & Menu.stealFocus ()

        ColorPicker.ReturnFocus ->
            model & Menu.returnFocus ()
