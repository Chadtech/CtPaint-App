module Taskbar.Download.Update exposing (update)

import Util
import Taskbar.Download.Ports as Ports
import Taskbar.Download.Types
    exposing
        ( Model
        , ExternalMessage(..)
        , Message(..)
        )


update : Message -> Model -> ( Model, ExternalMessage, Cmd Message )
update message model =
    case message of
        UpdateField content ->
            Util.pack
                { model
                    | content = content
                }
                DoNothing
                Cmd.none

        CloseClick ->
            Util.pack
                model
                Close
                Cmd.none

        Submit ->
            let
                fileName =
                    case model.content of
                        "" ->
                            model.placeholder

                        content ->
                            content
            in
                Util.pack
                    model
                    Close
                    (Ports.download (fileName ++ ".png"))
