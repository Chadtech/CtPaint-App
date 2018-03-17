module Data.Menu
    exposing
        ( ClickState(..)
        , ContentMsg(..)
        , Menu(..)
        , Model
        , Msg(..)
        , drawingSaveCompleted
        , fileNotImage
        , fileRead
        , loginFailed
        , loginSucceeded
        )

import About
import BugReport
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
import Open
import ReplaceColor
import Resize
import Save
import Scale
import Text
import Upload


type Menu
    = Download Download.Model
    | Import Import.Model
    | Scale Scale.Model
    | Text String
    | BugReport BugReport.Model
    | About About.State
    | ReplaceColor ReplaceColor.Model
    | New New.Model
    | Open Open.Model
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
    | HeaderMouseUp
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
    | OpenMsg Open.Msg
    | LoginMsg Login.Msg
    | UploadMsg Upload.Msg
    | ResizeMsg Resize.Msg
    | DrawingMsg Drawing.Msg
    | SaveMsg Save.Msg
    | LogoutMsg Logout.Msg


fileRead : String -> Msg
fileRead =
    Upload.GotDataUrl >> UploadMsg >> ContentMsg


fileNotImage : Msg
fileNotImage =
    Upload.FileNotImage
        |> Upload.UploadFailed
        |> UploadMsg
        |> ContentMsg


drawingSaveCompleted : Result String String -> Msg
drawingSaveCompleted =
    Save.DrawingSaveCompleted >> SaveMsg >> ContentMsg


loginFailed : String -> Msg
loginFailed =
    Login.LoginFailed >> LoginMsg >> ContentMsg


loginSucceeded : User -> Msg
loginSucceeded =
    Login.LoginSucceeded >> LoginMsg >> ContentMsg
