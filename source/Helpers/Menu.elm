module Helpers.Menu exposing (..)

import Array
import Menu
import Model exposing (Model)


initReplaceColor : Model -> Model
initReplaceColor model =
    { model
        | menu =
            Menu.initReplaceColor
                model.swatches.primary
                model.swatches.second
                (Array.toList model.palette)
                model.windowSize
                |> Just
    }
