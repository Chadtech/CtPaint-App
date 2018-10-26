module Track exposing (track)

import Color.Track as Color
import Data.Tracking as Tracking
import Json.Encode as E
import Menu.Track as Menu
import Minimap.Track as Minimap
import Model exposing (Model)
import Msg exposing (Msg(..), decodeProblemToString)
import Taskbar.Track as Taskbar
import Toolbar
import Util exposing (def)


track : Msg -> Model -> Tracking.Event
track msg model =
    case msg of
        WindowSizeReceived size ->
            [ def "width" <| E.int size.width
            , def "height" <| E.int size.height
            ]
                |> Tracking.withProps
                    "window-size-received"

        ToolbarMsg subMsg ->
            Toolbar.track subMsg model
                |> Tracking.namespace
                    "toolbar"

        TaskbarMsg subMsg ->
            Taskbar.track subMsg model
                |> Tracking.namespace
                    "taskbar"

        MenuMsg subMsg ->
            case model.menu of
                Just menu ->
                    Menu.track subMsg menu
                        |> Tracking.namespace
                            "menu"

                Nothing ->
                    "menu msg but no menu"
                        |> msgMismatch

        Tick _ ->
            Tracking.none

        ColorMsg subMsg ->
            Color.track subMsg
                |> Tracking.namespace
                    "color"

        ToolMsg _ ->
            Tracking.none

        MinimapMsg subMsg ->
            Minimap.track subMsg
                |> Tracking.namespace
                    "minimap"

        WorkareaMouseMove _ ->
            Tracking.none

        WorkareaContextMenu ->
            "workarea-context-menu"
                |> Tracking.noProps

        WorkareaMouseExit ->
            Tracking.none

        KeyboardEvent _ ->
            Tracking.none

        LogoutSucceeded ->
            logoutResult E.null

        LogoutFailed error ->
            logoutResult (E.string error)

        InitFromUrl _ ->
            Tracking.none

        DrawingLoaded _ ->
            Tracking.none

        DrawingDeblobed _ (Ok _) ->
            Tracking.none

        DrawingDeblobed _ (Err _) ->
            "drawing-failed-to-deblob"
                |> Tracking.noProps

        GalleryScreenClicked ->
            "gallery-screen-clicked"
                |> Tracking.noProps

        FileRead _ ->
            Tracking.none

        FileNotImage ->
            Tracking.none

        MsgDecodeFailed problem ->
            [ problem
                |> decodeProblemToString
                |> E.string
                |> def "msg-decode-failed"
            ]
                |> Tracking.withProps
                    "msg-decode-failed"


logoutResult : E.Value -> Tracking.Event
logoutResult error =
    [ def "error" error ]
        |> Tracking.withProps
            "logout-result"


msgMismatch : String -> Tracking.Event
msgMismatch mismatch =
    [ mismatch
        |> E.string
        |> def "mismatch"
    ]
        |> Tracking.withProps
            "msg-mismatch-error"
