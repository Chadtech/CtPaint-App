module Minimap.Mouse exposing (subscriptions)

import Minimap.Types exposing (Model, Msg(..))
import Mouse


subscriptions : Maybe Model -> Sub Msg
subscriptions maybeModel =
    case maybeModel of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch
                [ Mouse.moves HeaderMouseMove
                , Mouse.ups (always HeaderMouseUp)
                ]
