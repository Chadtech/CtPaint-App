module Taskbar.Import.Update exposing (update)

import Mouse exposing (Position)
import Util exposing (pack)
import Taskbar.Import.Types
    exposing
        ( Model
        , ExternalMessage(..)
        , Message(..)
        )
import Debug exposing (log)


update : Message -> Model -> ( Model, ExternalMessage )
update message model =
    case message of
        UpdateField url ->
            pack
                { model | url = url }
                DoNothing

        CloseClick ->
            pack model Close

        AttemptLoad ->
            pack model LoadImage

        ImageLoaded (Ok canvas) ->
            pack model (IncorporateImage canvas)

        ImageLoaded (Err err) ->
            pack model DoNothing

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
