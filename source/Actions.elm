module Actions exposing (..)

import Array
import Color exposing (Color)
import Data.History exposing (Event(..))
import History
import Menu
import Types exposing (Model)


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
