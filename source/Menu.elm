port module Menu exposing (..)

import Download
import Html exposing (Attribute, Html, div)
import Html.Attributes exposing (class)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Random exposing (Seed)
import Util exposing ((&))
import Window exposing (Size)


type alias Model =
    { position : Position
    , size : Size
    , click : ClickState
    , title : String
    , content : Menu
    }


type Menu
    = Download Download.Model


type ClickState
    = NoClick
    | ClickAt Position


type Msg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove MouseEvent
    | HeaderMouseUp
    | Close



-- VIEW --


view : Model -> Html Msg
view { position, size, title, content } =
    div
        [ class ("card" ++ menuClass content) ]
        []


menuClass : Menu -> String
menuClass content =
    case content of
        Download _ ->
            "download"



-- INIT --


initDownload : Size -> Maybe String -> Seed -> ( Menu, Seed )
initDownload windowSize maybeProjectName seed =
    let
        ( menu, seed ) =
            Download.init maybeProjectName seed
    in
    { position =
        { x = 400
        , y = 400
        }
    , size =
        { width = 400
        , height = 400
        }
    , click = NoClick
    , title = "download"
    , content = Download menu
    }
        & seed
