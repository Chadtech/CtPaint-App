module Clipboard.Helpers
    exposing
        ( copy
        , cut
        , paste
        )

import Model exposing (Model)
import Selection.Model as Selection


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
