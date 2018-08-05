module Menu.Msg
    exposing
        ( Msg(..)
        , drawingCreateCompleted
        , drawingUpdateCompleted
        , fileNotImage
        , fileRead
        , loginFailed
        , loginSucceeded
        )

import Data.Drawing exposing (Drawing)
import Data.User exposing (User)
import Menu.BugReport as BugReport
import Menu.Download as Download
import Menu.Drawing as Drawing
import Menu.Import as Import
import Menu.Login as Login
import Menu.Logout as Logout
import Menu.New as New
import Menu.ReplaceColor as ReplaceColor
import Menu.Resize as Resize
import Menu.Save as Save
import Menu.Scale as Scale
import Menu.Text as Text
import Menu.Upload as Upload
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


type Msg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Mouse.Position
    | HeaderMouseUp Mouse.Position
    | XButtonMouseDown
    | XButtonMouseUp
    | DownloadMsg Download.Msg
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
    Upload.GotDataUrl >> UploadMsg


fileNotImage : Msg
fileNotImage =
    Upload.FileNotImage
        |> Upload.UploadFailed
        |> UploadMsg


drawingUpdateCompleted : Result String String -> Msg
drawingUpdateCompleted =
    Save.DrawingUpdateCompleted >> SaveMsg


drawingCreateCompleted : Result String Drawing -> Msg
drawingCreateCompleted =
    Save.DrawingCreateCompleted >> SaveMsg


loginFailed : String -> Msg
loginFailed =
    Login.LoginFailed >> LoginMsg


loginSucceeded : User -> Msg
loginSucceeded =
    Login.LoginSucceeded >> LoginMsg
