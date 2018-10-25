module Menu.Track exposing (track)

import Data.Tracking as Tracking
import Json.Encode as E
import Menu.BugReport as BugReport
import Menu.Data as Menu exposing (Menu(..))
import Menu.Download as Download
import Menu.Drawing as Drawing
import Menu.Import as Import
import Menu.Login as Login
import Menu.Logout as Logout
import Menu.Model exposing (Model)
import Menu.Msg exposing (Msg(..))
import Menu.New as New
import Menu.ReplaceColor as ReplaceColor
import Menu.Resize as Resize
import Menu.Save as Save
import Menu.Scale as Scale
import Menu.Text as Text
import Menu.Upload as Upload
import Util exposing (def)


track : Msg -> Model -> Tracking.Event
track msg model =
    case msg of
        XButtonMouseDown ->
            "x-button-mouse-down"
                |> Tracking.noProps

        XButtonMouseUp ->
            "x-button-mouse-up"
                |> Tracking.noProps

        HeaderMouseDown _ ->
            "header-mouse-down"
                |> Tracking.noProps

        HeaderMouseMove _ ->
            Tracking.none

        HeaderMouseUp _ ->
            "header-mouse-up"
                |> Tracking.noProps

        DownloadMsg subMsg ->
            case model.content of
                Download _ ->
                    Download.track subMsg
                        |> Tracking.namespace
                            "download"

                _ ->
                    msgMismatch model "download"

        ImportMsg subMsg ->
            case model.content of
                Import subModel ->
                    subModel
                        |> Import.track subMsg
                        |> Tracking.namespace
                            "import"

                _ ->
                    msgMismatch model "import"

        ScaleMsg subMsg ->
            case model.content of
                Scale subModel ->
                    Scale.track subMsg
                        |> Tracking.namespace
                            "scale"

                _ ->
                    msgMismatch model "scale"

        TextMsg subMsg ->
            case model.content of
                Text subModel ->
                    Text.track subMsg
                        |> Tracking.namespace
                            "text"

                _ ->
                    msgMismatch model "text"

        BugReportMsg subMsg ->
            case model.content of
                BugReport subModel ->
                    subModel
                        |> BugReport.track subMsg
                        |> Tracking.namespace
                            "bug-report"

                _ ->
                    msgMismatch model "bug-report"

        ReplaceColorMsg subMsg ->
            case model.content of
                ReplaceColor _ ->
                    ReplaceColor.track subMsg
                        |> Tracking.namespace
                            "replace-color"

                _ ->
                    msgMismatch model "replace-color"

        LoginMsg subMsg ->
            case model.content of
                Login _ ->
                    Login.track subMsg
                        |> Tracking.namespace
                            "login"

                _ ->
                    msgMismatch model "login"

        UploadMsg subMsg ->
            case model.content of
                Upload _ ->
                    Upload.track subMsg
                        |> Tracking.namespace
                            "upload"

                _ ->
                    msgMismatch model "upload"

        ResizeMsg subMsg ->
            case model.content of
                Resize _ ->
                    Resize.track subMsg
                        |> Tracking.namespace
                            "resize"

                _ ->
                    msgMismatch model "resize"

        NewMsg subMsg ->
            case model.content of
                New _ ->
                    New.track subMsg
                        |> Tracking.namespace
                            "new"

                _ ->
                    msgMismatch model "new"

        DrawingMsg subMsg ->
            case model.content of
                Drawing _ ->
                    Drawing.track subMsg
                        |> Tracking.namespace
                            "drawing"

                _ ->
                    msgMismatch model "drawing"

        SaveMsg subMsg ->
            case model.content of
                Save _ ->
                    Save.track subMsg
                        |> Tracking.namespace
                            "save"

                _ ->
                    msgMismatch model "save"

        LogoutMsg subMsg ->
            case model.content of
                Logout ->
                    Logout.track subMsg
                        |> Tracking.namespace
                            "logout"

                _ ->
                    msgMismatch model "logout"


msgMismatch : Model -> String -> Tracking.Event
msgMismatch model expectedMenu =
    [ def "expected-menu" <|
        E.string expectedMenu
    , def "actual-menu" <|
        E.string (Menu.toString model.content)
    ]
        |> Tracking.withProps
            "msg-mismatch"
