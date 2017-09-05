module Taskbar.Download.Update exposing (update)

import Mouse exposing (Position)
import Taskbar.Download.Types
    exposing
        ( ExternalMessage(..)
        , Message(..)
        , Model
        )
import Util exposing (pack)


update : Message -> Model -> ( Model, ExternalMessage )
update message model =
    case message of
        UpdateField content ->
            pack
                { model
                    | content = content
                }
                DoNothing

        CloseClick ->
            pack model Close

        Submit ->
            let
                fileName =
                    case model.content of
                        "" ->
                            model.placeholder

                        content ->
                            content
            in
            pack model (DownloadFile fileName)

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
