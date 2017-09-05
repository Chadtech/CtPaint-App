module Minimap.Mouse exposing (subscriptions)

import Minimap.Types exposing (Message(..), Model)
import Mouse


subscriptions : Maybe Model -> Sub Message
subscriptions maybeModel =
    case maybeModel of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch
                [ Mouse.moves HeaderMouseMove
                , Mouse.ups (always HeaderMouseUp)
                ]
