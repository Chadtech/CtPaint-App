module Main.Init exposing (..)

import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Json.Decode exposing (Value)
import Canvas exposing (Size)
import Task
import Window
import Debug exposing (log)


init : Value -> ( Model, Cmd Message )
init json =
    let
        _ =
            log "json" json
    in
        ( model, cmd )


model : Model
model =
    { session = Nothing
    , canvas = Canvas.initialize (Size 400 400)
    , pendingDraw = Canvas.batch []
    , palette = []
    , toolbarsSize = Size 29 58
    , window = Nothing
    }


cmd : Cmd Message
cmd =
    Task.attempt GetWindowSize Window.size
