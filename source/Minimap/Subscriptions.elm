module Minimap.Subscriptions exposing (subscriptions)

import Minimap.Model
    exposing
        ( ClickState(..)
        , Model
        , OpenState(..)
        )
import Minimap.Msg exposing (Msg(..))
import Mouse


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.openState of
        Open openModel ->
            case openModel.clickState of
                NoClicks ->
                    Sub.none

                _ ->
                    [ Mouse.moves MouseMoved
                    , Mouse.ups (always MouseUp)
                    ]
                        |> Sub.batch

        Closed _ ->
            Sub.none
