module Helpers.Menu exposing (..)

import Array
import Menu
import Model exposing (Model)
import Ports
import Return2 as R2


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
        |> R2.withCmd Ports.stealFocus
