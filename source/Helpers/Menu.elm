module Helpers.Menu exposing (..)

import Array
import Menu
import Model exposing (Model)
import Ports
import Tuple.Infix exposing ((&))


initReplaceColor : Model -> ( Model, Cmd msg )
initReplaceColor model =
    { model
        | menu =
            Menu.initReplaceColor
                model.color.swatches.top
                model.color.swatches.bottom
                (Array.toList model.color.palette)
                model.windowSize
                |> Just
    }
        & Ports.stealFocus
