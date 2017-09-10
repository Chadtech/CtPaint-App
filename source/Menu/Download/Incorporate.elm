module Menu.Download.Incorporate exposing (incorporate)

import Main.Model exposing (Model)
import Menu.Download.Ports as Ports
import Menu.Download.Types as Download exposing (ExternalMessage(..), Message(..))
import Menu.Ports as Ports
import Menu.Types exposing (Menu(..))


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
            { model | menu = None } ! [ Ports.returnFocus () ]
