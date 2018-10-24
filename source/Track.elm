module Track exposing (track)

import Data.Tracking as Tracking
import Json.Encode as E
import Menu.Track as Menu
import Model exposing (Model)
import Msg exposing (Msg(..))
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

        _ ->
            Tracking.none


msgMismatch : String -> Tracking.Event
msgMismatch mismatch =
    [ mismatch
        |> E.string
        |> def "mismatch"
    ]
        |> Tracking.withProps
            "msg-mismatch-error"
