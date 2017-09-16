module Menu.Text.Update exposing (update)

import Menu.Text.Types
    exposing
        ( ExternalMsg(..)
        , Model
        , Msg(..)
        )
import Mouse exposing (Position)
import Util exposing (pack)


update : Msg -> Model -> ( Model, ExternalMsg )
update message model =
    case message of
        UpdateField str ->
            pack
                { model
                    | text = str
                }
                DoNothing

        Finished ->
            pack model AddText

        CloseClick ->
            pack model Close

        HeaderMouseDown { targetPos, clientPos } ->
            pack
                { model
                    | clickState =
                        { x = clientPos.x - targetPos.x
                        , y = clientPos.y - targetPos.y
                        }
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
