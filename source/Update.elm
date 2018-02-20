module Update exposing (update)

import Canvas exposing (DrawOp(Batch))
import ColorPicker
import Data.User as User
import Helpers.History as History
import Helpers.Keys
import Incorporate.Color
import Incorporate.Menu as Menu
import Keys
import Menu
import Minimap
import Model exposing (Model)
import Msg exposing (Msg(..))
import Palette
import Taskbar
import Tool
import Toolbar
import Tuple.Infix exposing ((&), (|&))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ClientMouseMoved position ->
            Tool.handleClientMouseMovement position model & Cmd.none

        ClientMouseUp position ->
            Tool.handleClientMouseUp position model & Cmd.none

        ToolbarMsg subMsg ->
            Toolbar.update subMsg model

        TaskbarMsg subMsg ->
            Taskbar.update subMsg model

        PaletteMsg subMsg ->
            { model
                | color =
                    Palette.update subMsg model.color
            }
                & Cmd.none

        MenuMsg subMsg ->
            case model.menu of
                Just menu ->
                    let
                        ( ( newMenu, menuCmd ), reply ) =
                            Menu.update model.config subMsg menu

                        ( newModel, modelCmd ) =
                            Menu.incorporate reply newMenu model
                    in
                    [ modelCmd
                    , Cmd.map MenuMsg menuCmd
                    ]
                        |> Cmd.batch
                        |& newModel

                Nothing ->
                    model & Cmd.none

        WindowSizeReceived size ->
            { model | windowSize = size } & Cmd.none

        KeyboardEvent (Ok event) ->
            model
                |> Helpers.Keys.setShift event
                |> Keys.exec (Helpers.Keys.getCmd model.config event)

        KeyboardEvent (Err err) ->
            model & Cmd.none

        Tick _ ->
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
                ( ( newColorModel, cmd ), reply ) =
                    model.color.picker
                        |> ColorPicker.update subMsg
                        |> Incorporate.Color.picker model.color
            in
            case reply of
                Incorporate.Color.NoReply ->
                    { model | color = newColorModel } & cmd

                Incorporate.Color.ColorHistory index color ->
                    { model | color = newColorModel }
                        |> History.color index color
                        & cmd

        MinimapMsg subMsg ->
            { model
                | minimap =
                    Minimap.update subMsg model.minimap
            }
                & Cmd.none

        ScreenMouseUp mouseEvent ->
            Tool.handleScreenMouseUp mouseEvent model & Cmd.none

        ScreenMouseDown mouseEvent ->
            Tool.handleScreenMouseDown mouseEvent model & Cmd.none

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

        LogoutSucceeded ->
            { model | user = User.LoggedOut }
                & Cmd.none

        LogoutFailed err ->
            model & Cmd.none

        MsgDecodeFailed _ ->
            model & Cmd.none
