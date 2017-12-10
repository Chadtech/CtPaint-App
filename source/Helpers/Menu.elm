module Helpers.Menu exposing (..)

import Array
import Menu
import Model exposing (Model)


initReplaceColor : Model -> Model
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
