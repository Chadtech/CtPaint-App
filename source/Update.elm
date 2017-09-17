module Update exposing (update)

import Array
import Canvas exposing (DrawOp(Batch))
import ColorPicker
import Debug exposing (log)
import History
import Keyboard.Update as Keyboard
import List.Unique
import Menu.Ports
import Menu.Update as Menu
import Minimap.Incorporate as Minimap
import Minimap.Update as Minimap
import Mouse exposing (Position)
import Palette.Update as Palette
import Taskbar.Update as Taskbar
import Tool.Update as Tool
import Types exposing (Model, Msg(..))
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
                ! []

        SetTool tool ->
            { model
                | tool = tool
            }
                ! []

        KeyboardMsg subMsg ->
            let
                ( newModel, cmd ) =
                    Keyboard.update subMsg model

                _ =
                    log "keys down" newModel.keysDown
            in
            newModel ! [ cmd ]

        Tick dt ->
            case model.pendingDraw of
                Batch [] ->
                    model ! []

                _ ->
                    { model
                        | canvas =
                            Canvas.draw
                                model.pendingDraw
                                model.canvas
                        , pendingDraw =
                            Canvas.batch []
                    }
                        ! []

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
                    Minimap.incorporate minimapUpdate model ! []

                Nothing ->
                    model ! []

        ScreenMouseMove { targetPos, clientPos } ->
            let
                x =
                    clientPos.x - targetPos.x - model.canvasPosition.x

                y =
                    clientPos.y - targetPos.y - model.canvasPosition.y

                position =
                    Position
                        (x // model.zoom)
                        (y // model.zoom)
            in
            { model
                | mousePosition =
                    Just position
            }
                ! []

        ScreenMouseExit ->
            { model
                | mousePosition =
                    Nothing
            }
                ! []

        HandleWindowFocus focused ->
            if focused then
                { model
                    | keysDown = List.Unique.empty
                }
                    ! []
            else
                model ! []


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
            model & Menu.Ports.stealFocus ()

        ColorPicker.ReturnFocus ->
            model & Menu.Ports.returnFocus ()
