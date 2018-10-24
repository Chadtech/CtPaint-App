module Taskbar.Track exposing (track)

import Data.Tracking as Tracking
import Data.Window as Window
import Json.Encode as E
import Model exposing (Model)
import Taskbar.Data.Dropdown as Dropdown
import Taskbar.Msg exposing (Msg(..))
import Tool.Data as Tool
import Util exposing (def)


track : Msg -> Model -> Tracking.Event
track msg model =
    case msg of
        DropdownClickedOut ->
            Tracking.none

        DropdownClicked dropdown ->
            [ dropdown
                |> Dropdown.toString
                |> E.string
                |> def "dropdown"
            ]
                |> Tracking.withProps
                    "dropdown-clicked"

        HoveredOnto _ ->
            Tracking.none

        LoginClicked ->
            "login-clicked"
                |> Tracking.noProps

        UserClicked ->
            "user-clicked"
                |> Tracking.noProps

        LogoutClicked ->
            "logout-clicked"
                |> Tracking.noProps

        AboutClicked ->
            "about-clicked"
                |> Tracking.noProps

        ReportBugClicked ->
            "report-bug-clicked"
                |> Tracking.noProps

        KeyCmdClicked cmd ->
            "key-cmd-clicked"
                |> Tracking.noProps

        NewWindowClicked window ->
            [ window
                |> Window.toString
                |> E.string
                |> def "window"
            ]
                |> Tracking.withProps
                    "new-window-clicked"

        UploadClicked ->
            "upload-clicked"
                |> Tracking.noProps

        ToolClicked tool ->
            [ tool
                |> Tool.name
                |> E.string
                |> def "tool"
            ]
                |> Tracking.withProps
                    "tool-clicked"

        DrawingClicked ->
            "drawing-clicked"
                |> Tracking.noProps

        OpenImageLinkClicked ->
            "open-image-link-clicked"
                |> Tracking.noProps
