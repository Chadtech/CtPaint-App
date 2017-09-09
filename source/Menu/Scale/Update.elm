module Menu.Scale.Update exposing (update)

import Menu.Scale.Types
    exposing
        ( ExternalMessage(..)
        , Field(..)
        , Message(..)
        , Model
        )
import Mouse exposing (Position)
import Util exposing (pack)


update : Message -> Model -> ( Model, ExternalMessage )
update message model =
    case message of
        UpdateField field string ->
            pack model DoNothing

        CloseClick ->
            pack model Close

        HeaderMouseDown { targetPos, clientPos } ->
            pack
                { model
                    | clickState =
                        Position
                            (clientPos.x - targetPos.x)
                            (clientPos.y - targetPos.y)
                            |> Just
                }
                DoNothing

        HeaderMouseMove position ->
            case model.clickState of
                Nothing ->
                    pack model DoNothing

                Just originalClick ->
                    pack
                        { model
                            | position =
                                Position
                                    (position.x - originalClick.x)
                                    (position.y - originalClick.y)
                        }
                        DoNothing

        HeaderMouseUp ->
            pack
                { model
                    | clickState = Nothing
                }
                DoNothing
