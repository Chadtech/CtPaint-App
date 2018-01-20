module Helpers.Menu exposing (..)

import Array
import Menu
import Model exposing (Model)
import Ports exposing (JsMsg(StealFocus))
import Tuple.Infix exposing ((&))


initReplaceColor : Model -> ( Model, Cmd msg )
initReplaceColor model =
    { model
        | menu =
            Menu.initReplaceColor
                model.color.swatches.primary
                model.color.swatches.second
                (Array.toList model.color.palette)
                model.windowSize
                |> Just
    }
        & Ports.send StealFocus
