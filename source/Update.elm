module Update exposing (update)

import Array
import Canvas exposing (DrawOp(Batch))
import ColorPicker
import Data.Menu
import Data.Minimap exposing (State(..))
import Data.User as User
import Draw
import Helpers.Keys
import History
import Keys
import Menu
import Minimap
import Msg exposing (Msg(..))
import Palette
import Ports exposing (JsMsg(..))
import Reply exposing (Reply(..))
import Taskbar
import Tool.Update as Tool
import Toolbar
import Tuple.Infix exposing ((&))
import Types exposing (Model)
import Util exposing (origin)


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
            Palette.update subMsg model & Cmd.none

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

        KeyboardEvent (Ok payload) ->
            Keys.exec (Helpers.Keys.cmdFromEvent payload model.config) model

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
            model.colorPicker
                |> ColorPicker.update subMsg
                |> incorporateColorPicker model

        MinimapMsg subMsg ->
            case model.minimap of
                Opened minimap ->
                    let
                        minimapUpdate =
                            Minimap.update subMsg minimap
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

        IncorporateImage image ->
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
                    Just ( imagePosition, image )
                , menu = Nothing
            }
                & Ports.send ReturnFocus

        ScaleTo dw dh ->
            case model.selection of
                Nothing ->
                    { model
                        | menu = Nothing
                        , canvas =
                            Canvas.scale dw dh model.canvas
                    }
                        |> History.addCanvas
                        & Ports.send ReturnFocus

                Just ( pos, selection ) ->
                    let
                        newSelection =
                            Canvas.scale dw dh selection
                    in
                    { model
                        | menu = Nothing
                        , selection =
                            Just ( pos, newSelection )
                    }
                        & Ports.send ReturnFocus

        AddText str ->
            { model
                | menu = Nothing
                , selection =
                    ( origin
                    , Draw.text
                        str
                        model.swatches.primary
                    )
                        |> Just
            }
                |> History.addCanvas
                & Ports.send ReturnFocus

        Replace target replacement ->
            case model.selection of
                Just ( position, selection ) ->
                    { model
                        | menu = Nothing
                        , selection =
                            ( position
                            , Draw.replace
                                target
                                replacement
                                selection
                            )
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
                        & Cmd.none

        NewUser user ->
            { model | user = User.LoggedIn user } & Cmd.none


incorporateColorPicker :
    Model
    -> ( ColorPicker.Model, ColorPicker.Reply )
    -> ( Model, Cmd Msg )
incorporateColorPicker model ( colorPicker, reply ) =
    case reply of
        ColorPicker.NoReply ->
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
            { model
                | colorPicker = colorPicker
            }
                |> History.addColor index color
                & Cmd.none

        ColorPicker.StealFocus ->
            model & Ports.send StealFocus

        ColorPicker.ReturnFocus ->
            model & Ports.send ReturnFocus
