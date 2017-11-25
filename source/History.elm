module History exposing (..)

import Data.History exposing (Event(..), Model)


-- HISTORY --


add : Event -> Model -> Model
add event model =
    { model
        | future = []
    }
        |> passToPast event



-- PAST --


setPast : List Event -> Model -> Model
setPast past model =
    { model | past = past }


passToPast : Event -> Model -> Model
passToPast event model =
    { model
        | past =
            List.take 15 (event :: model.past)
    }



-- FUTURE --


setFuture : List Event -> Model -> Model
setFuture future model =
    { model | future = future }


passToFuture : Event -> Model -> Model
passToFuture event model =
    { model
        | future =
            List.take 15 (event :: model.future)
    }
