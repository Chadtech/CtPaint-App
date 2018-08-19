module Taskbar.Update exposing (update)

import Data.User as User
import Data.Window as Window exposing (Window(..))
import Keys
import Menu.Model as Menu
import Model exposing (Model)
import Ports
    exposing
        ( JsMsg
            ( Logout
            , OpenNewWindow
            , OpenUpFileUpload
            , StealFocus
            )
        )
import Return2 as R2
import Taskbar.Data.Dropdown exposing (Dropdown(..))
import Taskbar.Msg exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DropdownClickedOut ->
            { model
                | taskbarDropped = Nothing
            }
                |> R2.withNoCmd

        DropdownClicked dropdown ->
            { model
                | taskbarDropped = Just dropdown
            }
                |> R2.withNoCmd

        HoveredOnto dropdown ->
            hoverOnto dropdown model
                |> R2.withNoCmd

        LoginClicked ->
            Model.initLogin model

        UserClicked ->
            case Model.getUser model of
                User.LoggedIn user ->
                    user
                        |> User.toggleOptionsDropped
                        |> User.LoggedIn
                        |> Model.setUser
                        |> Model.applyTo model
                        |> R2.withNoCmd

                _ ->
                    model
                        |> R2.withNoCmd

        LogoutClicked ->
            Model.initLogout model

        AboutClicked ->
            Model.initAbout model

        ReportBugClicked ->
            { model
                | menu =
                    model
                        |> Model.getWindowSize
                        |> Menu.initBugReport
                            (User.isLoggedIn (Model.getUser model))
                        |> Just
            }
                |> R2.withCmd Ports.stealFocus

        KeyCmdClicked keyCmd ->
            Keys.exec keyCmd model

        NewWindowClicked window ->
            window
                |> Window.toUrl (Model.getMountPath model)
                |> Ports.OpenNewWindow
                |> Ports.send
                |> R2.withModel model

        UploadClicked ->
            Ports.send OpenUpFileUpload
                |> R2.withModel model

        ToolClicked tool ->
            { model | tool = tool }
                |> R2.withNoCmd

        DrawingClicked ->
            Model.initDrawing model

        OpenImageLinkClicked ->
            case User.getPublicId (Model.getUser model) of
                Just publicId ->
                    publicId
                        |> Window.Drawing
                        |> Window.toUrl (Model.getMountPath model)
                        |> OpenNewWindow
                        |> Ports.send
                        |> R2.withModel model

                _ ->
                    model |> R2.withNoCmd


hoverOnto : Dropdown -> Model -> Model
hoverOnto dropdown model =
    case model.taskbarDropped of
        Nothing ->
            model

        Just currentDropdown ->
            if currentDropdown == dropdown then
                model
            else
                { model
                    | taskbarDropped = Just dropdown
                }
