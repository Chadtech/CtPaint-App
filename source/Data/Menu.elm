module Data.Menu exposing (Menu(..), Model)

import Download
import Imgur
import Import
import Login
import Mouse exposing (Position)
import New
import Open
import ReplaceColor
import Scale
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
