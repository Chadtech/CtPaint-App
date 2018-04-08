module Update exposing (update)

import Canvas exposing (DrawOp(Batch))
import ColorPicker
import Data.Color as Color
import Data.Keys as Key
import Data.Minimap as Minimap
import Data.User as User
import Helpers.Keys
import Incorporate.Color
import Incorporate.Menu as Menu
import Keys
import Menu
import Minimap
import Model exposing (Model)
import Mouse exposing (Position)
import Msg exposing (Msg(..))
import Palette
import Ports
import Return2 as R2
import Return3 as R3
import Task
import Taskbar
import Tool
import Toolbar
import Tracking
    exposing
        ( Event
            ( Logout
            , MsgDecodeFail
            , WindowSize
            )
        )
import Util


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClientMouseMoved position ->
            Tool.handleClientMouseMovement position model
                |> R2.withNoCmd

        ClientMouseUp position ->
            Tool.handleClientMouseUp position model
                |> R2.withCmd (trackClientMouseUp position model)

        ToolbarMsg subMsg ->
            Toolbar.update subMsg model

        TaskbarMsg subMsg ->
            Taskbar.update subMsg model

        PaletteMsg subMsg ->
            model.color
                |> Palette.update model.taco subMsg
                |> R2.mapCmd PaletteMsg
                |> R2.mapModel (setColorModel model)

        MenuMsg subMsg ->
            case model.menu of
                Just menu ->
                    menu
                        |> Menu.update model.taco subMsg
                        |> R3.mapCmd MenuMsg
                        |> R3.incorp Menu.incorporate model

                Nothing ->
                    model |> R2.withNoCmd

        WindowSizeReceived size ->
            size
                |> WindowSize
                |> Ports.track model.taco
                |> R2.withModel
                    { model | windowSize = size }

        KeyboardEvent (Ok event) ->
            let
                keyCmd =
                    Helpers.Keys.getCmd
                        model.taco.config
                        event
            in
            model
                |> Helpers.Keys.setShift event
                |> Keys.exec keyCmd
                |> R2.addCmd (trackKeyEvent model keyCmd event)

        KeyboardEvent (Err err) ->
            err
                |> Tracking.KeyboardEventFail
                |> Ports.track model.taco
                |> R2.withModel model

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
            model.minimap
                |> Minimap.update model.taco subMsg
                |> R2.mapCmd MinimapMsg
                |> R2.mapModel (setMinimap model)

        ScreenMouseUp mouseEvent ->
            Tool.handleScreenMouseUp mouseEvent model
                |> R2.withCmd
                    (trackScreenMouseUp mouseEvent.clientPos model)

        ScreenMouseDown mouseEvent ->
            Tool.handleScreenMouseDown mouseEvent model
                |> R2.withCmd
                    (trackScreenMouseDown mouseEvent.clientPos model)

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
            Logout Nothing
                |> Ports.track model.taco
                |> R2.withModel
                    { model | user = User.LoggedOut }

        LogoutFailed err ->
            err
                |> Just
                |> Logout
                |> Ports.track model.taco
                |> R2.withModel model

        MsgDecodeFailed err ->
            err
                |> toString
                |> MsgDecodeFail
                |> Ports.track model.taco
                |> R2.withModel model

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


trackScreenMouseDown : Position -> Model -> Cmd Msg
trackScreenMouseDown position model =
    position
        |> Tracking.ScreenMouseDown
        |> Ports.track model.taco


trackScreenMouseUp : Position -> Model -> Cmd Msg
trackScreenMouseUp position model =
    position
        |> Tracking.ScreenMouseUp
        |> Ports.track model.taco


trackClientMouseUp : Position -> Model -> Cmd Msg
trackClientMouseUp position model =
    position
        |> Tracking.ClientMouseUp
        |> Ports.track model.taco


setColorModel : Model -> Color.Model -> Model
setColorModel model colorModel =
    { model | color = colorModel }


setMinimap : Model -> Minimap.State -> Model
setMinimap model state =
    { model | minimap = state }


trackKeyEvent : Model -> Key.Cmd -> Key.Event -> Cmd Msg
trackKeyEvent { taco } keyCmd keyEvent =
    Tracking.KeyboardEvent
        (toString keyCmd)
        (toString keyEvent)
        |> Ports.track taco
