module Tool.Hand.Update exposing (..)

import Main.Model exposing (Model)
import Tool.Hand.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))


update : Message -> Tool -> Model -> ( Model, Cmd Message )
update message tool model =
    case message of
        OnCanvasMouseDown point ->
            model ! []
