module Canvas.Model
    exposing
        ( Model
        , applyTo
        , mapMain
        , setMain
        , setPosition
        )

import Canvas exposing (Canvas, DrawOp)
import Position.Data as Position
    exposing
        ( Position
        )


-- TYPES --


type alias Model =
    { main : Canvas
    , position : Position
    }



-- HELPERS --


applyTo : Model -> (Model -> Model) -> Model
applyTo model f =
    f model


mapMain : (Canvas -> Canvas) -> Model -> Model
mapMain f model =
    { model | main = f model.main }


setMain : Canvas -> Model -> Model
setMain main model =
    { model | main = main }


setPosition : Position -> Model -> Model
setPosition position model =
    { model | position = position }
