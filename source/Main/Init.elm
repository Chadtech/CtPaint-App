module Main.Init exposing (..)

import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Json.Decode exposing (Value)
import Canvas exposing (Size)
import Types.Session as Session


init : Value -> ( Model, Cmd Message )
init json =
    { session = Session.decode json
    , canvas = Canvas.initialize (Size 400 400)
    , pendingDraw = Canvas.batch []
    , palette = []
    , toolbarsSize = Size 29 58
    }
        ! []
