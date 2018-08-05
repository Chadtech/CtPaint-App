module Menu.Subscriptions
    exposing
        ( subscriptions
        )

import Menu.Model exposing (Model)
import Menu.Msg exposing (Msg(..))
import Mouse


subscriptions : Maybe Model -> Sub Msg
subscriptions maybeModel =
    case maybeModel of
        Just _ ->
            [ Mouse.moves HeaderMouseMove
            , Mouse.ups HeaderMouseUp
            ]
                |> Sub.batch

        Nothing ->
            Sub.none
