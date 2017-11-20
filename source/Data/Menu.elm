module Data.Menu
    exposing
        ( ContentMsg(..)
        , Menu(..)
        , Model
        , Msg(..)
        , loginFailed
        )

import Download
import Imgur
import Import
import Login
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import New
import Open
import ReplaceColor
import Scale
import Text
import Util exposing (ClickState)


type Menu
    = Download Download.Model
    | Import Import.Model
    | Scale Scale.Model
    | Text String
    | About
    | ReplaceColor ReplaceColor.Model
    | Imgur Imgur.Model
    | New New.Model
    | Open Open.Model
    | Login Login.Model
    | Error String


type alias Model =
    { position : Position
    , click : ClickState
    , title : String
    , content : Menu
    }


type Msg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Mouse.Position
    | HeaderMouseUp
    | XClick
    | ContentMsg ContentMsg


type ContentMsg
    = DownloadMsg Download.Msg
    | ImportMsg Import.Msg
    | ScaleMsg Scale.Msg
    | TextMsg Text.Msg
    | ReplaceColorMsg ReplaceColor.Msg
    | ImgurMsg Imgur.Msg
    | NewMsg New.Msg
    | OpenMsg Open.Msg
    | LoginMsg Login.Msg


loginFailed : String -> Msg
loginFailed =
    Login.LoginFailed >> LoginMsg >> ContentMsg
