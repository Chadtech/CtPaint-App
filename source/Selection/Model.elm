module Selection.Model
    exposing
        ( Model
        , Origin(..)
        , applyTo
        , fromClipboard
        , mapCanvas
        , setCanvas
        , setPosition
        , toClipboard
        )

import Canvas exposing (Canvas)
import Clipboard.Model as Clipboard
import Mouse exposing (Position)


-- TYPES --


type alias Model =
    { position : Position
    , canvas : Canvas
    , origin : Origin
    }


type Origin
    = MainCanvas
    | Other



-- HELPERS --


applyTo : Model -> (Model -> Model) -> Model
applyTo model f =
    f model


setPosition : Position -> Model -> Model
setPosition position model =
    { model | position = position }


setCanvas : Canvas -> Model -> Model
setCanvas canvas model =
    { model | canvas = canvas }


mapCanvas : (Canvas -> Canvas) -> Model -> Model
mapCanvas f model =
    { model | canvas = f model.canvas }


toClipboard : Model -> Clipboard.Model
toClipboard { position, canvas } =
    { position = position
    , canvas = canvas
    }


fromClipboard : Clipboard.Model -> Model
fromClipboard { position, canvas } =
    { position = position
    , canvas = canvas
    , origin = Other
    }
