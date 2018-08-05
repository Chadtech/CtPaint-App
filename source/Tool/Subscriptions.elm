module Tool.Subscriptions
    exposing
        ( subscriptions
        )

import Model exposing (Model)
import Mouse
import Tool.Msg exposing (Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    [ Mouse.moves WindowMouseMove
    , Mouse.ups WindowMouseUp
    ]
        |> Sub.batch
