module Tool.Msg
    exposing
        ( Msg(..)
        , mapPosition
        )

import Mouse exposing (Position)
import Html.Mouse exposing (Button)


-- TYPES --


type Msg
    = WorkareaMouseDown Button Position
    | WorkareaMouseUp Position
    | WindowMouseMove Position
    | WindowMouseUp Position



-- HELPERS --


mapPosition : (Position -> Position) -> Msg -> Msg
mapPosition f msg =
    case msg of
        WorkareaMouseDown button position ->
            WorkareaMouseDown button (f position)

        WorkareaMouseUp position ->
            WorkareaMouseUp (f position)

        WindowMouseMove position ->
            WindowMouseMove (f position)

        WindowMouseUp position ->
            WindowMouseUp (f position)
