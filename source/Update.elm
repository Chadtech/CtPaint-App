module Update exposing (update)

import Canvas exposing (DrawOp(Batch))
import ColorPicker
import Data.Menu
import Data.Minimap exposing (State(..))
import Data.User as User
import Draw
import Helpers.History as History
import Helpers.Keys
import Helpers.Zoom as Zoom
import Incorporate.Color
import Keys
import Menu
import Minimap
import Model exposing (Model)
import Msg exposing (Msg(..))
import Palette
import Ports exposing (JsMsg(..))
import Reply exposing (Reply(..))
import Taskbar
import Tool.Update as Tool
import Toolbar
import Tuple.Infix exposing ((&), (|&))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ToolbarMsg subMsg ->
            Toolbar.update subMsg model & Cmd.none

        TaskbarMsg subMsg ->
            Taskbar.update subMsg model

        ToolMsg subMsg ->
            Tool.update subMsg model & Cmd.none

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
                            Menu.update subMsg menu

                        ( newModel, modelCmd ) =
                            incorporateMenu reply newMenu model
                    in
                    newModel
                        & Cmd.batch
                            [ modelCmd
                            , Cmd.map MenuMsg menuCmd
                            ]

                Nothing ->
                    model & Cmd.none

        WindowSizeReceived size ->
            { model | windowSize = size } & Cmd.none

        KeyboardEvent (Ok event) ->
            Keys.exec (Helpers.Keys.getCmd model.config event) model

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
            case model.minimap of
                Opened minimap ->
                    let
                        minimapUpdate =
                            Minimap.update
                                subMsg
                                minimap
                                model.canvas
                    in
                    incorporateMinimap minimapUpdate model

                _ ->
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

        LogoutSucceeded ->
            { model | user = User.NoSession }
                & Cmd.none

        LogoutFailed err ->
            model & Cmd.none

        MsgDecodeFailed _ ->
            model & Cmd.none


incorporateMinimap : ( Data.Minimap.Model, Data.Minimap.Reply ) -> Model -> ( Model, Cmd Msg )
incorporateMinimap ( minimap, externalMsg ) model =
    case externalMsg of
        Data.Minimap.NoReply ->
            { model
                | minimap = Opened minimap
            }
                & Cmd.none

        Data.Minimap.Close ->
            { model
                | minimap =
                    Closed minimap.externalPosition
            }
                & Cmd.none


incorporateMenu : Reply -> Data.Menu.Model -> Model -> ( Model, Cmd Msg )
incorporateMenu reply menu model =
    case reply of
        NoReply ->
            { model
                | menu = Just menu
            }
                & Cmd.none

        CloseMenu ->
            { model
                | menu = Nothing
            }
                & Ports.send ReturnFocus

        IncorporateImageAsSelection image ->
            let
                size =
                    Canvas.getSize image

                canvas =
                    Canvas.getSize model.canvas

                imagePosition =
                    { x =
                        (canvas.width - size.width) // 2
                    , y =
                        (canvas.height - size.height) // 2
                    }
            in
            { model
                | selection =
                    { x = (canvas.width - size.width) // 2
                    , y = (canvas.height - size.height) // 2
                    }
                        & image
                        |> Just
                , menu = Nothing
            }
                & Ports.send ReturnFocus

        IncorporateImageAsCanvas image ->
            { model
                | canvas = image
                , menu = Nothing
            }
                & Ports.send ReturnFocus

        ScaleTo w h ->
            case model.selection of
                Nothing ->
                    { model
                        | menu = Nothing
                        , canvas =
                            Canvas.scale w h model.canvas
                    }
                        |> History.canvas
                        & Ports.send ReturnFocus

                Just ( pos, selection ) ->
                    { model
                        | menu = Nothing
                        , selection =
                            selection
                                |> Canvas.scale w h
                                |& pos
                                |> Just
                    }
                        & Ports.send ReturnFocus

        AddText str ->
            addText str model

        Replace target replacement ->
            case model.selection of
                Just ( position, selection ) ->
                    { model
                        | menu = Nothing
                        , selection =
                            selection
                                |> Draw.replace target replacement
                                |& position
                                |> Just
                    }
                        & Cmd.none

                Nothing ->
                    { model
                        | menu = Nothing
                        , canvas =
                            Draw.replace
                                target
                                replacement
                                model.canvas
                    }
                        |> History.canvas
                        & Cmd.none

        SetUser user ->
            { model
                | user = User.LoggedIn user
                , menu = Nothing
            }
                & Cmd.none

        AttemptingLogin ->
            { model
                | user = User.LoggingIn
                , menu = Just menu
            }
                & Cmd.none

        SetToNoSession ->
            { model
                | user = User.NoSession
                , menu = Just menu
            }
                & Cmd.none

        SetProject id project ->
            { model
                | project = Just project
                , menu = Nothing
            }
                & Cmd.none

        ResizeTo left top width height ->
            { model
                | menu = Nothing
                , canvas =
                    Draw.resize
                        left
                        top
                        width
                        height
                        model.color.swatches.second
                        model.canvas
            }
                & Ports.send ReturnFocus


addText : String -> Model -> ( Model, Cmd Msg )
addText str model =
    let
        selection =
            Draw.text str model.color.swatches.primary

        position =
            Zoom.pointInMiddle
                model.windowSize
                model.zoom
                model.canvasPosition

        { width, height } =
            Canvas.getSize selection
    in
    { model
        | menu = Nothing
        , selection =
            { x = position.x - (width // 2)
            , y = position.y - (height // 2)
            }
                & selection
                |> Just
    }
        & Ports.send ReturnFocus
