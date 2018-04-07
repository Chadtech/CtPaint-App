module Update exposing (update)

import Canvas exposing (DrawOp(Batch))
import ColorPicker
import Data.User as User
import Helpers.Keys
import Incorporate.Color
import Incorporate.Menu as Menu
import Keys
import Menu
import Minimap
import Model exposing (Model)
import Msg exposing (Msg(..))
import Palette
import Return2 as R2
import Return3 as R3
import Task
import Taskbar
import Tool
import Toolbar
import Util


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClientMouseMoved position ->
            Tool.handleClientMouseMovement position model
                |> R2.withNoCmd

        ClientMouseUp position ->
            Tool.handleClientMouseUp position model
                |> R2.withNoCmd

        ToolbarMsg subMsg ->
            Toolbar.update subMsg model

        TaskbarMsg subMsg ->
            Taskbar.update subMsg model

        PaletteMsg subMsg ->
            { model
                | color =
                    Palette.update subMsg model.color
            }
                |> R2.withNoCmd

        MenuMsg subMsg ->
            case model.menu of
                Just menu ->
                    let
                        ( newMenu, menuCmd, reply ) =
                            Menu.update model.config subMsg menu

                        ( newModel, modelCmd ) =
                            Menu.incorporate reply newMenu model
                    in
                    ( newModel
                    , Cmd.batch
                        [ modelCmd
                        , Cmd.map MenuMsg menuCmd
                        ]
                    )

                Nothing ->
                    model |> R2.withNoCmd

        WindowSizeReceived size ->
            { model | windowSize = size } |> R2.withNoCmd

        KeyboardEvent (Ok event) ->
            model
                |> Helpers.Keys.setShift event
                |> Keys.exec (Helpers.Keys.getCmd model.config event)

        KeyboardEvent (Err err) ->
            model |> R2.withNoCmd

        Tick _ ->
            case model.pendingDraw of
                Batch [] ->
                    model |> R2.withNoCmd

                _ ->
                    { model
                        | canvas =
                            Canvas.draw
                                model.pendingDraw
                                model.canvas
                        , pendingDraw =
                            Canvas.batch []
                    }
                        |> R2.withNoCmd

        ColorPickerMsg subMsg ->
            model.color.picker
                |> ColorPicker.update subMsg
                |> R3.mapCmd ColorPickerMsg
                |> Incorporate.Color.picker model.color
                |> R3.incorp Incorporate.Color.model model

        MinimapMsg subMsg ->
            { model
                | minimap =
                    Minimap.update subMsg model.minimap
            }
                |> R2.withNoCmd

        ScreenMouseUp mouseEvent ->
            Tool.handleScreenMouseUp mouseEvent model
                |> R2.withNoCmd

        ScreenMouseDown mouseEvent ->
            Tool.handleScreenMouseDown mouseEvent model
                |> R2.withNoCmd

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
                |> R2.withNoCmd

        ScreenMouseExit ->
            { model
                | mousePosition =
                    Nothing
            }
                |> R2.withNoCmd

        LogoutSucceeded ->
            { model | user = User.LoggedOut }
                |> R2.withNoCmd

        LogoutFailed err ->
            model |> R2.withNoCmd

        MsgDecodeFailed _ ->
            model |> R2.withNoCmd

        InitFromUrl (Ok canvas) ->
            { model
                | canvas = canvas
                , canvasPosition =
                    Util.center
                        model.windowSize
                        (Canvas.getSize canvas)
                , menu = Nothing
            }
                |> R2.withNoCmd

        InitFromUrl (Err err) ->
            model |> R2.withNoCmd

        DrawingLoaded drawing ->
            drawing.data
                |> Canvas.loadImage
                |> Task.attempt (DrawingDeblobed drawing)
                |> R2.withModel model

        DrawingDeblobed drawing (Ok canvas) ->
            case model.user of
                User.LoggedIn user ->
                    { model
                        | menu = Nothing
                        , drawingName = drawing.name
                        , drawingNameIsGenerated = drawing.nameIsGenerated
                        , canvas = canvas
                        , canvasPosition =
                            Util.center
                                model.windowSize
                                (Canvas.getSize canvas)
                        , user =
                            user
                                |> User.setDrawing drawing
                                |> User.LoggedIn
                    }
                        |> R2.withNoCmd

                _ ->
                    model |> R2.withNoCmd

        DrawingDeblobed drawing (Err _) ->
            model |> R2.withNoCmd
