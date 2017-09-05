module Taskbar.Download.Handle exposing (handle)

import Main.Model exposing (Model)
import Taskbar.Download.Ports as Ports
import Taskbar.Download.Types as Download exposing (ExternalMessage(..), Message(..))
import Types.Menu exposing (Menu(..))


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
            }
                ! [ Ports.download (fileName ++ ".png") ]

        Close ->
            { model | menu = None } ! []
