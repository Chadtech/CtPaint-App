module Taskbar.Download.Incorporate exposing (incorporate)

import Main.Model exposing (Model)
import Menu.Types exposing (Menu(..))
import Taskbar.Download.Ports as Ports
import Taskbar.Download.Types as Download exposing (ExternalMessage(..), Message(..))


incorporate : Model -> ( Download.Model, ExternalMessage ) -> ( Model, Cmd Message )
incorporate model ( downloadModel, externalmessage ) =
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
