module Helpers.Import
    exposing
        ( loadCmd
        )

import Canvas exposing (Canvas, Error)
import Task


loadCmd : String -> (Result Error Canvas -> msg) -> Cmd msg
loadCmd url toMsg =
    [ "https://cors-anywhere.herokuapp.com/"
    , url
    ]
        |> String.concat
        |> Canvas.loadImage
        |> Task.attempt toMsg
