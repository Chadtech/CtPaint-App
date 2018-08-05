module History.Model
    exposing
        ( Event(..)
        , Model
        , add
        , init
        , passToFuture
        , passToPast
        , setFuture
        , setPast
        )

import Canvas exposing (Canvas)
import Color exposing (Color)


type alias Model =
    { past : List Event
    , future : List Event
    }


type Event
    = CanvasChange Canvas
    | ColorChange Int Color


init : Canvas -> Model
init canvas =
    { past = [ CanvasChange canvas ]
    , future = []
    }



-- HELPERS --


add : Event -> Model -> Model
add event model =
    { model
        | future = []
    }
        |> passToPast event


setPast : List Event -> Model -> Model
setPast past model =
    { model | past = past }


passToPast : Event -> Model -> Model
passToPast event model =
    { model
        | past =
            List.take 15 (event :: model.past)
    }


setFuture : List Event -> Model -> Model
setFuture future model =
    { model | future = future }


passToFuture : Event -> Model -> Model
passToFuture event model =
    { model
        | future =
            List.take 15 (event :: model.future)
    }
