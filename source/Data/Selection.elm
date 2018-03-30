module Data.Selection
    exposing
        ( Model
        , Origin(..)
        , fromClipboard
        , setCanvas
        , setPosition
        , toClipboard
        , updateCanvas
        )

import Canvas exposing (Canvas)
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


setPosition : Position -> Model -> Model
setPosition position model =
    { model | position = position }


setCanvas : Canvas -> Model -> Model
setCanvas canvas model =
    { model | canvas = canvas }


updateCanvas : (Canvas -> Canvas) -> Model -> Model
updateCanvas f model =
    { model | canvas = f model.canvas }


toClipboard : Model -> ( Position, Canvas )
toClipboard { position, canvas } =
    ( position, canvas )


fromClipboard : ( Position, Canvas ) -> Model
fromClipboard ( position, canvas ) =
    { position = position
    , canvas = canvas
    , origin = Other
    }
