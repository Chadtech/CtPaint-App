module Data.Menu
    exposing
        ( ClickState(..)
        , ContentMsg(..)
        , Menu(..)
        , Model
        , Msg(..)
        , fileNotImage
        , fileRead
        , loginFailed
        , loginSucceeded
        )

import Data.User exposing (User)
import Download
import Import
import Login
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import New
import Open
import ReplaceColor
import Resize
import Scale
import Text
import Upload


type Menu
    = Download Download.Model
    | Import Import.Model
    | Scale Scale.Model
    | Text String
    | About
    | ReplaceColor ReplaceColor.Model
    | New New.Model
    | Open Open.Model
    | Login Login.Model
    | Error String
    | Loading String
    | Upload Upload.Model
    | Resize Resize.Model


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
    | ReplaceColorMsg ReplaceColor.Msg
    | NewMsg New.Msg
    | OpenMsg Open.Msg
    | LoginMsg Login.Msg
    | UploadMsg Upload.Msg
    | ResizeMsg Resize.Msg


fileRead : String -> Msg
fileRead =
    Upload.GotDataUrl >> UploadMsg >> ContentMsg


fileNotImage : Msg
fileNotImage =
    Upload.FileNotImage
        |> Upload.UploadFailed
        |> UploadMsg
        |> ContentMsg


loginFailed : String -> Msg
loginFailed =
    Login.LoginFailed >> LoginMsg >> ContentMsg


loginSucceeded : User -> Msg
loginSucceeded =
    Login.LoginSucceeded >> LoginMsg >> ContentMsg
