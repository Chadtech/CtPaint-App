module Clipboard exposing (copy, cut, paste)

import Data.Selection as Selection
import Model exposing (Model)


copy : Model -> Model
copy model =
    { model
        | clipboard =
            Maybe.map
                Selection.toClipboard
                model.selection
    }


cut : Model -> Model
cut model =
    { model
        | clipboard =
            Maybe.map
                Selection.toClipboard
                model.selection
        , selection = Nothing
    }


paste : Model -> Model
paste model =
    { model
        | selection =
            Maybe.map
                Selection.fromClipboard
                model.clipboard
    }
