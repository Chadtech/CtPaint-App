module Update exposing (update)

import Canvas exposing (DrawOp(Batch))
import Canvas.Draw.Model as DrawModel
import Canvas.Model
import Color.Update as Color
import Data.Position as Position
import Data.User as User
import Incorporate
import Keys
import Menu.Update as Menu
import Minimap.Update as Minimap
import Model exposing (Model)
import Msg exposing (Msg(..))
import Return2 as R2
import Return3 as R3
import Task
import Taskbar.Update as Taskbar
import Tool.Update as Tool
import Toolbar


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToolMsg subMsg ->
            Tool.update subMsg model
                |> R2.withNoCmd

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
                        |> Menu.update
                            { mountPath = Model.getMountPath model }
                            subMsg
                        |> R3.mapCmd MenuMsg
                        |> R3.incorp Incorporate.menu model

                Nothing ->
                    model
                        |> R2.withNoCmd

        WindowSizeReceived size ->
            Model.setWindowSize size model
                |> R2.withNoCmd

        KeyboardEvent (Ok event) ->
            let
                keyCmd =
                    Keys.getCmd
                        (Model.getConfig model)
                        event
            in
            model
                |> Model.setShift event
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
                                |> DrawModel.clearPending
                    }
                        |> R2.withNoCmd

        MinimapMsg subMsg ->
            model.minimap
                |> Minimap.update
                    { windowSize = Model.getWindowSize model }
                    subMsg
                |> Model.setMinimap
                |> Model.applyTo model
                |> R2.withNoCmd

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
                        Model.centerInWorkarea
                            model
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
            case Model.getUser model of
                User.LoggedIn user ->
                    user
                        |> User.setDrawing drawing
                        |> User.LoggedIn
                        |> Model.setUser
                        |> Model.applyTo
                            { model
                                | drawingName = drawing.name
                                , drawingNameIsGenerated = drawing.nameIsGenerated
                                , canvas =
                                    { main = canvas
                                    , position =
                                        Model.centerInWorkarea
                                            model
                                            (Canvas.getSize canvas)
                                    }
                            }
                        |> Model.closeMenu

                _ ->
                    model
                        |> R2.withNoCmd

        GalleryScreenClicked ->
            { model | galleryView = False }
                |> R2.withNoCmd

        FileRead url ->
            model
                |> Model.initUpload
                |> R2.addCmd (Msg.loadCmd url)

        FileNotImage ->
            model
                |> Model.initUploadFromFileNotImage

        DrawingDeblobed drawing (Err _) ->
            model
                |> R2.withNoCmd
