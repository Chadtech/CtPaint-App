module Data.Menu
    exposing
        ( ClickState(..)
        , ContentMsg(..)
        , Menu(..)
        , Model
        , Msg(..)
        , drawingCreateCompleted
        , drawingUpdateCompleted
        , fileNotImage
        , fileRead
        , loginFailed
        , loginSucceeded
        , toString
        )

import About
import BugReport
import Data.Drawing exposing (Drawing)
import Data.User exposing (User)
import Download
import Drawing
import Import
import Loading
import Login
import Logout
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import New
import ReplaceColor
import Resize
import Save
import Scale
import Text
import Upload


-- TYPES --


type Menu
    = Download Download.Model
    | Import Import.Model
    | Scale Scale.Model
    | Text String
    | BugReport BugReport.Model
    | About About.State
    | ReplaceColor ReplaceColor.Model
    | New New.Model
    | Login Login.Model
    | Loading Loading.Model
    | Upload Upload.Model
    | Resize Resize.Model
    | Drawing Drawing.Model
    | Save Save.Model
    | Logout


type alias Model =
    { position : Position
    , click : ClickState
    , title : String
    , content : Menu
    }


type ClickState
    = NoClick
    | XButtonIsDown
    | ClickAt Position


type Msg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Mouse.Position
    | HeaderMouseUp Mouse.Position
    | XButtonMouseDown
    | XButtonMouseUp
    | ContentMsg ContentMsg


type ContentMsg
    = DownloadMsg Download.Msg
    | ImportMsg Import.Msg
    | ScaleMsg Scale.Msg
    | TextMsg Text.Msg
    | BugReportMsg BugReport.Msg
    | ReplaceColorMsg ReplaceColor.Msg
    | NewMsg New.Msg
    | LoginMsg Login.Msg
    | UploadMsg Upload.Msg
    | ResizeMsg Resize.Msg
    | DrawingMsg Drawing.Msg
    | SaveMsg Save.Msg
    | LogoutMsg Logout.Msg



-- MSG HELPERS --


fileRead : String -> Msg
fileRead =
    Upload.GotDataUrl >> UploadMsg >> ContentMsg


fileNotImage : Msg
fileNotImage =
    Upload.FileNotImage
        |> Upload.UploadFailed
        |> UploadMsg
        |> ContentMsg


drawingUpdateCompleted : Result String String -> Msg
drawingUpdateCompleted =
    Save.DrawingUpdateCompleted >> SaveMsg >> ContentMsg


drawingCreateCompleted : Result String Drawing -> Msg
drawingCreateCompleted =
    Save.DrawingCreateCompleted >> SaveMsg >> ContentMsg


loginFailed : String -> Msg
loginFailed =
    Login.LoginFailed >> LoginMsg >> ContentMsg


loginSucceeded : User -> Msg
loginSucceeded =
    Login.LoginSucceeded >> LoginMsg >> ContentMsg



-- HELPERS --


toString : Menu -> String
toString menu =
    case menu of
        Download _ ->
            "download"

        Import _ ->
            "import"

        Scale _ ->
            "scale"

        Text _ ->
            "text"

        BugReport _ ->
            "bug-report"

        About _ ->
            "about"

        ReplaceColor _ ->
            "replace-color"

        New _ ->
            "new"

        Login _ ->
            "login"

        Loading _ ->
            "loading"

        Upload _ ->
            "upload"

        Resize _ ->
            "resize"

        Drawing _ ->
            "drawing"

        Save _ ->
            "save"

        Logout ->
            "logout"
