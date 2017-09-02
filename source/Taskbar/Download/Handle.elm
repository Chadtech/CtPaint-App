module Taskbar.Download.Handle exposing (handle)

import Main.Model exposing (Model)
import Taskbar.Download.Types as Download exposing (Message(..), ExternalMessage(..))
import Types.Menu exposing (Menu(..))
import Taskbar.Download.Ports as Ports


handle : Model -> ( Download.Model, ExternalMessage ) -> ( Model, Cmd Message )
handle model ( downloadModel, externalmessage ) =
    case externalmessage of
        DoNothing ->
            { model
                | menu = Download downloadModel
            }
                ! []

        DownloadFile fileName ->
            { model
                | menu = None
                , listenForKeyCmds = True
            }
                ! [ Ports.download (fileName ++ ".png") ]

        Close ->
            { model
                | menu = None
                , listenForKeyCmds = True
            }
                ! []
