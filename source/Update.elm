module Update exposing (update)

import Canvas exposing (DrawOp(Batch))
import Canvas.Model
import Color.Update as Color
import Data.Minimap as Minimap
import Data.Position as Position
import Data.Taco as Taco
import Data.User as User
import Draw.Model
import Helpers.Keys
import Incorporate
import Keys
import Menu.Update as Menu
import Minimap
import Model exposing (Model)
import Msg exposing (Msg(..))
import Position.Helpers
import Return2 as R2
import Return3 as R3
import Task
import Taskbar
import Tool.Update as Tool
import Toolbar


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToolMsg subMsg ->
            Tool.update subMsg model
                |> R2.withNoCmd

        -- ClientMouseMoved position ->
        --     Tool.handleClientMouseMovement position model
        --         |> R2.withNoCmd
        -- ClientMouseUp position ->
        --     Tool.handleClientMouseUp position model
        --         |> R2.withNoCmd
        ToolbarMsg subMsg ->
            Toolbar.update subMsg model

        TaskbarMsg subMsg ->
            Taskbar.update subMsg model

        ColorMsg subMsg ->
            model.color
                |> Color.update subMsg
                |> R3.mapCmd ColorMsg
                |> R3.incorp Incorporate.colorModel model

        MenuMsg subMsg ->
            case model.menu of
                Just menu ->
                    menu
                        |> Menu.update model.taco subMsg
                        |> R3.mapCmd MenuMsg
                        |> R3.incorp Incorporate.menu model

                Nothing ->
                    model
                        |> R2.withNoCmd

        WindowSizeReceived size ->
            { model | windowSize = size }
                |> R2.withNoCmd

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

        KeyboardEvent (Err err) ->
            model
                |> R2.withNoCmd

        Tick _ ->
            case model.draws.pending of
                Batch [] ->
                    model
                        |> R2.withNoCmd

                _ ->
                    { model
                        | canvas =
                            Canvas.Model.mapMain
                                (Canvas.draw model.draws.pending)
                                model.canvas
                        , draws =
                            model.draws
                                |> Draw.Model.clearPending
                    }
                        |> R2.withNoCmd

        MinimapMsg subMsg ->
            model.minimap
                |> Minimap.update model.taco subMsg
                |> R2.mapCmd MinimapMsg
                |> R2.mapModel (setMinimap model)

        -- ScreenMouseUp mouseEvent ->
        --     Tool.handleScreenMouseUp mouseEvent model
        --         |> R2.withNoCmd
        -- ScreenMouseDown button mouseEvent ->
        --     Tool.handleScreenMouseDown button mouseEvent model
        --         |> R2.withNoCmd
        WorkareaContextMenu ->
            model
                |> R2.withNoCmd

        WorkareaMouseMove { targetPos, clientPos } ->
            { model
                | mousePosition =
                    clientPos
                        |> Position.subtract targetPos
                        |> Position.subtract model.canvas.position
                        |> Position.divideBy model.zoom
                        |> Just
            }
                |> R2.withNoCmd

        WorkareaMouseExit ->
            { model
                | mousePosition =
                    Nothing
            }
                |> R2.withNoCmd

        LogoutSucceeded ->
            model
                |> R2.withNoCmd

        LogoutFailed err ->
            model
                |> R2.withNoCmd

        MsgDecodeFailed err ->
            model
                |> R2.withNoCmd

        InitFromUrl (Ok canvas) ->
            { model
                | canvas =
                    { main = canvas
                    , position =
                        Position.Helpers.centerInWorkarea
                            model.windowSize
                            (Canvas.getSize canvas)
                    }
                , menu = Nothing
            }
                |> R2.withNoCmd

        InitFromUrl (Err err) ->
            model
                |> R2.withNoCmd

        DrawingLoaded drawing ->
            drawing.data
                |> Canvas.loadImage
                |> Task.attempt (DrawingDeblobed drawing)
                |> R2.withModel model

        DrawingDeblobed drawing (Ok canvas) ->
            case model.taco.user of
                User.LoggedIn user ->
                    { model
                        | menu = Nothing
                        , drawingName = drawing.name
                        , drawingNameIsGenerated = drawing.nameIsGenerated
                        , canvas =
                            { main = canvas
                            , position =
                                Position.Helpers.centerInWorkarea
                                    model.windowSize
                                    (Canvas.getSize canvas)
                            }
                        , taco =
                            user
                                |> User.setDrawing drawing
                                |> User.LoggedIn
                                |> Taco.setUser model.taco
                    }
                        |> R2.withNoCmd

                _ ->
                    model
                        |> R2.withNoCmd

        GalleryScreenClicked ->
            { model | galleryView = False }
                |> R2.withNoCmd

        DrawingDeblobed drawing (Err _) ->
            model
                |> R2.withNoCmd


setMinimap : Model -> Minimap.State -> Model
setMinimap model state =
    { model | minimap = state }
