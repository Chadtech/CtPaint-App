module Minimap.Update exposing (update)

import Minimap.Types exposing (Model, Message(..), ExternalMessage(..))
import Mouse exposing (Position)


update : Message -> Model -> ( Model, ExternalMessage )
update message model =
    case message of
        HeaderMouseDown { targetPos, clientPos } ->
            let
                newModel =
                    { model
                        | clickState =
                            Position
                                (clientPos.x - targetPos.x)
                                (clientPos.y - targetPos.y)
                                |> Just
                    }
            in
                ( newModel, DoNothing )

        HeaderMouseMove position ->
            case model.clickState of
                Nothing ->
                    ( model, DoNothing )

                Just originalClick ->
                    let
                        x =
                            position.x - originalClick.x

                        y =
                            position.y - originalClick.y

                        newModel =
                            { model
                                | externalPosition =
                                    Position x y
                            }
                    in
                        ( newModel, DoNothing )

        HeaderMouseUp ->
            let
                newModel =
                    { model
                        | clickState = Nothing
                    }
            in
                ( newModel, DoNothing )

        CloseClick ->
            ( model, Close )
